;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Small Rock Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SmallRocks
SmallRock0					SmallRock
SmallRock1					SmallRock
SmallRock2					SmallRock
SmallRock3					SmallRock
SmallRock4					SmallRock
SmallRock5					SmallRock
SmallRock6					SmallRock
SmallRock7					SmallRock
SmallRock8					SmallRock
SmallRock9					SmallRock
SmallRockA					SmallRock

SmallRockLines				equ		$05
SmallRockXOffset			equ		$01
SmallRockYOffset			equ		$02
SmallRockBottom				equ		$54
SmallRockGone				equ		SmallRockBottom+SmallRockLines
SmallRockBuried				equ		SmallRockBottom+1
SmallRockLeft				equ		$01
SmallRockRight				equ		$3E
SmallRockCountSoftMax		equ		$05
SmallRockCountHardMax		equ		$0B
LastSmallRockCounter		equ		$07

SmallRockYStart				equ		$0200

SmallRockStartXMask			equ		$0F
SmallRockVelocityMask		equ		$0E
SmallRockColorMask			equ		$03

SmallRockSBLineUp			equ		-30
SmallRockOneLineOffset		equ		-128
SmallRockTwoLineOffset		equ		-96
SmallRockThreeLineOffset	equ		-64
SmallRockFourLineOffset		equ		-32

SmallRockOneLineSOffset		equ		8
SmallRockTwoLineSOffset		equ		6
SmallRockThreeLineSOffset	equ		4
SmallRockFourLineSOffset	equ		2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw all the Small rocks on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSmallRocks
						ldx		#SmallRock0
						lda		SmallRock.Active,x
						beq		Rock1?
						bsr		DrawSmallRock
Rock1?					ldx		#SmallRock1
						lda		SmallRock.Active,x
						beq		Rock2?
						bsr		DrawSmallRock
Rock2?					ldx		#SmallRock2
						lda		SmallRock.Active,x
						beq		Rock3?
						bsr		DrawSmallRock
Rock3?					ldx		#SmallRock3
						lda		SmallRock.Active,x
						beq		Rock4?
						bsr		DrawSmallRock
Rock4?					ldx		#SmallRock4
						lda		SmallRock.Active,x
						beq		Rock5?
						bsr		DrawSmallRock
Rock5?					ldx		#SmallRock5
						lda		SmallRock.Active,x
						beq		Rock6?
						bsr		DrawSmallRock
Rock6?					ldx		#SmallRock6
						lda		SmallRock.Active,x
						beq		Rock7?
						bsr		DrawSmallRock
Rock7?					ldx		#SmallRock7
						lda		SmallRock.Active,x
						beq		Rock8?
						bsr		DrawSmallRock
Rock8?					ldx		#SmallRock8
						lda		SmallRock.Active,x
						beq		Rock9?
						bsr		DrawSmallRock
Rock9?					ldx		#SmallRock9
						lda		SmallRock.Active,x
						beq		RockA?
						bsr		DrawSmallRock
RockA?					ldx		#SmallRockA
						lda		SmallRock.Active,x
						beq		Exit?
						bra		DrawSmallRock
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a Small rock on current work screen
; Pass Small rock in x
; Uses: a,b,x,y,u,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSmallRock
						lda		SmallRock.Color,x
						lsla
						lsla
						ldy		#SmallRockTable
						leay	a,y
						ldu		WorkScreen
						lda		SmallRock.Xpos,x
						adda	#SmallRockXOffset
						ldb		SmallRock.Ypos,x
						addb	#SmallRockYOffset
						jsr		FindAddessOffset
						leau	d,u
						lda		WorkNumber
						beq		Work0?
						stu		SmallRock.Erase2,x
						clr		SmallRock.EraseLine2,x
						bra		OffInt?
Work0?					stu		SmallRock.Erase1,x
						clr		SmallRock.EraseLine1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
CheckOdd?				sts		SaveSp
						lda		SmallRock.Xpos,x
						lsra
						bcc		Even?
						lds		2,y
						bra		Start?
