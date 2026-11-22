;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bomb Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BombLines					equ		$07
BombYOffset					equ		$01
BombBottom					equ		$56
BombLeft					equ		$00
BombRight					equ		$3f
BombCountMax				equ		$02
LastBombCounter				equ		$18

BombSBOffset				equ		$41
BombSBLineUp				equ		-31

BombOdd						equ		$C5
BombEven					equ		$CA

BombStartOffset				equ		$05
BombYvelocity				equ		$0180

BombCountCurrent			rmb		1

Bombs
Bomb0						Bomb
Bomb1						Bomb

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Bombs on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBombs
						lda		Bomb0.Active
						beq		Bomb1?
						ldx		#Bomb0
						bsr		DrawBomb
Bomb1?					lda		Bomb1.Active
						beq		Exit?
						ldx		#Bomb1
						bsr		DrawBomb
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a Bomb on current work screen
; Pass Bomb in x
; Uses: a,b,x,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBomb
						ldu		WorkScreen
						lda		Bomb.Xpos,x
						ldb		Bomb.Ypos,x
						addb	#BombYOffset
						jsr		FindAddessOffset
						leau	d,u
						lda		WorkNumber
						beq		Work0?
						stu		Bomb.Erase2,x
						bra		OffInt?
Work0?					stu		Bomb.Erase1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
						ldb		Bomb.Xpos,x
						lsrb
						bcc		Even?
						lda		#BombOdd
						bra		Start?
Even?					lda		#BombEven
Start?					pshu	a
						leau	BombSBLineUp,u
						pshu	a
						leau	BombSBLineUp,u
						pshu	a
Restore?				lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase the Bombs on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBombs
						ldx		#Bomb0
						bsr		EraseBomb
						ldx		#Bomb1
						bsr		EraseBomb
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase a Bomb on current work screen
; Pass Bomb in x
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBomb				lda		WorkNumber				; find current work screen
						beq		Erase1?					; Is screen 1
Erase2?					ldu		Bomb.Erase2,x			; set screen 2
						bne		ClearErase2?			; if address is 0 nothing to erase
						rts
ClearErase2?			ldd		#$0000					; erase
						std		Bomb.Erase2,x			; buffer
						bra		OffInt?					; go start erasing
Erase1?					ldu		Bomb.Erase1,x			; set screen 1
						bne		ClearErase1?			; if address is 0 nothing to erase
						rts
ClearErase1?			ldd		#$0000					; erase
						std		Bomb.Erase1,x			; buffer
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				lda		#BlackBlock				; load black block for erasing
						pshu	a
						leau	BombSBLineUp,u
						pshu	a
						leau	BombSBLineUp,u
						pshu	a
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Moves the Bombs on current work screen
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveBombs
						lda		Bomb0.Active
						beq		Bomb1?
						ldx		#Bomb0
						bsr		MoveBomb
Bomb1?					lda		Bomb1.Active
						beq		Exit?
						ldx		#Bomb1
						bsr		MoveBomb
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a Bomb on current work screen
; Pass MoveBomb in x
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveBomb
						ldd		Bomb.Yvelocity,x
						addd	Bomb.Ypos,x
						std		Bomb.Ypos,x
						cmpa	#BombBottom
						blo		Exit?
						clr		Bomb.Active,x
						dec		BombCountCurrent
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a bomb
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddBombs
						lda		UfoActive
						bne		Level?
						rts
Level?					lda		Level
						cmpa	#$02
						bhs		Last?
						rts
Last?					lda		LastBomb
						beq		CheckCount?
						dec		LastBomb
						rts
CheckCount?				lda		BombCountCurrent
						cmpa	#BombCountMax
						bne		FindBomb?
						rts
FindBomb?				ldu		#Bombs
CheckNext?				lda		Bomb.Active,u
						beq		AddBomb?
						leau	sizeof{Bomb},u
						bra		CheckNext?
AddBomb?				lda		UfoXpos
						cmpa	#UfoEdgeLeft
						blt		Exit?
						cmpa	#UfoEdgeRight
						bgt		Exit?
						sta		Bomb.Xpos,u
						inc		Bomb.Active,u
						lda		#UfoYpos
						adda	#BombStartOffset
						clrb
						std		Bomb.Ypos,u
						lda		UfoXpos
						sta		Bomb.Xpos,u
						ldd		#BombYvelocity
						std		Bomb.Yvelocity,u
						inc		BombCountCurrent
						lda		#LastBombCounter
						sta		LastBomb
						jsr		TurnOnBombSound
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a bomb
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeBombs
						ldu		#Bombs
						lda		#BombCountMax
						ldx		#$0000
NextBomb?				stx		Bomb.Xpos,u
						stx		Bomb.Ypos,u
						stx		Bomb.Active,u
						stx		Bomb.Yvelocity,u
						stx		Bomb.Erase1,u
						stx		Bomb.Erase2,u
						deca
						bne		ToNextBomb?
						sta		BombCountCurrent
						rts
ToNextBomb?				leau	sizeof{Bomb},u
						bra		NextBomb?

