//#define LOG_LOCAL_LEVEL ESP_LOG_ERROR

#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"
#include "rom/ets_sys.h"
#include "esp_wifi.h"
#include "esp_event_loop.h"
#include "esp_log.h"
#include "nvs_flash.h"
#include "driver/adc.h"

#include "mqtt_client.h"

static const char *TAG = "soil_moisture_sensor";

#include "homie.h"

#define STR_(X) #X
#define STR(X) STR_(X)

static EventGroupHandle_t wifi_event_group;
static EventGroupHandle_t mqtt_event_group;

static esp_mqtt_client_handle_t mqtt_client = NULL;

const static int MQTT_CONNECTED_BIT = BIT0;

void update_moisture(struct homie_handle_s *handle, int node, int property);

homie_handle_t homie =
		{ .deviceid = "soil_moisture_sensor", .devicename =
				"Soil Moisture Sensor", .update_interval = 0, /* set to 0 to workaround openhab problem of taking device offline */
		.firmware = "foo", .firmware_version = "bar",
		//       .firmware = GIT_URL,
		//       .firmware_version = GIT_BRANCH" "GIT_COMMIT_HASH,
				.num_nodes = 1, .nodes = { { .id = "sensor", .name = "sensor",
						.type = "soilmoisture", .num_properties = 1,
						.properties = { { .id = "moisture", .name = "Moisture",
								.settable = HOMIE_FALSE, .retained = HOMIE_TRUE,
								.unit = " ", .datatype = HOMIE_BOOL,
								.read_property_cbk = &update_moisture,
								.user_data = NULL, }, } } }, .uptime = 0, };

int wifi_retry_count = 0;
const int WIFI_CONNECTED_BIT = BIT0;

static esp_err_t mqtt_event_handler(esp_mqtt_event_handle_t event) {
	switch (event->event_id) {
	case MQTT_EVENT_CONNECTED:
		ESP_LOGI(TAG, "MQTT_EVENT_CONNECTED");
		xEventGroupSetBits(mqtt_event_group, MQTT_CONNECTED_BIT);
		break;
	case MQTT_EVENT_DISCONNECTED:
		ESP_LOGI(TAG, "MQTT_EVENT_DISCONNECTED");
		break;

	case MQTT_EVENT_SUBSCRIBED:
		ESP_LOGI(TAG, "MQTT_EVENT_SUBSCRIBED, msg_id=%d", event->msg_id);
		break;
	case MQTT_EVENT_UNSUBSCRIBED:
		ESP_LOGI(TAG, "MQTT_EVENT_UNSUBSCRIBED, msg_id=%d", event->msg_id);
		break;
	case MQTT_EVENT_PUBLISHED:
		ESP_LOGI(TAG, "MQTT_EVENT_PUBLISHED, msg_id=%d", event->msg_id);
		break;
	case MQTT_EVENT_DATA:
		//ESP_LOGI(TAG, "MQTT_EVENT_DATA");
		//printf("TOPIC=%.*s\r\n", event->topic_len, event->topic);
		//printf("DATA='%.*s'\r\n", event->data_len, event->data);
		//printf("ID=%d, total_len=%d, data_len=%d, current_data_offset=%d\n",
		//       event->msg_id, event->total_data_len, event->data_len,
		//       event->current_data_offset);

		homie_handle_mqtt_incoming_event(&homie, event);

		break;
	case MQTT_EVENT_ERROR:
		ESP_LOGI(TAG, "MQTT_EVENT_ERROR");
		break;
	default:
		ESP_LOGI(TAG, "Other event id:%d", event->event_id);
		break;
	}
	return ESP_OK;
}

static esp_err_t wifi_event_handler(void *ctx, system_event_t *event) {
	/* For accessing reason codes in case of disconnection */
	system_event_info_t *info = &event->event_info;

	switch (event->event_id) {
	case SYSTEM_EVENT_STA_START:
		esp_wifi_connect();
		break;
	case SYSTEM_EVENT_STA_GOT_IP:
		ESP_LOGI(TAG, "got ip:%s",
				ip4addr_ntoa(&event->event_info.got_ip.ip_info.ip));
		snprintf(homie.ip, sizeof(homie.ip), "%s",
				ip4addr_ntoa(&event->event_info.got_ip.ip_info.ip));
		wifi_retry_count = 0;
		xEventGroupSetBits(wifi_event_group, WIFI_CONNECTED_BIT);
		break;
	case SYSTEM_EVENT_AP_STACONNECTED:
		ESP_LOGI(TAG, "station:"MACSTR" join, AID=%d",
				MAC2STR(event->event_info.sta_connected.mac),
				event->event_info.sta_connected.aid);
		break;
	case SYSTEM_EVENT_AP_STADISCONNECTED:
		ESP_LOGI(TAG, "station:"MACSTR"leave, AID=%d",
				MAC2STR(event->event_info.sta_disconnected.mac),
				event->event_info.sta_disconnected.aid);
		break;
	case SYSTEM_EVENT_STA_DISCONNECTED:
		ESP_LOGE(TAG, "Disconnect reason : %d", info->disconnected.reason);
		if (info->disconnected.reason == WIFI_REASON_BASIC_RATE_NOT_SUPPORT) {
			/*Switch to 802.11 bgn mode */
			esp_wifi_set_protocol(ESP_IF_WIFI_STA,
					WIFI_PROTOCOL_11B | WIFI_PROTOCOL_11G | WIFI_PROTOCOL_11N);
		}
		esp_wifi_connect();
		xEventGroupClearBits(wifi_event_group, WIFI_CONNECTED_BIT);
		wifi_retry_count++;
		ESP_LOGI(TAG, "retry to connect to the AP");
		if (wifi_retry_count > 10) {
			ESP_LOGI(TAG, "reboot to many tries");
			fflush(stdout);
			esp_restart();
		}
		break;
	default:
		break;
	}
	return ESP_OK;
}

