EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Screw_Terminal_01x02 Solar+1
U 1 1 5FA05F5E
P 5200 2850
F 0 "Solar+1" H 5280 2842 50  0001 L CNN
F 1 "Solar" H 5280 2796 50  0000 L CNN
F 2 "Connector_Phoenix_MC:PhoenixContact_MCV_1,5_2-G-3.5_1x02_P3.50mm_Vertical" H 5200 2850 50  0001 C CNN
F 3 "~" H 5200 2850 50  0001 C CNN
	1    5200 2850
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 Battery+1
U 1 1 5FA0637A
P 6100 2450
F 0 "Battery+1" H 6180 2442 50  0001 L CNN
F 1 "Battery" H 6180 2396 50  0000 L CNN
F 2 "Connector_Phoenix_MC:PhoenixContact_MCV_1,5_2-G-3.5_1x02_P3.50mm_Vertical" H 6100 2450 50  0001 C CNN
F 3 "~" H 6100 2450 50  0001 C CNN
	1    6100 2450
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x03 Sensor+1
U 1 1 5FA06DF8
P 4250 2250
F 0 "Sensor+1" H 4330 2292 50  0001 L CNN
F 1 "Sensor" H 4330 2246 50  0000 L CNN
F 2 "Connector_Phoenix_MC:PhoenixContact_MCV_1,5_3-G-3.5_1x03_P3.50mm_Vertical" H 4250 2250 50  0001 C CNN
F 3 "~" H 4250 2250 50  0001 C CNN
	1    4250 2250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5FA083FA
P 2000 1400
F 0 "R1" H 2070 1446 50  0001 L CNN
F 1 "10k" H 2070 1400 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 1930 1400 50  0001 C CNN
F 3 "~" H 2000 1400 50  0001 C CNN
	1    2000 1400
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper JP1
U 1 1 5FA088FD
P 4500 3250
F 0 "JP1" V 4454 3376 50  0001 L CNN
F 1 "Flash" V 4500 3376 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x02_P2.54mm_Vertical" H 4500 3250 50  0001 C CNN
F 3 "~" H 4500 3250 50  0001 C CNN
	1    4500 3250
	0    1    1    0   
$EndComp
$Comp
L mylib:SolarRegulator U2
U 1 1 5FA097B6
P 5350 2300
F 0 "U2" H 5200 2525 50  0001 C CNN
F 1 "SolarRegulator" H 5200 2433 50  0000 C CNN
F 2 "mylib:SolarRegulator" H 5400 2500 50  0001 C CNN
F 3 "" H 5400 2500 50  0001 C CNN
	1    5350 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 2300 4600 2300
Wire Wire Line
	5600 2300 5600 1050
Wire Wire Line
	5600 1050 4500 1050
$Comp
L Switch:SW_Push SW1
U 1 1 5FA1C9D0
P 2000 3100
F 0 "SW1" V 1954 3248 50  0001 L CNN
F 1 "Reset" V 2000 3248 50  0000 L CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H4.3mm" H 2000 3300 50  0001 C CNN
F 3 "~" H 2000 3300 50  0001 C CNN
	1    2000 3100
	0    1    1    0   
$EndComp
Wire Wire Line
	2000 1050 2000 1250
Wire Wire Line
	3150 1050 3150 1450
Connection ~ 3150 1050
Wire Wire Line
	3150 1050 2350 1050
Wire Wire Line
	2000 1550 2000 1650
Wire Wire Line
	2550 1650 2250 1650
$Comp
L Device:R R2
U 1 1 5FA222DB
P 2350 1400
F 0 "R2" H 2420 1446 50  0001 L CNN
F 1 "10k" H 2420 1400 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 2280 1400 50  0001 C CNN
F 3 "~" H 2350 1400 50  0001 C CNN
	1    2350 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 1250 2350 1050
Connection ~ 2350 1050
Wire Wire Line
	2350 1050 2000 1050
Wire Wire Line
	2350 1550 2350 1850
Wire Wire Line
	2350 1850 2550 1850
Wire Wire Line
	2000 1650 2000 2900
Connection ~ 2000 1650
Wire Wire Line
	2000 3300 2000 3800
Wire Wire Line
	2000 3800 3150 3800
$Comp
L Device:R R4
U 1 1 5FA27405
P 4050 1400
F 0 "R4" H 4120 1446 50  0001 L CNN
F 1 "10k" H 4120 1400 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 3980 1400 50  0001 C CNN
F 3 "~" H 4050 1400 50  0001 C CNN
	1    4050 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 1250 4050 1050
Connection ~ 4050 1050
Wire Wire Line
	4050 1050 3150 1050
Wire Wire Line
	4050 1550 4050 1850
Wire Wire Line
	4050 1850 3750 1850
Wire Wire Line
	3150 2950 3150 3800
Connection ~ 3150 3800
Wire Wire Line
	3150 3800 3950 3800
$Comp
L Device:R R3
U 1 1 5FA2A8C9
P 3950 3300
F 0 "R3" H 4020 3346 50  0001 L CNN
F 1 "10k" H 4020 3300 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 3880 3300 50  0001 C CNN
F 3 "~" H 3950 3300 50  0001 C CNN
	1    3950 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 2550 3950 2550
