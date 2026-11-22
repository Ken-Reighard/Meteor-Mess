;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Direct Page
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						org		$2600
SwitchScreen			rmb		1						; Flag to screen switch, 0=none, 1=First, 2=Second
WorkNumber				rmb		1						; Work screen number 0=first, 1=second
WorkScreen				rmb		2						; Pointer to Work screen memory address

Randomx					fcb		$11
Randoma					fcb		$F0
Randomb					fcb		$2D
Randomc					fcb		$A7

GameState				rmb		1

AddessOffsetSaveData	rmb		2

SaveSp					rmb 	2

BigRockColor			rmb		1
SmallRockColor			rmb		1

LastBigRock				rmb		1
LastSmallRock			rmb		1
LastSpinnerMsb			rmb		1
LastSpinnerLsb			rmb		1
LastPulsarMsb			rmb		1
LastPulsarLsb			rmb		1
LastUfoMsb				rmb		1
LastUfoLsb				rmb		1
LastShot				rmb		1
LastBomb				rmb		1

ShotCountCurrent		rmb		1
BigRockCountCurrent		rmb		1
SmallRockCountCurrent	rmb		1

UpdateScore				rmb		1
UpdateLives				rmb		1
RequestShot				rmb		1

Level					rmb		1
Lives					rmb		1

ShootDelay				rmb 	1
ShootSoundCounter		rmb		1
ShootSoundRepeat		rmb		1

RockHitSoundCounter		rmb		1
RockHitSoundState		rmb		1
RockHitSoundPos			rmb		2

BaseHitSoundCounter		rmb		1
BaseHitSoundPos			rmb		2

SpinnerDelay			rmb 	1

PulsarDelay				rmb 	1
PulsarPause				rmb		1

BombDelay				rmb 	1

SoundControl			rmb		1

SpinnerFrame			rmb		1
SpinnerFrameCounter		rmb		1
SpinnerCountCurrent		rmb		1

LetterColor				rmb		1

BaseSpeedState			rmb		1
BaseSpeedSwitchState	rmb		1

ControlSetting			rmb		1
KeyDelay				rmb		1
AutoFire				rmb		1

ExitKey					rmb		1

BaseXpos				rmb		2						; MSB is whole and LSB fractional
BaseXvelocity			rmb		2						; MSB is whole and LSB fractional
BaseErase1				rmb		2						; Address to erase for work screen 0
BaseErase2				rmb		2						; Address to erase for work screen 1

PulsarActive			rmb		1						; 0 Inactive, 1 Active
PulsarXpos				rmb		2						; MSB is whole and LSB fractional
PulsarYpos				rmb		2						; MSB is whole and LSB fractional
PulsarXvelocity			rmb		2						; MSB is whole and LSB fractional
PulsarErase1			rmb		2						; Address to erase for work screen 0
PulsarErase2			rmb		2						; Address to erase for work screen 1
PulsarFrame				rmb		1
PulsarFrameCounter		rmb		1

UfoActive				rmb		1				; 0 Inactive, 1 Active
UfoXpos					rmb		2				; MSB is whole and LSB fractional
UfoXvelocity			rmb		2				; MSB is whole and LSB fractional
UfoErase1				rmb		2				; Address to erase for work screen 0
UfoErase2				rmb		2				; Address to erase for work screen 1
UfoEraseBytes1			rmb		1				; Bytes to erase for work screen 0
UfoEraseBytes2			rmb		1				; Bytes to erase for work screen 1

OrigIrqVector			rmb		2

TempWord0
TempByte0				rmb		1
TempByte1				rmb		1
TempWord1
TempByte2				rmb		1
TempByte3				rmb		1
TempWord2
TempByte4				rmb		1
TempByte5				rmb		1

