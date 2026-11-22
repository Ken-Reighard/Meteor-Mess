;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Base Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PulsarXOffset			equ		$02
PulsarYOffset			equ		$03
PulsarBottom			equ		$54
PulsarLeft				equ		$02
PulsarRight				equ		$3D
PulsarLeftSet			equ		PulsarLeft*$0100
PulsarRightSet			equ		PulsarRight*$0100
PulsarFrameCountStart	equ		$02
LastPulsarCounter		equ		$14
PulsarYStart			equ		$0300
PulsarXStartAnd			equ		$1F
PulsarXStartSub			equ		$0F00
PulsarVelocityDown		equ		$0200
PulsarVelocityRight		equ		$0080
PulsarVelocityLeft		equ		-PulsarVelocityRight
PulsarFrameMask			equ		$03

PulsarSBLineUp			equ		-29

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a Pulsar on current work screen
; Uses: a,b,x,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPulsar
						lda     PulsarActive
						bne		CheckFrame?
						rts
CheckFrame?				lda		PulsarFrameCounter
						beq		NextFrame?
						deca
						sta		PulsarFrameCounter
						bra		ProcessPulsar?
NextFrame?				lda		PulsarFrame
						inca
						anda	#PulsarFrameMask
						sta		PulsarFrame
						lda		#PulsarFrameCountStart
						sta		PulsarFrameCounter
ProcessPulsar?			ldu		WorkScreen
						lda		PulsarXpos
						adda	#PulsarXOffset
						ldb		PulsarYpos
						addb	#PulsarYOffset
						jsr		FindAddessOffset
						leau	d,u
						lda		WorkNumber
						beq		Work0?
						stu		PulsarErase2
						bra		OffInt?
Work0?					stu		PulsarErase1
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
						sts		SaveSp
						lds		#PulsarFrameTable
						lda		PulsarFrame
						lsla
						lsla
						ldb		PulsarXpos
						lsrb
						bcc		Even?
						adda	#$02
Even?					lds		a,s
Start?					puls	a,x
						pshu	a,x
						leau	PulsarSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	PulsarSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	PulsarSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	PulsarSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	PulsarSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	PulsarSBLineUp,u
						puls	a,x
						pshu	a,x
Restore?				lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase a Pulsar on current work screen
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ErasePulsar				lda		WorkNumber
						beq		Erase1?
Erase2?					ldu		PulsarErase2
						bne		ClearErase2?
						rts
ClearErase2?			ldd		#$0000
						std		PulsarErase2
						bra		OffInt?
Erase1?					ldu		PulsarErase1
						bne		ClearErase1?
						rts
ClearErase1?			ldd		#$0000
						std		PulsarErase1
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				lda		#BlackBlock
						ldx		#DoubleBlackBlock
						pshu	a,x
						leau	PulsarSBLineUp,u
						pshu	a,x
						leau	PulsarSBLineUp,u
						pshu	a,x
						leau	PulsarSBLineUp,u
						pshu	a,x
						leau	PulsarSBLineUp,u
						pshu	a,x
						leau	PulsarSBLineUp,u
						pshu	a,x
						leau	PulsarSBLineUp,u
						pshu	a,x
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a Pulsar on current work screen
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MovePulsar
						lda     PulsarActive
						bne		Move?
						rts
Move?					ldd		PulsarYpos
						addd	#PulsarVelocityDown
						std		PulsarYpos
						cmpa	#PulsarBottom
						blo		XVel?
						clr		PulsarActive
SetPulsarPauseCounterMsb
						lda		#$00
						sta		LastPulsarMsb
						lda		#$FF
						sta		LastPulsarLsb
						clr		SoundControl
						rts
XVel?					ldd		PulsarXvelocity
						addd	PulsarXpos
						std		PulsarXpos
						cmpa	#PulsarLeft
						blo		LeftBorder?
						cmpa	#PulsarRight
						bhi		RightBorder?
						bra		AdjustXvelocity?
LeftBorder?				ldd		#PulsarLeftSet
						std		PulsarXpos
						ldd		#PulsarVelocityRight
						std		PulsarXvelocity
						rts
