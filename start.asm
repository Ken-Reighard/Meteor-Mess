						setdp	$26
						;org		$2600
Start
						lda		#$26
						tfr		a,dp
						lds     #StackTop


						clr		ControlSetting
						clr		AutoFire
						jsr		SetControlType
						jsr		ClearScreens
						jsr		IrqSetup
						jsr		ReadScores
						jsr		SetUpGraphicMode
						jsr		ResetLevelThresh


						lda		$FFFE
						cmpa	#$8C
						bne		ContinueStart
						lda		#GameStateMonitor
						sta		GameState
						bra		GoSetup

ContinueStart			lda		#GameStateTitle
						sta		GameState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GoSetup					jsr		SetupGame
						jsr		ClearScreens

SetGameState			lda		GameState
						lsra
						lbcs	Normal
						lsra
						bcs		Exploding
						lsra
						bcs		Wait
						lsra
						lbcs	GameOver
						lsra
						lbcs	TitleScreen
						lsra
						lbcs	ControlScreen
						lsra
						lbcs	HighScoreScreen
						lsra
						lbcs	HighScoreEntry
						jmp		Monitor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Exploding
						jsr 	GetWorkScreen
						lda		UpdateScore
						beq		ExpUpdLives?
						deca
						sta		UpdateScore
						jsr		DisplayScore
ExpUpdLives?			lda		UpdateLives
						beq		ExpErase?
						deca
						sta		UpdateLives
						jsr		DisplayLives
ExpErase?				jsr		EraseSmallRocks
						jsr		DrawMountain
						jsr		DrawSmallRocks
						jsr		SetSwitchScreen
						jsr		MoveSmallRocksUp
						jsr		HandleSound
						clra
						ora		SmallRock0.Active
						ora		SmallRock1.Active
						ora		SmallRock2.Active
						ora		SmallRock3.Active
						ora		SmallRock4.Active
						beq		ExplodeDone?
WaitForIRQ?				lda     SwitchScreen
						bne     WaitForIRQ?
						bra		Exploding
ExplodeDone?
						lda		#GameStateWait
						sta		GameState
						jmp		SetGameState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NewGame
						lda		#GameStateWait
						sta		GameState
						jmp		GoSetup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Wait
						clr		ExitKey
						lda		#$03
						sta		TempByte0
						lda		#$A0
						sta		TempByte1
						jsr		ClearScreensTop
						ldd		#DoubleBlackBlock
						std		SmallRockEraseBlock+1
						jsr		SetLevelMountainColor
						clr		SoundControl
						lda		Lives
						bne		WaitLoop?
						ldx		#Score
						ldu		#PeakScore
						ldd		,u
						std		,x
						ldd		2,u
						std		2,x
						lda		#$02
						sta		UpdateScore
						lda		#GameStateGameOver
						sta		GameState
						jmp		SetGameState
WaitLoop?
						jsr 	GetWorkScreen
						jsr		DrawMountain
						ldd		#BaseStart
						std		BaseXpos
						jsr		DrawBase
						lda		TempByte0
						deca
						sta		TempByte0
						bne		Color?
						lda		TempByte1
						adda	#$10
						bcc		SetColor1?
						lda		#$80
SetColor1?				sta		TempByte1
						lda		#$03
						sta		TempByte0
Color?					lda		TempByte1
						sta		LetterColor
						jsr		DrawPressFireText
						jsr		SetSwitchScreen
WaitForIRQ2?  			lda     SwitchScreen
						bne     WaitForIRQ2?
						jsr		GetSpaceButtonPress
						cmpa	ExitKey
						lbne	WaitLoop?
						lda		ExitKey
						inca
						cmpa	#$02
						beq		Exit?
						sta		ExitKey
						jmp		WaitLoop?
Exit?					jsr		SetScreensTopBlack
						lda		#GameStateNormal
						sta		GameState
						jmp		SetGameState


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Normal
						jsr 	GetWorkScreen
						jsr		AddBigRock
						jsr		AddSmallRock
						jsr		AddSpinner
						jsr		AddPulsar
						jsr		AddShots
						jsr		AddUfo
						jsr		AddBombs
						lda		UpdateScore
						beq		UpdLives?
						deca
						sta		UpdateScore
						jsr		DisplayScore
UpdLives?				lda		UpdateLives
						beq		Erase?
						deca
						sta		UpdateLives
						jsr		DisplayLives
