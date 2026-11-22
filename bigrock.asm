;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Big Rock Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BigRocks
BigRock0					BigRock
BigRock1					BigRock
BigRock2					BigRock
BigRock3					BigRock


BigRockYStart				equ		$0300
BigRockLines				equ		$07
BigRockXOffset				equ		$03
BigRockYOffset				equ		$03
BigRockBottom				equ		$53
BigRockGone					equ		BigRockBottom+BigRockLines
BigRockBuried				equ		BigRockBottom+1
BigRockCountHardMax			equ		$04
BigRockStartXMask			equ		$0F
BigRockVelocityMask			equ		$0E
BigRockColorMask			equ		$03

BigRockSBLineUp				equ		-28
BigRockOneLineOffset		equ		-192
BigRockTwoLineOffset		equ		-160
BigRockThreeLineOffset		equ		-128
BigRockFourLineOffset		equ		-96
BigRockFiveLineOffset		equ		-64
BigRockSixLineOffset		equ		-32

BigRockOneLineSOffset		equ		24
BigRockTwoLineSOffset		equ		20
BigRockThreeLineSOffset		equ		16
BigRockFourLineSOffset		equ		12
BigRockFiveLineSOffset		equ		8
BigRockSixLineSOffset		equ		4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw all the big rocks on current work screen
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBigRocks
						ldx		#BigRock0
						lda     BigRock.Active,x   					; get control byte
						beq		BigRock1?
						bsr		DrawBigRock
BigRock1?				
						ldx		#BigRock1
						lda     BigRock.Active,x    				; get control byte
						beq		BigRock2?
						bsr		DrawBigRock
BigRock2?				
						ldx		#BigRock2
						lda     BigRock.Active,x    				; get control byte
						beq		BigRock3?
						bsr		DrawBigRock
BigRock3?				
						ldx		#BigRock3
						lda     BigRock.Active,x    				; get control byte
						beq		Exit?
						bra		DrawBigRock
Exit?					rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a big rock on current work screen
; Pass big rock in x
; Uses: a,b,x,y,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBigRock
						lda		BigRock.Color,x
						lsla
						lsla
						ldy		#BigRockTable
						leay	a,y
						ldu		WorkScreen							; get work screen
						lda		BigRock.Xpos,x						; Get x position
						adda	#BigRockXOffset						; add x offset
						ldb		BigRock.Ypos,x						; Get y position
						addb	#BigRockYOffset						; add y offset
						jsr		FindAddessOffset					; get address offset
						leau	d,u									; get address to place rock
						lda		WorkNumber							; get work screen
						beq		Work0?
						stu		BigRock.Erase2,x
						clr		BigRock.EraseLine2,x
						bra		OffInt?
Work0?					stu		BigRock.Erase1,x
						clr		BigRock.EraseLine1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
CheckOdd?				sts		SaveSp
						lda		BigRock.Xpos,x						; Get X position
						lsra										; Check for odd
						bcc		Even?
						lds		2,y
						bra		Start?
Even?					lds		,y
Start?					ldb		BigRock.Ypos,x						; Get y position
						cmpb	#BigRockBottom
						bhi		Partial?
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts
Partial?				subb	#BigRockBuried
						negb
						addb	#6
						lda		WorkNumber
						beq		Work1?
						stb		BigRock.EraseLine2,x
						bra		Cont?
Work1?					stb		BigRock.EraseLine1,x
Cont?					cmpb	#6
						lbeq	Six?
						cmpb	#5
						beq		Five?
						cmpb	#4
						beq		Four?
						cmpb	#3
						beq		Three?
						cmpb	#2
						beq		Two?
						leas	BigRockOneLineSOffset,s
						leau	BigRockOneLineOffset,u
						puls	d,y
						pshu	d,y
						jmp		Restore?
Two?					leas	BigRockTwoLineSOffset,s
						leau	BigRockTwoLineOffset,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						jmp 	Restore?
Three?					leas	BigRockThreeLineSOffset,s
						leau	BigRockThreeLineOffset,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						bra		Restore?
Four?					leas	BigRockFourLineSOffset,s
						leau	BigRockFourLineOffset,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						bra		Restore?
Five?					leas	BigRockFiveLineSOffset,s
						leau	BigRockFiveLineOffset,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						bra		Restore?
Six?					leas	BigRockSixLineSOffset,s
						leau	BigRockSixLineOffset,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
						leau	BigRockSBLineUp,u
						puls	d,y
						pshu	d,y
