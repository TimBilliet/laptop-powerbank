   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  14                     	bsct
  15  0000               _addr:
  16  0000 78            	dc.b	120
  17  0001               _i2cspeed:
  18  0001 1a80          	dc.w	6784
  98                     ; 21 main() {
 100                     	switch	.text
 101  0000               _main:
 103  0000 5205          	subw	sp,#5
 104       00000005      OFST:	set	5
 107                     ; 24 	uint16_t spanning = 0x03e8;
 109                     ; 25 	uint8_t spanning_lsb = 0xe8;
 111  0002 a6e8          	ld	a,#232
 112  0004 6b03          	ld	(OFST-2,sp),a
 114                     ; 26 	uint8_t spanning_msb = 0x03;
 116  0006 a603          	ld	a,#3
 117  0008 6b04          	ld	(OFST-1,sp),a
 119                     ; 27 	i2c_setup();
 121  000a ad39          	call	_i2c_setup
 123                     ; 29 	reg_val = readRegisterByte(addr, 0x19);
 125  000c b600          	ld	a,_addr
 126  000e ae0019        	ldw	x,#25
 127  0011 95            	ld	xh,a
 128  0012 ad5e          	call	_readRegisterByte
 130  0014 6b05          	ld	(OFST+0,sp),a
 132                     ; 30 	newval = reg_val | 1;
 134  0016 7b05          	ld	a,(OFST+0,sp)
 135  0018 aa01          	or	a,#1
 136  001a 6b05          	ld	(OFST+0,sp),a
 138                     ; 31 	writeRegisterByte(addr, 0x19, newval);
 140  001c 7b05          	ld	a,(OFST+0,sp)
 141  001e 88            	push	a
 142  001f b600          	ld	a,_addr
 143  0021 ae0019        	ldw	x,#25
 144  0024 95            	ld	xh,a
 145  0025 cd00e7        	call	_writeRegisterByte
 147  0028 84            	pop	a
 148                     ; 33 	writeRegisterByte(addr, 0x0c, spanning_lsb);
 150  0029 7b03          	ld	a,(OFST-2,sp)
 151  002b 88            	push	a
 152  002c b600          	ld	a,_addr
 153  002e ae000c        	ldw	x,#12
 154  0031 95            	ld	xh,a
 155  0032 cd00e7        	call	_writeRegisterByte
 157  0035 84            	pop	a
 158                     ; 34 	writeRegisterByte(addr, 0x0d, spanning_msb);
 160  0036 7b04          	ld	a,(OFST-1,sp)
 161  0038 88            	push	a
 162  0039 b600          	ld	a,_addr
 163  003b ae000d        	ldw	x,#13
 164  003e 95            	ld	xh,a
 165  003f cd00e7        	call	_writeRegisterByte
 167  0042 84            	pop	a
 168  0043               L74:
 170  0043 20fe          	jra	L74
 207                     .const:	section	.text
 208  0000               L01:
 209  0000 000f4240      	dc.l	1000000
 210                     ; 41 void i2c_setup(void) {
 211                     	switch	.text
 212  0045               _i2c_setup:
 214  0045 88            	push	a
 215       00000001      OFST:	set	1
 218                     ; 42 	u8 Input_Clock = 0;
 220                     ; 43 	Input_Clock = CLK_GetClockFreq()/1000000;
 222  0046 cd0000        	call	_CLK_GetClockFreq
 224  0049 ae0000        	ldw	x,#L01
 225  004c cd0000        	call	c_ludv
 227  004f b603          	ld	a,c_lreg+3
 228  0051 6b01          	ld	(OFST+0,sp),a
 230                     ; 44   I2C_Init(i2cspeed, 0xa0, I2C_DUTYCYCLE_2, I2C_ACK_CURR, I2C_ADDMODE_7BIT, Input_Clock);
 232  0053 7b01          	ld	a,(OFST+0,sp)
 233  0055 88            	push	a
 234  0056 4b00          	push	#0
 235  0058 4b01          	push	#1
 236  005a 4b00          	push	#0
 237  005c ae00a0        	ldw	x,#160
 238  005f 89            	pushw	x
 239  0060 be01          	ldw	x,_i2cspeed
 240  0062 cd0000        	call	c_itolx
 242  0065 be02          	ldw	x,c_lreg+2
 243  0067 89            	pushw	x
 244  0068 be00          	ldw	x,c_lreg
 245  006a 89            	pushw	x
 246  006b cd0000        	call	_I2C_Init
 248  006e 5b0a          	addw	sp,#10
 249                     ; 45 }
 252  0070 84            	pop	a
 253  0071 81            	ret
 313                     ; 47 uint8_t readRegisterByte(uint8_t slave_addr, uint8_t ReadAddr) {
 314                     	switch	.text
 315  0072               _readRegisterByte:
 317  0072 89            	pushw	x
 318  0073 89            	pushw	x
 319       00000002      OFST:	set	2
 322  0074               L121:
 323                     ; 49 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
 325  0074 ae0302        	ldw	x,#770
 326  0077 cd0000        	call	_I2C_GetFlagStatus
 328  007a 4d            	tnz	a
 329  007b 26f7          	jrne	L121
 330                     ; 50 	I2C_GenerateSTART(ENABLE);
 332  007d a601          	ld	a,#1
 333  007f cd0000        	call	_I2C_GenerateSTART
 336  0082               L721:
 337                     ; 51 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 339  0082 ae0301        	ldw	x,#769
 340  0085 cd0000        	call	_I2C_CheckEvent
 342  0088 4d            	tnz	a
 343  0089 27f7          	jreq	L721
 344                     ; 52 	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_TX);
 346  008b 7b03          	ld	a,(OFST+1,sp)
 347  008d 5f            	clrw	x
 348  008e 95            	ld	xh,a
 349  008f cd0000        	call	_I2C_Send7bitAddress
 352  0092               L531:
 353                     ; 53 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
 355  0092 ae0782        	ldw	x,#1922
 356  0095 cd0000        	call	_I2C_CheckEvent
 358  0098 4d            	tnz	a
 359  0099 27f7          	jreq	L531
 360                     ; 54 	I2C_SendData((u8)(ReadAddr));
 362  009b 7b04          	ld	a,(OFST+2,sp)
 363  009d cd0000        	call	_I2C_SendData
 366  00a0               L341:
 367                     ; 55 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 369  00a0 ae0784        	ldw	x,#1924
 370  00a3 cd0000        	call	_I2C_CheckEvent
 372  00a6 4d            	tnz	a
 373  00a7 27f7          	jreq	L341
 374                     ; 56 	I2C_GenerateSTART(ENABLE);
 376  00a9 a601          	ld	a,#1
 377  00ab cd0000        	call	_I2C_GenerateSTART
 380  00ae               L151:
 381                     ; 57 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 383  00ae ae0301        	ldw	x,#769
 384  00b1 cd0000        	call	_I2C_CheckEvent
 386  00b4 4d            	tnz	a
 387  00b5 27f7          	jreq	L151
 388                     ; 58 	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_RX);
 390  00b7 7b03          	ld	a,(OFST+1,sp)
 391  00b9 ae0001        	ldw	x,#1
 392  00bc 95            	ld	xh,a
 393  00bd cd0000        	call	_I2C_Send7bitAddress
 396  00c0               L751:
 397                     ; 59 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED));
 399  00c0 ae0302        	ldw	x,#770
 400  00c3 cd0000        	call	_I2C_CheckEvent
 402  00c6 4d            	tnz	a
 403  00c7 27f7          	jreq	L751
 405  00c9               L561:
 406                     ; 60 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_RECEIVED));
 408  00c9 ae0340        	ldw	x,#832
 409  00cc cd0000        	call	_I2C_CheckEvent
 411  00cf 4d            	tnz	a
 412  00d0 27f7          	jreq	L561
 413                     ; 61 	pBuffer = I2C_ReceiveData();
 415  00d2 cd0000        	call	_I2C_ReceiveData
 417  00d5 5f            	clrw	x
 418  00d6 97            	ld	xl,a
 419  00d7 1f01          	ldw	(OFST-1,sp),x
 421                     ; 62 	I2C_AcknowledgeConfig(I2C_ACK_NONE);
 423  00d9 4f            	clr	a
 424  00da cd0000        	call	_I2C_AcknowledgeConfig
 426                     ; 63 	I2C_GenerateSTOP(ENABLE);
 428  00dd a601          	ld	a,#1
 429  00df cd0000        	call	_I2C_GenerateSTOP
 431                     ; 64 	return pBuffer;
 433  00e2 7b02          	ld	a,(OFST+0,sp)
 436  00e4 5b04          	addw	sp,#4
 437  00e6 81            	ret
 495                     ; 67 void writeRegisterByte(uint8_t slave_addr, uint8_t register_addr, uint8_t data){
 496                     	switch	.text
 497  00e7               _writeRegisterByte:
 499  00e7 89            	pushw	x
 500       00000000      OFST:	set	0
 503  00e8               L122:
 504                     ; 68 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
 506  00e8 ae0302        	ldw	x,#770
 507  00eb cd0000        	call	_I2C_GetFlagStatus
 509  00ee 4d            	tnz	a
 510  00ef 26f7          	jrne	L122
 511                     ; 69 	I2C_GenerateSTART(ENABLE);
 513  00f1 a601          	ld	a,#1
 514  00f3 cd0000        	call	_I2C_GenerateSTART
 517  00f6               L722:
 518                     ; 70 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 520  00f6 ae0301        	ldw	x,#769
 521  00f9 cd0000        	call	_I2C_CheckEvent
 523  00fc 4d            	tnz	a
 524  00fd 27f7          	jreq	L722
 525                     ; 71 	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_TX);
 527  00ff 7b01          	ld	a,(OFST+1,sp)
 528  0101 5f            	clrw	x
 529  0102 95            	ld	xh,a
 530  0103 cd0000        	call	_I2C_Send7bitAddress
 533  0106               L532:
 534                     ; 72 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
 536  0106 ae0782        	ldw	x,#1922
 537  0109 cd0000        	call	_I2C_CheckEvent
 539  010c 4d            	tnz	a
 540  010d 27f7          	jreq	L532
 541                     ; 73 	I2C_SendData((u8)(register_addr));
 543  010f 7b02          	ld	a,(OFST+2,sp)
 544  0111 cd0000        	call	_I2C_SendData
 547  0114               L342:
 548                     ; 74 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 550  0114 ae0784        	ldw	x,#1924
 551  0117 cd0000        	call	_I2C_CheckEvent
 553  011a 4d            	tnz	a
 554  011b 27f7          	jreq	L342
 555                     ; 75 	I2C_SendData((u8)(data));
 557  011d 7b05          	ld	a,(OFST+5,sp)
 558  011f cd0000        	call	_I2C_SendData
 561  0122               L152:
 562                     ; 76 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 564  0122 ae0784        	ldw	x,#1924
 565  0125 cd0000        	call	_I2C_CheckEvent
 567  0128 4d            	tnz	a
 568  0129 27f7          	jreq	L152
 569                     ; 77 	I2C_GenerateSTOP(ENABLE);
 571  012b a601          	ld	a,#1
 572  012d cd0000        	call	_I2C_GenerateSTOP
 574                     ; 78 }
 577  0130 85            	popw	x
 578  0131 81            	ret
 636                     ; 79 void writeRegisterWord(uint8_t slave_addr, uint8_t register_addr, uint16_t data){
 637                     	switch	.text
 638  0132               _writeRegisterWord:
 640  0132 89            	pushw	x
 641       00000000      OFST:	set	0
 644  0133               L503:
 645                     ; 80 	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
 647  0133 ae0302        	ldw	x,#770
 648  0136 cd0000        	call	_I2C_GetFlagStatus
 650  0139 4d            	tnz	a
 651  013a 26f7          	jrne	L503
 652                     ; 81 	I2C_GenerateSTART(ENABLE);
 654  013c a601          	ld	a,#1
 655  013e cd0000        	call	_I2C_GenerateSTART
 658  0141               L313:
 659                     ; 82 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
 661  0141 ae0301        	ldw	x,#769
 662  0144 cd0000        	call	_I2C_CheckEvent
 664  0147 4d            	tnz	a
 665  0148 27f7          	jreq	L313
 666                     ; 83 	I2C_Send7bitAddress(slave_addr, I2C_DIRECTION_TX);
 668  014a 7b01          	ld	a,(OFST+1,sp)
 669  014c 5f            	clrw	x
 670  014d 95            	ld	xh,a
 671  014e cd0000        	call	_I2C_Send7bitAddress
 674  0151               L123:
 675                     ; 84 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
 677  0151 ae0782        	ldw	x,#1922
 678  0154 cd0000        	call	_I2C_CheckEvent
 680  0157 4d            	tnz	a
 681  0158 27f7          	jreq	L123
 682                     ; 85 	I2C_SendData((u8)(register_addr));
 684  015a 7b02          	ld	a,(OFST+2,sp)
 685  015c cd0000        	call	_I2C_SendData
 688  015f               L723:
 689                     ; 86 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 691  015f ae0784        	ldw	x,#1924
 692  0162 cd0000        	call	_I2C_CheckEvent
 694  0165 4d            	tnz	a
 695  0166 27f7          	jreq	L723
 696                     ; 87 	I2C_SendData((u8)(data));
 698  0168 7b06          	ld	a,(OFST+6,sp)
 699  016a cd0000        	call	_I2C_SendData
 702  016d               L533:
 703                     ; 88 	while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
 705  016d ae0784        	ldw	x,#1924
 706  0170 cd0000        	call	_I2C_CheckEvent
 708  0173 4d            	tnz	a
 709  0174 27f7          	jreq	L533
 710                     ; 89 	I2C_GenerateSTOP(ENABLE);
 712  0176 a601          	ld	a,#1
 713  0178 cd0000        	call	_I2C_GenerateSTOP
 715                     ; 90 }
 718  017b 85            	popw	x
 719  017c 81            	ret
 752                     	xdef	_main
 753                     	xdef	_writeRegisterWord
 754                     	xdef	_writeRegisterByte
 755                     	xdef	_readRegisterByte
 756                     	xdef	_i2c_setup
 757                     	xdef	_i2cspeed
 758                     	xdef	_addr
 759                     	xref	_I2C_GetFlagStatus
 760                     	xref	_I2C_CheckEvent
 761                     	xref	_I2C_SendData
 762                     	xref	_I2C_Send7bitAddress
 763                     	xref	_I2C_ReceiveData
 764                     	xref	_I2C_AcknowledgeConfig
 765                     	xref	_I2C_GenerateSTOP
 766                     	xref	_I2C_GenerateSTART
 767                     	xref	_I2C_Init
 768                     	xref	_CLK_GetClockFreq
 769                     	xref.b	c_lreg
 770                     	xref.b	c_x
 789                     	xref	c_itolx
 790                     	xref	c_ludv
 791                     	end