Erase?					jsr		EraseBigRocks
						jsr		EraseSmallRocks
						jsr		EraseBase
						jsr		EraseSpinners
						jsr		ErasePulsar
						jsr		EraseShots
						jsr		EraseUfo
						jsr		EraseBombs
						jsr		DrawMountain
						jsr		DrawSmallRocks
						jsr		DrawBigRocks
						jsr		DrawSpinners
						jsr		DrawPulsar
						jsr		DrawUfo
						jsr		DrawShots
						jsr		DrawBase
						jsr		DrawBombs
GetInput				jsr		GetJoystickAnalog
						jsr		MoveBigRocks
						jsr		MoveSmallRocks
						jsr		MoveBase
						jsr		MoveSpinners
						jsr		MovePulsar
						jsr		MoveUfo
						jsr 	MoveShots
						jsr		MoveBombs
						jsr		ShotCollisions
						jsr		BaseCollision
						tstb								; game state has changed due to base collision
						lbne	SetGameState
						jsr		HandleSound
						bsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jmp		Normal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetWorkScreen			lda		WorkNumber
						beq		SetPage1?
						ldd		#Screen2Loc
						std		WorkScreen
						rts
SetPage1?				ldd		#Screen1Loc
						std		WorkScreen
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetSwitchScreen			lda		WorkNumber
						inca
						sta		SwitchScreen
						deca
						eora	#1
						sta		WorkNumber
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GameOver
						jsr 	GetWorkScreen
						jsr		DisplayScore
						jsr		DisplayLives
						jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr 	GetWorkScreen
						jsr		DisplayScore
						jsr		DisplayLives
						clr		ExitKey
						lda		#$03
						sta		TempByte0
						lda		#$A0
						sta		TempByte1

GameOverLoop?
						jsr 	GetWorkScreen
						jsr		AddBigRock
						jsr		AddSmallRock
						jsr		AddSpinner
						jsr		AddPulsar
						jsr		AddUfo
						jsr		AddBombs
Erase?					jsr		EraseBigRocks
						jsr		EraseSmallRocks
						jsr		EraseSpinners
						jsr		ErasePulsar
						jsr		EraseUfo
						jsr		EraseBombs
						jsr		DrawMountain
						jsr		DrawSmallRocks
						jsr		DrawBigRocks
						jsr		DrawSpinners
						jsr		DrawPulsar
						jsr		DrawUfo
						jsr		DrawBombs
						jsr		MoveBigRocks
						jsr		MoveSmallRocks
						jsr		MoveSpinners
						jsr		MovePulsar
						jsr		MoveUfo
						jsr 	MoveShots
						jsr		MoveBombs
						lda		Spinner0.Active
						beq		Spin1?
						lda		Spinner0.Ypos
						cmpa	#SpinnerBottom
						blo		Spin1?
						clra
						sta		Spinner0.Active
						dec		SpinnerCountCurrent
Spin1?
						lda		Spinner1.Active
						beq		DoneSpin?
						lda		Spinner1.Ypos
						cmpa	#SpinnerBottom
						blo		DoneSpin?
						clra
						sta		Spinner1.Active
						dec 	SpinnerCountCurrent
DoneSpin?
						lda		TempByte0
						deca
						sta		TempByte0
						bne		Color?
						lda		TempByte1
						adda	#$10
						bcc		SetColor1?
						lda		#$80
SetColor1?				sta		TempByte1
						lda		#$03
						sta		TempByte0
Color?					lda		TempByte1
						sta		LetterColor
						jsr		DrawGameOverText
						jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr		GetSpaceButtonPress
						cmpa	ExitKey
						lbne	GameOverLoop?
						lda		ExitKey
						inca
						cmpa	#$02
						beq		CheckScore?
						sta		ExitKey
						jmp		GameOverLoop?
CheckScore?
						ldu		#HighScore3
						ldx		#PeakScore
						jsr		Compare
						cmpa	#$01
						bne		HighScoreScreen?
						lda		#GameStateHighScoreEntry
						sta		GameState
						jmp		SetGameState
HighScoreScreen?		lda		#GameStateHighScores
						sta		GameState
						jmp		SetGameState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TitleScreen
						clra
						sta		Level
						sta		ExitKey
						jsr		SetLevelData
						jsr		ClearScreens
						lda		#$03
						sta		TempByte0
						lda		#$A0
						sta		TempByte1
						lda		#$FF
						sta		TempByte5
