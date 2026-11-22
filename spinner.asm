;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Spinner Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Spinners
Spinner0					Spinner
Spinner1					Spinner

SpinnerLines				equ		$07
SpinnerXOffset				equ		$02
SpinnerYOffset				equ		$03
SpinnerYStart				equ		$0300
SpinnerBottom				equ		$53
SpinnerFrameMask			equ		$03
SpinnerFrameCountStart		equ		$02
SpinnerCountMax				equ		$02

SpinnerSBLineUp				equ		-29

SpinnerStartXMask			equ		$0F
SpinnerVelocityMask			equ		$0E


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update spinner frame and draw spinners
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSpinners
						lda		SpinnerFrameCounter
						beq		NextFrame?
						deca
						sta		SpinnerFrameCounter
						bra		Process?
NextFrame?				lda		SpinnerFrame
						inca
						anda	#SpinnerFrameMask
						sta		SpinnerFrame
						lda		#SpinnerFrameCountStart
						sta		SpinnerFrameCounter
Process?				ldx		#Spinner0
						lda		Spinner.Active,x
						beq		Spinner1?
						bsr		DrawSpinner
Spinner1?				ldx		#Spinner1
						lda		Spinner.Active,x
						beq		Exit?
						bra		DrawSpinner
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a Spinner on current work screen
; Pass spinner in x
; Uses: a,b,x,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSpinner
						ldu		WorkScreen
						lda		Spinner.Xpos,x
						adda	#SpinnerXOffset
						ldb		Spinner.Ypos,x
						addb	#SpinnerYOffset
						jsr		FindAddessOffset
						leau	d,u
						lda		WorkNumber
						beq		Work0?
						stu		Spinner.Erase2,x
						bra		OffInt?
Work0?					stu		Spinner.Erase1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
						sts		SaveSp
						lds		#SpinnerFrameTable
						lda		SpinnerFrame
						lsla
						lsla
						ldb		Spinner.Xpos,x
						lsrb
						bcc		Even?
						adda	#$02
Even?					lds		a,s
Start?					puls	a,x
						pshu	a,x
						leau	SpinnerSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	SpinnerSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	SpinnerSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	SpinnerSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	SpinnerSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	SpinnerSBLineUp,u
						puls	a,x
						pshu	a,x
Restore?				lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase spinners
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseSpinners
						ldx		#Spinner0
						bsr		EraseSpinner
						ldx		#Spinner1
						bsr		EraseSpinner
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase a Spinner on current work screen
; Pass Spinner in x
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseSpinner			tst		WorkNumber
						beq		Erase1?
Erase2?					ldu		Spinner.Erase2,x
						bne		ClearErase2?
						rts
ClearErase2?			clra
						clrb
						std		Spinner.Erase2,x
						bra		OffInt?
Erase1?					ldu		Spinner.Erase1,x
						bne		ClearErase1?
						rts
ClearErase1?			clra
						clrb
						std		Spinner.Erase1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				lda		#BlackBlock
						ldx		#DoubleBlackBlock
						pshu	a,x
						leau	SpinnerSBLineUp,u
						pshu	a,x
						leau	SpinnerSBLineUp,u
						pshu	a,x
						leau	SpinnerSBLineUp,u
						pshu	a,x
						leau	SpinnerSBLineUp,u
						pshu	a,x
						leau	SpinnerSBLineUp,u
						pshu	a,x
						leau	SpinnerSBLineUp,u
						pshu	a,x
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move spinners
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveSpinners
						ldx		#Spinner0
						lda		Spinner.Active,x
						beq		Spinner1?
						bsr		MoveSpinner
Spinner1?				ldx		#Spinner1
						lda		Spinner.Active,x
						beq		Exit?
						bra		MoveSpinner
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a Spinner on current work screen
; Pass MoveSpinner in x
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveSpinner
						ldd		Spinner.Yvelocity,x
						addd	Spinner.Ypos,x
						std		Spinner.Ypos,x
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a spinner
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddSpinner
						lda		PulsarActive
						beq		CheckCount?
						rts
CheckCount?				lda		SpinnerCountCurrent
SetSpinnerMax			cmpa	#$00
						bne		Next2?
						rts
Next2?					lda		LastSpinnerLsb
						deca
						beq		Msb?
						sta		LastSpinnerLsb
						rts
Msb?					lda		LastSpinnerMsb
						deca
						beq		SpinnerChance?
						sta		LastSpinnerMsb
SetSpinnerPauseLsbCounterDown
						lda		#$FF
						sta		LastSpinnerLsb
						rts
SpinnerChance?			jsr		Random
SetSpinnerChance		cmpa	#$00
						bls		FindSpinner?
						rts
