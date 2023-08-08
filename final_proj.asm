LIST 	P=PIC16F877
		include	<P16f877.inc>
 __CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

		org 0x00
reset:	goto start

		org 0x10
start:
		bcf		STATUS, RP1
		bcf		STATUS, RP0			;Bank0 <------
;---------- Initialize area: -----------------------------------------------------------;
		clrf    PORTE
		clrf	PORTB 
		clrf	PORTD
		clrf	0x30	;A=0
		clrf	0x40	;B=0
		clrf 	0x50	;cont=0
		clrf	0x60	;res =0
		bcf		INTCON , GIE 	;disable all interrupts		
		;-----------------------------------------
		bsf		STATUS, RP0			;Bank1 <------
		;-----------------------------------------
		movlw	0x06
		movwf	ADCON1	;define port A and port E to be digitals (we dont use any kind of Analog)
		clrf	TRISD	;portd output
		clrf	TRISE	;porte output 
		movlw 	0x0f 	;WREG=0X0F
		movwf 	TRISB 	;4 MSB of B will be outputs and 4 LSB of B will be inputs
		bcf		OPTION_REG,0x7	;Enable PortB Pull-Up
		bcf		STATUS, RP0 	; Bank0 <------			
;--------------------------end of intializing area-----------------------
starting_point:
		;---->clearing variables:
		clrf	0x30	;A=0
		clrf	0x40	;B=0
		clrf 	0x50	;cont=0
		clrf	0x60	;res =0
		;---->clearing LCD:
		call 	init
		call	mdel
		movlw	0x80			 ;PLACE for the data on the LCD (first_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		movlw	'A'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'='			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
			
		movlw	0x88			 ;PLACE for the data on the LCD (first_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		movlw	'B'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'='			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		movlw	0xc0			 ;PLACE for the data on the LCD (secd_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		movlw	'C'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'='			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'0'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
;--------------------------end of starting point init--------------------------
getvars:
		call 	wkbABC	;waiting to enter var name from keyboard
		movwf	0x21	; temp =wreg(key board input)
		;checking if the input is A
		movlw	0x0a	; wreg = 0x0a
		subwf	0x21 , w	; w=w-temp
		btfsc	STATUS , Z	; if w is A
			goto inputA
		;checking if the input is B
		movlw	0x0b	; wreg = 0x0b
		subwf	0x21 , w	; w=w-temp
		btfsc	STATUS , Z	; if w is B
			goto inputB
		;checking if the input is C
		movlw	0x0c	; wreg = 0x0b
		subwf	0x21 , w	; w=w-temp
		btfsc	STATUS , Z	; if w is B
			goto inputC
		;just to make sure:
		goto ERR
;-------------------------------input A---------------------
inputA:
		clrf	0x30
		movlw	0x82			 ;PLACE for the data on the LCD (first_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		;first digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x08
		btfsc	0x21 , 8	;if the number was one
			addwf 0x30 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;second digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x04
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x30 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;third digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x02
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x30 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;fourth digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x01
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x30 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		goto	getvars

						
;-------------------------------input B---------------------		
inputB:
		clrf	0x40
		movlw	0x8a			 ;PLACE for the data on the LCD (first_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		;first digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x08
		btfsc	0x21 , 8	;if the number was one
			addwf 0x40 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;second digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x04
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x40 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;third digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x02
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x40 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;fourth digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x01
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x40 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		goto	getvars
;-------------------------------input C---------------------
inputC:
		clrf	0x50
		movlw	0xc2			 ;PLACE for the data on the LCD (first_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		;first digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x08
		btfsc	0x21 , 8	;if the number was one
			addwf 0x50 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;second digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x04
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x50 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;third digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x02
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x50 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;fourth digit---------->
		call wkb

		movwf	0x21	;temp = wreg(keyboard input)
		movlw	0x01
		btfsc	0x21 , 8	;if the number was one
			addwf 	0x50 ,f	;than up one by the value
		
	
		movlw 	0x30	;wreg = '0'
		addwf	0x21 ,w		; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel

		;--preparing to next stage:
		movlw	0xc0			 ;PLACE for the data on the LCD
		movwf	0x20
		call 	lcdc
		call	mdel
		;------------checking command list:--------------
		movlw 	0x01
		subwf 	0x50 ,w
		btfsc 	STATUS ,Z
			goto sub_func
		
		movlw 	0x02
		subwf 	0x50 ,w
		btfsc 	STATUS ,Z
			goto mult_func

		movlw 	0x03
		subwf 	0x50 ,w
		btfsc 	STATUS ,Z
			goto divide_func

		movlw 	0x04
		subwf 	0x50 ,w
		btfsc 	STATUS ,Z
			goto power_func

		movlw 	0x05
		subwf 	0x50 ,w
		btfsc 	STATUS ,Z
			goto onesInA_func

		movlw 	0x06
		subwf 	0x50 ,w
		btfsc 	STATUS ,Z
			goto zeroesInB_func

;-----------------------error case function-----------------------------
ERR:
		call 	init
		movlw	0x80			 ;PLACE for the data on the LCD (first_line)
		movwf	0x20
		call 	lcdc
		call	mdel
		movlw	'e'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'r'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'o'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'r'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'r'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		call	wkbABC	; waiting for next command
		goto starting_point
sub_func:
		call	print_RES
		call	sub
		call	res_print
		call	wkbABC
		goto	starting_point
mult_func:
		call	print_RES
		call	mult
		call	res_print
		call	wkbABC
		goto	starting_point
divide_func:
		call	print_RES
		call	div
		call	res_print
		call	wkbABC
		goto	starting_point 
power_func:
		call	print_RES
		call	pow
		call	res_print
		call	wkbABC
		goto	starting_point
onesInA_func:
		call	print_RES
		call	onesInA
		call	res_print
		call	wkbABC
		goto	starting_point
zeroesInB_func:
		call	print_RES
		call	zerosInB
		call	res_print
		call	wkbABC
		goto	starting_point
;----------------------------------printing to the screen "RES = "-------------
print_RES:
		movlw	'R'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'E'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'S'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movlw	'='			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		
		return
;------------------------------------RES-PRINTING function---------------------
res_print:
		;checkin ther result:
		movlw 	d'16'
		subwf	0x60  ,w
		btfsc	STATUS ,C
			goto ERR
		

		; restore res:
		movfw 	0x60 
		movwf 	0x21	;temp = res
		movlw	0x30
		movwf	0x22	;temp2 ='0'

		movlw	0x08
		andwf 	0x21,w	;getting the first digit
		btfss	STATUS , Z
			incf	0x22 ,f
		movfw	0x22	;now w will hold the value to print
		movwf	0x20
		call 	lcdd
		call	mdel			

		movfw 	0x60 
		movwf 	0x21	;temp = res
		movlw	0x30
		movwf	0x22	;temp2 ='0'

		movlw	0x04
		andwf 	0x21,w	;getting the first digit
		btfss	STATUS , Z
			incf	0x22 ,f
		movfw	0x22	;now w will hold the value to print
		movwf	0x20
		call 	lcdd
		call	mdel

		movfw 	0x60 
		movwf 	0x21	;temp = res
		movlw	0x30
		movwf	0x22	;temp2 ='0'

		movlw	0x02
		andwf 	0x21,w	;getting the first digit
		btfss	STATUS , Z
			incf	0x22 ,f
		movfw	0x22	;now w will hold the value to print
		movwf	0x20
		call 	lcdd
		call	mdel

		movfw 	0x60 
		movwf 	0x21	;temp = res
		movlw	0x30
		movwf	0x22	;temp2 ='0'

		movlw	0x01
		andwf 	0x21,w	;getting the first digit
		btfss	STATUS , Z
			incf	0x22 ,f
		movfw	0x22	;now w will hold the value to print
		movwf	0x20
		call 	lcdd
		call	mdel
	return
;------------------------------------LCD code----------------------------------
init:	movlw	0x30
		movwf	0x20
		call 	lcdc
		call	del_41

		movlw	0x30
		movwf	0x20
		call 	lcdc
		call	del_01

		movlw	0x30
		movwf	0x20
		call 	lcdc
		call	mdel

		movlw	0x01		; display clear
		movwf	0x20
		call 	lcdc
		call	mdel

		movlw	0x06		; ID=1,S=0 increment,no  shift 000001 ID S
		movwf	0x20
		call 	lcdc
		call	mdel

		movlw	0x0c		; D=1,C=B=0 set display ,no cursor, no blinking
		movwf	0x20
		call 	lcdc
		call	mdel

		movlw	0x38		; dl=1 ( 8 bits interface,n=12 lines,f=05x8 dots)
		movwf	0x20
		call 	lcdc
		call	mdel
		return

;
;subroutine to write command to LCD
;

lcdc	movlw	0x00		; E=0,RS=0 
		movwf	PORTE
		movf	0x20,w
		movwf	PORTD
		movlw	0x01		; E=1,RS=0
		movwf	PORTE
        call	sdel
		movlw	0x00		; E=0,RS=0
		movwf	PORTE
		return

;
;subroutine to write data to LCD
;

lcdd	movlw		0x02		; E=0, RS=1
		movwf		PORTE
		movf		0x20,w
		movwf		PORTD
        movlw		0x03		; E=1, rs=1  
		movwf		PORTE
		call		sdel
		movlw		0x02		; E=0, rs=1  
		movwf		PORTE
		return

;-----------------delays loops---------------------------------

del_41	movlw		0xcd
		movwf		0x23
lulaa6	movlw		0x20
		movwf		0x22
lulaa7	decfsz		0x22,1
		goto		lulaa7
		decfsz		0x23,1
		goto 		lulaa6 
		return


del_01	movlw		0x20
		movwf		0x22
lulaa8	decfsz		0x22,1
		goto		lulaa8
		return


sdel	movlw		0x19		; movlw = 1 cycle
		movwf		0x23		; movwf	= 1 cycle
lulaa2	movlw		0xfa
		movwf		0x22
lulaa1	decfsz		0x22,1		; decfsz= 12 cycle
		goto		lulaa1		; goto	= 2 cycles
		decfsz		0x23,1
		goto 		lulaa2 
		return


mdel	movlw		0x0a
		movwf		0x24
lulaa5	movlw		0x19
		movwf		0x23
lulaa4	movlw		0xfa
		movwf		0x22
lulaa3	decfsz		0x22,1
		goto		lulaa3
		decfsz		0x23,1
		goto 		lulaa4 
		decfsz		0x24,1
		goto		lulaa5
		return
;-----------------------buttons code--------------------------------------
;for scanning a/b/c:
wkbABC:	bcf		PORTB,0x4		;scan Row 1
		bsf		PORTB,0x5
		bsf		PORTB,0x6
		bsf		PORTB,0x7
		btfss 	PORTB,0x3
		goto 	kb0a	;can scan only A from that row

		bsf		PORTB,0x4
		bcf 	PORTB,0x5		;scan Row 2
		btfss 	PORTB,0x3
		goto 	kb0b	;can scan only B from that row

		bsf		PORTB,0x5
		bcf		PORTB,0x6		;scan Row 3
		btfss 	PORTB,0x3
		goto 	kb0c	;can scan only C from that row

		goto 	wkbABC


kb0a:	movlw 	0x0A
		goto 	dispABC
kb0b:	movlw 	0x0B
		goto 	dispABC
kb0c:	movlw 	0x0C
		goto 	dispABC

dispABC: 	goto stop_push_loop

;for scanning 1/0:
wkb:	bcf		PORTB,0x4		;scan Row 1
		bsf		PORTB,0x5
		bsf		PORTB,0x6
		bsf		PORTB,0x7
		btfss 	PORTB,0x0
		goto 	kb01	; can only scan 1 from this row


		bsf 	PORTB,0x4
		bcf 	PORTB,0x7		;scan Row 4
		btfss 	PORTB,0x1
		goto 	kb00	; can only scan 0 from this row

		goto 	wkb

kb00:	movlw 	0x00
		goto 	disp
kb01:	movlw 	0x01
		goto 	disp

disp: 	goto stop_push_loop

;loop that wait until the user stop pushing the button
stop_push_loop:
		bcf		PORTB,0x4		;scan Row 1
		bsf		PORTB,0x5
		bsf		PORTB,0x6
		bsf		PORTB,0x7
		btfss 	PORTB,0x0
		goto 	push	
		btfss 	PORTB,0x3
		goto 	push	

		bsf		PORTB,0x4
		bcf 	PORTB,0x5		;scan Row 2
		btfss 	PORTB,0x3
		goto 	push	

		bsf		PORTB,0x5
		bcf		PORTB,0x6		;scan Row 3
		btfss 	PORTB,0x3
		goto 	push	

		bsf 	PORTB,0x4
		bcf 	PORTB,0x7		;scan Row 4
		btfss 	PORTB,0x1
		goto 	push	
		
		goto	disp_spl	; if we get here so there is no pushing button.

push:	goto 	stop_push_loop


disp_spl: 	return
;---------------end of buttons code----------------------------------------------

;----------------checking one and zeros--------------	
zerosInB:
	;restore A:
	movfw 	0x30
	movwf 	0x21 	; tamp = A
	comf 	0x40 , w 	; w= not(b)
	movwf 	0x30 ; A = not(b)
	movlw 	0x0f 
	andwf 	0x30 , f 	; ignoring 4 msb
	call 	onesInA
	movfw 	0x21
	movwf 	0x30 	; restoring A
	return
	
onesInA:
	;restore A:
	movfw 	0x30
	movwf 	0x20 	; temp = A
	;----------- 
loop_onesInA:
	btfsc 	0x30 , 0 ;if the first bit in A !=0
		incf 	0x60
	RRF 	0x30 	; shift right A
;--------check if(A==0)----
	movlw 	0x0f
	andwf 	0x30 ,w
	btfss 	STATUS , Z 	; if (A)and(0x0f) != 0
	 	goto 	loop_onesInA
	movfw 	0x20 
	movwf 	0x30 ; restore A
	return
;---------------------power and mult functions:-----------------------

pow:
	movlw 	0xff 
	andwf 	0x40 
	btfsc 	STATUS , Z ; if B==0
		goto 	Bzero_pow
	decf 	0x40,w   
    btfsc 	STATUS , Z ;if B==1
		goto 	Bone_pow
	decf 	0x40
	movfw 	0x40 	; restore to B
	movwf 	0x22 	; temp = B
	movwf 	0x23 	; temp2 =B
	movfw 	0x30
	movwf 	0x40 	; B=A
pow_loop:
	call 	mult
	movfw 	0x60
	movwf 	0x30 	; A=res
	decfsz 	0x22 	; decrease f skip if zero temp(B) 
		goto 	pow_loop
	movfw 	0x40 	; B holding A
	movwf 	0x30 	; restore A
	movfw 	0x23 	; w= temp2 
	movwf 	0x40 	; restore B
	incf 	0x40 	; for the decrease in the beginning
	return 
Bzero_pow:	
	incf 	0x60
	return
Bone_pow:
	addwf 	0x30 ,w
	movwf 	0x60
	return
mult:
	;restore A and B:
	movfw 	0x30
	movwf 	0x20 ; temp1 =A
	movfw 	0x40
	movwf 	0x21 ; temp2 =B
	;----------------
	movlw 	0xff 
	andwf 	0x40 
	btfsc 	STATUS , Z ; if B==0
	goto 	Bzero
	movfw 	0x30 ; w=A
	
mult_loop:

	addwf 	0x30 ,f ; A=A+w
	decfsz 	0x40
		goto 	mult_loop
	subwf 	0x30 ,f ; A=A-w
	movfw 	0x30
	movwf 	0x60
	movfw 	0x20 ; w=temp1
	movwf 	0x30 ; restoreA
	movfw 	0x21 ; w=temp2
	movwf 	0x40 ; restoreB
	goto 	e
Bzero:
	clrf 	0x60
	goto 	e
e:
return 
;---------------------------division-------------------
div:
	;restore A:
	movfw 	0x30
	movwf 	0x20 	;temp = A
	;-------------
	movfw 	0x30 
	movlw 	0xff 
	andwf 	0x40,w 
	btfsc 	STATUS , Z 	; if B==0
	goto 	B_zero 	; ----->print error
	movfw 	0x40 	; w=B
	
div_loop:
	incf 	0x60 	; res++
	subwf 	0x30 ,f ; A=A-w
	btfsc 	STATUS , C 	;if a>0
		goto 	div_loop
	decf 	0x60
	movfw 	0x20; w =temp
	movwf 	0x30; restore A
	return
B_zero:
	clrf 	0x60
	return

;-----------------------------------sub func-------------------------------------
sub:		btfsc 0x30  , 3 ; if A is negative:
			goto Aneg
		btfsc 0x40  , 3 ; if B is negative:
			goto sub_Apositive
		goto sub_positives
Aneg:
		btfsc 0x40  , 3 ; if B is negative:
			goto sub_negatives
		goto sub_Bpositive

;if A>0 and B>0 
sub_positives: 
		movfw 0x40  ; wreg = B
		subwf 0x30 , w  ;  wreg = A-B
		btfss STATUS ,C ; if B>A
		call neg_num
		movwf 0x60 ;  Res = A-B
return


;-----------------------------------------
; if A>0 and B<0 
sub_Apositive:
; comp's 2 to B:
	movfw 0x40
	call comps_2
	movwf 0x40
	movfw 0x30 ; wreg = A
	addwf 0x40  , w ; w = A+B
	movwf 0x60 ; RES = A-(-B)
return

;---------------------------------------------------------------
;if A<0 and B>0
sub_Bpositive:
		call 	NSP
		;comp's 2 on A:
		movfw 0x30  
		call comps_2 
		movwf 0x30 
		;------------
		addwf 0x40 , w
		movwf 0x60 ; RES = -(-A-B)
 
return
;----------------------------------------------

;if A<0 and B<0

sub_negatives: 
		movfw 0x40  ; wreg = B
		call comps_2
		movwf 0x21  ; temp = comp's2(B)
		movfw 0x30 ; wreg = A
		call comps_2
		movwf 0x40 ; B=comp's2(A)
		movfw 0x21 ; wreg =temp
		movwf 0x30 ; A=comp's2(B)
		goto sub_positives

;----------------------------func_doing comps 2 to w 4 bits-------------------------
comps_2:;asuuming the number is in w
		;using: 0x25
		clrf 0x25 ;com_res=0
		movwf 0x25 ;com_res = w 
		comf 0x25  ; comps'1(com_res)
		movlw 0x0f ; w = 0x0f
		andwf 0x25, f  ; ignoring 4 MSB 
		incf 0x25 ; comp's 2(com_res)
		movfw 0x25 ; w = com_res
return
;-----------------------------func_doing comps 2 to w 8 bits---------------------------
neg_num:;asuuming the number is in w
		;using: 0x20
		clrf 	0x25 ;com_res=0
		movwf 	0x25 ;com_res = w 
		comf 	0x25  ; comps'1(com_res)
		incf 	0x25 ; comp's 2(com_res)
		movfw 	0x25 ; w = com_res
		call 	NSP
return 
;-------------------------------negative sign--------------------------------------
NSP:
		movwf	0x61 	;temp = w
		movlw	'-'			; CHAR (the data )
		movwf	0x20
		call 	lcdd
		call	mdel
		movfw	0x61 	;restoring
		return
endcon: 	goto endcon ; ending loop
		
end