TitleScreenLoop?
						jsr		Random
						jsr 	GetWorkScreen
						jsr		AddBigRock
						jsr		AddSmallRock
Erase?					jsr		EraseBigRocks
						jsr		EraseSmallRocks
						jsr		DrawMountain
						jsr		DrawSmallRocks
						jsr		DrawBigRocks
						jsr		MoveBigRocks
						jsr		MoveSmallRocks
						lda		TempByte0
						deca
						sta		TempByte0
						bne		Color?
						lda		TempByte1
						adda	#$10
						bcc		SetColor1?
						lda		#$80
SetColor1?				sta		TempByte1
						lda		#$03
						sta		TempByte0
Color?					lda		TempByte1
						sta		LetterColor
						jsr		DrawMeteorText
						jsr		DrawMessText
						lda		#$C0
						sta		LetterColor
						jsr		DrawByText
						lda		TempByte5
						inca
						sta		TempByte5
						cmpa	#$AB
						bhs		ShowHighScore?
						cmpa	#$56
						bhs		ShowControl?
						jsr		DrawStartGameText
						bra		SetSwitch?
ShowControl?			jsr		DrawSelectControlsText
						bra		SetSwitch?
ShowHighScore?			jsr		DrawHighScoreSelectText
SetSwitch?				jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr		GetSpaceButtonPress
						tsta
						beq		RegNoPress?
						ldb		ExitKey
						lbeq	TitleScreenLoop?
						cmpa	#$01
						beq		NewGame?
						cmpa	#$02
						beq		Controls?
						cmpa	#$03
						beq		HighScore?
						jmp		TitleScreenLoop?
RegNoPress?				lda		#$01
						sta		ExitKey
						jmp		TitleScreenLoop?
HighScore?				lda		#GameStateHighScores
						sta		GameState
						jmp		SetGameState
Controls?				lda		#GameStateControls
						sta		GameState
						jmp		SetGameState
NewGame?				jmp		NewGame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ControlScreen
						jsr		ClearScreens
						lda		#$03
						sta		TempByte0
						lda		#$A0
						sta		TempByte1
						lda		#$14
						sta		KeyDelay
ControlScreenLoop?
						jsr 	GetWorkScreen
						jsr		DrawMountain
						lda		TempByte0
						deca
						sta		TempByte0
						bne		Color?
						lda		TempByte1
						adda	#$10
						bcc		SetColor1?
						lda		#$80
SetColor1?				sta		TempByte1
						lda		#$03
						sta		TempByte0
Color?					lda		TempByte1
						sta		LetterColor
						jsr		DrawControlsText
						jsr		DrawAText
						jsr		DrawAnalogText
						jsr		DrawDigitalText
						jsr		DrawKeyboardText
						jsr		DrawUtofireText
						lda		AutoFire
						beq		Off?
						jsr		DrawOnText
						bra		Switch?
Off?					jsr		DrawOffText
Switch?					jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr		GetUpDownSpaceEnter
						tsta
						beq		ControlScreenLoop?
CheckUp?				cmpa	#$01
						bne		CheckDown?
						bsr		ControlUp
						jmp		ControlScreenLoop?
CheckDown?				cmpa	#$02
						bne 	CheckA?
						bsr		ControlDown
						jmp		ControlScreenLoop?
CheckA?					cmpa	#$04
						bne 	CheckEnter?
						bsr		ToggleAutoFire
						jmp		ControlScreenLoop?
CheckEnter?				cmpa	#$03
						lbne	ControlScreenLoop?
						bsr		SetControlType
						lda		#GameStateTitle
						sta		GameState
						jmp		SetGameState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ControlUp
						lda		ControlSetting
						suba	#$01
						bmi		RollOver?
						bra		Save?
RollOver?				lda		#$02
Save?					sta		ControlSetting
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ControlDown
						lda		ControlSetting
						adda	#$01
						cmpa	#$02
						bgt		RollOver?
						bra		Save?
RollOver?				clra
Save?					sta		ControlSetting
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ToggleAutoFire
						lda		AutoFire
						inca
						anda	#$01
						sta		AutoFire
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetControlType
						lda		ControlSetting
						bne		Check1?
						ldd		#GetJoystickAnalog
						bra		Save?
Check1?					cmpa	#$01
						bne		Check2?
						ldd		#GetJoystickDigital
						bra		Save?
Check2?					cmpa	#$02
						bne		Exit?
						ldd		#GetKeyPress
