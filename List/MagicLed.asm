
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny13A
;Program type             : Application
;Clock frequency          : 9,600000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 16 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Smart register allocation     : Off
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny13A
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 159
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _pwm_counter=R4
	.DEF _red_bs=R5
	.DEF _green_bs=R6
	.DEF _blue_bs=R7
	.DEF _time=R8
	.DEF _sensorNotTouched=R10
	.DEF _STATE=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _wdt_timeout_isr
	RJMP 0x00

_0x5D:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  _0x5D*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;#include <tiny13a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;
;//#define PROTEUS_SIMULATION//из-за ошибок симул€ции Watchdog в протеусе используем чуть разный код.
;//                          //ƒл€ рабочей прошивки закоментировать этот макрос
;
;//PORTS
;
;/*
;#define RED_P 4
;#define GREEN_P 2
;#define BLUE_P 3
;#define SENSOR_OUT_P 1
;#define SENSOR_IN_P 0
;*/
;
;//*
;#define RED_P 0
;#define GREEN_P 1
;#define BLUE_P 2
;#define SENSOR_OUT_P 3
;#define SENSOR_IN_P 4
;//*/
;
;//STATES
;#define SLEEP 0
;#define AWAKED 1
;#define SHINE1 2
;#define SHINE2 3
;#define SHINE3 4
;#define SHINE4 5
;//CONSTS
;
;//√лобальные переменные
;unsigned char pwm_counter=0;//счЄтчик Ў»ћ цикла
;unsigned char red_bs=0;//€ркость красного светодиода (0-255)
;unsigned char green_bs=0;//€ркость зеленого светодиода (0-255)
;unsigned char blue_bs=0;//€ркость синего светодиода (0-255)
;unsigned int time;//подсчЄт времени непрерывного свечени€
;unsigned char sensorNotTouched;//значение не притронутого сенсора, устанавливаетс€ в процессе
;                              //калибровки
;unsigned char STATE=0;//состо€ние программы
;//********* ќбъ€влени€ функций *********
;void common_init();
;//
;void sensorCalibration();
;unsigned char sensorTouched();//провер€ет есть ли прикосновение к сенсору, возвращает 1 если есть,
;                              //0 если нет
;unsigned int sensorValue();//получает значение сенсора
;//
;void changeColor1(unsigned char shine,unsigned char pause);//плавный переход к случайному значению
;                                                           //случайного канала (одного из R,G,B)
;                                                           //или затухание если shine=0
;//**************************************
;void main(void)
; 0000 0039 {

	.CSEG
_main:
; 0000 003A     unsigned char sleepCount=0;//счЄтчик циклов сп€щего режима
; 0000 003B     unsigned char i;
; 0000 003C 
; 0000 003D     common_init();
;	sleepCount -> R16
;	i -> R17
	LDI  R16,0
	RCALL _common_init
; 0000 003E 
; 0000 003F     PORTB.RED_P=1;PORTB.GREEN_P=1;PORTB.BLUE_P=1;
	SBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
; 0000 0040 
; 0000 0041     delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x0
	RCALL _delay_ms
; 0000 0042 
; 0000 0043     //дл€ отладки - определение значени€ непритронутого сенсора
; 0000 0044     /*if (sensorNotTouched>125)red_bs=100;
; 0000 0045     if (sensorNotTouched>170)blue_bs=100;
; 0000 0046     if (sensorNotTouched>200)green_bs=100;*/
; 0000 0047 
; 0000 0048     //#asm("sei") //прерывание включаютс€ в функции sensorValue
; 0000 0049 
; 0000 004A     while (1){
_0x9:
; 0000 004B 
; 0000 004C         if(time>26368||sleepCount==0){//рекалибровка раз в 2,43 минуты сп€щего режима
	LDI  R30,LOW(26368)
	LDI  R31,HIGH(26368)
	CP   R30,R8
	CPC  R31,R9
	BRLO _0xD
	CPI  R16,0
	BRNE _0xC
_0xD:
; 0000 004D                                       //и раз в 3 минуты свечени€
; 0000 004E             time=0;
	CLR  R8
	CLR  R9
; 0000 004F             sensorCalibration();
	RCALL _sensorCalibration
; 0000 0050         }
; 0000 0051 
; 0000 0052         if(sensorTouched()){
_0xC:
	RCALL _sensorTouched
	CPI  R30,0
	BRNE PC+2
	RJMP _0xF
; 0000 0053 
; 0000 0054              srand(time+sleepCount);
	RCALL SUBOPT_0x1
	ADD  R30,R8
	ADC  R31,R9
	RCALL SUBOPT_0x0
	RCALL _srand
; 0000 0055 
; 0000 0056              switch(STATE){
	MOV  R30,R11
	RCALL SUBOPT_0x2
; 0000 0057                 case SLEEP:
	SBIW R30,0
	BRNE _0x13
; 0000 0058                     STATE=AWAKED;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0059                     changeColor1(1,12);//медленно разжигаем
	ST   -Y,R30
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x3
; 0000 005A                     break;
	RJMP _0x12
; 0000 005B                 case AWAKED:
_0x13:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14
; 0000 005C                     //получаем случайное значение от 2 до 4
; 0000 005D                     STATE=(rand()&3)+2;
	RCALL _rand
	ANDI R30,LOW(0x3)
	SUBI R30,-LOW(2)
	RJMP _0x5B
; 0000 005E                     break;
; 0000 005F                 case SHINE1:
_0x14:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x16
; 0000 0060                 case SHINE2:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x17
_0x16:
; 0000 0061                     //эффект свечени€ 1
; 0000 0062                     for(i=0;i<=7;i++)changeColor1(1,3);
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,8
	BRSH _0x1A
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 0063 STATE=1;
	RJMP _0x5C
; 0000 0064                     break;
; 0000 0065                 case SHINE3:
_0x17:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x1C
; 0000 0066                 case SHINE4:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x12
_0x1C:
; 0000 0067                     //эффект свечени€ 2
; 0000 0068                     changeColor1(0,5);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3
; 0000 0069                     delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x4
; 0000 006A                     changeColor1(1,5);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3
; 0000 006B                     STATE=AWAKED;
_0x5C:
	LDI  R30,LOW(1)
_0x5B:
	MOV  R11,R30
; 0000 006C                     break;
; 0000 006D              }
_0x12:
; 0000 006E         }
; 0000 006F         else{
	RJMP _0x1E
_0xF:
; 0000 0070             if(STATE==SLEEP)sleepCount++;//+0,507 сек сп€щего режима
	TST  R11
	BRNE _0x1F
	SUBI R16,-1
; 0000 0071             else{
	RJMP _0x20
_0x1F:
; 0000 0072                 changeColor1(0,15);//медленно гасим
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x3
; 0000 0073                 //sleepCount=0;//специально не сбрасываем счЄтчик, что бы калибровка запускалась при
; 0000 0074                                //частых переходах сон-активность
; 0000 0075                 time=0;
	CLR  R8
	CLR  R9
; 0000 0076                 STATE=SLEEP;
	CLR  R11
; 0000 0077             }
_0x20:
; 0000 0078             #ifndef PROTEUS_SIMULATION
; 0000 0079                 //¬ключаем Watchdog Timer interrupt
; 0000 007A                 WDTCR|=0x40;
	IN   R30,0x21
	ORI  R30,0x40
	OUT  0x21,R30
; 0000 007B                 //переходим в энергосберегающий режим
; 0000 007C                 #asm("sleep");
	sleep
; 0000 007D             #else
; 0000 007E             	delay_ms(500);//в Proteus сп€чку имитируем задержкой
; 0000 007F             #endif
; 0000 0080         }
_0x1E:
; 0000 0081     }
	RJMP _0x9
; 0000 0082 }
_0x21:
	RJMP _0x21
