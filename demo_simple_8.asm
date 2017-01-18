
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;demo_simple_8.c,163 :: 		void interrupt(){
;demo_simple_8.c,164 :: 		if (TMR2IF_bit){
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;demo_simple_8.c,165 :: 		if (mode == mode_inverter){
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;demo_simple_8.c,166 :: 		if (MOSdriveState){
	MOVF       _MOSdriveState+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt2
;demo_simple_8.c,168 :: 		if (MOSdriveState == drvMOS1){
	MOVF       _MOSdriveState+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;demo_simple_8.c,169 :: 		duty = duty_buffer;
	MOVF       _duty_buffer+0, 0
	MOVWF      _duty+0
;demo_simple_8.c,170 :: 		}
L_interrupt3:
;demo_simple_8.c,172 :: 		dutyCounter++;
	INCF       _dutyCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _dutyCounter+0
;demo_simple_8.c,174 :: 		if (dutyCounter == duty){
	MOVF       _dutyCounter+0, 0
	XORWF      _duty+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;demo_simple_8.c,175 :: 		MOS1 = 0;
	BCF        RC6_bit+0, 6
;demo_simple_8.c,176 :: 		MOS2 = 0;
	BCF        RC5_bit+0, 5
;demo_simple_8.c,177 :: 		}
L_interrupt4:
;demo_simple_8.c,179 :: 		if (dutyCounter == period){
	MOVF       _dutyCounter+0, 0
	XORWF      _period+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
;demo_simple_8.c,180 :: 		dutyCounter = 0;
	CLRF       _dutyCounter+0
;demo_simple_8.c,181 :: 		if (MOSdriveState == drvMOS1){
	MOVF       _MOSdriveState+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;demo_simple_8.c,182 :: 		MOS2 = 0;
	BCF        RC5_bit+0, 5
;demo_simple_8.c,183 :: 		delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;demo_simple_8.c,184 :: 		MOS1 = 1;
	BSF        RC6_bit+0, 6
;demo_simple_8.c,186 :: 		MOSdriveState = drvMOS2;
	MOVLW      2
	MOVWF      _MOSdriveState+0
;demo_simple_8.c,188 :: 		}
	GOTO       L_interrupt7
L_interrupt6:
;demo_simple_8.c,189 :: 		else if (MOSdriveState == drvMOS2){
	MOVF       _MOSdriveState+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;demo_simple_8.c,190 :: 		MOS1 = 0;
	BCF        RC6_bit+0, 6
;demo_simple_8.c,191 :: 		delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;demo_simple_8.c,192 :: 		MOS2 = 1;
	BSF        RC5_bit+0, 5
;demo_simple_8.c,194 :: 		MOSdriveState = drvMOS1;
	MOVLW      1
	MOVWF      _MOSdriveState+0
;demo_simple_8.c,195 :: 		}
L_interrupt8:
L_interrupt7:
;demo_simple_8.c,196 :: 		}
L_interrupt5:
;demo_simple_8.c,198 :: 		}
	GOTO       L_interrupt9
L_interrupt2:
;demo_simple_8.c,200 :: 		MOS1 = 0;
	BCF        RC6_bit+0, 6
;demo_simple_8.c,201 :: 		MOS2 = 0;
	BCF        RC5_bit+0, 5
;demo_simple_8.c,202 :: 		}
L_interrupt9:
;demo_simple_8.c,204 :: 		}
	GOTO       L_interrupt10
L_interrupt1:
;demo_simple_8.c,207 :: 		cdCounter++;
	INCF       _cdCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _cdCounter+0
;demo_simple_8.c,208 :: 		if (cdCounter == chargingDuty){
	MOVF       _cdCounter+0, 0
	XORWF      _chargingDuty+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt11
;demo_simple_8.c,209 :: 		if ((hicutreached == 0) && (chargingEnabled == 1)){
	MOVF       _hicutreached+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt14
	MOVLW      0
	XORWF      _chargingEnabled+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt175
	MOVLW      1
	XORWF      _chargingEnabled+0, 0
L__interrupt175:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt14
L__interrupt173:
;demo_simple_8.c,210 :: 		Triac = 1;       // fire Triac
	BSF        RB3_bit+0, 3
;demo_simple_8.c,211 :: 		}
	GOTO       L_interrupt15
L_interrupt14:
;demo_simple_8.c,213 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,214 :: 		}
L_interrupt15:
;demo_simple_8.c,215 :: 		}
	GOTO       L_interrupt16
L_interrupt11:
;demo_simple_8.c,217 :: 		Triac = 0;      // ensure Triac is off
	BCF        RB3_bit+0, 3
;demo_simple_8.c,218 :: 		}
L_interrupt16:
;demo_simple_8.c,221 :: 		}
L_interrupt10:
;demo_simple_8.c,222 :: 		TMR2 = 0;
	CLRF       TMR2+0
;demo_simple_8.c,223 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, 1
;demo_simple_8.c,224 :: 		}
L_interrupt0:
;demo_simple_8.c,226 :: 		if (INTF_bit){
	BTFSS      INTF_bit+0, 1
	GOTO       L_interrupt17
;demo_simple_8.c,227 :: 		cdCounter = 0;
	CLRF       _cdCounter+0
;demo_simple_8.c,228 :: 		INTF_bit = 0;
	BCF        INTF_bit+0, 1
;demo_simple_8.c,229 :: 		TMR2 = 0; TMR2IF_bit = 0;
	CLRF       TMR2+0
	BCF        TMR2IF_bit+0, 1
;demo_simple_8.c,230 :: 		pulseCounter++;
	INCF       _pulseCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _pulseCounter+0
;demo_simple_8.c,231 :: 		if (pulseCounter == 4){
	MOVF       _pulseCounter+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt18
;demo_simple_8.c,232 :: 		pulseCounter = 0;
	CLRF       _pulseCounter+0
;demo_simple_8.c,233 :: 		chargingDuty = firing;
	MOVF       _firing+0, 0
	MOVWF      _chargingDuty+0
;demo_simple_8.c,234 :: 		}
L_interrupt18:
;demo_simple_8.c,235 :: 		}
L_interrupt17:
;demo_simple_8.c,236 :: 		}
L__interrupt174:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_batteryIcon:

