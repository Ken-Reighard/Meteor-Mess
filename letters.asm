LetterLines				equ		5
LetterWidth				equ		3

HighScore1Location		equ		($12*BytesPerLine)+$04
HighScore2Location		equ		($26*BytesPerLine)+$04
HighScore3Location		equ		($3A*BytesPerLine)+$04
HighScoreLine1			equ		($1E*BytesPerLine)+$0A
HighScoreLine2			equ		($34*BytesPerLine)+$0A
HighScoreLine3			equ		($46*BytesPerLine)+$0A

ChooseLine				equ		($08*BytesPerLine)+$06
MonitorLine				equ		($12*BytesPerLine)+$05
RgbLine					equ		($2A*BytesPerLine)+$03
CmpLine					equ		($2A*BytesPerLine)+$14
PressKeyLine			equ		($40*BytesPerLine)+$02

ChooseText				fcn		"CHOOSE"
MonitorText				fcn		"MONITOR"
RgbText					fcn		"RGB"
CmpText					fcn		"CMP"
PressKeyText			fcn		"PRESS KEY"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw text on the current work screen
; Text pointed by u
; Location in d
; Uses: a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawTextWorkScreen		ldx		WorkScreen						; get work screen
						leax	d,x								; set pointer to offset
NextLetter?				lda		,u+								; get letter
						bne		FindLetter?						; hit 0, end of text
						rts
FindLetter?				suba	#$41							; set value to an offset
						bcs		Skip?							; less than, not a letter
						ldy		#Letters						; load man table address
						lsla
						ldy		a,y								; set to the first byte of the Letter
						pshs	x								; save start location of letter
						bsr		DrawLetter
ReadyNextLetter?		puls	x								; restore start location of letter
						leax	3,x								; Move to next letter
						bra		NextLetter?						; get next letter
Skip?					pshs	x
						bsr		DrawBlank
						puls	x
						leax	3,x								; Move to next letter
						bra		NextLetter?


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a letter
; Letter pointed to by y
; Location pointed to by x
; Uses: a,b,x,y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawLetter				ldb		#LetterLines
Next1?					lda		,y
						ora		LetterColor
						sta		,x
						lda		1,y
						ora		LetterColor
						sta		1,x
						lda		2,y
						ora		LetterColor
						sta		2,x
						decb
						beq		Exit?
						leax	BytesPerLine,x
						leay	3,y
						bra 	Next1?
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a blank
; Location pointed to by x
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBlank				ldb		#LetterLines
Next1?					lda		#$80
						sta		,x
						sta		1,x
						sta		2,x
						decb
						beq		Exit?
						leax	BytesPerLine,x
						brn		Exit?
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						nop
						bra 	Next1?
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Letter Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Letters
						fdb		LetterA
						fdb		LetterB
						fdb		LetterC
						fdb		LetterD
						fdb		LetterE
						fdb		LetterF
						fdb		LetterG
						fdb		LetterH
						fdb		LetterI
						fdb		LetterJ
						fdb		LetterK
						fdb		LetterL
						fdb		LetterM
						fdb		LetterN
						fdb		LetterO
						fdb		LetterP
						fdb		LetterQ
						fdb		LetterR
						fdb		LetterS
						fdb		LetterT
						fdb		LetterU
						fdb		LetterV
						fdb		LetterW
						fdb		LetterX
						fdb		LetterY
						fdb		LetterZ

LetterA
						fcb		$00,$0A,$00
						fcb		$05,$05,$00
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$0A
						fcb		$0A,$00,$0A
LetterB
						fcb		$0F,$0F,$00
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$00
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$00
LetterC
						fcb		$0F,$0F,$0A
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
						fcb		$0F,$0F,$0A
LetterD
						fcb		$0F,$0F,$00
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$00
LetterE
						fcb		$0F,$0F,$0A
						fcb		$0A,$00,$00
						fcb		$0F,$0A,$00
						fcb		$0A,$00,$00
						fcb		$0F,$0F,$0A
LetterF
						fcb		$0F,$0F,$0A
						fcb		$0A,$00,$00
						fcb		$0F,$0A,$00
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
LetterG
						fcb		$0F,$0F,$0A
						fcb		$0A,$00,$00
						fcb		$0A,$0F,$0A
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$0A
LetterH
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
LetterI
						fcb		$0F,$0F,$0A
						fcb		$00,$0A,$00
						fcb		$00,$0A,$00
						fcb		$00,$0A,$00
						fcb		$0F,$0F,$0A
LetterJ
						fcb		$00,$00,$0A
						fcb		$00,$00,$0A
						fcb		$00,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$0A
LetterK
						fcb		$0A,$00,$0A
						fcb		$0A,$05,$00
						fcb		$0F,$0A,$00
						fcb		$0A,$05,$00
						fcb		$0A,$00,$0A
LetterL
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
						fcb		$0F,$0F,$0A
LetterM
						fcb		$0A,$00,$0A
						fcb		$0F,$05,$0A
						fcb		$0A,$0A,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
LetterN
						fcb		$0A,$00,$0A
						fcb		$0F,$00,$0A
						fcb		$0A,$0A,$0A
						fcb		$0A,$05,$0A
						fcb		$0A,$00,$0A
LetterO
						fcb		$05,$0F,$00
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$05,$0F,$00
LetterP
						fcb		$0F,$0F,$00
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$00
						fcb		$0A,$00,$00
						fcb		$0A,$00,$00
LetterQ
						fcb		$05,$0A,$00
						fcb		$0A,$05,$00
						fcb		$0A,$05,$00
						fcb		$0A,$05,$00
						fcb		$05,$0A,$0A
LetterR
						fcb		$0F,$0F,$00
						fcb		$0A,$00,$0A
						fcb		$0F,$0F,$00
						fcb		$0A,$0A,$00
						fcb		$0A,$05,$0A
LetterS
						fcb		$05,$0F,$0A
						fcb		$0A,$00,$00
						fcb		$05,$0F,$00
						fcb		$00,$00,$0A
						fcb		$0F,$0F,$00
LetterT
						fcb		$0F,$0F,$0A
						fcb		$00,$0A,$00
						fcb		$00,$0A,$00
						fcb		$00,$0A,$00
						fcb		$00,$0A,$00
LetterU
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$05,$0F,$00
LetterV
						fcb		$0A,$00,$0A
						fcb		$05,$05,$00
						fcb		$05,$05,$00
						fcb		$05,$05,$00
						fcb		$00,$0A,$00
LetterW
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$0A,$0A,$0A
						fcb		$05,$05,$00
						fcb		$05,$05,$00
LetterX
						fcb		$0A,$00,$0A
						fcb		$05,$05,$00
						fcb		$00,$0A,$00
						fcb		$05,$05,$00
						fcb		$0A,$00,$0A
LetterY
						fcb		$0A,$00,$0A
						fcb		$0A,$00,$0A
						fcb		$05,$0F,$00
						fcb		$00,$0A,$00
						fcb		$00,$0A,$00
LetterZ
						fcb		$0F,$0F,$0A
						fcb		$00,$05,$00
						fcb		$00,$0A,$00
						fcb		$05,$00,$00
						fcb		$0F,$0F,$0A
