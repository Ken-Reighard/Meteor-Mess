;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Object Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StackTop    			equ     $400					; Top end of stack space, grows down

InterruptRegister		equ		$FF03
InterruptOffMask		equ		%11111110
InterruptOnMask			equ		%00000001
ScreenXMiddle			equ		$20

GameStateNormal			equ		%00000001
GameStateExpolsion		equ		%00000010
GameStateWait			equ		%00000100
GameStateGameOver		equ		%00001000
GameStateTitle			equ		%00010000
GameStateControls		equ		%00100000
GameStateHighScores		equ		%01000000
GameStateHighScoreEntry	equ		%10000000
GameStateMonitor		equ		%00000000

ControlSettingJstkAnalog	equ	$00
ControlSettingJstkDigital	equ	$01
ControlSettingKeyboard		equ	$02

BigRock						STRUCT
Active						rmb		1						; 0 Inactive, 1 Active
Xpos						rmb		2						; MSB is whole and LSB fractional
Ypos						rmb		2						; MSB is whole and LSB fractional
Yvelocity					rmb		2						; MSB is whole and LSB fractional
Erase1						rmb		2						; Address to erase for work screen 0
EraseLine1					rmb		1
Erase2						rmb		2						; Address to erase for work screen 1
EraseLine2					rmb		1
Color						rmb		1						; Color
							ENDSTRUCT

SmallRock					STRUCT
Active						rmb		1						; 0 Inactive, 1 Active
Xpos						rmb		2						; MSB is whole and LSB fractional
Ypos						rmb		2						; MSB is whole and LSB fractional
Xvelocity					rmb		2						; MSB is whole and LSB fractional
Yvelocity					rmb		2						; MSB is whole and LSB fractional
Erase1						rmb		2						; Address to erase for work screen 0
EraseLine1					rmb		1
Erase2						rmb		2						; Address to erase for work screen 1
EraseLine2					rmb		1
Color						rmb		1						; Color
							ENDSTRUCT

Shot						STRUCT
Active						rmb		1						; 0 Inactive, 1 Active
Xpos						rmb		2						; MSB is whole and LSB fractional
Ypos						rmb		2						; MSB is whole and LSB fractional
Yvelocity					rmb		2						; MSB is whole and LSB fractional
Erase1						rmb		2						; Address to erase for work screen 0
Erase2						rmb		2						; Address to erase for work screen 1
							ENDSTRUCT

Bomb						STRUCT
Active						rmb		1						; 0 Inactive, 1 Active
Xpos						rmb		2						; MSB is whole and LSB fractional
Ypos						rmb		2						; MSB is whole and LSB fractional
Yvelocity					rmb		2						; MSB is whole and LSB fractional
Erase1						rmb		2						; Address to erase for work screen 0
Erase2						rmb		2						; Address to erase for work screen 1
							ENDSTRUCT

Spinner						STRUCT
Active						rmb		1						; 0 Inactive, 1 Active
Xpos						rmb		2						; MSB is whole and LSB fractional
Ypos						rmb		2						; MSB is whole and LSB fractional
Yvelocity					rmb		2						; MSB is whole and LSB fractional
Erase1						rmb		2						; Address to erase for work screen 0
Erase2						rmb		2						; Address to erase for work screen 1
							ENDSTRUCT