Even?					lds		,y
Start?					ldb		SmallRock.Ypos,x
						cmpb	#SmallRockBottom
						bhi		Partial?
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts
Partial?				subb	#SmallRockBuried
						negb
						addb	#4
						lda		WorkNumber
						beq		Work1?
						stb		SmallRock.EraseLine2,x
						bra		Cont?
Work1?					stb		SmallRock.EraseLine1,x
Cont?					cmpb	#4
						beq		Four?
						cmpb	#3
						beq		Three?
						cmpb	#2
						beq		Two?
						leas	SmallRockOneLineSOffset,s
						leau	SmallRockOneLineOffset,u
						puls	d
						pshu	d
						jmp		Restore?
Two?					leas	SmallRockTwoLineSOffset,s
						leau	SmallRockTwoLineOffset,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						jmp 	Restore?
Three?					leas	SmallRockThreeLineSOffset,s
						leau	SmallRockThreeLineOffset,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						bra		Restore?
Four?					leas	SmallRockFourLineSOffset,s
						leau	SmallRockFourLineOffset,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
						leau	SmallRockSBLineUp,u
						puls	d
						pshu	d
Restore?				lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase the Small Rocks on current work screen
; Uses: x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseSmallRocks
						ldx		#SmallRock0
						bsr		EraseSmallRock
						ldx		#SmallRock1
						bsr		EraseSmallRock
						ldx		#SmallRock2
						bsr		EraseSmallRock
						ldx		#SmallRock3
						bsr		EraseSmallRock
						ldx		#SmallRock4
						bsr		EraseSmallRock
						ldx		#SmallRock5
						bsr		EraseSmallRock
						ldx		#SmallRock6
						bsr		EraseSmallRock
						ldx		#SmallRock7
						bsr		EraseSmallRock
						ldx		#SmallRock8
						bsr		EraseSmallRock
						ldx		#SmallRock9
						bsr		EraseSmallRock
						ldx		#SmallRockA
						bra		EraseSmallRock

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase a Small Rock on current work screen
; Pass Small Rock in x
; Uses: a,b,x,y,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseSmallRock
						lda		WorkNumber
						beq		Erase1?
Erase2?					ldu		SmallRock.Erase2,x
						bne		ClearErase2?
						rts
ClearErase2?			ldd		#$0000
						std		SmallRock.Erase2,x
						ldb		SmallRock.EraseLine2,x
						bra		OffInt?
Erase1?					ldu		SmallRock.Erase1,x
						bne		ClearErase1?
						rts
ClearErase1?			ldd		#$0000
						std		SmallRock.Erase1,x
						ldb		SmallRock.EraseLine1,x
OffInt?					lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
SmallRockEraseBlock
StartErase?				ldx		#DoubleBlackBlock
						tstb
						bne		EraseLoop?
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts
EraseLoop?				cmpb	#4
						beq		Four?
						cmpb	#3
						beq		Three?
						cmpb	#2
						beq		Two?
						leau	SmallRockOneLineOffset,u
						pshu	x
						bra		Restore?
Two?					leau	SmallRockTwoLineOffset,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						bra		Restore?
Three?					leau	SmallRockThreeLineOffset,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						bra		Restore?
Four?					leau	SmallRockFourLineOffset,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
						leau	SmallRockSBLineUp,u
						pshu	x
Restore?				lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move the Small rocks on current work screen
; Uses: u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveSmallRocks
						ldx		#SmallRock0
						lda		SmallRock.Active,x
						beq		Rock1?
						bsr		MoveSmallRock
Rock1?					ldx		#SmallRock1
						lda		SmallRock.Active,x
						beq		Rock2?
						bsr		MoveSmallRock
Rock2?					ldx		#SmallRock2
						lda		SmallRock.Active,x
						beq		Rock3?
						bsr		MoveSmallRock