FindSpinner?			ldu		#Spinners
CheckNext?				lda		Spinner.Active,u
						beq		AddSpin?
						leau	sizeof{Spinner},u
						bra		CheckNext?
AddSpin?				inc		Spinner.Active,u
						ldd		#SpinnerYStart
						std		Spinner.Ypos,u
						jsr		Random
						anda	#SpinnerStartXMask
						ldx		#SpinnerStartTable
						lda		a,x
						clrb
						std		Spinner.Xpos,u
						jsr		Random
						anda	#SpinnerVelocityMask
						ldx		#SpinnerVelocityTable
						ldd		a,x
						std		Spinner.Yvelocity,u
						inc		SpinnerCountCurrent
SetSpinnerMax2			lda		#$00
						cmpa	SpinnerCountCurrent
						beq		Reg?
						jsr		Random
Set2ndSpinnerChance		cmpa	#$00
						bhi		Reg?
						anda	#$40
						sta		LastSpinnerLsb
						lda		#$01
						sta		LastSpinnerMsb
						jsr		TurnOnSpinnerSound
						rts
SetSpinnerPauseMsbCounter
Reg?					lda		#$00
						sta		LastSpinnerMsb
						lda		#$FF
						sta		LastSpinnerLsb
						jsr		TurnOnSpinnerSound
						rts

SpinnerStartTable		fcb		$02,$04,$08,$0C,$10,$14,$18,$1C,$20,$25,$29,$2D,$31,$35,$29,$3D
SpinnerVelocityTable	rmb		16


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize spinners
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeSpinners
						ldu		#Spinners
						lda		#SpinnerCountMax
						clrb
						ldx		#$0000
NextSpinner?			stx		Spinner.Xpos,u
						stx		Spinner.Ypos,u
						stb		Spinner.Active,u
						stx		Spinner.Yvelocity,u
						stx		Spinner.Erase1,u
						stx		Spinner.Erase2,u
						deca
						bne		ToNextSpinner?
						stb		SpinnerCountCurrent
						stb		SpinnerFrameCounter
						stb		SpinnerFrame
						lda		#$01
						sta		LastSpinnerMsb
						lda		#$FF
						sta		LastSpinnerLsb
						rts
ToNextSpinner?			leau	sizeof{Spinner},u
						bra		NextSpinner?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Spinner Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpinnerFrameTable
						fdb		SpinnerDataFrame0Even
						fdb		SpinnerDataFrame0Odd
						fdb		SpinnerDataFrame1Even
						fdb		SpinnerDataFrame1Odd
						fdb		SpinnerDataFrame2Even
						fdb		SpinnerDataFrame2Odd
						fdb		SpinnerDataFrame3Even
						fdb		SpinnerDataFrame3Odd

SpinnerData
SpinnerDataFrame0Even
						fcb		$C5,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CF,$CA
						fcb		$C0,$CA,$CA
						fcb		$C0,$CF,$CA
						fcb		$C0,$C0,$CA
						fcb		$C0,$C0,$CF
SpinnerDataFrame1Even
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
						fcb		$C0,$CF,$CA
						fcb		$C5,$CA,$CF
						fcb		$C0,$CF,$CA
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
SpinnerDataFrame2Even
						fcb		$C0,$C0,$CF
						fcb		$C0,$C0,$CA
						fcb		$C0,$CF,$CA
						fcb		$C0,$CA,$CA
						fcb		$C0,$CF,$CA
						fcb		$C0,$CA,$C0
						fcb		$C5,$CA,$C0
SpinnerDataFrame3Even
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$CF,$CA
						fcb		$C0,$CA,$CA
						fcb		$C0,$CF,$CA
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
SpinnerDataFrame0Odd
						fcb		$CF,$C0,$C0
						fcb		$C5,$C0,$C0
						fcb		$C5,$CF,$C0
						fcb		$C5,$C5,$C0
						fcb		$C5,$CF,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$CA
SpinnerDataFrame1Odd
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
						fcb		$C5,$CF,$C0
						fcb		$CF,$C5,$CA
						fcb		$C5,$CF,$C0
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
SpinnerDataFrame2Odd
						fcb		$C0,$C5,$CA
						fcb		$C0,$C5,$C0
						fcb		$C5,$CF,$C0
						fcb		$C5,$C5,$C0
						fcb		$C5,$CF,$C0
						fcb		$C5,$C0,$C0
						fcb		$CF,$C0,$C0
SpinnerDataFrame3Odd
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C5,$CF,$C0
						fcb		$C5,$C5,$C0
						fcb		$C5,$CF,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0