;demo_simple_8.c,238 :: 		void batteryIcon(char pos_row, char pos_char) {
;demo_simple_8.c,239 :: 		Lcd_Cmd(64);
	MOVLW      64
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;demo_simple_8.c,240 :: 		for (loopcounter = 0; loopcounter <= 7; loopcounter++){
	CLRF       _loopcounter+0
	CLRF       _loopcounter+1
L_batteryIcon19:
	MOVF       _loopcounter+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__batteryIcon176
	MOVF       _loopcounter+0, 0
	SUBLW      7
L__batteryIcon176:
	BTFSS      STATUS+0, 0
	GOTO       L_batteryIcon20
;demo_simple_8.c,241 :: 		switch (batlv){
	GOTO       L_batteryIcon22
;demo_simple_8.c,242 :: 		case 1:
L_batteryIcon24:
;demo_simple_8.c,243 :: 		character = batlv1[loopcounter];
	MOVF       _loopcounter+0, 0
	ADDLW      _batlv1+0
	MOVWF      R0+0
	MOVLW      hi_addr(_batlv1+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      _character+0
;demo_simple_8.c,244 :: 		break;
	GOTO       L_batteryIcon23
;demo_simple_8.c,245 :: 		case 2:
L_batteryIcon25:
;demo_simple_8.c,246 :: 		character = batlv2[loopcounter];
	MOVF       _loopcounter+0, 0
	ADDLW      _batlv2+0
	MOVWF      R0+0
	MOVLW      hi_addr(_batlv2+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      _character+0
;demo_simple_8.c,247 :: 		break;
	GOTO       L_batteryIcon23
;demo_simple_8.c,248 :: 		case 3:
L_batteryIcon26:
;demo_simple_8.c,249 :: 		character = batlv3[loopcounter];
	MOVF       _loopcounter+0, 0
	ADDLW      _batlv3+0
	MOVWF      R0+0
	MOVLW      hi_addr(_batlv3+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      _character+0
;demo_simple_8.c,250 :: 		break;
	GOTO       L_batteryIcon23
;demo_simple_8.c,251 :: 		case 4:
L_batteryIcon27:
;demo_simple_8.c,252 :: 		character = batlv4[loopcounter];
	MOVF       _loopcounter+0, 0
	ADDLW      _batlv4+0
	MOVWF      R0+0
	MOVLW      hi_addr(_batlv4+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      _character+0
;demo_simple_8.c,253 :: 		break;
	GOTO       L_batteryIcon23
;demo_simple_8.c,254 :: 		case 5:
L_batteryIcon28:
;demo_simple_8.c,255 :: 		character = batlv5[loopcounter];
	MOVF       _loopcounter+0, 0
	ADDLW      _batlv5+0
	MOVWF      R0+0
	MOVLW      hi_addr(_batlv5+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      _character+0
;demo_simple_8.c,256 :: 		break;
	GOTO       L_batteryIcon23
;demo_simple_8.c,257 :: 		}
L_batteryIcon22:
	MOVF       _batlv+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_batteryIcon24
	MOVF       _batlv+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_batteryIcon25
	MOVF       _batlv+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_batteryIcon26
	MOVF       _batlv+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_batteryIcon27
	MOVF       _batlv+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_batteryIcon28
L_batteryIcon23:
;demo_simple_8.c,258 :: 		Lcd_Chr_CP(character);
	MOVF       _character+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,240 :: 		for (loopcounter = 0; loopcounter <= 7; loopcounter++){
	MOVF       _loopcounter+0, 0
	ADDLW      1
	MOVWF      R0+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _loopcounter+0
	MOVF       R0+1, 0
	MOVWF      _loopcounter+1
;demo_simple_8.c,259 :: 		}
	GOTO       L_batteryIcon19
L_batteryIcon20:
;demo_simple_8.c,260 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW      2
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;demo_simple_8.c,261 :: 		Lcd_Chr(pos_row, pos_char, 0);
	MOVF       FARG_batteryIcon_pos_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_batteryIcon_pos_char+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	CLRF       FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,262 :: 		}
	RETURN
; end of _batteryIcon

_initializePeripherals:

;demo_simple_8.c,264 :: 		void initializePeripherals(){
;demo_simple_8.c,266 :: 		ADC_Init();
	CALL       _ADC_Init+0
;demo_simple_8.c,268 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, 7
;demo_simple_8.c,269 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, 6
;demo_simple_8.c,270 :: 		}
	RETURN
; end of _initializePeripherals

_initializePWM:

;demo_simple_8.c,272 :: 		void initializePWM(){
;demo_simple_8.c,273 :: 		T2CON = 5; // prescaler 1:4, t2 on
	MOVLW      5
	MOVWF      T2CON+0
;demo_simple_8.c,274 :: 		PR2 = 249; // period = 10ms / 50 (50 steps to 10ms)
	MOVLW      249
	MOVWF      PR2+0
;demo_simple_8.c,275 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, 1
;demo_simple_8.c,276 :: 		TMR2IE_bit = 1;
	BSF        TMR2IE_bit+0, 1
;demo_simple_8.c,278 :: 		T1CON = 0x11; // period = 23.2ms, t1 on
	MOVLW      17
	MOVWF      T1CON+0
;demo_simple_8.c,280 :: 		MOSdriveState = drvMOS1;
	MOVLW      1
	MOVWF      _MOSdriveState+0
;demo_simple_8.c,281 :: 		duty_buffer = dutyMin;       // minimum duty cycle
	MOVLW      30
	MOVWF      _duty_buffer+0
;demo_simple_8.c,282 :: 		duty = duty_buffer;
	MOVF       _duty_buffer+0, 0
	MOVWF      _duty+0
;demo_simple_8.c,283 :: 		overloadState = ovl_normal;
	CLRF       _overloadState+0
;demo_simple_8.c,284 :: 		overloadcounter = 0;
	CLRF       _overloadcounter+0
;demo_simple_8.c,285 :: 		mainsStarted = 0;
	CLRF       _mainsStarted+0
;demo_simple_8.c,286 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,287 :: 		INTE_bit = 0;
	BCF        INTE_bit+0, 4
;demo_simple_8.c,288 :: 		ovThreshold = overloadThreshold;
	MOVLW      27
	MOVWF      _ovThreshold+0
	MOVLW      0
	MOVWF      _ovThreshold+1
;demo_simple_8.c,290 :: 		}
	RETURN
; end of _initializePWM

_stopPWM:

;demo_simple_8.c,292 :: 		void stopPWM(){
;demo_simple_8.c,295 :: 		TMR2IF_bit = 0; TMR2IE_bit = 0;
	BCF        TMR2IF_bit+0, 1
	BCF        TMR2IE_bit+0, 1
;demo_simple_8.c,296 :: 		TMR2 = 0;
	CLRF       TMR2+0
;demo_simple_8.c,297 :: 		MOS1 = 0;
	BCF        RC6_bit+0, 6
;demo_simple_8.c,298 :: 		MOS2 = 0;
	BCF        RC5_bit+0, 5
;demo_simple_8.c,299 :: 		MOSdriveState = 0;
	CLRF       _MOSdriveState+0
;demo_simple_8.c,300 :: 		outputRelay = 0;
	BCF        RB4_bit+0, 4
;demo_simple_8.c,301 :: 		pwmStarted = 0;
	CLRF       _pwmStarted+0
;demo_simple_8.c,302 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,303 :: 		INTE_bit = 0;
	BCF        INTE_bit+0, 4
;demo_simple_8.c,304 :: 		}
	RETURN
; end of _stopPWM

_initializeIO:

;demo_simple_8.c,306 :: 		void initializeIO(){
;demo_simple_8.c,307 :: 		TRISA = 0x2F;
	MOVLW      47
	MOVWF      TRISA+0
;demo_simple_8.c,308 :: 		TRISB = 0x21;
	MOVLW      33
	MOVWF      TRISB+0
;demo_simple_8.c,309 :: 		TRISC = 0;
	CLRF       TRISC+0
;demo_simple_8.c,310 :: 		PORTA = 0;
	CLRF       PORTA+0
;demo_simple_8.c,311 :: 		PORTB = 0;
	CLRF       PORTB+0
;demo_simple_8.c,312 :: 		PORTC = 0;
	CLRF       PORTC+0
;demo_simple_8.c,313 :: 		ADCON1 = 7;
	MOVLW      7
	MOVWF      ADCON1+0
;demo_simple_8.c,314 :: 		}
	RETURN
; end of _initializeIO

_getMainsVoltage:

;demo_simple_8.c,316 :: 		void getMainsVoltage(){
;demo_simple_8.c,327 :: 		ADCON1 = 0;
	CLRF       ADCON1+0
;demo_simple_8.c,328 :: 		ADCON0 = (ADCON0 & 0xC5) | (mainsCHANNEL << 3);
	MOVLW      197
	ANDWF      ADCON0+0, 0
	MOVWF      R0+0
	MOVLW      16
	IORWF      R0+0, 0
	MOVWF      ADCON0+0
;demo_simple_8.c,330 :: 		vAc = 0;
	CLRF       _vAc+0
	CLRF       _vAc+1
;demo_simple_8.c,331 :: 		for (counter = 0; counter < 8; counter++){
	CLRF       _counter+0
L_getMainsVoltage29:
	MOVLW      8
	SUBWF      _counter+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_getMainsVoltage30
;demo_simple_8.c,332 :: 		vAc = vAc + ADC_Get_Sample(mainsCHANNEL);
	MOVLW      2
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0+0, 0
	ADDWF      _vAc+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _vAc+1, 1
;demo_simple_8.c,331 :: 		for (counter = 0; counter < 8; counter++){
	INCF       _counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _counter+0
;demo_simple_8.c,333 :: 		}
	GOTO       L_getMainsVoltage29
L_getMainsVoltage30:
;demo_simple_8.c,335 :: 		vAc = vAc >> 3; // 8/8 = 1
	MOVF       _vAc+0, 0
	MOVWF      R0+0
	MOVF       _vAc+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      _vAc+0
	MOVF       R0+1, 0
	MOVWF      _vAc+1
;demo_simple_8.c,337 :: 		if (acStatus == acLow){
	MOVF       _acStatus+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_getMainsVoltage32
;demo_simple_8.c,338 :: 		ac_low = acLowLevel + hysteresis;
	MOVLW      118
	MOVWF      _ac_low+0
;demo_simple_8.c,339 :: 		}
	GOTO       L_getMainsVoltage33
L_getMainsVoltage32:
;demo_simple_8.c,341 :: 		ac_low = acLowLevel;
	MOVLW      114
	MOVWF      _ac_low+0
;demo_simple_8.c,342 :: 		}
L_getMainsVoltage33:
;demo_simple_8.c,344 :: 		if (acStatus == acHigh){
	MOVF       _acStatus+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_getMainsVoltage34
;demo_simple_8.c,345 :: 		ac_high = acHighLevel - hysteresis;
	MOVLW      211
	MOVWF      _ac_high+0
	CLRF       _ac_high+1
;demo_simple_8.c,346 :: 		}
	GOTO       L_getMainsVoltage35
L_getMainsVoltage34:
;demo_simple_8.c,348 :: 		ac_high = acHighLevel;
	MOVLW      215
	MOVWF      _ac_high+0
	CLRF       _ac_high+1
;demo_simple_8.c,349 :: 		}
L_getMainsVoltage35:
;demo_simple_8.c,351 :: 		if (vAc < ac_low){
	MOVLW      0
	SUBWF      _vAc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getMainsVoltage177
	MOVF       _ac_low+0, 0
	SUBWF      _vAc+0, 0
L__getMainsVoltage177:
	BTFSC      STATUS+0, 0
	GOTO       L_getMainsVoltage36
;demo_simple_8.c,352 :: 		acStatus = acLow;
	MOVLW      1
	MOVWF      _acStatus+0
;demo_simple_8.c,353 :: 		}
	GOTO       L_getMainsVoltage37
L_getMainsVoltage36:
;demo_simple_8.c,354 :: 		else if (vAc > ac_high){
	MOVF       _vAc+1, 0
	SUBWF      _ac_high+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getMainsVoltage178
	MOVF       _vAc+0, 0
	SUBWF      _ac_high+0, 0
L__getMainsVoltage178:
	BTFSC      STATUS+0, 0
	GOTO       L_getMainsVoltage38
;demo_simple_8.c,355 :: 		acStatus = acHigh;
	MOVLW      2
	MOVWF      _acStatus+0
;demo_simple_8.c,356 :: 		}
	GOTO       L_getMainsVoltage39
L_getMainsVoltage38:
;demo_simple_8.c,358 :: 		acStatus = acNormal;
	CLRF       _acStatus+0
;demo_simple_8.c,359 :: 		}
L_getMainsVoltage39:
L_getMainsVoltage37:
;demo_simple_8.c,363 :: 		ADCON1 = 7;
	MOVLW      7
	MOVWF      ADCON1+0
;demo_simple_8.c,365 :: 		}
	RETURN
; end of _getMainsVoltage

_getBatteryVoltage:

;demo_simple_8.c,367 :: 		void getBatteryVoltage(){
;demo_simple_8.c,372 :: 		ADCON1 = 0;
	CLRF       ADCON1+0
;demo_simple_8.c,374 :: 		vBat = 0;
	CLRF       _vBat+0
	CLRF       _vBat+1
;demo_simple_8.c,375 :: 		ADCON0 = (ADCON0 & 0xC5) | (batteryCHANNEL << 3);
	MOVLW      197
	ANDWF      ADCON0+0, 1
;demo_simple_8.c,376 :: 		for (counter = 0; counter < 8; counter++){
	CLRF       _counter+0
L_getBatteryVoltage40:
	MOVLW      8
	SUBWF      _counter+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_getBatteryVoltage41
;demo_simple_8.c,377 :: 		vBat = vBat + ADC_Get_Sample(batteryCHANNEL);
	CLRF       FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0+0, 0
	ADDWF      _vBat+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _vBat+1, 1
;demo_simple_8.c,376 :: 		for (counter = 0; counter < 8; counter++){
	INCF       _counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _counter+0
;demo_simple_8.c,378 :: 		}
	GOTO       L_getBatteryVoltage40
L_getBatteryVoltage41:
;demo_simple_8.c,380 :: 		vBat = vBat >> 3; // 8/8 = 1
	MOVF       _vBat+0, 0
	MOVWF      R0+0
	MOVF       _vBat+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      _vBat+0
	MOVF       R0+1, 0
	MOVWF      _vBat+1
;demo_simple_8.c,384 :: 		if ((batteryState != batteryLow) | (mode == mode_mains)){
	MOVF       _batteryState+0, 0
	XORLW      2
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _mode+0, 0
	XORLW      1
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_getBatteryVoltage43
;demo_simple_8.c,385 :: 		if (vBat < bat_low){
	MOVLW      0
	SUBWF      _vBat+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getBatteryVoltage179
	MOVLW      95
	SUBWF      _vBat+0, 0
L__getBatteryVoltage179:
	BTFSC      STATUS+0, 0
	GOTO       L_getBatteryVoltage44
;demo_simple_8.c,386 :: 		batteryState = batteryLow;
	MOVLW      2
	MOVWF      _batteryState+0
;demo_simple_8.c,387 :: 		hicutreached = 0;
	CLRF       _hicutreached+0
;demo_simple_8.c,388 :: 		}
	GOTO       L_getBatteryVoltage45
L_getBatteryVoltage44:
;demo_simple_8.c,389 :: 		else if (vBat < bat_warning){
	MOVLW      0
	SUBWF      _vBat+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getBatteryVoltage180
	MOVLW      105
	SUBWF      _vBat+0, 0
L__getBatteryVoltage180:
	BTFSC      STATUS+0, 0
	GOTO       L_getBatteryVoltage46
;demo_simple_8.c,390 :: 		batteryState = batteryWarning;
	MOVLW      1
	MOVWF      _batteryState+0
;demo_simple_8.c,391 :: 		hicutreached = 0;
	CLRF       _hicutreached+0
;demo_simple_8.c,392 :: 		}
	GOTO       L_getBatteryVoltage47
L_getBatteryVoltage46:
;demo_simple_8.c,393 :: 		else if (vBat > bat_high){
	MOVF       _vBat+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__getBatteryVoltage181
	MOVF       _vBat+0, 0
	SUBLW      142
L__getBatteryVoltage181:
	BTFSC      STATUS+0, 0
	GOTO       L_getBatteryVoltage48
;demo_simple_8.c,394 :: 		hicutreached = 1;
	MOVLW      1
	MOVWF      _hicutreached+0
;demo_simple_8.c,395 :: 		batteryState = batteryHigh;
	MOVLW      4
	MOVWF      _batteryState+0
;demo_simple_8.c,396 :: 		}
	GOTO       L_getBatteryVoltage49
L_getBatteryVoltage48:
;demo_simple_8.c,397 :: 		else if (vBat > bat_rechg){
	MOVF       _vBat+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__getBatteryVoltage182
	MOVF       _vBat+0, 0
	SUBLW      125
L__getBatteryVoltage182:
	BTFSC      STATUS+0, 0
	GOTO       L_getBatteryVoltage50
;demo_simple_8.c,398 :: 		if (hicutreached){
	MOVF       _hicutreached+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_getBatteryVoltage51
;demo_simple_8.c,399 :: 		batteryState = batteryHigh;
	MOVLW      4
	MOVWF      _batteryState+0
;demo_simple_8.c,400 :: 		}
	GOTO       L_getBatteryVoltage52
L_getBatteryVoltage51:
;demo_simple_8.c,402 :: 		batteryState = batteryPause;
	MOVLW      5
	MOVWF      _batteryState+0
;demo_simple_8.c,403 :: 		}
L_getBatteryVoltage52:
;demo_simple_8.c,404 :: 		}
	GOTO       L_getBatteryVoltage53
L_getBatteryVoltage50:
;demo_simple_8.c,406 :: 		batteryState = batteryNormal;
	MOVLW      3
	MOVWF      _batteryState+0
;demo_simple_8.c,407 :: 		hicutreached = 0;
	CLRF       _hicutreached+0
;demo_simple_8.c,408 :: 		}
L_getBatteryVoltage53:
L_getBatteryVoltage49:
L_getBatteryVoltage47:
L_getBatteryVoltage45:
;demo_simple_8.c,409 :: 		}
L_getBatteryVoltage43:
;demo_simple_8.c,411 :: 		ADCON1 = 7;
	MOVLW      7
	MOVWF      ADCON1+0
;demo_simple_8.c,412 :: 		}
	RETURN
; end of _getBatteryVoltage

_doChecks:

;demo_simple_8.c,414 :: 		void doChecks(){
;demo_simple_8.c,415 :: 		if (acStatus != acNormal){
	MOVF       _acStatus+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_doChecks54
;demo_simple_8.c,416 :: 		mode = mode_inverter;
	CLRF       _mode+0
;demo_simple_8.c,417 :: 		}
	GOTO       L_doChecks55
L_doChecks54:
;demo_simple_8.c,419 :: 		mode = mode_mains;
	MOVLW      1
	MOVWF      _mode+0
;demo_simple_8.c,420 :: 		inverterState = inv_off;
	MOVLW      3
	MOVWF      _inverterState+0
;demo_simple_8.c,421 :: 		}
L_doChecks55:
;demo_simple_8.c,423 :: 		if ((batteryState != batteryLow) & (overloadState == ovl_normal)){
	MOVF       _batteryState+0, 0
	XORLW      2
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _overloadState+0, 0
	XORLW      0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_doChecks56
;demo_simple_8.c,424 :: 		if (inverterSw == 0){         // inverter switch pressed
	BTFSC      RB5_bit+0, 5
	GOTO       L_doChecks57
;demo_simple_8.c,425 :: 		inverterState = inv_normal;
	CLRF       _inverterState+0
;demo_simple_8.c,426 :: 		}
	GOTO       L_doChecks58
L_doChecks57:
;demo_simple_8.c,428 :: 		inverterState = inv_off;
	MOVLW      3
	MOVWF      _inverterState+0
;demo_simple_8.c,429 :: 		}
L_doChecks58:
;demo_simple_8.c,430 :: 		}
	GOTO       L_doChecks59
L_doChecks56:
;demo_simple_8.c,431 :: 		else if (batteryState == batteryLow){
	MOVF       _batteryState+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks60
;demo_simple_8.c,432 :: 		inverterState = inv_lowbattery;
	MOVLW      1
	MOVWF      _inverterState+0
;demo_simple_8.c,433 :: 		}
	GOTO       L_doChecks61
L_doChecks60:
;demo_simple_8.c,434 :: 		else if (overloadState == ovl_overload){
	MOVF       _overloadState+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks62
;demo_simple_8.c,435 :: 		inverterState = inv_overload;
	MOVLW      2
	MOVWF      _inverterState+0
;demo_simple_8.c,436 :: 		}
L_doChecks62:
L_doChecks61:
L_doChecks59:
;demo_simple_8.c,438 :: 		if (inverterSw == 1){ // switch unpressed
	BTFSS      RB5_bit+0, 5
	GOTO       L_doChecks63
;demo_simple_8.c,439 :: 		inverterState = inv_off;
	MOVLW      3
	MOVWF      _inverterState+0
;demo_simple_8.c,440 :: 		}
L_doChecks63:
;demo_simple_8.c,442 :: 		if (mode == mode_mains){
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks64
;demo_simple_8.c,443 :: 		if (mainsStarted == 0){
	MOVF       _mainsStarted+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks65
;demo_simple_8.c,448 :: 		chargingEnabled = 0;
	CLRF       _chargingEnabled+0
	CLRF       _chargingEnabled+1
;demo_simple_8.c,451 :: 		TMR2IF_bit = 0; TMR2IE_bit = 0;
	BCF        TMR2IF_bit+0, 1
	BCF        TMR2IE_bit+0, 1
;demo_simple_8.c,452 :: 		TMR2 = 0;
	CLRF       TMR2+0
;demo_simple_8.c,453 :: 		MOS1 = 0;
	BCF        RC6_bit+0, 6
;demo_simple_8.c,454 :: 		MOS2 = 0;
	BCF        RC5_bit+0, 5
;demo_simple_8.c,455 :: 		MOSdriveState = 0;
	CLRF       _MOSdriveState+0
;demo_simple_8.c,456 :: 		pwmStarted = 0;
	CLRF       _pwmStarted+0
;demo_simple_8.c,457 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,458 :: 		INTE_bit = 0;
	BCF        INTE_bit+0, 4
;demo_simple_8.c,460 :: 		inverterState = inv_off;
	MOVLW      3
	MOVWF      _inverterState+0
;demo_simple_8.c,462 :: 		delay_ms(20); // settling time to ensure everything is off
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_doChecks66:
	DECFSZ     R13+0, 1
	GOTO       L_doChecks66
	DECFSZ     R12+0, 1
	GOTO       L_doChecks66
	NOP
	NOP
;demo_simple_8.c,463 :: 		outputRelay = 0;
	BCF        RB4_bit+0, 4
;demo_simple_8.c,464 :: 		delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_doChecks67:
	DECFSZ     R13+0, 1
	GOTO       L_doChecks67
	DECFSZ     R12+0, 1
	GOTO       L_doChecks67
	NOP
	NOP
;demo_simple_8.c,466 :: 		INTEDG_bit = 1; // rising edge
	BSF        INTEDG_bit+0, 6
;demo_simple_8.c,467 :: 		INTE_bit = 1;
	BSF        INTE_bit+0, 4
;demo_simple_8.c,468 :: 		INTF_bit = 0;
	BCF        INTF_bit+0, 1
;demo_simple_8.c,469 :: 		mainsStarted = 1;
	MOVLW      1
	MOVWF      _mainsStarted+0
;demo_simple_8.c,471 :: 		T2CON = 5;   // prescaler 1:4, t2 on
	MOVLW      5
	MOVWF      T2CON+0
;demo_simple_8.c,472 :: 		PR2 = 249;   // period = 200us, 50 steps
	MOVLW      249
	MOVWF      PR2+0
;demo_simple_8.c,473 :: 		TMR2IF_bit = 0;
	BCF        TMR2IF_bit+0, 1
;demo_simple_8.c,474 :: 		TMR2IE_bit = 1;
	BSF        TMR2IE_bit+0, 1
;demo_simple_8.c,476 :: 		chargingDuty = 40;
	MOVLW      40
	MOVWF      _chargingDuty+0
;demo_simple_8.c,477 :: 		chargingDuty_buffer = chargingDuty;
	MOVF       _chargingDuty+0, 0
	MOVWF      _chargingDuty_buffer+0
	CLRF       _chargingDuty_buffer+1
;demo_simple_8.c,479 :: 		cdCounter = 0;
	CLRF       _cdCounter+0
;demo_simple_8.c,481 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,483 :: 		hicutreached = 0;
	CLRF       _hicutreached+0
;demo_simple_8.c,484 :: 		vShunt = 0;
	CLRF       _vShunt+0
	CLRF       _vShunt+1
;demo_simple_8.c,485 :: 		chgDelay = 0;
	CLRF       _chgDelay+0
;demo_simple_8.c,487 :: 		TMR1H = 0; TMR1L = 0;
	CLRF       TMR1H+0
	CLRF       TMR1L+0
;demo_simple_8.c,488 :: 		T1CON = 0x31;  // period ~105ms, t1 on
	MOVLW      49
	MOVWF      T1CON+0
;demo_simple_8.c,489 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,491 :: 		firing = 100; // should never start
	MOVLW      100
	MOVWF      _firing+0
;demo_simple_8.c,492 :: 		chargingEnabled = 0;
	CLRF       _chargingEnabled+0
	CLRF       _chargingEnabled+1
;demo_simple_8.c,494 :: 		delayCounter = 0;
	CLRF       _delayCounter+0
;demo_simple_8.c,495 :: 		delayCounter2 = 0;
	CLRF       _delayCounter2+0
;demo_simple_8.c,497 :: 		chlv = 0;
	CLRF       _chlv+0
;demo_simple_8.c,499 :: 		ovThreshold = overloadThreshold;
	MOVLW      27
	MOVWF      _ovThreshold+0
	MOVLW      0
	MOVWF      _ovThreshold+1
;demo_simple_8.c,501 :: 		}
L_doChecks65:
;demo_simple_8.c,503 :: 		}
	GOTO       L_doChecks68
L_doChecks64:
;demo_simple_8.c,504 :: 		else if (mode == mode_inverter){
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks69
;demo_simple_8.c,505 :: 		cdCounter = 0;
	CLRF       _cdCounter+0
;demo_simple_8.c,506 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,507 :: 		mainsStarted = 0;
	CLRF       _mainsStarted+0
;demo_simple_8.c,508 :: 		if (inverterState == inv_normal){
	MOVF       _inverterState+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks70
;demo_simple_8.c,509 :: 		if (pwmStarted == 0){
	MOVF       _pwmStarted+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks71
;demo_simple_8.c,510 :: 		initializePWM();
	CALL       _initializePWM+0
;demo_simple_8.c,511 :: 		pwmStarted = 1;
	MOVLW      1
	MOVWF      _pwmStarted+0
;demo_simple_8.c,512 :: 		outputRelay = 1;
	BSF        RB4_bit+0, 4
;demo_simple_8.c,513 :: 		}
L_doChecks71:
;demo_simple_8.c,514 :: 		}
	GOTO       L_doChecks72
L_doChecks70:
;demo_simple_8.c,517 :: 		TMR2IF_bit = 0; TMR2IE_bit = 0;
	BCF        TMR2IF_bit+0, 1
	BCF        TMR2IE_bit+0, 1
;demo_simple_8.c,518 :: 		TMR2 = 0;
	CLRF       TMR2+0
;demo_simple_8.c,519 :: 		MOS1 = 0;
	BCF        RC6_bit+0, 6
;demo_simple_8.c,520 :: 		MOS2 = 0;
	BCF        RC5_bit+0, 5
;demo_simple_8.c,521 :: 		MOSdriveState = 0;
	CLRF       _MOSdriveState+0
;demo_simple_8.c,522 :: 		delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_doChecks73:
	DECFSZ     R13+0, 1
	GOTO       L_doChecks73
	DECFSZ     R12+0, 1
	GOTO       L_doChecks73
	NOP
	NOP
;demo_simple_8.c,523 :: 		outputRelay = 0;
	BCF        RB4_bit+0, 4
;demo_simple_8.c,524 :: 		pwmStarted = 0;
	CLRF       _pwmStarted+0
;demo_simple_8.c,525 :: 		Triac = 0;
	BCF        RB3_bit+0, 3
;demo_simple_8.c,526 :: 		INTE_bit = 0;
	BCF        INTE_bit+0, 4
;demo_simple_8.c,528 :: 		if (inverterState == inv_off){
	MOVF       _inverterState+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_doChecks74
;demo_simple_8.c,529 :: 		batteryState = batteryNormal;
	MOVLW      3
	MOVWF      _batteryState+0
;demo_simple_8.c,530 :: 		overloadState = ovl_normal;
	CLRF       _overloadState+0
;demo_simple_8.c,531 :: 		vShunt = 0;
	CLRF       _vShunt+0
	CLRF       _vShunt+1
;demo_simple_8.c,532 :: 		}
L_doChecks74:
;demo_simple_8.c,533 :: 		}
L_doChecks72:
;demo_simple_8.c,534 :: 		}
L_doChecks69:
L_doChecks68:
;demo_simple_8.c,535 :: 		}
	RETURN