Rock3?					ldx		#SmallRock3
						lda		SmallRock.Active,x
						beq		Rock4?
						bsr		MoveSmallRock
Rock4?					ldx		#SmallRock4
						lda		SmallRock.Active,x
						beq		Rock5?
						bsr		MoveSmallRock
Rock5?					ldx		#SmallRock5
						lda		SmallRock.Active,x
						beq		Rock6?
						bsr		MoveSmallRock
Rock6?					ldx		#SmallRock6
						lda		SmallRock.Active,x
						beq		Rock7?
						bsr		MoveSmallRock
Rock7?					ldx		#SmallRock7
						lda		SmallRock.Active,x
						beq		Rock8?
						bsr		MoveSmallRock
Rock8?					ldx		#SmallRock8
						lda		SmallRock.Active,x
						beq		Rock9?
						bsr		MoveSmallRock
Rock9?					ldx		#SmallRock9
						lda		SmallRock.Active,x
						beq		RockA?
						bsr		MoveSmallRock
RockA?					ldx		#SmallRockA
						lda		SmallRock.Active,x
						beq		Exit?
						bra		MoveSmallRock
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a Small rock on current work screen
; Pass Small Rock in x
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveSmallRock
						ldd		SmallRock.Yvelocity,x
						addd	SmallRock.Ypos,x
						std		SmallRock.Ypos,x
						cmpa	#SmallRockGone
						blo		XVel?
						clr		SmallRock.Active,x
						dec		SmallRockCountCurrent
						pshs	b,u
						ldx		#SmallRockLandPoints
						jsr		SubtractScore
						puls	b,u,pc
XVel?					ldd		SmallRock.Xvelocity,x
						addd	SmallRock.Xpos,x
						std		SmallRock.Xpos,x
						cmpa	#SmallRockLeft
						blo		Clear?
						cmpa	#SmallRockRight
						bhi		Clear?
						rts
Clear?					clr		SmallRock.Active,x
						dec		SmallRockCountCurrent
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move small rocks up on current work screen for base explodes
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveSmallRocksUp
						ldx		#SmallRock0
						lda		SmallRock.Active,x
						beq		Rock1?
						bsr		MoveSmallRockUp
Rock1?					ldx		#SmallRock1
						lda		SmallRock.Active,x
						beq		Rock2?
						bsr		MoveSmallRockUp
Rock2?					ldx		#SmallRock2
						lda		SmallRock.Active,x
						beq		Rock3?
						bsr		MoveSmallRockUp
Rock3?					ldx		#SmallRock3
						lda		SmallRock.Active,x
						beq		Rock4?
						bsr		MoveSmallRockUp
Rock4?					ldx		#SmallRock4
						lda		SmallRock.Active,x
						beq		Exit?
						bra		MoveSmallRockUp
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move a small rock on current work screen for base explodes
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveSmallRockUp
						ldd		SmallRock.Yvelocity,x
						addd	SmallRock.Ypos,x
						std		SmallRock.Ypos,x
						cmpa	#02
						blo		Clear?
XVel?					ldd		SmallRock.Xvelocity,x
						addd	SmallRock.Xpos,x
						std		SmallRock.Xpos,x
						cmpa	#SmallRockLeft
						blo		Clear?
						cmpa	#SmallRockRight
						bhi		Clear?
						rts
Clear?					clr		SmallRock.Active,x
						dec		SmallRockCountCurrent
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a Small rock
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddSmallRock
						lda		LastSmallRock
						beq		CheckCount?
						dec		LastSmallRock
						rts
CheckCount?				lda		SmallRockCountCurrent
SetSmallRockMax			cmpa	#$00
						blt		FindRock?
						rts
RockChance?				jsr		Random
SetSmallRockChance		cmpa	#$00
						bls		FindRock?
						rts
FindRock?				ldu		#SmallRocks
CheckNext?				lda		SmallRock.Active,u
						beq		AddRock?
						leau	sizeof{SmallRock},u
						bra		CheckNext?
