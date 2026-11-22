;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Base Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseLines					equ		$07
BaseXOffset					equ		$02
BaseYOffset					equ		$03
BaseYPos					equ		$53
BaseYPosSet					equ		BaseYPos*$0100
BaseYPosDraw				equ		BaseYPos+BaseYOffset
BaseLeft					equ		$02
BaseRight					equ		$3D
BaseLeftPosSet				equ		BaseLeft*$0100
BaseRightPosSet				equ		BaseRight*$0100
BaseStart					equ		$2000
BaseRightVel				equ		$0080
BaseLeftVel					equ		-BaseRightVel
BaseRightDblVel				equ		BaseRightVel*2
BaseLeftDblVel				equ		BaseLeftVel*2

BaseSBLineUp				equ		-29

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the base on current work screen
; Uses: a,b,x,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBase
						ldu		WorkScreen							; get work screen
						lda		BaseXpos							; Get x position
						adda	#BaseXOffset						; add x offset
						ldb		#BaseYPosDraw						; Get y position
						jsr		FindAddessOffset					; get address offset
						leau	d,u									; get address to place rock
						lda		WorkNumber							; get work screen
						beq		Work0?								; if screen 1
						stu		BaseErase2							; store erase for screen 2
						bra		OffInt?								; find frame
Work0?					stu		BaseErase1							; store erase for screen 1
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
CheckOdd?				sts		SaveSp
						lda		BaseXpos							; Get X position
						lsra										; Check for odd
						bcc		Even?
						lds		#BaseDataOdd
						bra		Start?
Even?					lds		#BaseDataEven
Start?					puls	a,x
						pshu	a,x
						leau	BaseSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	BaseSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	BaseSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	BaseSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	BaseSBLineUp,u
						puls	a,x
						pshu	a,x
						leau	BaseSBLineUp,u
						puls	a,x
						pshu	a,x
Restore?				lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase the base on current work screen
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBase
						lda		WorkNumber				; find current work screen
						beq		Erase1?					; Is screen 1
Erase2?					ldu		BaseErase2				; set screen 2
						bne		ClearErase2?			; if address is 0 nothing to erase
						rts
ClearErase2?			ldd		#$0000					; clear
						std		BaseErase2				; buffer
						bra		OffInt?					; go start erasing
Erase1?					ldu		BaseErase1				; set screen 1
						bne		ClearErase1?			; if address is 0 nothing to erase
						rts
ClearErase1?			ldd		#$0000					; clear
						std		BaseErase1				; buffer
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				lda		#BlackBlock				; load black block for erasing
						ldx		#DoubleBlackBlock		; load black block for erasing
						pshu	a,x
						leau	BaseSBLineUp,u
						pshu	a,x
						leau	BaseSBLineUp,u
						pshu	a,x
						leau	BaseSBLineUp,u
						pshu	a,x
						leau	BaseSBLineUp,u
						pshu	a,x
						leau	BaseSBLineUp,u
						pshu	a,x
						leau	BaseSBLineUp,u
						pshu	a,x
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move the base on current work screen
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveBase				ldd		BaseXvelocity
						addd	BaseXpos
						std		BaseXpos
						cmpa	#BaseLeft
						blo		ClearLeft?
						cmpa	#BaseRight
						bhi		ClearRight?
						rts
ClearLeft?				ldd		#BaseLeftPosSet
						std		BaseXpos
						ldd		#$0000
						std		BaseXvelocity
						rts
ClearRight?				ldd		#BaseRightPosSet
						std		BaseXpos
						ldd		#$0000
						std		BaseXvelocity
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize the base
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeBase
						ldd		#BaseStart
						std		BaseXpos
						ldd		#$0000
						std		BaseXvelocity
						std		BaseErase1
						std		BaseErase2
						sta		BaseSpeedState
						sta		BaseSpeedSwitchState
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set environment when the base is hit and explodes
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseExplodes
						clra
						sta		BigRock0.Active				; Clear all the objects
						sta		BigRock1.Active
						sta		BigRock2.Active
						sta		BigRock3.Active
						sta		BigRockCountCurrent
						sta		SmallRock0.Active
						sta		SmallRock1.Active
						sta		SmallRock2.Active
						sta		SmallRock3.Active
						sta		SmallRock4.Active
						sta		SmallRock5.Active
						sta		SmallRock6.Active
						sta		SmallRock7.Active
						sta		SmallRock8.Active
						sta		SmallRock9.Active
						sta		SmallRockA.Active
						sta		SmallRockCountCurrent
						sta		Shot0.Active
						sta		Shot1.Active
						sta		ShotCountCurrent
						sta		Spinner0.Active
						sta		Spinner1.Active
						sta		SpinnerCountCurrent
						sta		Shot0.Active
						sta		Shot1.Active
						sta		ShotCountCurrent
						sta		Bomb0.Active
						sta		Bomb1.Active
						sta		BombCountCurrent
						sta		UfoActive
						sta		PulsarActive
						jsr		SetScreensTopRed		; turn screens red
						jsr		BaseExpodesAddRocks		; add the small rocks for expolsion
						ldd		#$BFBF
						std		SmallRockEraseBlock+1	; erase with red
						lda		#$80
						sta		DrawMountain+1			; Change mountain color to black
						jsr		DrawMountain
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Did spinner land
; Spinner is passed in x
; b is set to non zero if spinner has landed
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpinnerLands
						lda		Spinner.Active,x
						bne		CheckLand?
						rts
