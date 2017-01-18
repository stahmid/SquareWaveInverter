#line 1 "D:/Documents/Winter 2016/Kamruzzaman/SquareWaveInverter/demo_simple_8.c"
#line 7 "D:/Documents/Winter 2016/Kamruzzaman/SquareWaveInverter/demo_simple_8.c"
typedef volatile unsigned int uint16;
typedef volatile unsigned char uint8;

uint8 duty = 30;
uint8 duty_buffer = 30;
uint8 period = 50;
uint8 cdPeriod = 50;
uint8 dutyCounter = 0;

uint8 MOSdriveState = 0;
uint8 batteryState = 3;

uint16 vAc, vBat, vFb;
uint16 vShunt, iShunt;
uint8 acStatus;

uint8 counter;
uint16 adTemp;
uint16 loopcounter = 0;
uint8 overloadcounter = 0;
uint8 ac_low;
uint16 ac_high;

volatile uint8 mode;
volatile uint8 pwmStarted;
volatile uint8 mainsStarted;

uint8 overloadState;
volatile uint8 inverterState;
volatile uint8 chargingDuty, cdCounter;
volatile uint16 chargingDuty_buffer;
uint8 pulseCounter;
uint8 firing;
uint8 hicutreached;
uint8 chgDelay;
uint8 chgDot;
uint8 delayCounter, delayCounter2;

uint8 lcdState;
uint8 lcdCounter;

uint16 loadpc;

uint8 t1pr;
uint16 num;
uint16 vTop;
uint16 ovThreshold;
uint8 lv1, lv2, lv3, lv4;

volatile chargingEnabled = 0;

const char company1[] = "M Micro";
const char company2[] = "Solutions";
const char batlv1[] = {14,27,17,17,17,17,31,31};
const char batlv2[] = {14,27,17,17,17,31,31,31};
const char batlv3[] = {14,27,17,17,31,31,31,31};
const char batlv4[] = {14,27,17,31,31,31,31,31};
const char batlv5[] = {14,31,31,31,31,31,31,31};

char character, batlv, chlv;

uint8 hundreds, tens, ones;
#line 121 "D:/Documents/Winter 2016/Kamruzzaman/SquareWaveInverter/demo_simple_8.c"
sbit MOS1 at RC6_bit;
sbit MOS2 at RC5_bit;
sbit outputRelay at RB4_bit;
sbit inverterSw at RB5_bit;
sbit Triac at RB3_bit;

sbit LCD_RS at RB7_bit;
sbit LCD_EN at RC4_bit;
sbit LCD_D4 at RC0_bit;
sbit LCD_D5 at RC1_bit;
sbit LCD_D6 at RC2_bit;
sbit LCD_D7 at RC3_bit;

sbit LCD_RS_Direction at TRISB7_bit;
sbit LCD_EN_Direction at TRISC4_bit;
sbit LCD_D4_Direction at TRISC0_bit;
sbit LCD_D5_Direction at TRISC1_bit;
sbit LCD_D6_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISC3_bit;

void interrupt(){
 if (TMR2IF_bit){
 if (mode ==  0 ){
 if (MOSdriveState){

 if (MOSdriveState ==  1 ){
 duty = duty_buffer;
 }

 dutyCounter++;

 if (dutyCounter == duty){
 MOS1 = 0;
 MOS2 = 0;
 }

 if (dutyCounter == period){
 dutyCounter = 0;
 if (MOSdriveState ==  1 ){
 MOS2 = 0;
 delay_us(1);
 MOS1 = 1;

 MOSdriveState =  2 ;

 }
 else if (MOSdriveState ==  2 ){
 MOS1 = 0;
 delay_us(1);
 MOS2 = 1;

 MOSdriveState =  1 ;
 }
 }

 }
 else{
 MOS1 = 0;
 MOS2 = 0;
 }

 }
 else{

 cdCounter++;
 if (cdCounter == chargingDuty){
 if ((hicutreached == 0) && (chargingEnabled == 1)){
 Triac = 1;
 }
 else{
 Triac = 0;
 }
 }
 else{
 Triac = 0;
 }


 }
 TMR2 = 0;
 TMR2IF_bit = 0;
 }

 if (INTF_bit){
 cdCounter = 0;
 INTF_bit = 0;
 TMR2 = 0; TMR2IF_bit = 0;
 pulseCounter++;
 if (pulseCounter == 4){
 pulseCounter = 0;
 chargingDuty = firing;
 }
 }
}