AddRock?				inc		SmallRock.Active,u
						ldd		#SmallRockYStart
						std		SmallRock.Ypos,u
						jsr		Random
						anda	#SmallRockStartXMask
						ldx		#SmallRockStartTable
						lda		a,x
						clrb
						std		SmallRock.Xpos,u
						jsr		Random
						anda	#SmallRockVelocityMask
						ldx		#SmallRockVelocityTable
						ldd		a,x
						std		SmallRock.Yvelocity,u
						ldd		#$0000
						std		SmallRock.Xvelocity,u
						lda		SmallRockColor
						inca
						anda	#SmallRockColorMask
						sta		SmallRockColor
						sta		SmallRock.Color,u
						inc		SmallRockCountCurrent
SetSmallRockPauseCounter
						lda		#$00
						sta		LastSmallRock
						rts

SmallRockStartTable		fcb		$01,$05,$09,$0D,$11,$15,$19,$1E,$22,$26,$2A,$2E,$32,$36,$3A,$3E
SmallRockVelocityTable	rmb		16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a small rocks when big rock shot
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddExplodeSmallRocks
						pshs	d,u
						lda		SmallRockCountCurrent
						cmpa	#SmallRockCountHardMax
						bne		FindRockLeft?
						bra		Exit?
FindRockLeft?			ldu		#SmallRocks
CheckNextLeft?			lda		SmallRock.Active,u
						beq		AddRockLeft?
						leau	sizeof{SmallRock},u
						bra		CheckNextLeft?
AddRockLeft?			inc		SmallRock.Active,u
						ldd		BigRock.Ypos,x
						deca
						std		SmallRock.Ypos,u
						ldd		BigRock.Xpos,x
						std		SmallRock.Xpos,u
						ldd		#-$0080
						std		SmallRock.Xvelocity,u
						ldd		BigRock.Yvelocity,x
						std		SmallRock.Yvelocity,u
						lda		BigRock.Color,x
						sta		SmallRock.Color,u
						inc		SmallRockCountCurrent
						lda		SmallRockCountCurrent
						cmpa	#SmallRockCountHardMax
						bne		FindRockRight?
						bra		Exit?
FindRockRight?			ldu		#SmallRocks
CheckNextRight?			lda		SmallRock.Active,u
						beq		AddRockRight?
						leau	sizeof{SmallRock},u
						bra		CheckNextRight?
AddRockRight?			inc		SmallRock.Active,u
						ldd		SmallRock.Ypos,x
						deca
						std		SmallRock.Ypos,u
						ldd		BigRock.Xpos,x
						std		SmallRock.Xpos,u
						ldd		#$0080
						std		SmallRock.Xvelocity,u
						ldd		BigRock.Yvelocity,x
						std		SmallRock.Yvelocity,u
						lda		BigRock.Color,x
						sta		SmallRock.Color,u
						inc		SmallRockCountCurrent
Exit?					puls	d,u,pc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add a small rocks when base explodes
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BaseExpodesAddRocks
						lda		#$01
						sta		SmallRock0.Active
						sta		SmallRock1.Active
						sta		SmallRock2.Active
						sta		SmallRock3.Active
						sta		SmallRock4.Active
						ldd		BaseXpos
						std		SmallRock0.Xpos
						std		SmallRock1.Xpos
						std		SmallRock2.Xpos
						std		SmallRock3.Xpos
						std		SmallRock4.Xpos
						ldd		#BaseYPosSet
						std		SmallRock0.Ypos
						std		SmallRock1.Ypos
						std		SmallRock2.Ypos
						std		SmallRock3.Ypos
						std		SmallRock4.Ypos
						lda		#4
						sta		SmallRock0.Color
						sta		SmallRock1.Color
						sta		SmallRock2.Color
						sta		SmallRock3.Color
						sta		SmallRock4.Color
						ldd		#-$0040
						std		SmallRock0.Yvelocity
						ldd		#-$0100
						std		SmallRock0.Xvelocity
						ldd		#-$0100
						std		SmallRock1.Yvelocity
						ldd		#-$00C0
						std		SmallRock1.Xvelocity
						ldd		#-$0180
						std		SmallRock2.Yvelocity
						ldd		#$0000
						std		SmallRock2.Xvelocity
						ldd		#-$0100
						std		SmallRock3.Yvelocity
						ldd		#$00C0
						std		SmallRock3.Xvelocity
						ldd		#-$0040
						std		SmallRock4.Yvelocity
						ldd		#$0100
						std		SmallRock4.Xvelocity
						lda		#$05
						sta		SmallRockCountCurrent
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initilize Small rocks
; Uses: a,b,x,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeSmallRocks
						ldu		#SmallRocks
						lda		#SmallRockCountHardMax
						clrb
						ldx		#$0000