RightBorder?			ldd		#PulsarRightSet
						std		PulsarXpos
						ldd		#PulsarVelocityLeft
						std		PulsarXvelocity
						rts
AdjustXvelocity?		lda		BaseXpos
						suba	PulsarXpos
						asra
						asra
						bmi		GoLeft?
						beq		GoDown?
						ldd		#PulsarVelocityRight
						bra		Exit?
GoLeft?					ldd		#PulsarVelocityLeft
						bra		Exit?
GoDown?					ldd		PulsarXvelocity
						negb
Exit?					std		PulsarXvelocity
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a Pulsar on current work screen
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddPulsar
						lda		PulsarActive
						beq		Spinner?
						rts
Spinner?				lda		SpinnerCountCurrent
						beq		CheckDelay?
						rts
CheckDelay?				lda		LastPulsarMsb
						beq		PulsarChance?
						lda		LastPulsarLsb
						deca
						beq		Msb?
						sta		LastPulsarLsb
						rts
Msb?					lda		LastPulsarMsb
						deca
						beq		PulsarChance?
						sta		LastPulsarMsb
SetPulsarPauseLsbCounterDown
						lda		#$FF
						sta		LastPulsarLsb
						rts
PulsarChance?			jsr		Random
SetPulsarChance			cmpa	#$00
						bls		Add?
						rts
Add?					inc		PulsarActive
						ldd		#PulsarYStart
						std		PulsarYpos
						jsr		Random
						anda	#PulsarXStartAnd
						subd	#PulsarXStartSub
						addd	BaseXpos
						cmpa	#PulsarLeft
						blt		FixLeft?
						cmpa	#PulsarRight
						bhi		FixRight?
						bra 	StoreX?
FixLeft?				ldd		#PulsarLeftSet
						bra		StoreX?
FixRight?				ldd		#PulsarRightSet
StoreX?					std		PulsarXpos
						lda		BaseXpos
						suba	PulsarXpos
						bmi		GoLeft?
						ldd		#PulsarVelocityRight
						bra		Exit?
GoLeft?					ldd		#PulsarVelocityLeft
Exit?					std		PulsarXvelocity
						jsr		TurnOnPulsarSound
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize Pulsar
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializePulsar
						ldd		#$0000
						std		PulsarXpos
						std		PulsarYpos
						std		PulsarActive
						std		PulsarErase1
						std		PulsarErase2
						sta		PulsarFrame
						lda		#PulsarFrameCountStart
						sta		PulsarFrameCounter
SetPulsarPause			lda		#$00
						sta		LastPulsarMsb
						lda		#$FF
						sta		LastPulsarLsb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pulsar Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PulsarFrameTable
						fdb		PulsarDataFrame0Even
						fdb		PulsarDataFrame0Odd
						fdb		PulsarDataFrame1Even
						fdb		PulsarDataFrame1Odd
						fdb		PulsarDataFrame2Even
						fdb		PulsarDataFrame2Odd
						fdb		PulsarDataFrame3Even
						fdb		PulsarDataFrame3Odd

PulsarData
PulsarDataFrame0Odd
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
PulsarDataFrame1Odd
						fcb		$C0,$C0,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$CF,$CA
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C0,$C0
PulsarDataFrame2Odd
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$CF,$CA
						fcb		$C5,$CF,$CF
						fcb		$C0,$CF,$CA
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
PulsarDataFrame3Odd
						fcb		$C0,$C0,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$CF,$CA
						fcb		$C0,$C5,$C0
						fcb		$C0,$C5,$C0
						fcb		$C0,$C0,$C0
PulsarDataFrame0Even
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$C0,$C0
						fcb		$C0,$C0,$C0
PulsarDataFrame1Even
						fcb		$C0,$C0,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C5,$CF,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$C0,$C0
PulsarDataFrame2Even
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C5,$CF,$C0
						fcb		$CF,$CF,$CA
						fcb		$C5,$CF,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
PulsarDataFrame3Even
						fcb		$C0,$C0,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C5,$CF,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$CA,$C0
						fcb		$C0,$C0,$C0