; end of _doChecks

_doFeedback:

;demo_simple_8.c,537 :: 		void doFeedback(){
;demo_simple_8.c,538 :: 		ADCON1 = 0;
	CLRF       ADCON1+0
;demo_simple_8.c,540 :: 		ADCON0 = (ADCON0 & 0xC5) | (feedbackCHANNEL << 3);
	MOVLW      197
	ANDWF      ADCON0+0, 0
	MOVWF      R0+0
	MOVLW      8
	IORWF      R0+0, 0
	MOVWF      ADCON0+0
;demo_simple_8.c,542 :: 		vFb = 0;
	CLRF       _vFb+0
	CLRF       _vFb+1
;demo_simple_8.c,544 :: 		for (loopcounter = 0; loopcounter < 4; loopcounter++){
	CLRF       _loopcounter+0
	CLRF       _loopcounter+1
L_doFeedback75:
	MOVLW      0
	SUBWF      _loopcounter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__doFeedback183
	MOVLW      4
	SUBWF      _loopcounter+0, 0
L__doFeedback183:
	BTFSC      STATUS+0, 0
	GOTO       L_doFeedback76
;demo_simple_8.c,545 :: 		vFb += ADC_Get_Sample(feedbackCHANNEL);
	MOVLW      1
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0+0, 0
	ADDWF      _vFb+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _vFb+1, 1
;demo_simple_8.c,544 :: 		for (loopcounter = 0; loopcounter < 4; loopcounter++){
	MOVF       _loopcounter+0, 0
	ADDLW      1
	MOVWF      R0+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _loopcounter+0
	MOVF       R0+1, 0
	MOVWF      _loopcounter+1
;demo_simple_8.c,546 :: 		}
	GOTO       L_doFeedback75
L_doFeedback76:
;demo_simple_8.c,548 :: 		vFb = vFb >> 2;   // average
	MOVF       _vFb+0, 0
	MOVWF      R0+0
	MOVF       _vFb+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      _vFb+0
	MOVF       R0+1, 0
	MOVWF      _vFb+1
;demo_simple_8.c,550 :: 		if (vFb < (feedbackThreshold )){
	MOVLW      0
	SUBWF      _vFb+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__doFeedback184
	MOVLW      48
	SUBWF      _vFb+0, 0
L__doFeedback184:
	BTFSC      STATUS+0, 0
	GOTO       L_doFeedback78
;demo_simple_8.c,551 :: 		if (duty_buffer < dutyMax){
	MOVLW      47
	SUBWF      _duty_buffer+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_doFeedback79
;demo_simple_8.c,552 :: 		duty_buffer++;
	INCF       _duty_buffer+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _duty_buffer+0
;demo_simple_8.c,553 :: 		}
L_doFeedback79:
;demo_simple_8.c,554 :: 		}
	GOTO       L_doFeedback80
L_doFeedback78:
;demo_simple_8.c,555 :: 		else if (vFb > (feedbackThreshold + 1)){
	MOVF       _vFb+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__doFeedback185
	MOVF       _vFb+0, 0
	SUBLW      49
L__doFeedback185:
	BTFSC      STATUS+0, 0
	GOTO       L_doFeedback81
;demo_simple_8.c,556 :: 		if (duty_buffer > dutyMin){
	MOVF       _duty_buffer+0, 0
	SUBLW      30
	BTFSC      STATUS+0, 0
	GOTO       L_doFeedback82
;demo_simple_8.c,557 :: 		duty_buffer--;
	DECF       _duty_buffer+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _duty_buffer+0
;demo_simple_8.c,558 :: 		}
L_doFeedback82:
;demo_simple_8.c,559 :: 		}
L_doFeedback81:
L_doFeedback80:
;demo_simple_8.c,561 :: 		ADCON1 = 7;
	MOVLW      7
	MOVWF      ADCON1+0
;demo_simple_8.c,562 :: 		}
	RETURN
; end of _doFeedback

_getOverload:

;demo_simple_8.c,564 :: 		void getOverload(){
;demo_simple_8.c,565 :: 		ADCON1 = 0;
	CLRF       ADCON1+0
;demo_simple_8.c,567 :: 		ADCON0 = (ADCON0 & 0xC5) | (shuntCHANNEL << 3);
	MOVLW      197
	ANDWF      ADCON0+0, 0
	MOVWF      R0+0
	MOVLW      24
	IORWF      R0+0, 0
	MOVWF      ADCON0+0
;demo_simple_8.c,569 :: 		vShunt = 0;
	CLRF       _vShunt+0
	CLRF       _vShunt+1
;demo_simple_8.c,570 :: 		loopcounter = 0;
	CLRF       _loopcounter+0
	CLRF       _loopcounter+1
;demo_simple_8.c,571 :: 		TMR1H = 0; TMR1L = 0;
	CLRF       TMR1H+0
	CLRF       TMR1L+0
;demo_simple_8.c,572 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,574 :: 		while (TMR1IF_bit == 0){
L_getOverload83:
	BTFSC      TMR1IF_bit+0, 0
	GOTO       L_getOverload84
;demo_simple_8.c,575 :: 		adTemp = 0;
	CLRF       _adTemp+0
	CLRF       _adTemp+1
;demo_simple_8.c,576 :: 		for (counter = 0; counter < 64; counter++){
	CLRF       _counter+0
L_getOverload85:
	MOVLW      64
	SUBWF      _counter+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_getOverload86
;demo_simple_8.c,577 :: 		adTemp += ADC_Get_Sample(shuntCHANNEL);
	MOVLW      3
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0+0, 0
	ADDWF      _adTemp+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adTemp+1, 1
;demo_simple_8.c,576 :: 		for (counter = 0; counter < 64; counter++){
	INCF       _counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _counter+0
;demo_simple_8.c,578 :: 		}
	GOTO       L_getOverload85
L_getOverload86:
;demo_simple_8.c,580 :: 		loopcounter++;
	MOVF       _loopcounter+0, 0
	ADDLW      1
	MOVWF      R0+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _loopcounter+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _loopcounter+0
	MOVF       R0+1, 0
	MOVWF      _loopcounter+1
;demo_simple_8.c,581 :: 		adTemp = adTemp >> 6;  // average. (>>6 = /64)
	MOVLW      6
	MOVWF      R2+0
	MOVF       _adTemp+0, 0
	MOVWF      R0+0
	MOVF       _adTemp+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__getOverload186:
	BTFSC      STATUS+0, 2
	GOTO       L__getOverload187
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	ADDLW      255
	GOTO       L__getOverload186
L__getOverload187:
	MOVF       R0+0, 0
	MOVWF      _adTemp+0
	MOVF       R0+1, 0
	MOVWF      _adTemp+1
;demo_simple_8.c,582 :: 		vShunt += adTemp;
	MOVF       _adTemp+0, 0
	ADDWF      _vShunt+0, 1
	MOVF       _adTemp+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _vShunt+1, 1
;demo_simple_8.c,583 :: 		}
	GOTO       L_getOverload83
L_getOverload84:
;demo_simple_8.c,584 :: 		vShunt /= loopcounter;
	MOVF       _loopcounter+0, 0
	MOVWF      R4+0
	MOVF       _loopcounter+1, 0
	MOVWF      R4+1
	MOVF       _vShunt+0, 0
	MOVWF      R0+0
	MOVF       _vShunt+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _vShunt+0
	MOVF       R0+1, 0
	MOVWF      _vShunt+1
;demo_simple_8.c,586 :: 		ovThreshold = (overloadThreshold * 120)/vBat;  // recalculate current for current V
	MOVF       _vBat+0, 0
	MOVWF      R4+0
	MOVF       _vBat+1, 0
	MOVWF      R4+1
	MOVLW      168
	MOVWF      R0+0
	MOVLW      12
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _ovThreshold+0
	MOVF       R0+1, 0
	MOVWF      _ovThreshold+1
;demo_simple_8.c,588 :: 		if (vShunt > (ovThreshold * 3)){
	MOVF       _ovThreshold+0, 0
	MOVWF      R0+0
	MOVF       _ovThreshold+1, 0
	MOVWF      R0+1
	MOVLW      3
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       _vShunt+1, 0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getOverload188
	MOVF       _vShunt+0, 0
	SUBWF      R0+0, 0
L__getOverload188:
	BTFSC      STATUS+0, 0
	GOTO       L_getOverload88
;demo_simple_8.c,589 :: 		overloadState = ovl_overload;
	MOVLW      1
	MOVWF      _overloadState+0
;demo_simple_8.c,590 :: 		}
	GOTO       L_getOverload89
L_getOverload88:
;demo_simple_8.c,592 :: 		if (vShunt > ovThreshold){
	MOVF       _vShunt+1, 0
	SUBWF      _ovThreshold+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getOverload189
	MOVF       _vShunt+0, 0
	SUBWF      _ovThreshold+0, 0
L__getOverload189:
	BTFSC      STATUS+0, 0
	GOTO       L_getOverload90
;demo_simple_8.c,593 :: 		overloadcounter++;
	INCF       _overloadcounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _overloadcounter+0
;demo_simple_8.c,594 :: 		if (overloadcounter >= 7){
	MOVLW      7
	SUBWF      _overloadcounter+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_getOverload91
;demo_simple_8.c,595 :: 		overloadState = ovl_overload;
	MOVLW      1
	MOVWF      _overloadState+0
;demo_simple_8.c,596 :: 		}
L_getOverload91:
;demo_simple_8.c,597 :: 		}
	GOTO       L_getOverload92
L_getOverload90:
;demo_simple_8.c,599 :: 		overloadcounter = 0;
	CLRF       _overloadcounter+0
;demo_simple_8.c,600 :: 		}
L_getOverload92:
;demo_simple_8.c,601 :: 		}
L_getOverload89:
;demo_simple_8.c,603 :: 		ADCON1 = 7;
	MOVLW      7
	MOVWF      ADCON1+0
;demo_simple_8.c,604 :: 		}
	RETURN