;void sensorCalibration()
; 0000 0084 {
_sensorCalibration:
; 0000 0085     unsigned char max;
; 0000 0086     unsigned char i;
; 0000 0087 
; 0000 0088     sensorNotTouched=0;
	RCALL __SAVELOCR2
;	max -> R16
;	i -> R17
	CLR  R10
; 0000 0089 
; 0000 008A     for(i=1;i<=10;i++){
	LDI  R17,LOW(1)
_0x23:
	CPI  R17,11
	BRSH _0x24
; 0000 008B         max=sensorValue();
	RCALL _sensorValue
	MOV  R16,R30
; 0000 008C         if(max>sensorNotTouched)sensorNotTouched=max;
	CP   R10,R16
	BRSH _0x25
	MOV  R10,R16
; 0000 008D 
; 0000 008E         //дл€ отладки - индикаци€ калибровки
; 0000 008F         //if(red_bs==0)red_bs=100;
; 0000 0090         //else red_bs=0;
; 0000 0091         //delay_ms(50);
; 0000 0092 
; 0000 0093         delay_ms(50);
_0x25:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x4
; 0000 0094     }
	SUBI R17,-1
	RJMP _0x23
_0x24:
; 0000 0095 }
	RJMP _0x2080001
;unsigned char sensorTouched()
; 0000 0097 {
_sensorTouched:
; 0000 0098     unsigned char t=0;
; 0000 0099     unsigned char i;
; 0000 009A     for(i=1;i<=10;i++){
	RCALL __SAVELOCR2
;	t -> R16
;	i -> R17
	LDI  R16,0
	LDI  R17,LOW(1)
_0x27:
	CPI  R17,11
	BRSH _0x28
; 0000 009B         if(sensorValue()>sensorNotTouched+15)t++;
	RCALL _sensorValue
	MOV  R26,R30
	MOV  R27,R31
	MOV  R30,R10
	RCALL SUBOPT_0x2
	ADIW R30,15
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x29
	SUBI R16,-1
; 0000 009C         else if(t>0)t--;
	RJMP _0x2A
_0x29:
	CPI  R16,1
	BRLO _0x2B
	SUBI R16,1
; 0000 009D         delay_ms(10);
_0x2B:
_0x2A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x4
; 0000 009E     }
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 009F     return t;
	MOV  R30,R16
_0x2080001:
	RCALL __LOADLOCR2P
	RET
; 0000 00A0 }
;unsigned int sensorValue()
; 0000 00A2 {
_sensorValue:
; 0000 00A3     unsigned char sensorValue;
; 0000 00A4 
; 0000 00A5     #asm("cli")
	ST   -Y,R16
;	sensorValue -> R16
	cli
; 0000 00A6     PORTB.SENSOR_OUT_P=1;
	SBI  0x18,3
; 0000 00A7     TCNT0=0;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00A8     while(!PINB.SENSOR_IN_P);
_0x2E:
	SBIS 0x16,4
	RJMP _0x2E
; 0000 00A9     sensorValue=TCNT0;
	IN   R16,50
; 0000 00AA     #asm("sei")
	sei
; 0000 00AB     PORTB.SENSOR_OUT_P=0;
	CBI  0x18,3
; 0000 00AC     return sensorValue;
	RCALL SUBOPT_0x1
	LD   R16,Y+
	RET
; 0000 00AD }
;//----------------------------------------------------------------------------------------------------
;void common_init()
; 0000 00B0 {
_common_init:
; 0000 00B1     #pragma optsize-
; 0000 00B2     //Crystal Oscillator division factor: 1
; 0000 00B3     CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00B4     CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00B5     #ifdef _OPTIMIZE_SIZE_
; 0000 00B6     #pragma optsize+
; 0000 00B7     #endif
; 0000 00B8     //Watchdog Timer initialization
; 0000 00B9     //Watchdog Timer Prescaler: OSC/64k - period .5 sec
; 0000 00BA     //Watchdog mode: interrupt
; 0000 00BB     WDTCR=0b00010101;
	LDI  R30,LOW(21)
	OUT  0x21,R30
; 0000 00BC     //Enable sleep mode
; 0000 00BD     MCUCR|=0b00110000;
	IN   R30,0x35
	ORI  R30,LOW(0x30)
	OUT  0x35,R30
; 0000 00BE     //Analog Comparator off in power reduction
; 0000 00BF     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C0     //ADC off in power reduction
; 0000 00C1     PRR=1;
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 00C2     //установка режима таймера
; 0000 00C3     //Mode:Normal
; 0000 00C4     //TCCR0A=0;
; 0000 00C5     //division factor: 1
; 0000 00C6     TCCR0B=1;
	OUT  0x33,R30
; 0000 00C7     //timer interrupt on overflow
; 0000 00C8     TIMSK0=0b10;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 00C9     //Input/Output Ports initialization
; 0000 00CA     DDRB.SENSOR_OUT_P=1;
	SBI  0x17,3
; 0000 00CB     //DDRB.SENSOR_IN_P=0;//by default
; 0000 00CC     DDRB.RED_P=1;
	SBI  0x17,0
; 0000 00CD     DDRB.BLUE_P=1;
	SBI  0x17,2
; 0000 00CE     DDRB.GREEN_P=1;
	SBI  0x17,1
; 0000 00CF }
	RET
