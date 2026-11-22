;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shot Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Shots
Shot0						Shot
Shot1						Shot

ShotLines					equ		$07
ShotYOffset					equ		$02
ShotTop						equ		$02
ShotCountMax				equ		$02
LastShotCounter				equ		$12

ShotSBOffset				equ		129
ShotSBLineUp				equ		-31

ShotEven					equ		$CA
ShotOdd						equ		$C5

ShotYstart					equ		$4D00
ShotVelocity				equ		-$0300

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw shots on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawShots
						ldx		#Shot0
						bsr		DrawShot
						ldx		#Shot1
						bsr		DrawShot
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a Shot on current work screen
; Pass Shot in x
; Uses: a,b,x,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawShot				lda     Shot.Active,x
						bne		ProcessShot?
						rts
ProcessShot?			ldu		WorkScreen
						lda		Shot.Xpos,x
						ldb		Shot.Ypos,x
						addb	#ShotYOffset
						jsr		FindAddessOffset
						leau	d,u
						tst		WorkNumber
						beq		Work0?
						stu		Shot.Erase2,x
						bra		OffInt?
Work0?					stu		Shot.Erase1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
						ldb		Shot.Xpos,x
						lsrb
						bcc		Even?
						lda		#ShotOdd
						bra		Start?
Even?					lda		#ShotEven
Start?					pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
Restore?				lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase shots on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseShots
						ldx		#Shot0
						bsr		EraseShot
						ldx		#Shot1
						bsr		EraseShot
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase a Shot on current work screen
; Pass Shot in x
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseShot				lda		WorkNumber				; find current work screen
						beq		Erase1?					; Is screen 1
Erase2?					ldu		Shot.Erase2,x			; set screen 2
						bne		ClearErase2?			; if address is 0 nothing to erase
						rts
ClearErase2?			ldd		#$0000					; erase
						std		Shot.Erase2,x			; buffer
						bra		OffInt?					; go start erasing
Erase1?					ldu		Shot.Erase1,x			; set screen 1
						bne		ClearErase1?			; if address is 0 nothing to erase
						rts
ClearErase1?			ldd		#$0000					; erase
						std		Shot.Erase1,x			; buffer
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				lda		#BlackBlock				; load black block for erasing
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						leau	ShotSBLineUp,u
						pshu	a
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move shots
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveShots
						ldx		#Shot0
						bsr		MoveShot
						ldx		#Shot1
						bsr		MoveShot
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a Shot on current work screen
; Pass shot in x
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveShot				lda     Shot.Active,x
						bne		ProcessShot?
						rts
ProcessShot?			ldd		Shot.Yvelocity,x
						addd	Shot.Ypos,x
						cmpa	#ShotTop
						bge		Ok?
						dec		ShotCountCurrent
						clr		Shot.Active,x
						rts
Ok?						std		Shot.Ypos,x
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add shots
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddShots
						lda		LastShot
						beq		CheckCount?
						dec		LastShot
						rts
CheckCount?				lda		ShotCountCurrent
						cmpa	#ShotCountMax
						bne		Request?
						rts
Request?				lda		RequestShot
						bne		FindShot?
						rts
FindShot?				ldu		#Shots
CheckNext?				lda		Shot.Active,u
						beq		AddShot?
						leau	sizeof{Shot},u
						bra		CheckNext?
AddShot?				inc		Shot.Active,u
						ldd		#ShotYstart
						std		Shot.Ypos,u
						ldd		BaseXpos
						std		Shot.Xpos,u
						ldd		#ShotVelocity
						std		Shot.Yvelocity,u
						inc		ShotCountCurrent
						lda		#LastShotCounter
						sta		LastShot
SetAutoFire1			lda		#$00
						sta		RequestShot
						jsr		TurnOnShootSound
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Iitialize shots
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeShots
						ldu		#Shots
						lda		#ShotCountMax
						clrb
						ldx		#$0000
NextShot?				stx		Shot.Xpos,u
						stx		Shot.Ypos,u
						stx		Shot.Active,u
						stx		Shot.Yvelocity,u
						stx		Shot.Erase1,u
						stx		Shot.Erase2,u
						deca
						bne		ToNextShot?
						stb		ShotCountCurrent
SetAutoFire2			lda		#$00
						sta		RequestShot
						rts
ToNextShot?				leau	sizeof{Shot},u
						bra		NextShot?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shots for a collision
; Uses: u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotCollisions
						ldu		#Shot0
						bsr		ShotCollision
						ldu		#Shot1
						bsr		ShotCollision
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a collision
; Shot passed in u
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotCollision
						lda		Shot.Active,u
						bne		SmallRock?
						rts