; end of _getOverload

_numToOne:

;demo_simple_8.c,606 :: 		void numToOne(){
;demo_simple_8.c,607 :: 		hundreds = num / 100 + 48;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _num+0, 0
	MOVWF      R0+0
	MOVF       _num+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _hundreds+0
;demo_simple_8.c,608 :: 		tens = ( num / 10 ) % 10 + 48;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _num+0, 0
	MOVWF      R0+0
	MOVF       _num+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _tens+0
;demo_simple_8.c,609 :: 		ones = num % 10 + 48;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _num+0, 0
	MOVWF      R0+0
	MOVF       _num+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _ones+0
;demo_simple_8.c,610 :: 		}
	RETURN
; end of _numToOne

_pad:

;demo_simple_8.c,612 :: 		void pad(char c){
;demo_simple_8.c,613 :: 		for (counter = 0; counter < c; counter++){
	CLRF       _counter+0
L_pad93:
	MOVF       FARG_pad_c+0, 0
	SUBWF      _counter+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_pad94
;demo_simple_8.c,614 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,613 :: 		for (counter = 0; counter < c; counter++){
	INCF       _counter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _counter+0
;demo_simple_8.c,615 :: 		}
	GOTO       L_pad93
L_pad94:
;demo_simple_8.c,616 :: 		}
	RETURN
; end of _pad

_main:

;demo_simple_8.c,618 :: 		void main() {
;demo_simple_8.c,619 :: 		initializePeripherals();
	CALL       _initializePeripherals+0
;demo_simple_8.c,620 :: 		initializeIO();
	CALL       _initializeIO+0
;demo_simple_8.c,621 :: 		MOSdriveState = drvMOS1;
	MOVLW      1
	MOVWF      _MOSdriveState+0
;demo_simple_8.c,622 :: 		pwmStarted = 0;
	CLRF       _pwmStarted+0
;demo_simple_8.c,623 :: 		mode = mode_inverter;
	CLRF       _mode+0
;demo_simple_8.c,624 :: 		acStatus = acLow;
	MOVLW      1
	MOVWF      _acStatus+0
;demo_simple_8.c,625 :: 		mainsStarted = 0;
	CLRF       _mainsStarted+0
;demo_simple_8.c,626 :: 		hicutreached = 0;
	CLRF       _hicutreached+0
;demo_simple_8.c,627 :: 		chgDelay = 0;
	CLRF       _chgDelay+0
;demo_simple_8.c,628 :: 		lcdState = 0;
	CLRF       _lcdState+0
;demo_simple_8.c,629 :: 		lcdCounter = 0;
	CLRF       _lcdCounter+0
;demo_simple_8.c,630 :: 		batlv = 1;
	MOVLW      1
	MOVWF      _batlv+0
;demo_simple_8.c,632 :: 		LCD_Init();
	CALL       _Lcd_Init+0
;demo_simple_8.c,633 :: 		LCD_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;demo_simple_8.c,634 :: 		LCD_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;demo_simple_8.c,636 :: 		T1CON = 0x31;   // period = 105ms, t1 on
	MOVLW      49
	MOVWF      T1CON+0
;demo_simple_8.c,638 :: 		while (1){
L_main96:
;demo_simple_8.c,639 :: 		getMainsVoltage();
	CALL       _getMainsVoltage+0
;demo_simple_8.c,640 :: 		getBatteryVoltage();
	CALL       _getBatteryVoltage+0
;demo_simple_8.c,641 :: 		doChecks();
	CALL       _doChecks+0
;demo_simple_8.c,643 :: 		if (mode == mode_inverter){
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main98
;demo_simple_8.c,644 :: 		chargingEnabled = 0;
	CLRF       _chargingEnabled+0
	CLRF       _chargingEnabled+1
;demo_simple_8.c,645 :: 		if (inverterState == inv_normal){
	MOVF       _inverterState+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main99
;demo_simple_8.c,646 :: 		getOverload();
	CALL       _getOverload+0
;demo_simple_8.c,648 :: 		doFeedback();
	CALL       _doFeedback+0
;demo_simple_8.c,649 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,650 :: 		lcdCounter++;
	INCF       _lcdCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _lcdCounter+0
;demo_simple_8.c,652 :: 		}
	GOTO       L_main100
L_main99:
;demo_simple_8.c,654 :: 		if (TMR1IF_bit){
	BTFSS      TMR1IF_bit+0, 0
	GOTO       L_main101
;demo_simple_8.c,655 :: 		lcdCounter++;
	INCF       _lcdCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _lcdCounter+0
;demo_simple_8.c,656 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,657 :: 		}
L_main101:
;demo_simple_8.c,658 :: 		}
L_main100:
;demo_simple_8.c,659 :: 		}
	GOTO       L_main102
L_main98:
;demo_simple_8.c,661 :: 		if (mainsStarted == 1){
	MOVF       _mainsStarted+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main103
;demo_simple_8.c,662 :: 		if (chgDelay == 0){
	MOVF       _chgDelay+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main104
;demo_simple_8.c,663 :: 		if (TMR1IF_bit){
	BTFSS      TMR1IF_bit+0, 0
	GOTO       L_main105
;demo_simple_8.c,664 :: 		lcdCounter++;
	INCF       _lcdCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _lcdCounter+0
;demo_simple_8.c,665 :: 		delayCounter2++;
	INCF       _delayCounter2+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _delayCounter2+0
;demo_simple_8.c,666 :: 		if (delayCounter2 == 2){
	MOVF       _delayCounter2+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main106
;demo_simple_8.c,667 :: 		delayCounter++;
	INCF       _delayCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _delayCounter+0
;demo_simple_8.c,668 :: 		chargingDuty_buffer = (vAc * 32) / 184;
	MOVLW      5
	MOVWF      R2+0
	MOVF       _vAc+0, 0
	MOVWF      R0+0
	MOVF       _vAc+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__main190:
	BTFSC      STATUS+0, 2
	GOTO       L__main191
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__main190
L__main191:
	MOVLW      184
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _chargingDuty_buffer+0
	MOVF       R0+1, 0
	MOVWF      _chargingDuty_buffer+1
;demo_simple_8.c,669 :: 		if (delayCounter > 100){    // after 20 seconds go to normal
	MOVF       _delayCounter+0, 0
	SUBLW      100
	BTFSC      STATUS+0, 0
	GOTO       L_main107
;demo_simple_8.c,670 :: 		chgDelay = 1;
	MOVLW      1
	MOVWF      _chgDelay+0
;demo_simple_8.c,671 :: 		chargingEnabled = 1;
	MOVLW      1
	MOVWF      _chargingEnabled+0
	MOVLW      0
	MOVWF      _chargingEnabled+1
;demo_simple_8.c,673 :: 		}
	GOTO       L_main108
L_main107:
;demo_simple_8.c,674 :: 		else if (delayCounter > 50){    // initial 10 seconds delay
	MOVF       _delayCounter+0, 0
	SUBLW      50
	BTFSC      STATUS+0, 0
	GOTO       L_main109
;demo_simple_8.c,676 :: 		adTemp = chargingDuty_buffer;
	MOVF       _chargingDuty_buffer+0, 0
	MOVWF      _adTemp+0
	MOVF       _chargingDuty_buffer+1, 0
	MOVWF      _adTemp+1
;demo_simple_8.c,677 :: 		adTemp = 16 - (delayCounter - 50) + adTemp;
	MOVLW      50
	SUBWF      _delayCounter+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	SUBLW      16
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVF       R0+0, 0
	ADDWF      _adTemp+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adTemp+1, 1
;demo_simple_8.c,678 :: 		if (adTemp >= chargingDuty_buffer){
	MOVF       _chargingDuty_buffer+1, 0
	SUBWF      _adTemp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main192
	MOVF       _chargingDuty_buffer+0, 0
	SUBWF      _adTemp+0, 0
L__main192:
	BTFSS      STATUS+0, 0
	GOTO       L_main110
;demo_simple_8.c,679 :: 		chargingDuty_buffer = adTemp;
	MOVF       _adTemp+0, 0
	MOVWF      _chargingDuty_buffer+0
	MOVF       _adTemp+1, 0
	MOVWF      _chargingDuty_buffer+1
;demo_simple_8.c,680 :: 		}
L_main110:
;demo_simple_8.c,681 :: 		if (adTemp >= 46){
	MOVLW      0
	SUBWF      _adTemp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main193
	MOVLW      46
	SUBWF      _adTemp+0, 0
L__main193:
	BTFSS      STATUS+0, 0
	GOTO       L_main111
;demo_simple_8.c,682 :: 		chargingDuty_buffer = 46;
	MOVLW      46
	MOVWF      _chargingDuty_buffer+0
	MOVLW      0
	MOVWF      _chargingDuty_buffer+1
;demo_simple_8.c,683 :: 		}
L_main111:
;demo_simple_8.c,685 :: 		firing = chargingDuty_buffer;
	MOVF       _chargingDuty_buffer+0, 0
	MOVWF      _firing+0
;demo_simple_8.c,686 :: 		chargingEnabled = 1;
	MOVLW      1
	MOVWF      _chargingEnabled+0
	MOVLW      0
	MOVWF      _chargingEnabled+1
;demo_simple_8.c,687 :: 		}
	GOTO       L_main112
L_main109:
;demo_simple_8.c,689 :: 		chargingEnabled = 0;
	CLRF       _chargingEnabled+0
	CLRF       _chargingEnabled+1
;demo_simple_8.c,690 :: 		}
L_main112:
L_main108:
;demo_simple_8.c,691 :: 		delayCounter2 = 0;
	CLRF       _delayCounter2+0
;demo_simple_8.c,692 :: 		}
	GOTO       L_main113
L_main106:
;demo_simple_8.c,695 :: 		}
L_main113:
;demo_simple_8.c,696 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,697 :: 		}
L_main105:
;demo_simple_8.c,698 :: 		}
	GOTO       L_main114
L_main104:
;demo_simple_8.c,700 :: 		firing = (vAc * 32)/184;    // 184 -> 220VAC
	MOVLW      5
	MOVWF      R2+0
	MOVF       _vAc+0, 0
	MOVWF      R0+0
	MOVF       _vAc+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__main194:
	BTFSC      STATUS+0, 2
	GOTO       L__main195
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__main194
L__main195:
	MOVLW      184
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _firing+0
;demo_simple_8.c,701 :: 		if (TMR1IF_bit){
	BTFSS      TMR1IF_bit+0, 0
	GOTO       L_main115
;demo_simple_8.c,702 :: 		lcdCounter++;
	INCF       _lcdCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _lcdCounter+0
;demo_simple_8.c,703 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,704 :: 		}
L_main115:
;demo_simple_8.c,705 :: 		}
L_main114:
;demo_simple_8.c,706 :: 		}
	GOTO       L_main116