Restore?				lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase the Big Rocks on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBigRocks			ldx		#BigRock0					; get pointer to big rock
						bsr		EraseBigRock				; erase Big Rock
						ldx		#BigRock1					; get pointer to big rock
						bsr		EraseBigRock				; erase Big Rock
						ldx		#BigRock2					; get pointer to big rock
						bsr		EraseBigRock				; erase Big Rock
						ldx		#BigRock3					; get pointer to big rock
						bsr		EraseBigRock				; erase Big Rock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase a Big Rock on current work screen
; Pass Big Rock in x
; Uses: a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBigRock			tst		WorkNumber						; find current work screen
						beq		Erase1?							; Is screen 1
Erase2?					ldu		BigRock.Erase2,x				; set screen 2
						bne		ClearErase2?					; if address is 0 nothing to erase
						rts
ClearErase2?			ldd		#$0000							; erase
						std		BigRock.Erase2,x				; buffer
						ldb		BigRock.EraseLine2,x
						bra		OffInt?							; go start erasing
Erase1?					ldu		BigRock.Erase1,x				; set screen 1
						bne		ClearErase1?					; if address is 0 nothing to erase
						rts
ClearErase1?			ldd		#$0000							; erase
						std		BigRock.Erase1,x				; buffer
						ldb		BigRock.EraseLine1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
StartErase?				ldx		#DoubleBlackBlock				; load black block for erasing
						ldy		#DoubleBlackBlock				; load black block for erasing
						tstb
						bne		EraseLoop?
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts
EraseLoop?				cmpb	#6
						beq		Six?
						cmpb	#5
						beq		Five?
						cmpb	#4
						beq		Four?
						cmpb	#3
						beq		Three?
						cmpb	#2
						beq		Two?
						leau	BigRockOneLineOffset,u
						pshu	x,y
						bra		Restore?
Two?					leau	BigRockTwoLineOffset,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						bra		Restore?
Three?					leau	BigRockThreeLineOffset,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						bra		Restore?
Four?					leau	BigRockFourLineOffset,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						bra		Restore?
Five?					leau	BigRockFiveLineOffset,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						bra		Restore?
Six?					leau	BigRockSixLineOffset,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
						leau	BigRockSBLineUp,u
						pshu	x,y
Restore?				lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move the big rocks on current work screen
; Uses: u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveBigRocks
						ldx		#BigRock0
						lda     BigRock.Active,x
						beq		BigRock1?
						bsr		MoveBigRock
BigRock1?				
						ldx		#BigRock1
						lda     BigRock.Active,x
						beq		BigRock2?
						bsr		MoveBigRock
BigRock2?				
						ldx		#BigRock2
						lda     BigRock.Active,x
						beq		BigRock3?
						bsr		MoveBigRock
BigRock3?				
						ldx		#BigRock3
						lda     BigRock3.Active
						beq		Exit?
						bra		MoveBigRock
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a big rock on current work screen
; Pass Big Rock in x
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveBigRock				ldd		BigRock.Yvelocity,x
						addd	BigRock.Ypos,x
						std		BigRock.Ypos,x
						cmpa	#BigRockGone
						bhs		Clear?
						rts
Clear?					clr		BigRock.Active,x
						dec		BigRockCountCurrent
						pshs	b,u
						ldx		#BigRockLandPoints
						jsr		SubtractScore
						puls	b,u,pc



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a big rock
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddBigRock
						lda		BigRockCountCurrent
SetBigRockMax			cmpa	#$00
						bne		CheckCount?
						rts
CheckCount?				lda		LastBigRock
						beq		RockChance?
						dec		LastBigRock
						rts
RockChance?				jsr		Random
SetBigRockChance		cmpa	#$00
						bls		FindRock?
						rts
FindRock?				ldu		#BigRocks
CheckNext?				lda		BigRock.Active,u
						beq		AddRock?
						leau	sizeof{BigRock},u
						bra		CheckNext?
AddRock?				inc		BigRock.Active,u
						ldd		#BigRockYStart
						std		BigRock.Ypos,u
						jsr		Random
						anda	#BigRockStartXMask
						ldx		#BigRockStartTable
						lda		a,x
						clrb
						std		BigRock.Xpos,u
						jsr		Random
						anda	#BigRockVelocityMask
						ldx		#BigRockVelocityTable
						ldd		a,x
						std		BigRock.Yvelocity,u
						lda		BigRockColor
						inca
						anda	#BigRockColorMask
						sta		BigRockColor
						sta		BigRock.Color,u
						inc		BigRockCountCurrent