void batteryIcon(char pos_row, char pos_char) {
 Lcd_Cmd(64);
 for (loopcounter = 0; loopcounter <= 7; loopcounter++){
 switch (batlv){
 case 1:
 character = batlv1[loopcounter];
 break;
 case 2:
 character = batlv2[loopcounter];
 break;
 case 3:
 character = batlv3[loopcounter];
 break;
 case 4:
 character = batlv4[loopcounter];
 break;
 case 5:
 character = batlv5[loopcounter];
 break;
 }
 Lcd_Chr_CP(character);
 }
 Lcd_Cmd(_LCD_RETURN_HOME);
 Lcd_Chr(pos_row, pos_char, 0);
}

void initializePeripherals(){

 ADC_Init();

 GIE_bit = 1;
 PEIE_bit = 1;
}

void initializeLCD(){
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
}

void initializePWM(){
 T2CON = 5;
 PR2 = 249;
 TMR2IF_bit = 0;
 TMR2IE_bit = 1;

 T1CON = 0x11;

 MOSdriveState =  1 ;
 duty_buffer =  30 ;
 duty = duty_buffer;
 overloadState =  0 ;
 overloadcounter = 0;
 mainsStarted = 0;
 Triac = 0;
 INTE_bit = 0;
 ovThreshold =  27 ;

}

void stopPWM(){


 TMR2IF_bit = 0; TMR2IE_bit = 0;
 TMR2 = 0;
 MOS1 = 0;
 MOS2 = 0;
 MOSdriveState = 0;
 outputRelay = 0;
 pwmStarted = 0;
 Triac = 0;
 INTE_bit = 0;
}

void initializeIO(){
 TRISA = 0x2F;
 TRISB = 0x21;
 TRISC = 0;
 PORTA = 0;
 PORTB = 0;
 PORTC = 0;
 ADCON1 = 7;
}

void getMainsVoltage(){
#line 311 "D:/Documents/Winter 2016/Kamruzzaman/SquareWaveInverter/demo_simple_8.c"
 ADCON1 = 0;
 ADCON0 = (ADCON0 & 0xC5) | ( 2  << 3);

 vAc = 0;
 for (counter = 0; counter < 8; counter++){
 vAc = vAc + ADC_Get_Sample( 2 );
 }

 vAc = vAc >> 3;

 if (acStatus ==  1 ){
 ac_low =  114  +  4 ;
 }
 else{
 ac_low =  114 ;
 }

 if (acStatus ==  2 ){
 ac_high =  215  -  4 ;
 }
 else{
 ac_high =  215 ;
 }

 if (vAc < ac_low){
 acStatus =  1 ;
 }
 else if (vAc > ac_high){
 acStatus =  2 ;
 }
 else{
 acStatus =  0 ;
 }



 ADCON1 = 7;

}

void getBatteryVoltage(){
#line 356 "D:/Documents/Winter 2016/Kamruzzaman/SquareWaveInverter/demo_simple_8.c"
 ADCON1 = 0;

 vBat = 0;
 ADCON0 = (ADCON0 & 0xC5) | ( 0  << 3);
 for (counter = 0; counter < 8; counter++){
 vBat = vBat + ADC_Get_Sample( 0 );
 }

 vBat = vBat >> 3;



 if ((batteryState !=  2 ) | (mode ==  1 )){
 if (vBat <  95 ){
 batteryState =  2 ;
 hicutreached = 0;
 }
 else if (vBat <  105 ){
 batteryState =  1 ;
 hicutreached = 0;
 }
 else if (vBat >  142 ){
 hicutreached = 1;
 batteryState =  4 ;
 }
 else if (vBat >  125 ){
 if (hicutreached){
 batteryState =  4 ;
 }
 else{
 batteryState =  5 ;
 }
 }
 else{
 batteryState =  3 ;
 hicutreached = 0;
 }
 }

 ADCON1 = 7;
}