Wire Wire Line
	3950 2550 3950 3150
Wire Wire Line
	3950 3450 3950 3800
Connection ~ 3950 3800
Wire Wire Line
	3950 3800 4150 3800
$Comp
L Device:R R7
U 1 1 5FA2C060
P 4500 1400
F 0 "R7" H 4570 1446 50  0001 L CNN
F 1 "10k" H 4570 1400 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 4430 1400 50  0001 C CNN
F 3 "~" H 4500 1400 50  0001 C CNN
	1    4500 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 1250 4500 1050
Wire Wire Line
	4500 1550 4500 1650
Wire Wire Line
	4500 1650 3750 1650
Wire Wire Line
	4500 1650 4500 2950
Wire Wire Line
	4500 3550 4500 3800
Connection ~ 4500 3800
Wire Wire Line
	4500 3800 6550 3800
Wire Wire Line
	3750 2650 3750 3100
Wire Wire Line
	3750 3100 2450 3100
Wire Wire Line
	2450 3100 2450 2900
Wire Wire Line
	2450 2900 2250 2900
Wire Wire Line
	2250 2900 2250 1650
Connection ~ 2250 1650
Wire Wire Line
	2250 1650 2000 1650
Wire Wire Line
	4050 2150 3750 2150
Wire Wire Line
	4050 2250 3950 2250
Wire Wire Line
	3950 2250 3950 2500
Wire Wire Line
	3950 2500 4150 2500
Wire Wire Line
	4150 2500 4150 3800
Connection ~ 4150 3800
Wire Wire Line
	4150 3800 4250 3800
$Comp
L Device:R R5
U 1 1 5FA3E9E7
P 4250 2800
F 0 "R5" H 4320 2846 50  0001 L CNN
F 1 "220k" H 4320 2800 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 4180 2800 50  0001 C CNN
F 3 "~" H 4250 2800 50  0001 C CNN
	1    4250 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R6
U 1 1 5FA3F30F
P 4250 3200
F 0 "R6" H 4320 3246 50  0001 L CNN
F 1 "100k" H 4320 3200 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 4180 3200 50  0001 C CNN
F 3 "~" H 4250 3200 50  0001 C CNN
	1    4250 3200
	1    0    0    -1  
$EndComp
Connection ~ 4500 1050
Wire Wire Line
	4050 1050 4500 1050
Connection ~ 4500 1650
Wire Wire Line
	4050 2350 4050 2450
Wire Wire Line
	4050 2450 4250 2450
Wire Wire Line
	4250 2450 4250 2650
Wire Wire Line
	4250 2950 4250 3000
Wire Wire Line
	4250 3350 4250 3800
Connection ~ 4250 3800
Wire Wire Line
	4250 3800 4500 3800
Wire Wire Line
	4250 3000 2550 3000
Wire Wire Line
	2550 3000 2550 2850
Wire Wire Line
	2550 2850 2350 2850
Wire Wire Line
	2350 2850 2350 2050
Wire Wire Line
	2350 2050 2550 2050
Connection ~ 4250 3000
Wire Wire Line
	4250 3000 4250 3050
$Comp
L Connector_Generic_MountingPin:Conn_01x02_MountingPin J1
U 1 1 5FA574F0
P 4350 1750
F 0 "J1" H 4438 1664 50  0001 L CNN
F 1 "Serial" H 4438 1618 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x02_P2.54mm_Vertical" H 4350 1750 50  0001 C CNN
F 3 "~" H 4350 1750 50  0001 C CNN
	1    4350 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	4150 1750 3750 1750
Wire Wire Line
	4150 1850 4150 1950
Wire Wire Line
	4150 1950 3750 1950
Wire Wire Line
	4600 2300 4600 2950
Wire Wire Line
	4600 2950 5000 2950
Wire Wire Line
	5000 2850 4700 2850
Wire Wire Line
	4700 2850 4700 2550
Wire Wire Line
	4700 2550 4800 2550
Wire Wire Line
	5600 2500 5700 2500
Wire Wire Line
	5700 2500 5700 2450
Wire Wire Line
	5700 2450 5900 2450
Wire Wire Line
	5600 2550 5900 2550
Wire Wire Line
	6550 2350 6550 3800
Wire Wire Line
	5600 2350 6550 2350
$Comp
L RF_Module:ESP-12F U1
U 1 1 5FA07853
P 3150 2250
F 0 "U1" H 3150 3231 50  0001 C CNN
F 1 "ESP-12F" H 3150 3139 50  0000 C CNN
F 2 "RF_Module:ESP-12E" H 3150 2250 50  0001 C CNN
F 3 "http://wiki.ai-thinker.com/_media/esp8266/esp8266_series_modules_user_manual_v1.1.pdf" H 2800 2350 50  0001 C CNN
	1    3150 2250
	1    0    0    -1  
$EndComp
Text Label 3350 1000 0    50   ~ 0
3.3V
Text Label 3400 3750 0    50   ~ 0
GND
$EndSCHEMATC