L_main103:
;demo_simple_8.c,708 :: 		if (TMR1IF_bit){
	BTFSS      TMR1IF_bit+0, 0
	GOTO       L_main117
;demo_simple_8.c,709 :: 		lcdCounter++;
	INCF       _lcdCounter+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _lcdCounter+0
;demo_simple_8.c,710 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, 0
;demo_simple_8.c,711 :: 		}
L_main117:
;demo_simple_8.c,712 :: 		}
L_main116:
;demo_simple_8.c,713 :: 		}
L_main102:
;demo_simple_8.c,716 :: 		if (T1CON == 0x11){
	MOVF       T1CON+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_main118
;demo_simple_8.c,717 :: 		t1pr = 90;
	MOVLW      90
	MOVWF      _t1pr+0
;demo_simple_8.c,718 :: 		}
	GOTO       L_main119
L_main118:
;demo_simple_8.c,719 :: 		else if (T1CON == 0x31){
	MOVF       T1CON+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main120
;demo_simple_8.c,720 :: 		t1pr = 30;
	MOVLW      30
	MOVWF      _t1pr+0
;demo_simple_8.c,721 :: 		}
	GOTO       L_main121
L_main120:
;demo_simple_8.c,723 :: 		t1pr = 60;
	MOVLW      60
	MOVWF      _t1pr+0