void doChecks(){
 if (acStatus !=  0 ){
 mode =  0 ;
 }
 else{
 mode =  1 ;
 inverterState =  3 ;
 }

 if ((batteryState !=  2 ) & (overloadState ==  0 )){
 if (inverterSw == 0){
 inverterState =  0 ;
 }
 else{
 inverterState =  3 ;
 }
 }
 else if (batteryState ==  2 ){
 inverterState =  1 ;
 }
 else if (overloadState ==  1 ){
 inverterState =  2 ;
 }

 if (inverterSw == 1){
 inverterState =  3 ;
 }

 if (mode ==  1 ){
 if (mainsStarted == 0){
#line 432 "D:/Documents/Winter 2016/Kamruzzaman/SquareWaveInverter/demo_simple_8.c"
 initializeLCD();
 chargingEnabled = 0;


 TMR2IF_bit = 0; TMR2IE_bit = 0;
 TMR2 = 0;
 MOS1 = 0;
 MOS2 = 0;
 MOSdriveState = 0;
 pwmStarted = 0;
 Triac = 0;
 INTE_bit = 0;

 inverterState =  3 ;

 delay_ms(20);
 outputRelay = 0;
 delay_ms(20);

 INTEDG_bit = 1;
 INTE_bit = 1;
 INTF_bit = 0;
 mainsStarted = 1;

 T2CON = 5;
 PR2 = 249;
 TMR2IF_bit = 0;
 TMR2IE_bit = 1;

 chargingDuty = 40;
 chargingDuty_buffer = chargingDuty;

 cdCounter = 0;

 Triac = 0;

 hicutreached = 0;
 vShunt = 0;
 chgDelay = 0;

 TMR1H = 0; TMR1L = 0;
 T1CON = 0x31;
 TMR1IF_bit = 0;

 firing = 100;
 chargingEnabled = 0;

 delayCounter = 0;
 delayCounter2 = 0;

 chlv = 0;

 ovThreshold =  27 ;

 }

 }
 else if (mode ==  0 ){
 cdCounter = 0;
 Triac = 0;
 mainsStarted = 0;
 if (inverterState ==  0 ){
 if (pwmStarted == 0){
 delay_ms(10);
 initializeLCD();
 initializePWM();
 pwmStarted = 1;
 outputRelay = 1;
 }
 }
 else{

 TMR2IF_bit = 0; TMR2IE_bit = 0;
 TMR2 = 0;
 MOS1 = 0;
 MOS2 = 0;
 MOSdriveState = 0;
 delay_ms(20);
 outputRelay = 0;
 pwmStarted = 0;
 Triac = 0;
 INTE_bit = 0;

 if (inverterState ==  3 ){
 batteryState =  3 ;
 overloadState =  0 ;
 vShunt = 0;
 }
 }
 }
}

void doFeedback(){
 ADCON1 = 0;

 ADCON0 = (ADCON0 & 0xC5) | ( 1  << 3);

 vFb = 0;

 for (loopcounter = 0; loopcounter < 4; loopcounter++){
 vFb += ADC_Get_Sample( 1 );
 }

 vFb = vFb >> 2;

 if (vFb < ( 48  )){
 if (duty_buffer <  47 ){
 duty_buffer++;
 }
 }
 else if (vFb > ( 48  + 1)){
 if (duty_buffer >  30 ){
 duty_buffer--;
 }
 }

 ADCON1 = 7;
}

void getOverload(){
 ADCON1 = 0;

 ADCON0 = (ADCON0 & 0xC5) | ( 3  << 3);

 vShunt = 0;
 loopcounter = 0;
 TMR1H = 0; TMR1L = 0;
 TMR1IF_bit = 0;

 while (TMR1IF_bit == 0){
 adTemp = 0;
 for (counter = 0; counter < 64; counter++){
 adTemp += ADC_Get_Sample( 3 );
 }

 loopcounter++;
 adTemp = adTemp >> 6;
 vShunt += adTemp;
 }
 vShunt /= loopcounter;

 ovThreshold = ( 27  * 120)/vBat;

 if (vShunt > (ovThreshold * 3)){
 overloadState =  1 ;
 }
 else{
 if (vShunt > ovThreshold){
 overloadcounter++;
 if (overloadcounter >= 7){
 overloadState =  1 ;
 }
 }
 else{
 overloadcounter = 0;
 }
 }

 ADCON1 = 7;
}

void numToOne(){
 hundreds = num / 100 + 48;
 tens = ( num / 10 ) % 10 + 48;
 ones = num % 10 + 48;
}

void pad(char c){
 for (counter = 0; counter < c; counter++){
 LCD_Chr_Cp(' ');
 }
}