;void changeColor1(unsigned char shine,unsigned char pause)
; 0000 00D1 {
_changeColor1:
; 0000 00D2     unsigned char to_red=0,to_blue=0,to_green=0;
; 0000 00D3     if(shine){
	RCALL __SAVELOCR3
;	shine -> Y+4
;	pause -> Y+3
;	to_red -> R16
;	to_blue -> R17
;	to_green -> R18
	LDI  R16,0
	LDI  R17,0
	LDI  R18,0
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x3B
; 0000 00D4         //выбираем случайный канал и цвет
; 0000 00D5         loop:
_0x3C:
; 0000 00D6         shine=rand()&3;//случайное значение канала
	RCALL _rand
	ANDI R30,LOW(0x3)
	STD  Y+4,R30
; 0000 00D7         switch (shine){
	RCALL SUBOPT_0x2
; 0000 00D8             case 0:
	SBIW R30,0
	BRNE _0x40
; 0000 00D9                 to_red=rand();
	RCALL _rand
	MOV  R16,R30
; 0000 00DA                 break;
	RJMP _0x3F
; 0000 00DB             case 1:
_0x40:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x41
; 0000 00DC                 to_green=rand();
	RCALL _rand
	MOV  R18,R30
; 0000 00DD                 break;
	RJMP _0x3F
; 0000 00DE             case 2:
_0x41:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x43
; 0000 00DF                 to_blue=rand();
	RCALL _rand
	MOV  R17,R30
; 0000 00E0                 break;
	RJMP _0x3F
; 0000 00E1             default:
_0x43:
; 0000 00E2                 goto loop;
	RJMP _0x3C
; 0000 00E3         }
_0x3F:
; 0000 00E4     }
; 0000 00E5     //выполн€ем плавный переход к полученному цвету
; 0000 00E6     while(red_bs!=to_red||green_bs!=to_green||blue_bs!=to_blue){
_0x3B:
_0x44:
	CP   R16,R5
	BRNE _0x47
	CP   R18,R6
	BRNE _0x47
	CP   R17,R7
	BREQ _0x46
_0x47:
; 0000 00E7 
; 0000 00E8         if(to_red!=red_bs)
	CP   R5,R16
	BREQ _0x49
; 0000 00E9             if(to_red>red_bs)red_bs++;
	CP   R5,R16
	BRSH _0x4A
	INC  R5
; 0000 00EA             else red_bs--;
	RJMP _0x4B
_0x4A:
	DEC  R5
; 0000 00EB         if(to_green!=green_bs)
_0x4B:
_0x49:
	CP   R6,R18
	BREQ _0x4C
; 0000 00EC             if(to_green>green_bs)green_bs++;
	CP   R6,R18
	BRSH _0x4D
	INC  R6
; 0000 00ED             else green_bs--;
	RJMP _0x4E
_0x4D:
	DEC  R6
; 0000 00EE         if(to_blue!=blue_bs)
_0x4E:
_0x4C:
	CP   R7,R17
	BREQ _0x4F
; 0000 00EF             if(to_blue>blue_bs)blue_bs++;
	CP   R7,R17
	BRSH _0x50
	INC  R7
; 0000 00F0             else blue_bs--;
	RJMP _0x51
_0x50:
	DEC  R7
; 0000 00F1 
; 0000 00F2         delay_ms(pause);
_0x51:
_0x4F:
	LDD  R30,Y+3
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
; 0000 00F3     }
	RJMP _0x44
_0x46:
; 0000 00F4 }
	RCALL __LOADLOCR3
	ADIW R28,5
	RET