;demo_simple_8.c,724 :: 		}
L_main121:
L_main119:
;demo_simple_8.c,726 :: 		if (lcdCounter == t1pr){
	MOVF       _lcdCounter+0, 0
	XORWF      _t1pr+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main122
;demo_simple_8.c,727 :: 		lcdState++;
	INCF       _lcdState+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _lcdState+0
;demo_simple_8.c,728 :: 		LCD_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;demo_simple_8.c,729 :: 		chgDot = 0;
	CLRF       _chgDot+0
;demo_simple_8.c,730 :: 		if (lcdState >= maxLCDstates){
	MOVLW      7
	SUBWF      _lcdState+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main123
;demo_simple_8.c,731 :: 		lcdState = 0;
	CLRF       _lcdState+0
;demo_simple_8.c,732 :: 		}
L_main123:
;demo_simple_8.c,733 :: 		lcdCounter = 0;
	CLRF       _lcdCounter+0
;demo_simple_8.c,734 :: 		}
L_main122:
;demo_simple_8.c,736 :: 		switch (lcdState){
	GOTO       L_main124
;demo_simple_8.c,737 :: 		case 0:    // show company name
L_main126:
;demo_simple_8.c,738 :: 		case 1:
L_main127:
;demo_simple_8.c,740 :: 		LCD_Chr(1, 5, 'M');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      77
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,741 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,742 :: 		LCD_Chr_Cp('M');
	MOVLW      77
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,743 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,744 :: 		LCD_Chr_Cp('c');
	MOVLW      99
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,745 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,746 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,748 :: 		LCD_Chr(2, 4, 'S');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      83
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,749 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,750 :: 		LCD_Chr_Cp('l');
	MOVLW      108
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,751 :: 		LCD_Chr_Cp('u');
	MOVLW      117
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,752 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,753 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,754 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,755 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,756 :: 		LCD_Chr_Cp('s');
	MOVLW      115
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,758 :: 		break;
	GOTO       L_main125
;demo_simple_8.c,759 :: 		case 2:    // show mains state
L_main128:
;demo_simple_8.c,760 :: 		LCD_Chr(1, 1, 'M');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      77
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,761 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,762 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,763 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,764 :: 		LCD_Chr_Cp('s');
	MOVLW      115
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,765 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,766 :: 		LCD_Chr_Cp('V');
	MOVLW      86
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,767 :: 		LCD_Chr_Cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,769 :: 		num = (vAc * 220) / 184;
	MOVF       _vAc+0, 0
	MOVWF      R0+0
	MOVF       _vAc+1, 0
	MOVWF      R0+1
	MOVLW      220
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      184
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _num+0
	MOVF       R0+1, 0
	MOVWF      _num+1
;demo_simple_8.c,770 :: 		numToOne();
	CALL       _numToOne+0
;demo_simple_8.c,772 :: 		LCD_Chr(1, 12, '~');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      126
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,773 :: 		LCD_Chr_Cp(hundreds);
	MOVF       _hundreds+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,774 :: 		LCD_Chr_Cp(tens);
	MOVF       _tens+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,775 :: 		LCD_Chr_Cp(ones);
	MOVF       _ones+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,776 :: 		LCD_Chr_Cp('V');
	MOVLW      86
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,778 :: 		LCD_Chr(2, 3, 'M');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      77
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,779 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,780 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,781 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,782 :: 		LCD_Chr_Cp('s');
	MOVLW      115
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,783 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,785 :: 		if (acStatus == acNormal){
	MOVF       _acStatus+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main129
;demo_simple_8.c,786 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,787 :: 		LCD_Chr_Cp('k');
	MOVLW      107
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,788 :: 		pad(6);
	MOVLW      6
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,789 :: 		}
	GOTO       L_main130
L_main129:
;demo_simple_8.c,790 :: 		else if (acStatus == acLow){
	MOVF       _acStatus+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main131
;demo_simple_8.c,791 :: 		LCD_Chr_Cp('L');
	MOVLW      76
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,792 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,793 :: 		LCD_Chr_Cp('w');
	MOVLW      119
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,794 :: 		LCD_Chr_Cp('/');
	MOVLW      47
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,795 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,796 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,797 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,798 :: 		}
	GOTO       L_main132
L_main131:
;demo_simple_8.c,799 :: 		else if (acStatus == acHigh){
	MOVF       _acStatus+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main133
;demo_simple_8.c,800 :: 		LCD_Chr_Cp('H');
	MOVLW      72
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,801 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,802 :: 		LCD_Chr_Cp('g');
	MOVLW      103
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,803 :: 		LCD_Chr_Cp('h');
	MOVLW      104
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,804 :: 		pad(4);
	MOVLW      4
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,805 :: 		}
L_main133:
L_main132:
L_main130:
;demo_simple_8.c,806 :: 		break;
	GOTO       L_main125
;demo_simple_8.c,807 :: 		case 3:    // show inverter state
L_main134:
;demo_simple_8.c,808 :: 		LCD_Chr(1, 3, 'I');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      73
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,809 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,810 :: 		LCD_Chr_Cp('v');
	MOVLW      118
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,811 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,812 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,813 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,814 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,815 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,816 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,817 :: 		if ((inverterState == inv_normal) & (mode == mode_inverter)){
	MOVF       _inverterState+0, 0
	XORLW      0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _mode+0, 0
	XORLW      0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main135
;demo_simple_8.c,818 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,819 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,820 :: 		pad(3);
	MOVLW      3
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,821 :: 		}
	GOTO       L_main136
L_main135:
;demo_simple_8.c,822 :: 		else if ((inverterState == inv_off) | (mode == mode_mains)){
	MOVF       _inverterState+0, 0
	XORLW      3
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _mode+0, 0
	XORLW      1
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main137
;demo_simple_8.c,823 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,824 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,825 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,826 :: 		pad(2);
	MOVLW      2
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,827 :: 		LCD_Chr(2, 4, 'S');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      83
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,828 :: 		LCD_Chr_Cp('w');
	MOVLW      119
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,829 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,830 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,831 :: 		LCD_Chr_Cp('c');
	MOVLW      99
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,832 :: 		LCD_Chr_Cp('h');
	MOVLW      104
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,833 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,834 :: 		if (inverterSw == 1){
	BTFSS      RB5_bit+0, 5
	GOTO       L_main138
;demo_simple_8.c,835 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,836 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,837 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,838 :: 		}
	GOTO       L_main139
L_main138:
;demo_simple_8.c,840 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,841 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,842 :: 		pad(2);
	MOVLW      2
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,843 :: 		}
L_main139:
;demo_simple_8.c,844 :: 		}
	GOTO       L_main140
