;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Title Page, High Score, and Control Text Location
; value in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MeteorOffset			equ		($04*BytesPerLine)+$08
MessOffset				equ		($16*BytesPerLine)+$0A
ByOffset				equ		($3D*BytesPerLine)+$02
PressFireOffset			equ		($16*BytesPerLine)+$0C
GameOverOffset			equ		($16*BytesPerLine)+$06
HighScoresOffset		equ		($00*BytesPerLine)+$04
ControlsOffset			equ		($00*BytesPerLine)+$06
BottomLineOffset		equ		($59*BytesPerLine)+$01
AnalogJoystickOffset	equ		($11*BytesPerLine)+$03
DigitalJoystickOffset	equ		($1D*BytesPerLine)+$03
KeyboardOffset			equ		($29*BytesPerLine)+$03
EnterNameOffset			equ		($00*BytesPerLine)+$06
AOffset					equ		($41*BytesPerLine)+$09
UtofireOffset			equ		($41*BytesPerLine)+$0B
OnOffset				equ		($4F*BytesPerLine)+$0D
OffOffset				equ		($4F*BytesPerLine)+$0D

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Meteor Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMeteorText
					ldu		WorkScreen
					leau	MeteorOffset,u
					ldx		#MeteorText
					ldy		#$04
Next1?				lda		LetterColor
					adda	#$10
					bcc		SetColor1?
					lda		#$80
SetColor1?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	4,x
					leau	28,u
					leay	-1,y
					bne		Next1?
					ldy		#$0A
Next2?				lda		LetterColor
					adda	#$10
					bcc		SetColor2?
					lda		#$80
SetColor2?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	16,x
					leau	16,u
					leay	-1,y
					bne		Next2?
					rts

MeteorText
					fcb		$0A,$00,$00,$0A
					fcb		$0F,$00,$05,$0A
					fcb		$0F,$00,$05,$0A
					fcb		$0F,$00,$05,$0A
					fcb		$0A,$0A,$0A,$0A,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$0A,$0A,$0A,$0A,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$0A,$0A,$0A,$0A,$05,$0A,$00,$0A,$00,$0F,$00,$05,$0A,$05,$05,$00
					fcb		$0A,$05,$00,$0A,$0A,$05,$05,$0F,$05,$00,$0A,$0A,$05,$05,$0A,$0A
					fcb		$0A,$05,$00,$0A,$0A,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$0A
					fcb		$0A,$05,$00,$0A,$0A,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$00
					fcb		$0A,$00,$00,$0A,$0F,$0A,$00,$0A,$05,$0F,$00,$0A,$05,$05,$00,$00
					fcb		$0A,$00,$00,$0A,$0A,$00,$00,$0A,$05,$00,$00,$0A,$05,$05,$00,$00
					fcb		$0A,$00,$00,$0A,$0A,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$00
					fcb		$0A,$00,$00,$0A,$05,$0A,$00,$0A,$00,$0F,$00,$05,$0A,$05,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Mess Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMessText
					ldu		WorkScreen
					leau	MessOffset,u
					ldx		#MessText
					ldy		#$06
Next1?				lda		LetterColor
					adda	#$10
					bcc		SetColor1?
					lda		#$80
SetColor1?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	4,x
					leau	28,u
					leay	-1,y
					bne		Next1?
					ldy		#$08
Next2?				lda		LetterColor
					adda	#$10
					bcc		SetColor2?
					lda		#$80
SetColor2?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					lda		10,x
					ora		LetterColor
					sta		,u+
					leax	11,x
					leau	21,u
					leay	-1,y
					bne		Next2?
					rts

MessText
					fcb		$0A,$00,$00,$0A
					fcb		$0F,$00,$05,$0A
					fcb		$0F,$00,$05,$0A
					fcb		$0F,$00,$05,$0A
					fcb		$0A,$0A,$0A,$0A
					fcb		$0A,$0A,$0A,$0A
					fcb		$0A,$0A,$0A,$0A,$05,$0A,$00,$0F,$00,$05,$0A
					fcb		$0A,$05,$00,$0A,$0A,$05,$05,$00,$0A,$0A,$05
					fcb		$0A,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$00
					fcb		$0A,$05,$00,$0A,$0A,$05,$00,$0F,$00,$05,$0A
					fcb		$0A,$00,$00,$0A,$0F,$0A,$00,$00,$0A,$00,$05
					fcb		$0A,$00,$00,$0A,$0A,$00,$00,$00,$0A,$00,$05
					fcb		$0A,$00,$00,$0A,$0A,$05,$05,$00,$0A,$0A,$05
					fcb		$0A,$00,$00,$0A,$05,$0A,$00,$0F,$00,$05,$0A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the By Line Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawByText
					ldu		WorkScreen
					leau	ByOffset,u
					ldx		#ByText
					ldy		#$0B
					lda		#$D0
					sta		LetterColor