;
;//ќбработчики прерываний
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00F9 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00FA     PORTB.RED_P=(pwm_counter>=red_bs<<1);
	MOV  R30,R5
	RCALL SUBOPT_0x5
	BRNE _0x52
	CBI  0x18,0
	RJMP _0x53
_0x52:
	SBI  0x18,0
_0x53:
; 0000 00FB     PORTB.GREEN_P=(pwm_counter>=green_bs<<1);
	MOV  R30,R6
	RCALL SUBOPT_0x5
	BRNE _0x54
	CBI  0x18,1
	RJMP _0x55
_0x54:
	SBI  0x18,1
_0x55:
; 0000 00FC     PORTB.BLUE_P=(pwm_counter>=blue_bs<<1);
	MOV  R30,R7
	RCALL SUBOPT_0x5
	BRNE _0x56
	CBI  0x18,2
	RJMP _0x57
_0x56:
	SBI  0x18,2
_0x57:
; 0000 00FD     pwm_counter++;
	INC  R4
; 0000 00FE     if(STATE!=SLEEP&&pwm_counter==0)time++;//подсчет времени свечени€, + 0,006826667 сек
	LDI  R30,LOW(0)
	CP   R30,R11
	BREQ _0x59
	CP   R30,R4
	BREQ _0x5A
