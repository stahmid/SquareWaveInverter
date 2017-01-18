/* Modified 1/9/2017. Issues to be fixed:
 * 1. Display reportedly gets blocky and stops displaying info after a few weeks.
 * 2. Some MOSFETs supposedly blow up when switching to mains mode.
 * 3. Overload doesn't work with prescribed component values for 1000W.
 * 4. Charging current is not settable with pot. Charging current automatically set to ~15A.
 * 5. Need to rewire LCD pins so that they are in sequence. 
 */
typedef volatile unsigned int uint16;
typedef volatile unsigned char uint8;

uint8 duty = 30; // start with minimum duty cycle
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

#define drvOff              0
#define drvMOS1             1
#define drvMOS2             2

#define acNormal            0
#define acLow               1
#define acHigh              2

#define acLowLevel          114    // about 138VAC
#define acHighLevel         215   // about 255VAC
#define hysteresis          4  // about 5V

#define mainsCHANNEL        2
#define batteryCHANNEL      0
#define feedbackCHANNEL     1
#define shuntCHANNEL        3
#define iCHANNEL            4

#define batteryWarning      1
#define batteryLow          2
#define batteryNormal       3
#define batteryHigh         4
#define batteryPause        5  // just stopped charging - waiting to drop

#define bat_low             95 // about 9.6V apparently
#define bat_warning         105 // 10.5V
#define bat_rechg           125 // 12.5V -> restart charging after hicut
#define bat_high            142 // 14.2V

#define feedbackThreshold   48
#define dutyMax             47  // 94%
#define dutyMin             30  // 60%

#define mode_inverter       0
#define mode_mains          1

#define overloadThreshold   27
#define ovl_normal          0
#define ovl_overload        1

#define inv_normal          0
#define inv_lowbattery      1
#define inv_overload        2
#define inv_off             3

#define maxLCDstates        7

// 3.6V for 220VAC
// 2.24V for 142VAC
// 3.94V for 240VAC

sbit MOS1 at RC6_bit;
sbit MOS2 at RC5_bit;
sbit outputRelay at RB4_bit;
sbit inverterSw at RB5_bit;
sbit Triac at RB3_bit;

sbit LCD_RS at RC4_bit;
sbit LCD_EN at RB7_bit;
sbit LCD_D4 at RC3_bit;
sbit LCD_D5 at RC2_bit;
sbit LCD_D6 at RC1_bit;
sbit LCD_D7 at RC0_bit;

sbit LCD_RS_Direction at TRISC4_bit;
sbit LCD_EN_Direction at TRISB7_bit;
sbit LCD_D4_Direction at TRISC3_bit;
sbit LCD_D5_Direction at TRISC2_bit;
sbit LCD_D6_Direction at TRISC1_bit;
sbit LCD_D7_Direction at TRISC0_bit;

