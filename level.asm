;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup all the level data
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetLevelData
						lda		Level
						lsla
						lsla
						lsla
						sta		TempByte3
						lsra
						lsra
						adda	TempByte3
						ldx		#LevelScoreTable
						leax	a,x
						ldd		,x++
						std		SetBigRockHitPoints
						ldd		,x++
						std		SetSmallRockHitPoints
						ldd		,x++
						std		SetSpinnerHitPoints
						ldd		,x++
						std		SetPulsarHitPoints
						ldd		,x
						std		SetUfoHitPoints
						lda		Level
						lsla
						sta		TempByte3
						lsla
						adda	TempByte3
						ldx		#LevelDeductScoreTable
						leax	a,x
						ldd		,x++
						std		SetBigRockLandPoints
						ldd		,x++
						std		SetSmallRockLandPoints
						ldd		,x
						std		SetBaseHitPoints
;
						ldb		Level
						lsrb
						lsrb
						lsrb
						lsrb
						ldx		#BigRockLevelVelocityTable
						abx
						ldu		#BigRockVelocityTable
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						ldd		8,x
						std		8,u
						ldd		10,x
						std		10,u
						ldd		12,x
						std		12,u
						ldd		14,x
						std		14,u
;
						ldb		Level
						lsrb
						lsrb
						lsrb
						lsrb
						ldx		#SmallRockLevelVelocityTable
						abx
						ldu		#SmallRockVelocityTable
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						ldd		8,x
						std		8,u
						ldd		10,x
						std		10,u
						ldd		12,x
						std		12,u
						ldd		14,x
						std		14,u
;
						ldb		Level
						lsrb
						lsrb
						lsrb
						lsrb
						ldx		#SpinnerLevelVelocityTable
						abx
						ldu		#SpinnerVelocityTable
						ldd		,x
						std		,u
						ldd		2,x
						std		2,u
						ldd		4,x
						std		4,u
						ldd		6,x
						std		6,u
						ldd		8,x
						std		8,u
						ldd		10,x
						std		10,u
						ldd		12,x
						std		12,u
						ldd		14,x
						std		14,u
;
						ldb		Level
						ldx		#BigRockMinWait
						abx
						lda		,x
						sta		SetBigRockPauseCounter+1
;
						ldx		#BigRockMax
						abx
						lda		,x
						sta		SetBigRockMax+1
;
						ldx		#BigRockChance
						abx
						lda		,x
						sta		SetBigRockChance+1
;
						ldx		#SmallRockMinWait
						abx
						lda		,x
						sta		SetSmallRockPauseCounter+1
;
						ldx		#SmallRockMax
						abx
						lda		,x
						sta		SetSmallRockMax+1
;
						ldx		#SmallRockChance
						abx
						lda		,x
						sta		SetSmallRockChance+1
;
						ldx		#PulsarMinWait
						abx
						lda		,x
						sta		SetPulsarPause+1
						sta		SetPulsarPauseCounterMsb+1
						sta		SetPulsarPauseCounterMsbShot+1
						sta		SetPulsarPauseCounterMsbBase+1
;
						ldx		#PulsarChance
						abx
						lda		,x
						sta		SetPulsarChance+1
;
						ldx		#UfoMinWait
						abx
						lda		,x
						sta		SetUfoPauseMsbCounter1+1
						sta		SetUfoPauseMsbCounterShot+1
;
						ldx		#UfoChance
						abx
						lda		,x
						sta		SetUfoChance+1
;
						ldx		#SpinnerMinWait
						abx
						lda		,x
						sta		SetSpinnerPauseMsbCounterShot+1
						sta		SetSpinnerPauseMsbCounter+1
;
						ldx		#SpinnerMax
						abx
						lda		,x
						sta		SetSpinnerMax+1
						sta		SetSpinnerMax2+1
;
						ldx		#SpinnerChance
						abx
						lda		,x
						sta		SetSpinnerChance+1
;
						ldx		#SecondSpinnerChance
						abx
						lda		,x
						sta		Set2ndSpinnerChance+1
;
SetLevelMountainColor	ldx		#LevelMountainLookup
						lda		Level
						lda		a,x
						sta		DrawMountain+1
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Level Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LevelScoreTable
						fcb		$00,$10,$00,$20,$00,$40,$00,$80,$00,$00
						fcb		$00,$20,$00,$40,$00,$80,$01,$60,$00,$50
						fcb		$00,$30,$00,$60,$01,$20,$02,$40,$02,$00
						fcb		$00,$40,$00,$80,$01,$60,$03,$20,$04,$00
						fcb		$00,$50,$01,$00,$02,$00,$04,$00,$05,$00
LevelDeductScoreTable
						fcb		$99,$95,$99,$90,$99,$00
						fcb		$99,$90,$99,$80,$98,$00
						fcb		$99,$85,$99,$70,$97,$00
						fcb		$99,$80,$99,$60,$96,$00
						fcb		$99,$75,$99,$50,$95,$00

BigRockLevelVelocityTable
						fdb		$0080		; Level 0
						fdb		$0080
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0180

						fdb		$0080		; Level 1
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0200

						fdb		$0080		; Level 2
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200

						fdb		$0080		; Level 3
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200

						fdb		$0180		; Level 4
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200
						fdb		$0200

SmallRockLevelVelocityTable
						fdb		$0080		; Level 0
						fdb		$0080
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0180

						fdb		$0080		; Level 1
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0200

						fdb		$0080		; Level 2
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200

						fdb		$0080		; Level 3
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200

						fdb		$0180		; Level 4
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200
						fdb		$0200
						fdb		$0200

SpinnerLevelVelocityTable
						fdb		$0080		; Level 0
						fdb		$0080
						fdb		$0080
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100

						fdb		$0100		; Level 1
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0200

						fdb		$0100		; Level 2
						fdb		$0100
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200

						fdb		$0100		; Level 3
						fdb		$0100
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200
						fdb		$0200

						fdb		$0100		; Level 4
						fdb		$0100
						fdb		$0180
						fdb		$0180
						fdb		$0180
						fdb		$0200
						fdb		$0200
						fdb		$0200

BigRockMinWait			fcb		$44,$34,$24,$34,$24
BigRockMax				fcb		$02,$03,$03,$04,$04
BigRockChance			fcb		$20,$20,$30,$30,$30

SmallRockMinWait		fcb		$44,$34,$24,$14,$14
SmallRockMax			fcb		$03,$04,$04,$05,$06
SmallRockChance			fcb		$20,$25,$30,$35,$40

PulsarMinWait			fcb		$03,$02,$02,$01,$01
PulsarChance			fcb		$05,$0A,$0F,$15,$20

SpinnerMinWait			fcb		$03,$02,$02,$01,$01
SpinnerMax				fcb		$01,$02,$02,$02,$02
SpinnerChance			fcb		$0D,$10,$1D,$1F,$1F
SecondSpinnerChance		fcb		$00,$40,$45,$4A,$50

UfoMinWait				fcb		$00,$05,$05,$04,$03
UfoChance				fcb		$00,$01,$01,$01,$03