Next?				lda		LetterColor
					eora	#$70
					sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		18,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		20,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		22,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		24,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		26,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	28,x
					leau	4,u
					leay	-1,y
					lbne		Next?
					rts

ByText
					fcb		$0F,$0A,$00,$00,$00,$05,$00,$0A,$00,$00,$00,$00,$00,$0F,$0A,$00,$00,$05,$00,$00,$05,$00,$00,$00,$00,$00,$00,$05
					fcb		$0A,$05,$00,$00,$00,$05,$00,$0A,$05,$00,$0F,$00,$00,$0A,$05,$00,$0A,$00,$00,$0A,$05,$00,$00,$00,$00,$00,$00,$05
					fcb		$0A,$05,$00,$00,$00,$05,$05,$00,$0A,$0A,$0A,$0A,$00,$0A,$05,$05,$05,$05,$05,$05,$05,$00,$00,$05,$05,$0A,$00,$05
					fcb		$0F,$0A,$05,$05,$00,$05,$0A,$00,$0A,$0A,$0A,$0A,$00,$0F,$0A,$05,$05,$05,$05,$05,$05,$0A,$00,$0F,$05,$05,$00,$0F
					fcb		$0A,$05,$05,$05,$00,$05,$05,$00,$0F,$00,$0A,$0A,$00,$0A,$0A,$05,$0A,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
					fcb		$0A,$05,$05,$05,$00,$05,$00,$0A,$0A,$00,$0A,$0A,$00,$0A,$05,$05,$00,$05,$05,$05,$05,$05,$05,$05,$05,$00,$05,$05
					fcb		$0F,$0A,$05,$0F,$00,$05,$00,$0A,$05,$0A,$0A,$0A,$00,$0A,$05,$00,$0F,$05,$00,$0F,$05,$05,$00,$0F,$05,$00,$00,$0F
					fcb		$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Press Fire Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPressFireText
					ldu		WorkScreen
					leau	PressFireOffset,u
					ldx		#PressFireText
					ldy		#$07
Next1?				lda		LetterColor
					adda	#$10
					bcc		SetColor1?
					lda		#$80
SetColor1?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	$0A,x
					leau	$16,u
					leay	-1,y
					bne		Next1?
					leau	$40,u
					ldy		#$07
Next2?				lda		LetterColor
					adda	#$10
					bcc		SetColor2?
					lda		#$80
SetColor2?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	$0A,x
					leau	$16,u
					leay	-1,y
					bne		Next2?
					rts


PressFireText
					fcb		$0F,$00,$0F,$00,$0F,$0A,$0F,$0A,$0F,$0A
					fcb		$0A,$0A,$0A,$0A,$0A,$00,$0A,$00,$0A,$00
					fcb		$0A,$0A,$0A,$0A,$0A,$00,$0A,$00,$0A,$00
					fcb		$0F,$00,$0F,$00,$0F,$00,$0F,$0A,$0F,$0A
					fcb		$0A,$00,$0A,$0A,$0A,$00,$00,$0A,$00,$0A
					fcb		$0A,$00,$0A,$0A,$0A,$00,$00,$0A,$00,$0A
					fcb		$0A,$00,$0A,$0A,$0F,$0A,$0F,$0A,$0F,$0A


					fcb		$00,$05,$0F,$05,$05,$0A,$05,$0F,$00,$00
					fcb		$00,$05,$00,$05,$05,$05,$05,$00,$00,$00
					fcb		$00,$05,$00,$05,$05,$05,$05,$00,$00,$00
					fcb		$00,$05,$0A,$05,$05,$0A,$05,$0A,$00,$00
					fcb		$00,$05,$00,$05,$05,$00,$05,$00,$00,$00
					fcb		$00,$05,$00,$05,$05,$05,$05,$00,$00,$00
					fcb		$00,$05,$00,$05,$05,$05,$05,$0F,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Game Over Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawGameOverText
					ldu		WorkScreen
					leau	GameOverOffset,u
					ldx		#GameOverText
					ldy		#$07