Save?					std		GetInput+1
						lda		AutoFire
						sta		SetAutoFire1+1
						sta		SetAutoFire2+1
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HighScoreScreen
						jsr		ClearScreens
						clr		ExitKey
						lda		#$01
						sta		TempByte4
						lda		#$A0
						sta		TempByte5
HighScoreScreenLoop?
						jsr		Random
						jsr 	GetWorkScreen
						jsr		DrawMountain
						lda		TempByte4
						deca
						sta		TempByte4
						bne		Color?
						lda		TempByte5
						adda	#$10
						bcc		SetColor1?
						lda		#$80
SetColor1?				sta		TempByte5
						lda		#$01
						sta		TempByte4
Color?					lda		TempByte5
						sta		LetterColor
						jsr		DrawHighScoresText
						ldd		#HighScore1
						std		SetScoreLoc+1
						ldd		#HighScoreLine1
						std		SetScoreLine+1
						jsr		DisplayScore
						ldd		#HighScore2
						std		SetScoreLoc+1
						ldd		#HighScoreLine2
						std		SetScoreLine+1
						jsr		DisplayScore
						ldd		#HighScore3
						std		SetScoreLoc+1
						ldd		#HighScoreLine3
						std		SetScoreLine+1
						jsr		DisplayScore
						ldd		#Score
						std		SetScoreLoc+1
						ldd		#ScoreLine
						std		SetScoreLine+1
						lda		#$D0
						sta		LetterColor
						ldd		#HighScore1Location
						ldu		#Name1
						jsr		DrawTextWorkScreen
						lda		#$E0
						sta		LetterColor
						ldd		#HighScore2Location
						ldu		#Name2
						jsr		DrawTextWorkScreen
						lda		#$A0
						sta		LetterColor
						ldd		#HighScore3Location
						ldu		#Name3
						jsr		DrawTextWorkScreen
						jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr		GetSpaceButtonPress
						cmpa	ExitKey
						lbne	HighScoreScreenLoop?
						lda		ExitKey
						inca
						cmpa	#$02
						beq		Title?
						sta		ExitKey
						jmp		HighScoreScreenLoop?
Title?					lda		#GameStateTitle
						sta		GameState
						jmp		SetGameState
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HighScoreEntry
						jsr		ClearScreens
						clr		ExitKey
						lda		#$02
						sta		TempByte4
						lda		#$A0
						sta		TempByte5
						ldu		#NameEntry
						lda		#$07
NextPos?				ldb		a,u
						cmpb	#$20
						bne		SetPos?
						deca
						bmi		SetPos?
						bra		NextPos?
SetPos?					inca
						sta		TempByte3
HighScoreEntryLoop?
						jsr		Random
						jsr 	GetWorkScreen
						jsr		DrawMountain
						lda		TempByte4
						deca
						sta		TempByte4
						bne		Color?
						lda		TempByte5
						adda	#$10
						bcc		SetColor1?
						lda		#$80
SetColor1?				sta		TempByte5
						lda		#$02
						sta		TempByte4
Color?					lda		TempByte5
						sta		LetterColor
						jsr		DrawEnterNameText
						ldd		#HighScore2Location
						ldu		#NameEntry
						jsr		DrawTextWorkScreen
						ldd		#HighScore2Location+($07*BytesPerLine)
						ldu		WorkScreen
						leau	d,u
						ldb		#$08
Next?					lda		#$0F
						ora		LetterColor
						sta		,u+
						sta		,u+
						lda		#$0A
						ora		LetterColor
						sta		,u+
						decb
						bne		Next?
						jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr		[$A000]
						beq		HighScoreEntryLoop?
						cmpa	#$20
						beq		Enter?
						cmpa	#$41
						blo		BkspKey?
						cmpa	#$5A
						bhi		BkspKey?
Enter?					ldb		TempByte3
						cmpb	#$07
						bgt		HighScoreEntryLoop?
						ldu		#NameEntry
						sta		b,u
						incb
						stb		TempByte3
BkspKey?
						cmpa	#$08
						bne 	EnterKey?
						lda		#$20
						ldu		#NameEntry
						ldb		TempByte3
						decb
						bmi		HighScoreEntryLoop?
						sta		b,u
						stb		TempByte3
						lbra	HighScoreEntryLoop?
EnterKey?				cmpa	#$0D
						lbne	HighScoreEntryLoop?