SmallRock?				clrb								; b checks for collision
						ldx		#SmallRock0
						bsr		ShotSmallRockCollision
						ldx		#SmallRock1
						bsr		ShotSmallRockCollision
						ldx		#SmallRock2
						bsr		ShotSmallRockCollision
						ldx		#SmallRock3
						bsr		ShotSmallRockCollision
						ldx		#SmallRock4
						bsr		ShotSmallRockCollision
						ldx		#SmallRock5
						bsr		ShotSmallRockCollision
						ldx		#SmallRock6
						bsr		ShotSmallRockCollision
						ldx		#SmallRock7
						bsr		ShotSmallRockCollision
						ldx		#SmallRock8
						bsr		ShotSmallRockCollision
						ldx		#SmallRock9
						bsr		ShotSmallRockCollision
						ldx		#SmallRockA
						bsr		ShotSmallRockCollision
						ldx		#BigRock0
						bsr		ShotBigRockCollision
						ldx		#BigRock1
						bsr		ShotBigRockCollision
						ldx		#BigRock2
						bsr		ShotBigRockCollision
						ldx		#BigRock3
						bsr		ShotBigRockCollision
						ldx		#Spinner0
						jsr		ShotSpinnerCollision
						ldx		#Spinner1
						jsr		ShotSpinnerCollision
						ldx		#Bomb0
						jsr		ShotBombCollision
						ldx		#Bomb1
						jsr		ShotBombCollision
						jsr		ShotPulsarCollision
						jsr		ShotUfoCollision
						tstb								; if b nonzero, collision
						beq		Exit?
						clr		Shot.Active,u
						dec		ShotCountCurrent
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a small rock collision
; Shot passed in u
; Small rock passed in x
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotSmallRockCollision
						lda		SmallRock.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		SmallRock.Xpos,x
						suba	Shot.Xpos,u
						jsr		AbsoluteValue
						cmpa	#$01
						bls		CheckY?
						rts
CheckY?					lda		SmallRock.Ypos,x
						suba	Shot.Ypos,u
						jsr		AbsoluteValue
						cmpa	#$03
						bls		Splode?
						rts
Splode?
						clr		SmallRock.Active,x
						dec		SmallRockCountCurrent
						incb
						pshs	b,u
						ldx		#SmallRockHitPoints
						jsr		AddToScore
						jsr		TurnOnRockHitSound
						puls	b,u
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a big rock collision
; Shot passed in u
; Big rock passed in x
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotBigRockCollision
						lda		BigRock.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		BigRock.Xpos,x
						suba	Shot.Xpos,u
						jsr		AbsoluteValue
						cmpa	#$03
						bls		CheckY?
						rts
CheckY?					lda		BigRock.Ypos,x
						suba	Shot.Ypos,u
						jsr		AbsoluteValue
						cmpa	#$05
						bls		Splode?
						rts
Splode?
						clr		BigRock.Active,x
						dec		BigRockCountCurrent
						jsr		AddExplodeSmallRocks
						incb
						pshs	b,u
						ldx		#BigRockHitPoints
						jsr		AddToScore
						jsr		TurnOnRockHitSound
						puls	b,u
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a spinner collision
; Shot passed in u
; Spinner passed in x
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotSpinnerCollision
						lda		Spinner.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		Spinner.Xpos,x
						suba	Shot.Xpos,u
						jsr		AbsoluteValue
						cmpa	#$02
						bls		CheckY?
						rts
CheckY?					lda		Spinner.Ypos,x
						suba	Shot.Ypos,u
						jsr		AbsoluteValue
						cmpa	#$04
						bls		Splode?
						rts
Splode?
						clr		Spinner.Active,x
						dec		SpinnerCountCurrent
						bne		S2?
						clr		SoundControl
S2?						incb
						pshs	b,u
						ldx		#SpinnerHitPoints
						jsr		AddToScore
						puls	b,u
SetSpinnerPauseMsbCounterShot
						lda		#$00
						sta		LastUfoMsb
						lda		#$FF
						sta		LastUfoLsb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a bomb collision
; Shot passed in u
; Bomb rock passed in x
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotBombCollision
						lda		Bomb.Active,x
						bne		CheckCollision?
						rts
CheckCollision?			lda		Bomb.Xpos,x
						suba	Shot.Xpos,u
						beq		CheckY?
						rts
CheckY?					lda		Bomb.Ypos,x
						suba	Shot.Ypos,u
						jsr		AbsoluteValue
						cmpa	#$02
						bls		Splode?
						rts
Splode?
						clr		Bomb.Active,x
						dec		BombCountCurrent
						incb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a pulsar collision
; Shot passed in u
; Pulsar passed in x
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotPulsarCollision
						lda		PulsarActive
						bne		CheckCollision?
						rts
CheckCollision?			lda		PulsarXpos
						suba	Shot.Xpos,u
						jsr		AbsoluteValue
						cmpa	#$02
						bls		CheckY?
						rts
CheckY?					lda		PulsarYpos
						suba	Shot.Ypos,u
						jsr		AbsoluteValue
						cmpa	#$04
						bls		Splode?
						rts
Splode?
						clr		PulsarActive
SetPulsarPauseCounterMsbShot
						lda		#$00
						sta		LastPulsarMsb
						lda		#$FF
						sta		LastPulsarLsb
						incb
						pshs	b,u
						ldx		#PulsarHitPoints
						jsr		AddToScore
						puls	b,u
						clr		SoundControl
						rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check shot for a ufo collision
; Shot passed in u
; Ufo passed in x
; Uses a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShotUfoCollision
						lda		UfoActive
						bne		CheckCollision?
						rts
CheckCollision?			lda		UfoXpos
						suba	Shot.Xpos,u
						jsr		AbsoluteValue
						cmpa	#$03
						bls		CheckY?
						rts
CheckY?					lda		#UfoYpos
						suba	Shot.Ypos,u
						jsr		AbsoluteValue
						cmpa	#$05
						bls		Splode?
						rts
Splode?
						clr		UfoActive
						incb
						pshs	b,u,x
						ldx		#UfoHitPoints
						jsr		AddToScore
SetUfoPauseMsbCounterShot
						lda		#$00
						sta		LastUfoMsb
						lda		#$FF
						sta		LastUfoLsb
						puls	b,u,x,pc