Next1?				lda		LetterColor
					adda	#$10
					bcc		SetColor1?
					lda		#$80
SetColor1?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		18,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					lda		20,x
					ora		LetterColor
					sta		,u+
					leax	21,x
					leau	11,u
					leay	-1,y
					bne		Next1?
					rts

GameOverText
					fcb		$0F,$0F,$00,$0F,$00,$0F,$05,$0A,$0F,$0F,$00,$00,$0F,$00,$0A,$05,$05,$0F,$0A,$0F,$0A
					fcb		$0A,$00,$05,$00,$0A,$0F,$05,$0A,$0A,$00,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$05
					fcb		$0A,$00,$05,$00,$0A,$0A,$0A,$0A,$0A,$00,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$05
					fcb		$0A,$0F,$05,$0F,$0A,$0A,$0A,$0A,$0F,$0A,$00,$05,$00,$0A,$0A,$05,$05,$0F,$00,$0F,$0A
					fcb		$0A,$05,$05,$00,$0A,$0A,$0A,$0A,$0A,$00,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$05
					fcb		$0A,$05,$05,$00,$0A,$0A,$0A,$0A,$0A,$00,$00,$05,$00,$0A,$05,$0A,$05,$00,$00,$0A,$05
					fcb		$0F,$0F,$05,$00,$0A,$0A,$00,$0A,$0F,$0F,$00,$00,$0F,$00,$05,$0A,$05,$0F,$0A,$0A,$05

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the High Scores Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawHighScoresText
					ldu		WorkScreen
					leau	HighScoresOffset,u
					ldx		#HighScoresText
					ldy		#$07
Next1?				lda		LetterColor
					adda	#$10
					bcc		SetColor1?
					lda		#$80
SetColor1?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		18,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		20,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		22,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	24,x
					leau	8,u
					leay	-1,y
					bne		Next1?
					rts


HighScoresText
					fcb		$0A,$05,$05,$05,$0F,$0A,$0A,$05,$00,$05,$0F,$0A,$0F,$0F,$05,$0F,$0A,$0F,$0A,$05,$0F,$0A,$0F,$0F
					fcb		$0A,$05,$05,$05,$00,$00,$0A,$05,$00,$05,$00,$00,$0A,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$00
					fcb		$0A,$05,$05,$05,$00,$00,$0A,$05,$00,$05,$00,$00,$0A,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$00
					fcb		$0F,$0F,$05,$05,$05,$0A,$0F,$0F,$00,$05,$0F,$0A,$0A,$00,$05,$00,$0A,$0F,$0A,$05,$0F,$00,$0F,$0F
					fcb		$0A,$05,$05,$05,$00,$0A,$0A,$05,$00,$00,$00,$0A,$0A,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$00,$05
					fcb		$0A,$05,$05,$05,$00,$0A,$0A,$05,$00,$00,$00,$0A,$0A,$00,$05,$00,$0A,$0A,$05,$05,$00,$00,$00,$05
					fcb		$0A,$05,$05,$05,$0F,$0A,$0A,$05,$00,$05,$0F,$0A,$0F,$0F,$05,$0F,$0A,$0A,$05,$05,$0F,$0A,$0F,$0F


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Controls Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawControlsText
					ldu		WorkScreen
					leau	ControlsOffset,u
					ldx		#ControlsText
					ldy		#$07
Next1?				lda		LetterColor
					adda	#$10
					bcc		SetColor1?
					lda		#$80
SetColor1?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					lda		18,x
					ora		LetterColor
					sta		,u+
					leax	19,x
					leau	13,u
					leay	-1,y
					bne		Next1?
					rts