void connect_to_wifi() {
	wifi_event_group = xEventGroupCreate();

	tcpip_adapter_init();

	ESP_ERROR_CHECK(esp_event_loop_init(wifi_event_handler, NULL));

	wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
	ESP_ERROR_CHECK(esp_wifi_init(&cfg));

	wifi_config_t wifi_config = { .sta = { .ssid = CONFIG_WIFI_SSID, .password =
			CONFIG_WIFI_PASSWORD }, };
	ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA));
	ESP_ERROR_CHECK(esp_wifi_set_config(ESP_IF_WIFI_STA, &wifi_config));
	ESP_ERROR_CHECK(esp_wifi_start());

	uint8_t eth_mac[6];
	esp_wifi_get_mac(WIFI_IF_STA, eth_mac);
	snprintf(homie.mac, sizeof(homie.mac), "%02X:%02X:%02X:%02X:%02X:%02X",
			eth_mac[0], eth_mac[1], eth_mac[2], eth_mac[3], eth_mac[4],
			eth_mac[5]);

	ESP_LOGI(TAG, "wifi_init_sta finished.");
	ESP_LOGI(TAG, "connect to ap SSID:%s password:%s", CONFIG_WIFI_SSID,
			CONFIG_WIFI_PASSWORD);
}

static void mqtt_app_start(void) {
	char uri[256];
	sprintf(uri, "mqtt://%s:%s@%s:%d", CONFIG_MQTT_USER, CONFIG_MQTT_PASSWORD,
			CONFIG_MQTT_SERVER, CONFIG_MQTT_PORT);
	mqtt_event_group = xEventGroupCreate();
	const esp_mqtt_client_config_t mqtt_cfg = { .event_handle =
			mqtt_event_handler, .uri = uri, };

	ESP_LOGI(TAG, "connect to mqtt uri %s", uri);
	ESP_LOGI(TAG, "[APP] Free memory: %d bytes", esp_get_free_heap_size());
	mqtt_client = esp_mqtt_client_init(&mqtt_cfg);

	xEventGroupClearBits(mqtt_event_group, MQTT_CONNECTED_BIT);
	esp_mqtt_client_start(mqtt_client);
	ESP_LOGI(TAG, "Note free memory: %d bytes", esp_get_free_heap_size());
}

void update_moisture(struct homie_handle_s *handle, int node, int property) {
	uint16_t adc_data;
	if (ESP_OK == adc_read(&adc_data)) {

		char value[100];
		sprintf(value, "%d", adc_data);
		ESP_LOGI(TAG, "adc value %s", value);

		homie_publish_property_value(handle, node, property, value);
	}
}

void app_main(void) {
	ESP_LOGI(TAG, "starting....\n");

	//Initialize NVS
	esp_err_t ret = nvs_flash_init();
	if (ret == ESP_ERR_NVS_NO_FREE_PAGES) {
		ESP_ERROR_CHECK(nvs_flash_erase());
		ret = nvs_flash_init();
	}
	ESP_ERROR_CHECK(ret);

	connect_to_wifi();

	ESP_LOGI(TAG, "wait for wifi connect");
	xEventGroupWaitBits(wifi_event_group, WIFI_CONNECTED_BIT, false, true,
			portMAX_DELAY);

	adc_config_t adc_config;
	adc_config.mode = ADC_READ_TOUT_MODE;
	adc_config.clk_div = 8; // ADC sample collection clock = 80MHz/clk_div = 10MHz
	ESP_ERROR_CHECK(adc_init(&adc_config));

	mqtt_app_start();

	ESP_LOGI(TAG, "wait for mqtt connect");
	xEventGroupWaitBits(mqtt_event_group, MQTT_CONNECTED_BIT, false, true,
			portMAX_DELAY);

	homie.mqtt_client = mqtt_client;
	ESP_LOGI(TAG, "homie init");
	homie_init(&homie);

	for (int i = 24 * 60 * 60 / 5; i >= 0; i--) {
		ESP_LOGI(TAG, "Restarting in %d seconds...\n", i * 5);

		homie.uptime += 5;

		homie_cycle(&homie);
		vTaskDelay(5000 / portTICK_PERIOD_MS);
	}
	ESP_LOGI(TAG, "Restarting now.\n");
	fflush(stdout);
	esp_restart();
}
