;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UFO Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UfoColumns				equ		$07

UfoXOffset				equ		$03
UfoYOffset				equ		$03

UfoYpos					equ		$0A
UfoYPosDraw				equ		UfoYpos+UfoYOffset

UfoEdgeLeft				equ		$03
UfoEdgeRight			equ		$3C

UfoGoneLeft				equ		UfoEdgeLeft-UfoColumns+1
UfoGoneRight			equ		UfoEdgeRight+UfoColumns-1
UfoLeavingLeft			equ		UfoEdgeLeft-1
UfoLeavingRight			equ		UfoEdgeRight+1


UfoStartLeft			equ		UfoGoneLeft*$0100
UfoStartRight			equ		UfoGoneRight*$0100
UfoVelRight				equ		$0080
UfoVelLeft				equ		-UfoVelRight

UfoSBLineUp				equ		-28
UfoSBLineUpTwoOne		equ		-31
UfoSBLineUpFourThree	equ		-30
UfoSBLineUpSixFive		equ		-29

UfoSBColumnSTwoOne		equ		3
UfoSBColumnSFourThree	equ		2
UfoSBColumnSSixFive		equ		1

UfoSBColumnUTwoOne		equ		-UfoSBColumnSTwoOne
UfoSBColumnUFourThree	equ		-UfoSBColumnSFourThree
UfoSBColumnUSixFive		equ		-UfoSBColumnSSixFive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the UFO on current work screen
; Uses: a,b,x,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawUfo					lda     UfoActive    			; Is UFO active
						bne		ProcessUfo?				; if not, exit
						rts
ProcessUfo?				ldu		WorkScreen				; get work screen
						ldb		#UfoYPosDraw			; Get y position
						lda		UfoXpos					; Get x position
						adda	#UfoXOffset				; add x offset
						jsr		FindAddessOffsetNeg		; get address offset
						leau	d,u						; get address to place rock
						lda		WorkNumber				; get work screen
						beq		Work0?					; if screen 1
						stu		UfoErase2				; store erase for screen 2
						clr		UfoEraseBytes2
						bra		OffInt?					; find frame
Work0?					stu		UfoErase1				; store erase for screen 10
						clr		UfoEraseBytes1
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
CheckOdd?				sts		SaveSp
						lda		UfoXpos						; Get X position
						lsra								; Check for odd
						bcc		Even?
						lds		#UfoDataOdd
						bra		Start?
Even?					lds		#UfoDataEven
Start?					lda		UfoXpos
						cmpa	#UfoEdgeRight
						bgt		PartialRight?
						cmpa	#UfoEdgeLeft
						lblt	PartialLeft?
						puls	d,x
						pshu	d,x
						leau	UfoSBLineUp,u
						puls	d,x
						pshu	d,x
						leau	UfoSBLineUp,u
						puls	d,x
						pshu	d,x
						leau	UfoSBLineUp,u
						puls	d,x
						pshu	d,x
						leau	UfoSBLineUp,u
						puls	d,x
						pshu	d,x
						leau	UfoSBLineUp,u
						puls	d,x
						pshu	d,x
						leau	UfoSBLineUp,u
						puls	d,x
						pshu	d,x
						lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts
PartialRight?			suba	#UfoLeavingRight
						nega
						adda	#7
						lsra
						ldb		WorkNumber
						beq		Work1?
						sta		UfoEraseBytes2
						bra		Cont?
Work1?					sta		UfoEraseBytes1
Cont?					cmpa	#3
						lbeq	RightSixFive?
						cmpa	#2
						beq		RightFourThree?
						leau	UfoSBColumnUTwoOne,u
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						jmp		Restore?
RightFourThree?			leau	UfoSBColumnUFourThree,u
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						jmp		Restore?
RightSixFive?			leau	UfoSBColumnUSixFive,u
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						jmp		Restore?
PartialLeft?			cmpa	#2
						beq		SetThree?
						cmpa	#1
						beq		SetThree?
						cmpa	#0
						beq		SetTwo?
						cmpa	#-1
						beq		SetTwo?
						lda		#-1
						bra		DoWork?
SetThree?				lda		#-3
						bra		DoWork?
SetTwo?					lda		#-2
DoWork?					ldb		WorkNumber
						beq		Work2?
						sta		UfoEraseBytes2
						bra		ContA?
Work2?					sta		UfoEraseBytes1
ContA?					cmpa	#-3
						lbeq	LeftSixFive?
						cmpa	#-2
						beq		LeftFourThree?
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						leas	UfoSBColumnSTwoOne,s
						puls	a
						pshu	a
						jmp		Restore?
LeftFourThree?			leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						leau	UfoSBLineUpFourThree,u
						leas	UfoSBColumnSFourThree,s
						puls	x
						pshu	x
						jmp		Restore?