ControlsText
					fcb		$0F,$0F,$05,$0F,$0A,$0A,$05,$05,$0F,$05,$0F,$00,$0F,$0F,$05,$00,$00,$0F,$0F
					fcb		$0A,$00,$05,$00,$0A,$0F,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$00
					fcb		$0A,$00,$05,$00,$0A,$0F,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$00,$0A,$00
					fcb		$0A,$00,$05,$00,$0A,$0A,$0F,$00,$0A,$05,$0F,$00,$0A,$05,$05,$00,$00,$0F,$0F
					fcb		$0A,$00,$05,$00,$0A,$0A,$0F,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$00,$00,$05
					fcb		$0A,$00,$05,$00,$0A,$0A,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$00,$00,$00,$05
					fcb		$0F,$0F,$05,$0F,$0A,$0A,$05,$00,$0A,$05,$00,$0A,$0F,$0F,$05,$0F,$0A,$0F,$0F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Set Controls Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSelectControlsText
					ldx		#SelectControlsText
					lda		#$50
					sta		TextXor?+1
					ldy		#$07
					lda		#$90
					sta		LetterColor
					bra		DrawBottomLineText
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Start Game Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawStartGameText
					ldx		#StartGameText
					lda		#$40
					sta		TextXor?+1
					ldy		#$07
					lda		#$B0
					sta		LetterColor
					bra		DrawBottomLineText
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the View High Score Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawHighScoreSelectText
					ldx		#HighScoreSelectText
					lda		#$50
					sta		TextXor?+1
					ldy		#$07
					lda		#$D0
					sta		LetterColor
					bra		DrawBottomLineText
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the text on the bottom line
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawBottomLineText
					ldu		WorkScreen
					leau	BottomLineOffset,u
Next?				lda		LetterColor
TextXor?			eora	#$00
					sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		18,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		20,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		22,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		24,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		26,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					lda		28,x
					ora		LetterColor
					sta		,u+
					leax	29,x
					leau	3,u
					leay	-1,y
					lbne	Next?
					rts

SelectControlsText
					fcb		$05,$0F,$00,$00,$05,$0F,$0A,$00,$00,$05,$00,$00,$05,$0F,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$05,$00,$00
					fcb		$0A,$00,$00,$00,$05,$00,$00,$05,$00,$05,$00,$00,$0A,$00,$00,$00,$00,$0A,$00,$00,$0A,$05,$00,$00,$00,$00,$05,$00,$00
					fcb		$0A,$00,$00,$00,$05,$00,$00,$0A,$0A,$0F,$0A,$00,$0A,$00,$00,$0F,$00,$0F,$0A,$05,$0F,$05,$0F,$00,$05,$0A,$05,$00,$0F
					fcb		$0A,$00,$05,$0F,$05,$0F,$0A,$0A,$0A,$05,$00,$00,$0A,$00,$05,$00,$0A,$0A,$05,$00,$0A,$05,$00,$0A,$0A,$05,$05,$05,$00
					fcb		$0A,$00,$00,$00,$00,$00,$0A,$0F,$00,$05,$00,$00,$0A,$00,$05,$00,$0A,$0A,$05,$00,$0A,$05,$00,$00,$0A,$05,$05,$05,$0F
					fcb		$0A,$00,$00,$00,$00,$00,$0A,$0A,$00,$05,$00,$00,$0A,$00,$05,$00,$0A,$0A,$05,$00,$0A,$05,$00,$00,$0A,$05,$05,$00,$05
					fcb		$05,$0F,$00,$00,$05,$0F,$0A,$05,$0A,$05,$00,$00,$05,$0F,$00,$0F,$00,$0A,$05,$00,$0A,$05,$00,$00,$05,$0A,$05,$05,$0A