L_main137:
;demo_simple_8.c,846 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,847 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,848 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,849 :: 		pad(2);
	MOVLW      2
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,851 :: 		if (inverterState == inv_lowbattery){
	MOVF       _inverterState+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main141
;demo_simple_8.c,852 :: 		LCD_Chr(2, 1, 'B');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      66
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,853 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,854 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,855 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,856 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,857 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,858 :: 		LCD_Chr_Cp('y');
	MOVLW      121
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,859 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,860 :: 		LCD_Chr_Cp('L');
	MOVLW      76
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,861 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,862 :: 		LCD_Chr_Cp('w');
	MOVLW      119
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,863 :: 		}
	GOTO       L_main142
L_main141:
;demo_simple_8.c,864 :: 		else if (inverterState == inv_overload){
	MOVF       _inverterState+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main143
;demo_simple_8.c,865 :: 		LCD_Chr(2, 1, ' ');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,866 :: 		pad(4);
	MOVLW      4
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,867 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,868 :: 		LCD_Chr_Cp('v');
	MOVLW      118
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,869 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,870 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,871 :: 		LCD_Chr_Cp('l');
	MOVLW      108
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,872 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,873 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,874 :: 		LCD_Chr_Cp('d');
	MOVLW      100
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,875 :: 		}
L_main143:
L_main142:
;demo_simple_8.c,876 :: 		}
L_main140:
L_main136:
;demo_simple_8.c,877 :: 		break;
	GOTO       L_main125
;demo_simple_8.c,878 :: 		case 4:    // show battery state
L_main144:
;demo_simple_8.c,879 :: 		LCD_Chr(1, 1, 'B');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      66
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,880 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,881 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,882 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,883 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,884 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,885 :: 		LCD_Chr_Cp('y');
	MOVLW      121
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,886 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,887 :: 		LCD_Chr_Cp('V');
	MOVLW      86
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,888 :: 		LCD_Chr_Cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,890 :: 		num = vBat;
	MOVF       _vBat+0, 0
	MOVWF      _num+0
	MOVF       _vBat+1, 0
	MOVWF      _num+1
;demo_simple_8.c,891 :: 		numToOne();
	CALL       _numToOne+0
;demo_simple_8.c,892 :: 		LCD_Chr(1, 12, hundreds);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _hundreds+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,893 :: 		LCD_Chr_Cp( tens);
	MOVF       _tens+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,894 :: 		LCD_Chr_Cp('.');
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,895 :: 		LCD_Chr_Cp( ones);
	MOVF       _ones+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,896 :: 		LCD_Chr_Cp('V');
	MOVLW      86
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,898 :: 		LCD_Chr(2, 1, 'B');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      66
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,899 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,900 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,901 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,902 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,903 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,904 :: 		LCD_Chr_Cp('y');
	MOVLW      121
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,905 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,907 :: 		if (batteryState == batteryLow){
	MOVF       _batteryState+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_main145
;demo_simple_8.c,908 :: 		LCD_Chr_Cp('L');
	MOVLW      76
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,909 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,910 :: 		LCD_Chr_Cp('w');
	MOVLW      119
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,911 :: 		pad(1);
	MOVLW      1
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,912 :: 		}
	GOTO       L_main146
L_main145:
;demo_simple_8.c,913 :: 		else if ((batteryState == batteryHigh) | (batteryState == batteryPause)) {
	MOVF       _batteryState+0, 0
	XORLW      4
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _batteryState+0, 0
	XORLW      5
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main147
;demo_simple_8.c,914 :: 		if (hicutreached){
	MOVF       _hicutreached+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main148
;demo_simple_8.c,915 :: 		LCD_Chr_Cp('F');
	MOVLW      70
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,916 :: 		LCD_Chr_Cp('u');
	MOVLW      117
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,917 :: 		LCD_Chr_Cp('l');
	MOVLW      108
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,918 :: 		LCD_Chr_Cp('l');
	MOVLW      108
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,919 :: 		pad(2);
	MOVLW      2
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,920 :: 		}
	GOTO       L_main149
L_main148:
;demo_simple_8.c,922 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,923 :: 		LCD_Chr_Cp('K');
	MOVLW      75
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,924 :: 		pad(4);
	MOVLW      4
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,925 :: 		}
L_main149:
;demo_simple_8.c,926 :: 		}
	GOTO       L_main150
L_main147:
;demo_simple_8.c,928 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,929 :: 		LCD_Chr_Cp('K');
	MOVLW      75
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,930 :: 		pad(4);
	MOVLW      4
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,931 :: 		}
L_main150:
L_main146:
;demo_simple_8.c,933 :: 		if (inverterState == inv_normal){
	MOVF       _inverterState+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main151
;demo_simple_8.c,934 :: 		lv1 = 104;
	MOVLW      104
	MOVWF      _lv1+0
;demo_simple_8.c,935 :: 		lv2 = 108;
	MOVLW      108
	MOVWF      _lv2+0
;demo_simple_8.c,936 :: 		lv3 = 113;
	MOVLW      113
	MOVWF      _lv3+0
;demo_simple_8.c,937 :: 		lv4 = 117;
	MOVLW      117
	MOVWF      _lv4+0
;demo_simple_8.c,938 :: 		}
	GOTO       L_main152