_0x59:
	RJMP _0x58
_0x5A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 8,9,30,31
; 0000 00FF }
_0x58:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;// Watchdog timeout interrupt service routine
;interrupt [WDT] void wdt_timeout_isr(void)
; 0000 0102 {
_wdt_timeout_isr:
; 0000 0103     //ничего не делаем, прерывание используетс€ только дл€ выхода из сп€щего режима
; 0000 0104 }
	RETI

	.CSEG

	.DSEG

	.CSEG
_srand:
	LD   R30,Y
	LDD  R31,Y+1
	RCALL __CWD1
	RCALL SUBOPT_0x6
	ADIW R28,2
	RET
_rand:
	LDS  R30,__seed_G100
	LDS  R31,__seed_G100+1
	LDS  R22,__seed_G100+2
	LDS  R23,__seed_G100+3
	__GETD2N 0x41C64E6D
	RCALL __MULD12U
	__ADDD1N 30562
	RCALL SUBOPT_0x6
	mov  r30,r22
	mov  r31,r23
	andi r31,0x7F
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _changeColor1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x2
	LSL  R30
	ROL  R31
	MOV  R26,R4
	LDI  R27,0
	RCALL __GEW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	STS  __seed_G100,R30
	STS  __seed_G100+1,R31
	STS  __seed_G100+2,R22
	STS  __seed_G100+3,R23
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x960
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GEW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRGE __GEW12T
	CLR  R30
__GEW12T:
	RET

__MULD12U:
	PUSH R19
	PUSH R20
	PUSH R21
	LDI  R21,33
	MOV  R0,R26
	MOV  R1,R27
	MOV  R19,R24
	MOV  R20,R25
	CLR  R26
	CLR  R27
	CLR  R24
	SUB  R25,R25
	RJMP __MULD12U1
__MULD12U3:
	BRCC __MULD12U2
	ADD  R26,R0
	ADC  R27,R1
	ADC  R24,R19
	ADC  R25,R20
__MULD12U2:
	LSR  R25
	ROR  R24
	ROR  R27
	ROR  R26
__MULD12U1:
	ROR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __MULD12U3
	POP  R21
	POP  R20
	POP  R19
	RET

__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