StartGameText
					fcb		$00,$00,$0F,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$0A,$00,$00,$00,$0F,$0F,$00,$0A,$00,$00,$00,$00,$00,$0A,$00,$00
					fcb		$00,$00,$0A,$00,$05,$00,$0A,$00,$05,$00,$00,$00,$05,$00,$00,$00,$00,$0A,$00,$00,$0A,$00,$00,$05,$00,$00,$0A,$00,$00
					fcb		$00,$00,$0A,$00,$00,$00,$0F,$0A,$0A,$0A,$00,$00,$05,$00,$00,$00,$00,$0A,$00,$05,$0F,$00,$05,$05,$0F,$05,$0F,$00,$00
					fcb		$00,$00,$0F,$0A,$05,$00,$0A,$0A,$0A,$0A,$0F,$0A,$05,$00,$0F,$00,$00,$0F,$0F,$00,$0A,$00,$0F,$05,$05,$00,$0A,$00,$00
					fcb		$00,$00,$0A,$00,$05,$00,$0A,$00,$0F,$00,$00,$00,$05,$05,$00,$0A,$00,$00,$05,$00,$0A,$05,$05,$05,$00,$00,$0A,$00,$00
					fcb		$00,$00,$0A,$00,$05,$00,$0A,$00,$0A,$00,$00,$00,$05,$05,$00,$0A,$00,$00,$05,$00,$0A,$05,$05,$05,$00,$00,$0A,$00,$00
					fcb		$00,$00,$0A,$00,$05,$00,$0A,$00,$05,$0A,$00,$00,$05,$00,$0F,$00,$00,$0F,$0F,$00,$0A,$00,$0F,$05,$00,$00,$0A,$00,$00

HighScoreSelectText
					fcb		$00,$05,$00,$0A,$00,$00,$0A,$05,$00,$00,$00,$05,$00,$00,$00,$0F,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$05,$00,$0A,$00,$00,$0A,$05,$05,$00,$00,$05,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$05,$00,$0A,$00,$00,$0A,$05,$00,$05,$0F,$05,$05,$00,$00,$0A,$00,$00,$0F,$00,$0F,$00,$0A,$00,$05,$00,$05,$0A,$00
					fcb		$00,$05,$0F,$0A,$0F,$0A,$0F,$0F,$05,$05,$05,$05,$0A,$0A,$00,$0F,$0F,$05,$00,$05,$00,$0A,$0F,$0A,$0A,$0A,$0A,$00,$00
					fcb		$00,$05,$00,$0A,$00,$00,$0A,$05,$05,$05,$0F,$05,$00,$0A,$00,$00,$05,$05,$00,$05,$00,$0A,$0A,$0A,$0F,$00,$0F,$0A,$00
					fcb		$00,$05,$00,$0A,$00,$00,$0A,$05,$05,$00,$05,$05,$00,$0A,$00,$00,$05,$05,$00,$05,$00,$0A,$0A,$00,$0A,$00,$00,$0A,$00
					fcb		$00,$05,$00,$0A,$00,$00,$0A,$05,$05,$05,$0A,$05,$00,$0A,$00,$0F,$0F,$00,$0F,$00,$0F,$00,$0A,$00,$05,$0A,$0F,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Analog Joystick Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawAnalogText
					ldu		WorkScreen
					leau	AnalogJoystickOffset,u
					ldx		#AnalogText
					lda		ControlSetting	
					bne		NotSet0?
					lda		#$70
					sta		TextXor?+1
					lda		#$A0
					sta		LetterColor
					bra		DrawControlTypeText
NotSet0?			lda		#$40
					sta		TextXor?+1
					lda		#$F0
					sta		LetterColor
					bra		DrawControlTypeText
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Digital Joystick Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawDigitalText
					ldu		WorkScreen
					leau	DigitalJoystickOffset,u
					ldx		#DigitalText
					lda		ControlSetting	
					cmpa	#$01
					bne		NotSet1?
					lda		#$70
					sta		TextXor?+1
					lda		#$A0
					sta		LetterColor
					bra		DrawControlTypeText
NotSet1?			lda		#$40
					sta		TextXor?+1
					lda		#$F0
					sta		LetterColor
					bra		DrawControlTypeText
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Keyboard Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawKeyboardText
					ldu		WorkScreen
					leau	KeyboardOffset,u
					ldx		#KeyboardText
					lda		ControlSetting
					cmpa	#$02
					bne		NotSet2?
					lda		#$70
					sta		TextXor?+1
					lda		#$A0
					sta		LetterColor
					bra		DrawControlTypeText
NotSet2?			lda		#$40
					sta		TextXor?+1
					lda		#$F0
					sta		LetterColor
					bra		DrawControlTypeText
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Control Type Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawControlTypeText
					ldy		#$09
Next?				lda		LetterColor
TextXor?			eora	#$00
					sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		18,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		20,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		22,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		24,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					lda		26,x
					ora		LetterColor
					sta		,u+
					leax	27,x
					leau	5,u
					leay	-1,y
					lbne	Next?
					rts