void main() {
 initializePeripherals();
 initializeIO();
 MOSdriveState =  1 ;
 pwmStarted = 0;

 mode =  0 ;
 acStatus =  1 ;
 mainsStarted = 0;
 hicutreached = 0;
 chgDelay = 0;
 lcdState = 0;
 lcdCounter = 0;
 batlv = 1;

 T1CON = 0x31;

 while (1){
 getMainsVoltage();
 getBatteryVoltage();
 doChecks();

 if (mode ==  0 ){
 chargingEnabled = 0;
 if (inverterState ==  0 ){
 getOverload();

 doFeedback();
 TMR1IF_bit = 0;
 lcdCounter++;

 }
 else{
 if (TMR1IF_bit){
 lcdCounter++;
 TMR1IF_bit = 0;
 }
 }
 }
 else{
 if (mainsStarted == 1){
 if (chgDelay == 0){
 if (TMR1IF_bit){
 lcdCounter++;
 delayCounter2++;
 if (delayCounter2 == 2){
 delayCounter++;
 chargingDuty_buffer = (vAc * 32) / 184;
 if (delayCounter > 100){
 chgDelay = 1;
 chargingEnabled = 1;

 }
 else if (delayCounter > 50){

 adTemp = chargingDuty_buffer;
 adTemp = 16 - (delayCounter - 50) + adTemp;
 if (adTemp >= chargingDuty_buffer){
 chargingDuty_buffer = adTemp;
 }
 if (adTemp >= 46){
 chargingDuty_buffer = 46;
 }

 firing = chargingDuty_buffer;
 chargingEnabled = 1;
 }
 else{
 chargingEnabled = 0;
 }
 delayCounter2 = 0;
 }
 else{

 }
 TMR1IF_bit = 0;
 }
 }
 else{
 firing = (vAc * 32)/184;
 if (TMR1IF_bit){
 lcdCounter++;
 TMR1IF_bit = 0;
 }
 }
 }
 else{
 if (TMR1IF_bit){
 lcdCounter++;
 TMR1IF_bit = 0;
 }
 }
 }


 if (T1CON == 0x11){
 t1pr = 90;
 }
 else if (T1CON == 0x31){
 t1pr = 30;
 }
 else{
 t1pr = 60;
 }

 if (lcdCounter == t1pr){
 lcdState++;
 initializeLCD();
 chgDot = 0;
 if (lcdState >=  7 ){
 lcdState = 0;
 }
 lcdCounter = 0;
 }

 switch (lcdState){
 case 0:
 case 1:

 LCD_Chr(1, 5, 'M');
 LCD_Chr_Cp(' ');
 LCD_Chr_Cp('M');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('c');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('o');

 LCD_Chr(2, 4, 'S');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('l');
 LCD_Chr_Cp('u');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('n');
 LCD_Chr_Cp('s');

 break;
 case 2:
 LCD_Chr(1, 1, 'M');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('n');
 LCD_Chr_Cp('s');
 LCD_Chr_Cp(' ');
 LCD_Chr_Cp('V');
 LCD_Chr_Cp(':');

 num = (vAc * 220) / 184;
 numToOne();

 LCD_Chr(1, 12, '~');
 LCD_Chr_Cp(hundreds);
 LCD_Chr_Cp(tens);
 LCD_Chr_Cp(ones);
 LCD_Chr_Cp('V');

 LCD_Chr(2, 3, 'M');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('n');
 LCD_Chr_Cp('s');
 LCD_Chr_Cp(' ');

 if (acStatus ==  0 ){
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('k');
 pad(6);
 }
 else if (acStatus ==  1 ){
 LCD_Chr_Cp('L');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('w');
 LCD_Chr_Cp('/');
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('f');
 LCD_Chr_Cp('f');
 }
 else if (acStatus ==  2 ){
 LCD_Chr_Cp('H');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('g');
 LCD_Chr_Cp('h');
 pad(4);
 }
 break;
 case 3:
 LCD_Chr(1, 3, 'I');
 LCD_Chr_Cp('n');
 LCD_Chr_Cp('v');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp(' ');
 if ((inverterState ==  0 ) & (mode ==  0 )){
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('n');
 pad(3);
 }
 else if ((inverterState ==  3 ) | (mode ==  1 )){
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('f');
 LCD_Chr_Cp('f');
 pad(2);
 LCD_Chr(2, 4, 'S');
 LCD_Chr_Cp('w');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('c');
 LCD_Chr_Cp('h');
 LCD_Chr_Cp(' ');
 if (inverterSw == 1){
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('f');
 LCD_Chr_Cp('f');
 }
 else{
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('n');
 pad(2);
 }
 }
 else{
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('f');
 LCD_Chr_Cp('f');
 pad(2);

 if (inverterState ==  1 ){
 LCD_Chr(2, 1, 'B');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('y');
 LCD_Chr_Cp(' ');
 LCD_Chr_Cp('L');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('w');
 }
 else if (inverterState ==  2 ){
 LCD_Chr(2, 1, ' ');
 pad(4);
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('v');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('l');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('d');
 }
 }
 break;
 case 4:
 LCD_Chr(1, 1, 'B');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('y');
 LCD_Chr_Cp(' ');
 LCD_Chr_Cp('V');
 LCD_Chr_Cp(':');

 num = vBat;
 numToOne();
 LCD_Chr(1, 12, hundreds);
 LCD_Chr_Cp( tens);
 LCD_Chr_Cp('.');
 LCD_Chr_Cp( ones);
 LCD_Chr_Cp('V');

 LCD_Chr(2, 1, 'B');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('y');
 LCD_Chr_Cp(' ');

 if (batteryState ==  2 ){
 LCD_Chr_Cp('L');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('w');
 pad(1);
 }
 else if ((batteryState ==  4 ) | (batteryState ==  5 )) {
 if (hicutreached){
 LCD_Chr_Cp('F');
 LCD_Chr_Cp('u');
 LCD_Chr_Cp('l');
 LCD_Chr_Cp('l');
 pad(2);
 }
 else{
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('K');
 pad(4);
 }
 }
 else{
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('K');
 pad(4);
 }

 if (inverterState ==  0 ){
 lv1 = 104;
 lv2 = 108;
 lv3 = 113;
 lv4 = 117;
 }
 else if (mode ==  1 ){
 if (hicutreached){
 lv1 = 104;
 lv2 = 108;
 lv3 = 113;
 lv4 = 117;

 }
 else{
 lv1 = 113;
 lv2 = 120;
 lv3 = 125;
 lv4 = 135;
 }
 }
 else{
 lv1 = 115;
 lv2 = 118;
 lv3 = 121;
 lv4 = 123;
 }

 if (vBat < lv1){
 batlv = 1;
 }
 else if (vBat < lv2){
 batlv = 2;
 }
 else if (vBat < lv3){
 batlv = 3;
 }
 else if (vBat < lv4){
 batlv = 4;
 }
 else{
 batlv = 5;
 }

 batteryIcon(2,15);

 break;

 case 5:
 LCD_Chr(1, 2, 'C');
 LCD_Chr_Cp('h');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('g');
 LCD_Chr_Cp('i');
 LCD_Chr_Cp('n');
 LCD_Chr_Cp('g');
 LCD_Chr_Cp(' ');

 if (mode ==  0 ){
 LCD_Chr_Cp('O');
 LCD_Chr_Cp('f');
 LCD_Chr_Cp('f');
 pad(2);
 LCD_Chr(2, 1, ' ');
 pad(13);
 }
 else{
 if (hicutreached){
 LCD_Chr_Cp('F');
 LCD_Chr_Cp('u');
 LCD_Chr_Cp('l');
 LCD_Chr_Cp('l');
 LCD_Chr(2, 1, ' ');
 pad(13);
 }
 else{
 batlv = (lcdCounter * 10) / t1pr + 1;
 if (batlv > 5) batlv = batlv - 5;
 batteryIcon(1, 11);
 pad(6);
 }
 }
 break;
 case 6:

 loadpc = (vShunt * 100) / ovThreshold;
 num = loadpc;
 numToOne();
 if (loadpc > 99) loadpc = 99;

 LCD_Chr(1, 1, 'I');
 LCD_Chr_Cp('n');
 LCD_Chr_Cp('v');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp('t');
 LCD_Chr_Cp('e');
 LCD_Chr_Cp('r');
 LCD_Chr_Cp(' ');
 LCD_Chr_Cp('L');
 LCD_Chr_Cp('o');
 LCD_Chr_Cp('a');
 LCD_Chr_Cp('d');
 LCD_Chr_Cp(':');

 LCD_Chr(2, 5, '(');
 LCD_Chr_Cp( tens );
 LCD_Chr_Cp( ones );
 LCD_Chr_Cp(' ');
 LCD_Chr_Cp('%');
 LCD_Chr_Cp(')');

 break;




 }

 }
}
