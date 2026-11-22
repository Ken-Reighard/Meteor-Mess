;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Score Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NameEntry				fcn		"        "
Marker					fcc		"MM"
Name1					fcn		"        "
Name2					fcn		"        "
Name3					fcn		"        "

HighScore1				fcb		$00,$00,$00,$00
HighScore1End

HighScore2				fcb		$00,$00,$00,$00
HighScore2End

HighScore3				fcb		$00,$00,$00,$00
HighScore3End

Score					fcb		$00,$00,$00,$00
ScoreEnd

PeakScore				fcb		$00,$00,$00,$00
PeakScoreEnd

ExtraScore				fcb		$00,$00,$10,$00
ExtraScoreEnd

ExtraScoreInc			fcb		$00,$00,$10,$00
ExtraScoreIncEnd

LevelThreshTable
						rmb		16


						fdb		0
SetBigRockHitPoints		rmb		2
BigRockHitPoints

						fdb		0
SetSmallRockHitPoints	rmb		2
SmallRockHitPoints

						fdb		0
SetSpinnerHitPoints		rmb		2
SpinnerHitPoints

						fdb		0
SetPulsarHitPoints		rmb		2
PulsarHitPoints

						fdb		0
SetUfoHitPoints			rmb		2
UfoHitPoints


						fdb		$9999
SetBigRockLandPoints	rmb		2
BigRockLandPoints

						fdb		$9999
SetSmallRockLandPoints	rmb		2
SmallRockLandPoints

						fdb		$9999
SetBaseHitPoints		rmb		2
BaseHitPoints

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if we went up a level
; Uses: a,b,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckLevelUp			ldb		Level
						cmpb	#$04
						bne		Check?
						rts
Check?					ldx		#Score
						ldu		#LevelThreshTable
						lslb
						lslb
						leau	b,u
						bsr		Compare
						bpl		UpLevel?
						rts
UpLevel?				inc		Level
						jsr		SetLevelData
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if we went down a level
; Uses: a,b,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckLevelDown			ldb		Level
						bne		Check?
						rts
Check?					decb
						ldx		#Score
						ldu		#LevelThreshTable
						lslb
						lslb
						leau	b,u
						bsr		Compare
						bmi		DownLevel?
						rts
DownLevel?				dec		Level
						jsr		SetLevelData
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle a lost life
; Uses: a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoseLife
						lda		Lives
						adda	#$99
						daa
						sta		Lives
						lda		#$02
						sta		UpdateLives
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Compare two scores
; pass score to compare in x
; pass score to compare to in u
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Compare
						lda		#4
Loop?
						ldb		,x+
						cmpb	,u+
						bhi		Greater?
						blo		Smaller?
						deca
						bne		Loop?
						clra
						rts
Greater?
						lda		#1
						rts
Smaller?
						lda		#-1
						rts
NewPeak
						ldx		#Score
						ldu		#PeakScore
						bsr		Compare
						cmpa	#1
						beq		Copy?
						rts
Copy?					ldx		#Score
						ldu		#PeakScore
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check for award of an extra life
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XtraLife
						ldx		#Score
						ldu		#ExtraScore
						bsr		Compare
						cmpa	#1
						beq		Add?
						rts
Add?					lda		Lives
						inca
						daa
						bcs		Ceiling?
						bra		Store?
Ceiling?				lda		#$99
Store?					sta		Lives
						lda		#$02
						sta		UpdateLives
						ldu		#ExtraScoreEnd
						ldx		#ExtraScoreIncEnd
						bsr		DoArith
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add to the score
; Points to add pointed by x
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddToScore
						pshs	b,x,u
						ldu		#ScoreEnd
						bsr		DoArith
						bsr		DisplayScore
						jsr		CheckLevelUp
						bsr		NewPeak
						bsr		XtraLife
						lda		#$02
						sta		UpdateScore
						puls	b,x,u,pc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subtract from the score
; Points to subtract pointed by x
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubtractScore
						pshs	b,x,u
						ldu		#ScoreEnd
						bsr		DoArith
						bcs		Level?
						ldu		#Score
						ldd		#$0000
						std		,u
						std		2,u
Level?					jsr		CheckLevelDown
						lda		#$02
						sta		UpdateScore
						puls	b,x,u,pc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles to math
; Value to add/subtract end pointed to by x
; Value to update end pointed to by u
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoArith
						ldb		#$04
						andcc	#$FE          	; clear Carry first
LoopAdd?
						lda		,-x           	; get byte from first number
						adca	,-u           	; add byte from second + carry
						daa		            	; decimal adjust
						sta		,u				; store result
						decb
						bne		LoopAdd?
						rts						; Carry flag contains final carry-out


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display the score
; Uses: a,b,y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DisplayScore
SetScoreLoc				ldx		#Score							; set address to BCD score

StartScoreDraw			clr		TempByte0
						ldy		#4								; get the score length
						clrb									; b is the digit position
NextByte?				lda		,x								; get the first 2 BCD digits
						lsra									; divide by 16
						lsra									; for the MSD
						lsra
						lsra
						bsr		HandleDigit
						incb									; move to next position for digit
						cmpy	#$01
						bne		Reload?
						inc		TempByte0
Reload?					lda		,x+								; get the 2 digits again, then incremnt the pointer
						anda	#$0F							; get the LSD
						bsr		HandleDigit
						incb									; move to next position for digit
						leay	-1,y
						bne		NextByte?						; if not done loop again
						rts

HandleDigit				tst		TempByte0
						bne		DrawDigit?
						tsta
						bne		NotZero?
						lda		#$0A
						bra		DrawDigit?
NotZero?				inc		TempByte0
DrawDigit?				pshs	b
						bsr		DrawNumber						; draw that digit
						puls	b
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display the lives
; Uses: a,b,y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DisplayLives			clr		TempByte0
						ldb		#$0C							; b is the digit position
						ldx		#Lives							; set address to BCD score
NextByte?				lda		,x								; get the first 2 BCD digits
						lsra									; divide by 16
						lsra									; for the MSD
						lsra
						lsra
						bsr		HandleDigit
						incb									; move to next position for digit
						inc		TempByte0
Reload?					lda		,x+								; get the 2 digits again, then incremnt the pointer
						anda	#$0F							; get the LSD
						bsr		HandleDigit
						incb									; move to next position for digit
						rts