void interrupt(){
     if (TMR2IF_bit){
        if (mode == mode_inverter){
           if (MOSdriveState){

              if (MOSdriveState == drvMOS1){
                 duty = duty_buffer;
              }

              dutyCounter++;

              if (dutyCounter == duty){
                 MOS1 = 0;
                 MOS2 = 0;
              }

              if (dutyCounter == period){
                 dutyCounter = 0;
                 if (MOSdriveState == drvMOS1){
                    MOS2 = 0;
                    delay_us(1);
                    MOS1 = 1;

                    MOSdriveState = drvMOS2;

                 }
                 else if (MOSdriveState == drvMOS2){
                      MOS1 = 0;
                      delay_us(1);
                      MOS2 = 1;

                      MOSdriveState = drvMOS1;
                 }
              }

           }
           else{
                MOS1 = 0;
                MOS2 = 0;
           }

        }
        else{  // mode == mode_mains

           cdCounter++;
           if (cdCounter == chargingDuty){
              if ((hicutreached == 0) && (chargingEnabled == 1)){
                 Triac = 1;       // fire Triac
              }
              else{
                 Triac = 0;
              }
           }
           else{
              Triac = 0;      // ensure Triac is off
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

void initializePWM(){
     T2CON = 5; // prescaler 1:4, t2 on
     PR2 = 249; // period = 10ms / 50 (50 steps to 10ms)
     TMR2IF_bit = 0;
     TMR2IE_bit = 1;

     T1CON = 0x11; // period = 23.2ms, t1 on

     MOSdriveState = drvMOS1;
     duty_buffer = dutyMin;       // minimum duty cycle
     duty = duty_buffer;
     overloadState = ovl_normal;
     overloadcounter = 0;
     mainsStarted = 0;
     Triac = 0;
     INTE_bit = 0;
     ovThreshold = overloadThreshold;

}

void stopPWM(){
     //T1CON = 0;
     //TMR1H = 0; TMR1L = 0;
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
/* Mains voltage to be obtained through a 220V-18V transformer
 * The transformer output is to be rectified, filtered and stepped down
 * to be fed to the PIC.
 * AC voltage levels are "hard-fixed" such that:

 * 220VAC = 3.60V on pin
 * 240VAC = 3.94V on pin
 * 140VAC = 2.24V on pin
 */

   ADCON1 = 0;
   ADCON0 = (ADCON0 & 0xC5) | (mainsCHANNEL << 3);

   vAc = 0;
   for (counter = 0; counter < 8; counter++){
       vAc = vAc + ADC_Get_Sample(mainsCHANNEL);
   }

   vAc = vAc >> 3; // 8/8 = 1

   if (acStatus == acLow){
      ac_low = acLowLevel + hysteresis;
   }
   else{
      ac_low = acLowLevel;
   }

   if (acStatus == acHigh){
      ac_high = acHighLevel - hysteresis;
   }
   else{
      ac_high = acHighLevel;
   }

   if (vAc < ac_low){
      acStatus = acLow;
   }
   else if (vAc > ac_high){
      acStatus = acHigh;
   }
   else{
      acStatus = acNormal;
   }

   //firing = (vAc * 32)/184;    // 184 -> 220VAC

   ADCON1 = 7;

}

void getBatteryVoltage(){
/* Battery voltage to be obtained through a voltage divider such that
 * max voltage measured is 25.5V (since this is for a 12V system).
 */

   ADCON1 = 0;

   vBat = 0;
   ADCON0 = (ADCON0 & 0xC5) | (batteryCHANNEL << 3);
   for (counter = 0; counter < 8; counter++){
       vBat = vBat + ADC_Get_Sample(batteryCHANNEL);
   }

   vBat = vBat >> 3; // 8/8 = 1

   //vBat = (vBat * 120) / 198;  // For now, 198 is 12.0V; so scale it linearly

   if ((batteryState != batteryLow) | (mode == mode_mains)){
      if (vBat < bat_low){
         batteryState = batteryLow;
         hicutreached = 0;
      }
      else if (vBat < bat_warning){
         batteryState = batteryWarning;
         hicutreached = 0;
      }
      else if (vBat > bat_high){
         hicutreached = 1;
         batteryState = batteryHigh;
      }
      else if (vBat > bat_rechg){
         if (hicutreached){
            batteryState = batteryHigh;
         }
         else{
            batteryState = batteryPause;
         }
      }
      else{
         batteryState = batteryNormal;
         hicutreached = 0;
      }
   }

   ADCON1 = 7;
}

void doChecks(){
     if (acStatus != acNormal){
        mode = mode_inverter;
     }
     else{
        mode = mode_mains;
        inverterState = inv_off;
     }

     if ((batteryState != batteryLow) & (overloadState == ovl_normal)){
        if (inverterSw == 0){         // inverter switch pressed
           inverterState = inv_normal;
        }
        else{
             inverterState = inv_off;
        }
     }
     else if (batteryState == batteryLow){
        inverterState = inv_lowbattery;
     }
     else if (overloadState == ovl_overload){
        inverterState = inv_overload;
     }

     if (inverterSw == 1){ // switch unpressed
        inverterState = inv_off;
     }

     if (mode == mode_mains){
        if (mainsStarted == 0){
           /*
            *  Mains initialization
            */

            chargingEnabled = 0;
            
           // Stop PWM
           TMR2IF_bit = 0; TMR2IE_bit = 0;
           TMR2 = 0;
           MOS1 = 0;
           MOS2 = 0;
           MOSdriveState = 0;
           pwmStarted = 0;
           Triac = 0;
           INTE_bit = 0;

           inverterState = inv_off;
                   
           delay_ms(20); // settling time to ensure everything is off
           outputRelay = 0;
           delay_ms(20);

           INTEDG_bit = 1; // rising edge
           INTE_bit = 1;
           INTF_bit = 0;
           mainsStarted = 1;

           T2CON = 5;   // prescaler 1:4, t2 on
           PR2 = 249;   // period = 200us, 50 steps
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
           T1CON = 0x31;  // period ~105ms, t1 on
           TMR1IF_bit = 0;

           firing = 100; // should never start
           chargingEnabled = 0;

           delayCounter = 0;
           delayCounter2 = 0;
           
           chlv = 0;
           
           ovThreshold = overloadThreshold;

        }

     }
     else if (mode == mode_inverter){
        cdCounter = 0;
        Triac = 0;
        mainsStarted = 0;
        if (inverterState == inv_normal){
           if (pwmStarted == 0){
              initializePWM();
              pwmStarted = 1;
              outputRelay = 1;
           }
        }
        else{
           // Stop PWM
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

           if (inverterState == inv_off){
              batteryState = batteryNormal;
              overloadState = ovl_normal;
              vShunt = 0;
           }
        }
     }
}

void doFeedback(){
     ADCON1 = 0;

     ADCON0 = (ADCON0 & 0xC5) | (feedbackCHANNEL << 3);

     vFb = 0;

     for (loopcounter = 0; loopcounter < 4; loopcounter++){
         vFb += ADC_Get_Sample(feedbackCHANNEL);
     }

     vFb = vFb >> 2;   // average

     if (vFb < (feedbackThreshold )){
        if (duty_buffer < dutyMax){
           duty_buffer++;
        }
     }
     else if (vFb > (feedbackThreshold + 1)){
        if (duty_buffer > dutyMin){
           duty_buffer--;
        }
     }

     ADCON1 = 7;
}

void getOverload(){
     ADCON1 = 0;

     ADCON0 = (ADCON0 & 0xC5) | (shuntCHANNEL << 3);

     vShunt = 0;
     loopcounter = 0;
     TMR1H = 0; TMR1L = 0;
     TMR1IF_bit = 0;

     while (TMR1IF_bit == 0){
           adTemp = 0;
           for (counter = 0; counter < 64; counter++){
               adTemp += ADC_Get_Sample(shuntCHANNEL);
           }
           //getMainsVoltage();
           loopcounter++;
           adTemp = adTemp >> 6;  // average. (>>6 = /64)
           vShunt += adTemp;
     }
     vShunt /= loopcounter;

     ovThreshold = (overloadThreshold * 120)/vBat;  // recalculate current for current V
     
     if (vShunt > (ovThreshold * 3)){
        overloadState = ovl_overload;
     }
     else{
          if (vShunt > ovThreshold){
             overloadcounter++;
             if (overloadcounter >= 7){
                overloadState = ovl_overload;
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
     MOSdriveState = drvMOS1;
     pwmStarted = 0;
     mode = mode_inverter;
     acStatus = acLow;
     mainsStarted = 0;
     hicutreached = 0;
     chgDelay = 0;
     lcdState = 0;
     lcdCounter = 0;
     batlv = 1;

     LCD_Init();
     LCD_Cmd(_LCD_CLEAR);
     LCD_Cmd(_LCD_CURSOR_OFF);

     T1CON = 0x31;   // period = 105ms, t1 on

     while (1){
           getMainsVoltage();
           getBatteryVoltage();
           doChecks();

           if (mode == mode_inverter){
              chargingEnabled = 0;
              if (inverterState == inv_normal){
                 getOverload();
                 //if (TMR1IF_bit){
                    doFeedback();
                    TMR1IF_bit = 0;
                    lcdCounter++;
                 //}
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
                            if (delayCounter > 100){    // after 20 seconds go to normal
                               chgDelay = 1;
                               chargingEnabled = 1;
                               //T1CON = 0; // t1 off
                            }
                            else if (delayCounter > 50){    // initial 10 seconds delay

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
                                 //delayCounter = 0;
                         }
                         TMR1IF_bit = 0;
                      }
                   }
                   else{
                        firing = (vAc * 32)/184;    // 184 -> 220VAC
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

           // t1pr gives update time (~ 3 seconds)
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
              LCD_Cmd(_LCD_CLEAR);
              chgDot = 0;
              if (lcdState >= maxLCDstates){
                 lcdState = 0;
              }
              lcdCounter = 0;
           }

           switch (lcdState){
                  case 0:    // show company name
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
                  case 2:    // show mains state
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

                       if (acStatus == acNormal){
                          LCD_Chr_Cp('O');
                          LCD_Chr_Cp('k');
                          pad(6);
                       }
                       else if (acStatus == acLow){
                          LCD_Chr_Cp('L');
                          LCD_Chr_Cp('o');
                          LCD_Chr_Cp('w');
                          LCD_Chr_Cp('/');
                          LCD_Chr_Cp('O');
                          LCD_Chr_Cp('f');
                          LCD_Chr_Cp('f');
                       }
                       else if (acStatus == acHigh){
                          LCD_Chr_Cp('H');
                          LCD_Chr_Cp('i');
                          LCD_Chr_Cp('g');
                          LCD_Chr_Cp('h');
                          pad(4);
                       }
                       break;
                  case 3:    // show inverter state
                       LCD_Chr(1, 3, 'I');
                       LCD_Chr_Cp('n');
                       LCD_Chr_Cp('v');
                       LCD_Chr_Cp('e');
                       LCD_Chr_Cp('r');
                       LCD_Chr_Cp('t');
                       LCD_Chr_Cp('e');
                       LCD_Chr_Cp('r');
                       LCD_Chr_Cp(' ');
                       if ((inverterState == inv_normal) & (mode == mode_inverter)){
                          LCD_Chr_Cp('O');
                          LCD_Chr_Cp('n');
                          pad(3);
                       }
                       else if ((inverterState == inv_off) | (mode == mode_mains)){
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

                          if (inverterState == inv_lowbattery){
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
                          else if (inverterState == inv_overload){
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
                  case 4:    // show battery state
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

                       if (batteryState == batteryLow){
                          LCD_Chr_Cp('L');
                          LCD_Chr_Cp('o');
                          LCD_Chr_Cp('w');
                          pad(1);
                       }
                       else if ((batteryState == batteryHigh) | (batteryState == batteryPause)) {
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

                       if (inverterState == inv_normal){
                          lv1 = 104;
                          lv2 = 108;
                          lv3 = 113;
                          lv4 = 117;
                       }
                       else if (mode == mode_mains){
                          if (hicutreached){
                             lv1 = 104;
                             lv2 = 108;
                             lv3 = 113;
                             lv4 = 117;
                             // doesn't matter since it'll show lv5
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

                  case 5:    // show charging state
                       LCD_Chr(1, 2, 'C');
                       LCD_Chr_Cp('h');
                       LCD_Chr_Cp('a');
                       LCD_Chr_Cp('r');
                       LCD_Chr_Cp('g');
                       LCD_Chr_Cp('i');
                       LCD_Chr_Cp('n');
                       LCD_Chr_Cp('g');
                       LCD_Chr_Cp(' ');

                       if (mode == mode_inverter){
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
                  case 6:    // show load percentage

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
                  //case default: // default to company name
                  //     lcdState = 0;
                  //     break;

           }

     }
}