AnalogText
					fcb		$05,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00
					fcb		$0A,$0A,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$0A,$00
					fcb		$0A,$0A,$0A,$00,$00,$0A,$0A,$05,$00,$05,$00,$00,$00,$0A,$05,$00,$0A,$0A,$0F,$0A,$0F,$0A,$0A,$0F,$0A,$0A,$0A
					fcb		$0F,$0A,$0F,$00,$05,$0A,$0A,$0A,$0A,$0A,$0A,$00,$00,$0A,$0A,$0A,$0A,$0A,$0A,$00,$05,$00,$00,$0A,$00,$0F,$00
					fcb		$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$00,$0A,$0A,$0A,$0A,$0A,$0A,$0F,$0A,$05,$00,$0A,$0A,$00,$0F,$00
					fcb		$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$00,$0A,$0A,$0A,$0A,$0A,$0A,$00,$0A,$05,$00,$0A,$0A,$00,$0A,$0A
					fcb		$0A,$0A,$0A,$0A,$05,$0A,$0A,$05,$00,$05,$0A,$00,$0F,$0A,$05,$00,$0F,$0A,$0F,$0A,$05,$00,$0A,$0F,$0A,$0A,$0A
					fcb		$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$0A,$00,$00,$00,$00,$00,$0F,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00


DigitalText
					fcb		$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00
					fcb		$0A,$0A,$00,$00,$00,$00,$05,$00,$00,$00,$0A,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$0A,$00
					fcb		$0A,$0A,$0A,$05,$00,$0A,$0F,$0A,$00,$0A,$0A,$00,$00,$0A,$05,$00,$0A,$0A,$0F,$0A,$0F,$0A,$0A,$0F,$0A,$0A,$0A
					fcb		$0A,$0A,$00,$0A,$0A,$00,$05,$00,$05,$0A,$0A,$00,$00,$0A,$0A,$0A,$0A,$0A,$0A,$00,$05,$00,$00,$0A,$00,$0F,$00
					fcb		$0A,$0A,$0A,$0A,$0A,$0A,$05,$00,$0A,$0A,$0A,$00,$0A,$0A,$0A,$0A,$0A,$0A,$0F,$0A,$05,$00,$0A,$0A,$00,$0F,$00
					fcb		$0A,$0A,$0A,$0A,$0A,$0A,$05,$00,$0A,$0A,$0A,$00,$0A,$0A,$0A,$0A,$0A,$0A,$00,$0A,$05,$00,$0A,$0A,$00,$0A,$0A
					fcb		$0F,$00,$0A,$05,$0A,$0A,$05,$00,$05,$0A,$0A,$00,$0F,$0A,$05,$00,$0F,$0A,$0F,$0A,$05,$00,$0A,$0F,$0A,$0A,$0A
					fcb		$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$0F,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00

KeyboardText
					fcb		$00,$00,$00,$00,$00,$05,$05,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$05,$05,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$05,$05,$00,$0A,$05,$05,$05,$0A,$00,$0A,$00,$05,$05,$00,$00,$05,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$05,$0A,$05,$05,$05,$05,$05,$05,$05,$05,$00,$0F,$05,$0F,$00,$0F,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$05,$05,$05,$0A,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$05,$05,$05,$00,$05,$05,$05,$05,$05,$05,$05,$05,$05,$00,$05,$05,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$05,$05,$00,$0F,$05,$0F,$05,$0A,$00,$0A,$00,$0F,$05,$00,$00,$0F,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Enter Name Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEnterNameText
					ldu		WorkScreen
					leau	EnterNameOffset,u
					ldx		#EnterNameText
					ldy		#$07
Next?				lda		LetterColor
					adda	#$10
					bcc		SetColor2?
					lda		#$80
SetColor2?			sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		12,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		14,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		16,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		18,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	20,x
					leau	12,u
					leay	-1,y
					bne		Next?
					rts