High1?					ldu		#HighScore1
						ldx		#PeakScore
						jsr		Compare
						cmpa	#$01
						bne		High2?
						ldx		#HighScore2
						ldu		#HighScore3
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldx		#HighScore1
						ldu		#HighScore2
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldx		#PeakScore
						ldu		#HighScore1
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldx		#Name2
						ldu		#Name3
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						ldx		#Name1
						ldu		#Name2
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						ldx		#NameEntry
						ldu		#Name1
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						bra		Exit?
High2?					ldu		#HighScore2
						ldx		#PeakScore
						jsr		Compare
						cmpa	#$01
						bne		High3?
						ldx		#HighScore2
						ldu		#HighScore3
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldx		#PeakScore
						ldu		#HighScore2
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldx		#Name2
						ldu		#Name3
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						ldx		#NameEntry
						ldu		#Name2
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						bra		Exit?
High3?					ldx		#PeakScore
						ldu		#HighScore3
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldx		#NameEntry
						ldu		#Name3
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
Exit?					jsr		WriteScores
						lda		#GameStateHighScores
						sta		GameState
						jmp		SetGameState


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Monitor
						jsr		ClearScreens
						clra
						sta		TempByte4
MonitorLoop?
						jsr 	GetWorkScreen
						lda		#$A0
						sta		LetterColor
						ldd		#ChooseLine
						ldu		#ChooseText
						jsr		DrawTextWorkScreen
						ldd		#MonitorLine
						ldu		#MonitorText
						jsr		DrawTextWorkScreen
						ldd		#RgbLine
						ldu		#RgbText
						jsr		DrawTextWorkScreen
						ldd		#CmpLine
						ldu		#CmpText
						jsr		DrawTextWorkScreen
						ldd		#PressKeyLine
						ldu		#PressKeyText
						jsr		DrawTextWorkScreen
						lda		TempByte4
						deca
						sta		TempByte4
						anda	#$10
						beq		Way2?
						ldu		WorkScreen
						leau	RgbLine+($07*BytesPerLine),u
						lda		#$AF
						sta		,u+
						sta		,u+
						eora	#$05
						sta		,u+
						ldu		WorkScreen
						leau	CmpLine+($07*BytesPerLine),u
						lda		#$A0
						sta		,u+
						sta		,u+
						sta		,u+
						bra		Switch?
Way2?					ldu		WorkScreen
						leau	RgbLine+($07*BytesPerLine),u
						lda		#$A0
						sta		,u+
						sta		,u+
						sta		,u+
						ldu		WorkScreen
						leau	CmpLine+($07*BytesPerLine),u
						lda		#$AF
						sta		,u+
						sta		,u+
						eora	#$05
						sta		,u+
Switch?					jsr		SetSwitchScreen
WaitForIRQ?  			lda     SwitchScreen
						bne     WaitForIRQ?
						jsr		GetMonitorKeyPress
						lbeq	MonitorLoop?
						cmpa	#$01
						bne		TryC?
						jsr		$E5FA
						jmp		ContinueStart
TryC?					cmpa	#$02
						lbne	MonitorLoop?
						jsr		$E606
						jmp		ContinueStart
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetupGame
LevelSet				lda		#$00
						sta		Level
						jsr		SetLevelData
						jsr		InitializeBigRocks
						jsr		InitializeSmallRocks
						jsr		InitializeSpinners
						jsr		InitializePulsar
						jsr		InitializeShots
						jsr		InitializeUfos
						jsr		InitializeBombs
						jsr		InitializeBase

						clr		WorkNumber
						clr		SoundControl
						lda		#$10
						sta		Lives
						lda		#$02
						sta		UpdateScore
						sta		UpdateLives
						ldd		#$0000
						std		BigRockColor
						std		LastBigRock
						std		LastUfoMsb
						std		LastShot
						ldx		#Score
						std		,x
						std		2,x
						std		4,x
						std		6,x
						ldx		#ExtraScore
						std		,x
						sta		3,x
						lda		#$10
						sta		2,x
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ResetLevelThresh
						ldx		#LevelThreshTable
						ldd		#$0000
						std		,x
						ldd		#$1000
						std		2,x
						ldd		#$0000
						std		4,x
						ldd		#$5000
						std		6,x
						ldd		#$0002
						std		8,x
						ldd		#$0000
						std		10,x
						ldd		#$0005
						std		12,x
						ldd		#$0000
						std		14,x
						rts
						