LeftSixFive?			leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						leas	UfoSBColumnSSixFive,s
						puls	a,x
						pshu	a,x
Restore?				lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase the UFO on current work screen
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseUfo				lda		WorkNumber
						beq		Erase1?
Erase2?					ldu		UfoErase2
						bne		ClearErase2?
						rts
ClearErase2?			ldd		#$0000
						std		UfoErase2
						ldb		UfoEraseBytes2
						bra		OffInt?
Erase1?					ldu		UfoErase1
						bne		ClearErase1?
						rts
ClearErase1?			ldd		#$0000
						std		UfoErase1
						ldb		UfoEraseBytes1
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				ldx		#DoubleBlackBlock
						tstb
						lbmi	PartialLeft?
						bne		PartialRight?
						ldd		#DoubleBlackBlock
						pshu	x,d
						leau	UfoSBLineUp,u
						pshu	x,d
						leau	UfoSBLineUp,u
						pshu	x,d
						leau	UfoSBLineUp,u
						pshu	x,d
						leau	UfoSBLineUp,u
						pshu	x,d
						leau	UfoSBLineUp,u
						pshu	x,d
						leau	UfoSBLineUp,u
						pshu	x,d
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts
PartialRight?			lda		#BlackBlock
						cmpb	#3
						beq		SixFiveRight?
						cmpb	#2
						beq		FourThreeRight?
						leau	-3,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						jmp		Restore?
FourThreeRight?			leau	-2,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						jmp		Restore?
SixFiveRight?			leau	-1,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						jmp		Restore?
PartialLeft?			lda		#BlackBlock
						cmpb	#-3
						beq		SixFiveLeft?
						cmpb	#-2
						beq		FourThreeLeft?
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						leau	UfoSBLineUpTwoOne,u
						pshu	a
						jmp		Restore?
FourThreeLeft?			pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						leau	UfoSBLineUpFourThree,u
						pshu	x
						jmp		Restore?
SixFiveLeft?			pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
						leau	UfoSBLineUpSixFive,u
						pshu	a,x
Restore?				lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move the UFO on current work screen
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveUfo					lda     UfoActive
						bne		Move?
						rts
Move?					ldd		UfoXvelocity
						addd	UfoXpos
						std		UfoXpos
						cmpa	#UfoGoneLeft
						bge		CheckRight?
						clr		UfoActive
						rts
CheckRight?				cmpa	#UfoGoneRight
						ble		Exit?
						clr		UfoActive
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add the UFO
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddUfo
						lda		Level
						cmpa	#$01
						bhs		Next?
						rts
Next?					lda		UfoActive
						beq		CheckCount?
						rts
CheckCount?				lda		LastUfoLsb
						deca
						beq		Msb?
						sta		LastUfoLsb
						rts
Msb?					lda		LastUfoMsb
						deca
						beq		UfoChance?
						sta		LastUfoMsb
SetUfoPauseLsbCounterDown
						lda		#$FF
						sta		LastUfoLsb
						rts
UfoChance?				jsr		Random
SetUfoChance			cmpa	#$00
						bls		Add?
						rts
Add?					inc		UfoActive
						lda		BaseXpos
						cmpa	#ScreenXMiddle
						blo		Right?
						ldd		#UfoStartLeft
						std		UfoXpos
						ldd		#UfoVelRight
						bra		Done?
Right?					ldd		#UfoStartRight
						std		UfoXpos
						ldd		#UfoVelLeft
Done?					std		UfoXvelocity
SetUfoPauseMsbCounter1	lda		#$00
						sta		LastUfoMsb
						lda		#$FF
						sta		LastUfoLsb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize the UFO
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeUfos
						ldd		#$0000
						std		UfoXpos
						stb		UfoActive
						std		UfoXvelocity
						std		UfoErase1
						std		UfoErase2
						ldx		#UfoMinWait
						lda		3,x
						sta		LastUfoMsb
						lda		#$FF
						sta		LastUfoLsb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ufo Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UfoData
UfoDataEven
						fcb		$C5,$CF,$CF,$CF
						fcb		$C5,$C5,$C5,$C5
						fcb		$C5,$CF,$CF,$CF
						fcb		$C0,$C5,$CF,$C0
						fcb		$C0,$CF,$C5,$CA
						fcb		$C0,$CF,$C5,$CA
						fcb		$C0,$C5,$CF,$C0
UfoDataOdd
						fcb		$CF,$CF,$CF,$CA
						fcb		$CA,$CA,$CA,$CA
						fcb		$CF,$CF,$CF,$CA
						fcb		$C0,$CF,$CA,$C0
						fcb		$C5,$CA,$CF,$C0
						fcb		$C5,$CA,$CF,$C0
						fcb		$C0,$CF,$CA,$C0