CheckLand?				lda		Spinner.Ypos,x
						cmpa	#SpinnerBottom
						bhs		Splode?
						rts
Splode?
						incb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if there is a collision with the base
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseCollision
						clrb
						ldx		#Spinner0
						bsr		SpinnerLands
						ldx		#Spinner1
						bsr		SpinnerLands
						ldx		#BigRock0
						bsr		BaseBigRockCollision
						ldx		#BigRock1
						bsr		BaseBigRockCollision
						ldx		#BigRock2
						bsr		BaseBigRockCollision
						ldx		#BigRock3
						bsr		BaseBigRockCollision
						ldx		#SmallRock0
						bsr		BaseSmallRockCollision
						ldx		#SmallRock1
						bsr		BaseSmallRockCollision
						ldx		#SmallRock2
						bsr		BaseSmallRockCollision
						ldx		#SmallRock3
						bsr		BaseSmallRockCollision
						ldx		#SmallRock4
						bsr		BaseSmallRockCollision
						ldx		#SmallRock5
						bsr		BaseSmallRockCollision
						ldx		#SmallRock6
						bsr		BaseSmallRockCollision
						ldx		#SmallRock7
						bsr		BaseSmallRockCollision
						ldx		#SmallRock8
						bsr		BaseSmallRockCollision
						ldx		#SmallRock9
						bsr		BaseSmallRockCollision
						ldx		#SmallRockA
						bsr		BaseSmallRockCollision
						ldx		#Bomb0
						bsr		BaseBombCollision
						ldx		#Bomb1
						bsr		BaseBombCollision
						jsr		BasePulsarCollision
						tstb									; was there any collision?
						bne		Splode?
						rts
Splode?					pshs	b,u
						ldx		#BaseHitPoints
						jsr		SubtractScore
						puls	b,u
						jsr		TurnOnBaseHitSound
						jsr		BaseExplodes
						lda		#GameStateExpolsion
						sta		GameState
						jsr		LoseLife
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if there is a collision with the base and big rock
; Pass big rock in x
; b is non zero if collision
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseBigRockCollision
						lda		BigRock.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		BigRock.Ypos,x
						suba	#BaseYPos
						jsr		AbsoluteValue
						cmpa	#$06
						bls		CheckX?
						rts
CheckX?					lda		BigRock.Xpos,x
						suba	BaseXpos
						jsr		AbsoluteValue
						cmpa	#$05
						bls		Splode?
						rts
Splode?
						incb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if there is a collision with the base and small rock
; Pass small rock in x
; b is non zero if collision
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseSmallRockCollision
						lda		SmallRock.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		SmallRock.Ypos,x
						suba	#BaseYPos
						jsr		AbsoluteValue
						cmpa	#$04
						bls		CheckX?
						rts
CheckX?					lda		SmallRock.Xpos,x
						suba	BaseXpos
						jsr		AbsoluteValue
						cmpa	#$03
						bls		Splode?
						rts
Splode?
						incb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if there is a collision with the base and bomb
; Pass bomb in x
; b is non zero if collision
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseBombCollision
						lda		Bomb.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		Bomb.Ypos,x
						suba	#BaseYPos
						jsr		AbsoluteValue
						cmpa	#$03
						bls		CheckX?
						rts
CheckX?					lda		Bomb.Xpos,x
						suba	BaseXpos
						jsr		AbsoluteValue
						cmpa	#$02
						bls		Splode?
						rts
Splode?
						incb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if there is a collision with the base and pulsar
; b is non zero if collision
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BasePulsarCollision
						lda		PulsarActive
						bne		CheckCollision?
						rts
CheckCollision?			lda		PulsarYpos
						suba	#BaseYPos
						jsr		AbsoluteValue
						cmpa	#$05
						bls		CheckX?
						rts
CheckX?					lda		PulsarXpos
						suba	BaseXpos
						jsr		AbsoluteValue
						cmpa	#$04
						bls		Splode?
						rts
Splode?
SetPulsarPauseCounterMsbBase
						lda		#$00
						sta		LastPulsarMsb
						lda		#$FF
						sta		LastPulsarLsb
						incb
						rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseData
BaseDataOdd				fcb		$F5,$F5,$F5
						fcb		$F5,$FF,$FF
						fcb		$F0,$FA,$FA
						fcb		$F0,$FA,$FA
						fcb		$F5,$F5,$F5
						fcb		$F0,$F5,$F0
						fcb		$F0,$F5,$F0
BaseDataEven			fcb		$FA,$FA,$FA
						fcb		$FF,$FF,$FA
						fcb		$F5,$F5,$F0
						fcb		$F5,$F5,$F0
						fcb		$FA,$FA,$FA
						fcb		$F0,$FA,$F0
						fcb		$F0,$FA,$F0
