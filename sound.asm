;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sound settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ShootDelayStart			equ		$01
ShootDelayEnd			equ		$10

SpinnerDelayStart		equ		$01
SpinnerDelayEnd			equ		$20

PulsarDelayStart		equ		$50
PulsarDelayEnd			equ		$57
PulsarPauseAmount		equ		$07

BombDelayStart			equ		$E0
BombDelayEnd			equ		$E7

RockHitSoundCounterSet	equ		$0F

SetSpinnerSound			equ		%00000001
SetPulsarSound			equ		%00000010
SetRockHitSound			equ		%00000100
SetBombSound			equ		%00001000
SetShootSound			equ		%00010000
SetBaseHitSound			equ		%00100000

ResetShootSound			equ		%11101111
ResetBombSound			equ		%11110111
ResetRockHitSound		equ		%11111011

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uses
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TurnOnShootSound
						lda		SoundControl
						ora		#SetShootSound
						sta		SoundControl
						lda		#ShootDelayStart
						sta		ShootDelay
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uses a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TurnOnRockHitSound
						lda		SoundControl
						ora		#SetRockHitSound
						sta		SoundControl
						lda		#$FF
						sta		RockHitSoundState
						lda		#RockHitSoundCounterSet
						sta		RockHitSoundCounter
						ldd		#Start
						std		RockHitSoundPos
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uses a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TurnOnSpinnerSound
						lda		#SetSpinnerSound
						sta		SoundControl
						lda		#SpinnerDelayStart
						sta		SpinnerDelay
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uses a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TurnOnPulsarSound
						lda		#SetPulsarSound
						sta		SoundControl
						lda		#PulsarDelayStart
						sta		PulsarDelay
						clra
						sta		PulsarPause
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uses a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TurnOnBombSound
						lda		SoundControl
						ora		#SetBombSound
						sta		SoundControl
						lda		#BombDelayStart
						sta		BombDelay
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Uses a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TurnOnBaseHitSound
						lda		#SetBaseHitSound
						sta		SoundControl
						ldd		#Start
						std		BaseHitSoundPos
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Play a sound if needed
; uses: a, u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HandleSound
						lda		SoundControl
						bne		Check?
						rts
Check?					lsra
						bcs		SpinnerSound?
						lsra
						bcs		PulsarSound?
						lsra
						bcs		RockHitSound?
						lsra
						bcs		BombSound?
						lsra
						bcs		ShootSound?
						lsra
						bcs		BaseHitSound?
						rts
RockHitSound?			dec		RockHitSoundCounter
						bne		PlayRockHitSound?
						lda		SoundControl
						anda	#ResetRockHitSound
						sta		SoundControl
						rts
PlayRockHitSound?		ldx		RockHitSoundPos
						cmpx	#Wait
						bne		PlayRock?
						lda		RockHitSoundState
						eora	#$FF
						sta		RockHitSoundState
						ldd		#Start
						std		RockHitSoundPos
PlayRock?				bsr		PlayRockHitSound
						rts
PulsarSound?			lda		PulsarPause
						beq		PlayPulsar?
						deca
						sta		PulsarPause
						rts
PlayPulsar?				ldb		PulsarDelay
						bsr		PlaySound
						cmpb	#PulsarDelayEnd
						bge		PulsarRestart?
						stb		PulsarDelay
						rts
PulsarRestart?			lda		#PulsarDelayStart
						sta		PulsarDelay
						lda		#PulsarPauseAmount
						sta		PulsarPause
						rts
SpinnerSound?			ldb		SpinnerDelay
						bsr		PlaySound
						cmpb	#SpinnerDelayEnd
						bge		SpinnerRestart?
						stb		SpinnerDelay
						rts
SpinnerRestart?			lda		SpinnerDelayStart
						sta		SpinnerDelay
						rts
BombSound?				ldb		BombDelay
						bsr		PlaySound
						cmpb	#BombDelayEnd
						bge		BombEnd?
						stb		BombDelay
						rts
BombEnd?				lda		SoundControl
						anda	#ResetBombSound
						sta		SoundControl
						rts
ShootSound?				ldb		ShootDelay
						bsr		PlayShootSound
						cmpb	#ShootDelayEnd
						bge		ShootOff?
						stb		ShootDelay
						rts
						lda		SoundControl
ShootOff?				anda	#ResetShootSound
						sta		SoundControl
						rts
BaseHitSound?			ldx		BaseHitSoundPos
						cmpx	#Normal
						bne		PlayBase?
						ldx		#Start
PlayBase?				bsr		PlayBaseHitSound
						rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayRockHitSound
						bsr		SetupSound
						lda		,x+
						anda	#$FC
						anda	RockHitSoundState
						sta		$FF20
						stx		RockHitSoundPos
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayShootSound			bsr		SetupSound
						lda		#$FC
						sta		$FF20
						tfr		b,a
Loop3?					deca
						bne		Loop3?
						clra
						sta		$FF20
						addb	#$08
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlaySound
						bsr		SetupSound
						lda		#$FC
						sta		$FF20
						tfr		b,a
Loop?					deca
						bne		Loop?
						clra
						sta		$FF20
						addb	#$02
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayBaseHitSound		bsr		SetupSound
						lda		,x+
						anda	#$FC
						sta		$FF20
						stx		BaseHitSoundPos
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set up sound
; Code taken largely from William Barden's book
; Uses register a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetupSound				lda		$FF01	; select sound out
						anda	#$F7	; reset mux bit
						sta		$FF01	; store
						lda		$FF03	; select sound out
						anda	#$F7	; reset mux bit
						sta		$FF03	; store
						lda		$FF23	; Get PIA
						ora		#$08	; Get 6 bit sound enable
						sta		$FF23	; Store
						rts