EnterNameText
					fcb		$0F,$0A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$05,$00,$00,$00,$00,$00,$00,$00
					fcb		$0A,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$0F,$05,$00,$00,$00,$00,$00,$00,$00
					fcb		$0A,$00,$0A,$00,$0F,$0A,$05,$00,$0A,$00,$00,$0F,$05,$00,$05,$05,$0A,$0F,$00,$0A
					fcb		$0F,$00,$0F,$00,$05,$00,$0A,$0A,$0F,$0A,$00,$0A,$0F,$00,$0F,$05,$05,$05,$05,$05
					fcb		$0A,$00,$0A,$0A,$05,$00,$0F,$00,$0A,$0A,$00,$0A,$0F,$05,$05,$05,$05,$05,$05,$0A
					fcb		$0A,$00,$0A,$0A,$05,$00,$0A,$00,$0A,$00,$00,$0A,$05,$05,$05,$05,$05,$05,$05,$00
					fcb		$0F,$0A,$0A,$0A,$05,$00,$05,$0A,$0A,$00,$00,$0A,$05,$00,$0F,$05,$05,$05,$00,$0F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the A Text
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawAText
					ldu		WorkScreen
					leau	AOffset,u
					ldx		#AText
					ldy		#$07
Next?				lda		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u
					leax	2,x
					leau	32,u
					leay	-1,y
					lbne	Next?
					rts

AText
					fcb		$05,$00
					fcb		$0A,$0A
					fcb		$0A,$0A
					fcb		$0F,$0A
					fcb		$0A,$0A
					fcb		$0A,$0A
					fcb		$0A,$0A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the UtofireText
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawUtofireText
					ldu		WorkScreen
					leau	UtofireOffset,u
					ldx		#UtofireText
					lda		#$A0
					sta		LetterColor
					ldy		#$07
Next?				lda		LetterColor
					eora	#$70
					sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		6,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		8,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		10,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					lda		12,x
					ora		LetterColor
					sta		,u+
					leax	13,x
					leau	19,u
					leay	-1,y
					lbne	Next?
					rts

UtofireText
					fcb		$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00,$00
					fcb		$00,$00,$05,$00,$00,$00,$0A,$0A,$00,$00,$00,$00,$00
					fcb		$0A,$0A,$0F,$0A,$05,$00,$0A,$00,$0A,$0A,$00,$05,$00
					fcb		$0A,$0A,$05,$00,$0A,$0A,$0F,$00,$00,$0F,$0A,$0A,$0A
					fcb		$0A,$0A,$05,$00,$0A,$0A,$0A,$00,$0A,$0A,$0A,$0F,$00
					fcb		$0A,$0A,$05,$00,$0A,$0A,$0A,$00,$0A,$0A,$00,$0A,$00
					fcb		$05,$00,$05,$00,$05,$00,$0A,$00,$0A,$0A,$00,$05,$0A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the OnText
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawOnText
					ldu		WorkScreen
					leau	OnOffset,u
					ldx		#OnText
					lda		#$90
					sta		LetterColor
					ldy		#$07
Next?				lda		LetterColor
					eora	#$10
					sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	6,x
					leau	26,u
					leay	-1,y
					lbne	Next?
					rts

OnText
					fcb		$00,$05,$00,$00,$00,$00
					fcb		$00,$0A,$0A,$00,$00,$00
					fcb		$00,$0A,$0A,$0A,$00,$00
					fcb		$00,$0A,$0A,$0F,$00,$00
					fcb		$00,$0A,$0A,$0A,$0A,$00
					fcb		$00,$0A,$0A,$0A,$0A,$00
					fcb		$00,$05,$00,$0A,$0A,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the OffText
; a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
DrawOffText
					ldu		WorkScreen
					leau	OffOffset,u
					ldx		#OffText
					lda		#$F0
					sta		LetterColor
					ldy		#$07
Next?				lda		LetterColor
					eora	#$40
					sta		LetterColor
					ldd		,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		2,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					ldd		4,x
					ora		LetterColor
					orb		LetterColor
					std		,u++
					leax	6,x
					leau	26,u
					leay	-1,y
					lbne	Next?
					rts
OffText
					fcb		$05,$00,$05,$00,$05,$00
					fcb		$0A,$0A,$0A,$0A,$0A,$0A
					fcb		$0A,$0A,$0A,$00,$0A,$00
					fcb		$0A,$0A,$0F,$00,$0F,$00
					fcb		$0A,$0A,$0A,$00,$0A,$00
					fcb		$0A,$0A,$0A,$00,$0A,$00
					fcb		$05,$00,$0A,$00,$0A,$00