SetBigRockPauseCounter
						lda		#$00
						sta		LastBigRock
						rts

BigRockStartTable		fcb		$03,$07,$0B,$0F,$13,$17,$1A,$1D,$21,$24,$28,$2C,$30,$34,$38,$3C
BigRockVelocityTable	rmb		16




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize big rocks
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeBigRocks
						ldu		#BigRocks
						lda		#BigRockCountHardMax
						clrb
						ldx		#$0000
NextRock?				stx		BigRock.Xpos,u
						stx		BigRock.Ypos,u
						stb		BigRock.Active,u
						stb		BigRock.Color,u
						stx		BigRock.Yvelocity,u
						stx		BigRock.Erase1,u
						stx		BigRock.Erase2,u
						stb		BigRock.EraseLine1,u
						stb		BigRock.EraseLine2,u
						deca
						bne		ToNextRock?
						stb		BigRockCountCurrent
						rts
ToNextRock?				leau	sizeof{BigRock},u
						bra		NextRock?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Big Rock Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BigRockTable			fdb		BigRockYellowDataEven
						fdb		BigRockYellowDataOdd
						fdb		BigRockCyanDataEven
						fdb		BigRockCyanDataOdd
						fdb		BigRockPurpleDataEven
						fdb		BigRockPurpleDataOdd
						fdb		BigRockGreenDataEven
						fdb		BigRockGreenDataOdd

BigRockYellowData
BigRockYellowDataEven	fcb		$90,$95,$9F,$90
						fcb		$90,$9F,$9F,$9A
						fcb		$95,$9A,$9F,$9A
						fcb		$95,$9F,$9A,$9F
						fcb		$90,$9A,$9F,$9F
						fcb		$90,$9F,$9F,$9A
						fcb		$90,$95,$9F,$90
BigRockYellowDataOdd	fcb		$90,$9F,$9A,$90
						fcb		$95,$9F,$9F,$90
						fcb		$9F,$95,$9F,$90
						fcb		$9F,$9F,$95,$9A
						fcb		$95,$95,$9F,$9A
						fcb		$95,$9F,$9F,$90
						fcb		$90,$9F,$9A,$90
BigRockEnd

BigRockCyanData
BigRockCyanDataEven		fcb		$D0,$D5,$DF,$D0
						fcb		$D0,$DF,$DF,$DA
						fcb		$D5,$DA,$DF,$DA
						fcb		$D5,$DF,$DA,$DF
						fcb		$D0,$DA,$DF,$DF
						fcb		$D0,$DF,$DF,$DA
						fcb		$D0,$D5,$DF,$D0
BigRockCyanDataOdd		fcb		$D0,$DF,$DA,$D0
						fcb		$D5,$DF,$DF,$D0
						fcb		$DF,$D5,$DF,$D0
						fcb		$DF,$DF,$D5,$DA
						fcb		$D5,$D5,$DF,$DA
						fcb		$D5,$DF,$DF,$D0
						fcb		$D0,$DF,$DA,$D0

BigRockPurpleData
BigRockPurpleDataEven	fcb		$E0,$E5,$EF,$E0
						fcb		$E0,$EF,$EF,$EA
						fcb		$E5,$EA,$EF,$EA
						fcb		$E5,$EF,$EA,$EF
						fcb		$E0,$EA,$EF,$EF
						fcb		$E0,$EF,$EF,$EA
						fcb		$E0,$E5,$EF,$E0
BigRockPurpleDataOdd	fcb		$E0,$EF,$EA,$E0
						fcb		$E5,$EF,$EF,$E0
						fcb		$EF,$E5,$EF,$E0
						fcb		$EF,$EF,$E5,$EA
						fcb		$E5,$E5,$EF,$EA
						fcb		$E5,$EF,$EF,$E0
						fcb		$E0,$EF,$EA,$E0

BigRockGreenData
BigRockGreenDataEven	fcb		$80,$85,$8F,$80
						fcb		$80,$8F,$8F,$8A
						fcb		$85,$8A,$8F,$8A
						fcb		$85,$8F,$8A,$8F
						fcb		$80,$8A,$8F,$8F
						fcb		$80,$8F,$8F,$8A
						fcb		$80,$85,$8F,$80
BigRockGreenDataOdd		fcb		$80,$8F,$8A,$80
						fcb		$85,$8F,$8F,$80
						fcb		$8F,$85,$8F,$80
						fcb		$8F,$8F,$85,$8A
						fcb		$85,$85,$8F,$8A
						fcb		$85,$8F,$8F,$80
						fcb		$80,$8F,$8A,$80