L_main151:
;demo_simple_8.c,939 :: 		else if (mode == mode_mains){
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main153
;demo_simple_8.c,940 :: 		if (hicutreached){
	MOVF       _hicutreached+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main154
;demo_simple_8.c,941 :: 		lv1 = 104;
	MOVLW      104
	MOVWF      _lv1+0
;demo_simple_8.c,942 :: 		lv2 = 108;
	MOVLW      108
	MOVWF      _lv2+0
;demo_simple_8.c,943 :: 		lv3 = 113;
	MOVLW      113
	MOVWF      _lv3+0
;demo_simple_8.c,944 :: 		lv4 = 117;
	MOVLW      117
	MOVWF      _lv4+0
;demo_simple_8.c,946 :: 		}
	GOTO       L_main155
L_main154:
;demo_simple_8.c,948 :: 		lv1 = 113;
	MOVLW      113
	MOVWF      _lv1+0
;demo_simple_8.c,949 :: 		lv2 = 120;
	MOVLW      120
	MOVWF      _lv2+0
;demo_simple_8.c,950 :: 		lv3 = 125;
	MOVLW      125
	MOVWF      _lv3+0
;demo_simple_8.c,951 :: 		lv4 = 135;
	MOVLW      135
	MOVWF      _lv4+0
;demo_simple_8.c,952 :: 		}
L_main155:
;demo_simple_8.c,953 :: 		}
	GOTO       L_main156
L_main153:
;demo_simple_8.c,955 :: 		lv1 = 115;
	MOVLW      115
	MOVWF      _lv1+0
;demo_simple_8.c,956 :: 		lv2 = 118;
	MOVLW      118
	MOVWF      _lv2+0
;demo_simple_8.c,957 :: 		lv3 = 121;
	MOVLW      121
	MOVWF      _lv3+0
;demo_simple_8.c,958 :: 		lv4 = 123;
	MOVLW      123
	MOVWF      _lv4+0
;demo_simple_8.c,959 :: 		}
L_main156:
L_main152:
;demo_simple_8.c,961 :: 		if (vBat < lv1){
	MOVLW      0
	SUBWF      _vBat+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main196
	MOVF       _lv1+0, 0
	SUBWF      _vBat+0, 0
L__main196:
	BTFSC      STATUS+0, 0
	GOTO       L_main157
;demo_simple_8.c,962 :: 		batlv = 1;
	MOVLW      1
	MOVWF      _batlv+0
;demo_simple_8.c,963 :: 		}
	GOTO       L_main158
L_main157:
;demo_simple_8.c,964 :: 		else if (vBat < lv2){
	MOVLW      0
	SUBWF      _vBat+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main197
	MOVF       _lv2+0, 0
	SUBWF      _vBat+0, 0
L__main197:
	BTFSC      STATUS+0, 0
	GOTO       L_main159
;demo_simple_8.c,965 :: 		batlv = 2;
	MOVLW      2
	MOVWF      _batlv+0
;demo_simple_8.c,966 :: 		}
	GOTO       L_main160
L_main159:
;demo_simple_8.c,967 :: 		else if (vBat < lv3){
	MOVLW      0
	SUBWF      _vBat+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main198
	MOVF       _lv3+0, 0
	SUBWF      _vBat+0, 0
L__main198:
	BTFSC      STATUS+0, 0
	GOTO       L_main161
;demo_simple_8.c,968 :: 		batlv = 3;
	MOVLW      3
	MOVWF      _batlv+0
;demo_simple_8.c,969 :: 		}
	GOTO       L_main162
L_main161:
;demo_simple_8.c,970 :: 		else if (vBat < lv4){
	MOVLW      0
	SUBWF      _vBat+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main199
	MOVF       _lv4+0, 0
	SUBWF      _vBat+0, 0
L__main199:
	BTFSC      STATUS+0, 0
	GOTO       L_main163
;demo_simple_8.c,971 :: 		batlv = 4;
	MOVLW      4
	MOVWF      _batlv+0
;demo_simple_8.c,972 :: 		}
	GOTO       L_main164
L_main163:
;demo_simple_8.c,974 :: 		batlv = 5;
	MOVLW      5
	MOVWF      _batlv+0
;demo_simple_8.c,975 :: 		}
L_main164:
L_main162:
L_main160:
L_main158:
;demo_simple_8.c,977 :: 		batteryIcon(2,15);
	MOVLW      2
	MOVWF      FARG_batteryIcon_pos_row+0
	MOVLW      15
	MOVWF      FARG_batteryIcon_pos_char+0
	CALL       _batteryIcon+0
;demo_simple_8.c,979 :: 		break;
	GOTO       L_main125
;demo_simple_8.c,981 :: 		case 5:    // show charging state
L_main165:
;demo_simple_8.c,982 :: 		LCD_Chr(1, 2, 'C');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,983 :: 		LCD_Chr_Cp('h');
	MOVLW      104
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,984 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,985 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,986 :: 		LCD_Chr_Cp('g');
	MOVLW      103
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,987 :: 		LCD_Chr_Cp('i');
	MOVLW      105
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,988 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,989 :: 		LCD_Chr_Cp('g');
	MOVLW      103
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,990 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,992 :: 		if (mode == mode_inverter){
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main166
;demo_simple_8.c,993 :: 		LCD_Chr_Cp('O');
	MOVLW      79
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,994 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,995 :: 		LCD_Chr_Cp('f');
	MOVLW      102
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,996 :: 		pad(2);
	MOVLW      2
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,997 :: 		LCD_Chr(2, 1, ' ');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,998 :: 		pad(13);
	MOVLW      13
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,999 :: 		}
	GOTO       L_main167
L_main166:
;demo_simple_8.c,1001 :: 		if (hicutreached){
	MOVF       _hicutreached+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main168
;demo_simple_8.c,1002 :: 		LCD_Chr_Cp('F');
	MOVLW      70
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1003 :: 		LCD_Chr_Cp('u');
	MOVLW      117
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1004 :: 		LCD_Chr_Cp('l');
	MOVLW      108
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1005 :: 		LCD_Chr_Cp('l');
	MOVLW      108
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1006 :: 		LCD_Chr(2, 1, ' ');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,1007 :: 		pad(13);
	MOVLW      13
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,1008 :: 		}
	GOTO       L_main169
L_main168:
;demo_simple_8.c,1010 :: 		batlv = (lcdCounter * 10) / t1pr + 1;
	MOVF       _lcdCounter+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       _t1pr+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	INCF       R0+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _batlv+0
;demo_simple_8.c,1011 :: 		if (batlv > 5) batlv = batlv - 5;
	MOVF       R1+0, 0
	SUBLW      5
	BTFSC      STATUS+0, 0
	GOTO       L_main170
	MOVLW      5
	SUBWF      _batlv+0, 1
L_main170:
;demo_simple_8.c,1012 :: 		batteryIcon(1, 11);
	MOVLW      1
	MOVWF      FARG_batteryIcon_pos_row+0
	MOVLW      11
	MOVWF      FARG_batteryIcon_pos_char+0
	CALL       _batteryIcon+0
;demo_simple_8.c,1013 :: 		pad(6);
	MOVLW      6
	MOVWF      FARG_pad_c+0
	CALL       _pad+0
;demo_simple_8.c,1014 :: 		}
L_main169:
;demo_simple_8.c,1015 :: 		}
L_main167:
;demo_simple_8.c,1016 :: 		break;
	GOTO       L_main125
;demo_simple_8.c,1017 :: 		case 6:    // show load percentage
L_main171:
;demo_simple_8.c,1019 :: 		loadpc = (vShunt * 100) / ovThreshold;
	MOVF       _vShunt+0, 0
	MOVWF      R0+0
	MOVF       _vShunt+1, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       _ovThreshold+0, 0
	MOVWF      R4+0
	MOVF       _ovThreshold+1, 0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _loadpc+0
	MOVF       R0+1, 0
	MOVWF      _loadpc+1
;demo_simple_8.c,1020 :: 		num = loadpc;
	MOVF       _loadpc+0, 0
	MOVWF      _num+0
	MOVF       _loadpc+1, 0
	MOVWF      _num+1
;demo_simple_8.c,1021 :: 		numToOne();
	CALL       _numToOne+0
;demo_simple_8.c,1022 :: 		if (loadpc > 99) loadpc = 99;
	MOVF       _loadpc+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main200
	MOVF       _loadpc+0, 0
	SUBLW      99
L__main200:
	BTFSC      STATUS+0, 0
	GOTO       L_main172
	MOVLW      99
	MOVWF      _loadpc+0
	MOVLW      0
	MOVWF      _loadpc+1
L_main172:
;demo_simple_8.c,1024 :: 		LCD_Chr(1, 1, 'I');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      73
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,1025 :: 		LCD_Chr_Cp('n');
	MOVLW      110
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1026 :: 		LCD_Chr_Cp('v');
	MOVLW      118
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1027 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1028 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1029 :: 		LCD_Chr_Cp('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1030 :: 		LCD_Chr_Cp('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1031 :: 		LCD_Chr_Cp('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1032 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1033 :: 		LCD_Chr_Cp('L');
	MOVLW      76
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1034 :: 		LCD_Chr_Cp('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1035 :: 		LCD_Chr_Cp('a');
	MOVLW      97
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1036 :: 		LCD_Chr_Cp('d');
	MOVLW      100
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1037 :: 		LCD_Chr_Cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1039 :: 		LCD_Chr(2, 5, '(');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      40
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;demo_simple_8.c,1040 :: 		LCD_Chr_Cp( tens );
	MOVF       _tens+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1041 :: 		LCD_Chr_Cp( ones );
	MOVF       _ones+0, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1042 :: 		LCD_Chr_Cp(' ');
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1043 :: 		LCD_Chr_Cp('%');
	MOVLW      37
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1044 :: 		LCD_Chr_Cp(')');
	MOVLW      41
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;demo_simple_8.c,1046 :: 		break;
	GOTO       L_main125
;demo_simple_8.c,1051 :: 		}
L_main124:
	MOVF       _lcdState+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main126
	MOVF       _lcdState+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main127
	MOVF       _lcdState+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main128
	MOVF       _lcdState+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main134
	MOVF       _lcdState+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main144
	MOVF       _lcdState+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main165
	MOVF       _lcdState+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main171
L_main125:
;demo_simple_8.c,1053 :: 		}
	GOTO       L_main96
;demo_simple_8.c,1054 :: 		}
	GOTO       $+0
; end of _main