NextRock?				stx		SmallRock.Xpos,u
						stx		SmallRock.Ypos,u
						stb		SmallRock.Active,u
						stb		SmallRock.Color,u
						stx		SmallRock.Xvelocity,u
						stx		SmallRock.Yvelocity,u
						stx		SmallRock.Erase1,u
						stx		SmallRock.Erase2,u
						stb		SmallRock.EraseLine1,u
						stb		SmallRock.EraseLine2,u
						deca
						bne		ToNextRock?
						stb		SmallRockCountCurrent
						rts
ToNextRock?				leau	sizeof{SmallRock},u
						bra		NextRock?

SmallRockTable			fdb		SmallRockYellowDataEven
						fdb		SmallRockYellowDataOdd
						fdb		SmallRockCyanDataEven
						fdb		SmallRockCyanDataOdd
						fdb		SmallRockPurpleDataEven
						fdb		SmallRockPurpleDataOdd
						fdb		SmallRockGreenDataEven
						fdb		SmallRockGreenDataOdd
						fdb		SmallRockBlackDataEven
						fdb		SmallRockBlackDataOdd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Small Rock Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SmallRockYellowData
SmallRockYellowDataEven	fcb		$90,$9A
						fcb		$95,$95
						fcb		$95,$9F
						fcb		$95,$95
						fcb		$90,$9A
SmallRockYellowDataOdd	fcb		$95,$90
						fcb		$9A,$9A
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$95,$90

SmallRockCyanData
SmallRockCyanDataEven	fcb		$D0,$DA
						fcb		$D5,$D5
						fcb		$D5,$DF
						fcb		$D5,$D5
						fcb		$D0,$DA
SmallRockCyanDataOdd	fcb		$D5,$D0
						fcb		$DA,$DA
						fcb		$DF,$DA
						fcb		$DA,$DA
						fcb		$D5,$D0

SmallRockPurpleData
SmallRockPurpleDataEven	fcb		$E0,$EA
						fcb		$E5,$E5
						fcb		$E5,$EF
						fcb		$E5,$E5
						fcb		$E0,$EA
SmallRockPurpleDataOdd	fcb		$E5,$E0
						fcb		$EA,$EA
						fcb		$EF,$EA
						fcb		$EA,$EA
						fcb		$E5,$E0

SmallRockGreenData
SmallRockGreenDataEven	fcb		$80,$8A
						fcb		$85,$85
						fcb		$85,$8F
						fcb		$85,$85
						fcb		$80,$8A
SmallRockGreenDataOdd	fcb		$85,$80
						fcb		$8A,$8A
						fcb		$8F,$8A
						fcb		$8A,$8A
						fcb		$85,$80

SmallRockBlackData
SmallRockBlackDataEven	fcb		$BF,$B5
						fcb		$BA,$BA
						fcb		$BA,$B0
						fcb		$BA,$BA
						fcb		$BF,$B5
SmallRockBlackDataOdd	fcb		$BA,$BF
						fcb		$B5,$B5
						fcb		$B0,$B5
						fcb		$B5,$B5
						fcb		$BA,$BF

