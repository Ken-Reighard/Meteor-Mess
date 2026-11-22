;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hardware Register Equates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PIA0_DATA equ  $FF00       ; Joystick buttons & comparator
PIA0_CTLA equ  $FF01       ; Mux select: X-axis (0) or Y-axis (1)
PIA0_CTLB equ  $FF03       ; Mux select: Right stick (0) or Left stick (1)
PIA1_DATA equ  $FF20       ; 6-bit DAC output

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Keyboard Controls
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetKeyPress
						lda 	#$BF
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						bne		Left?
Rvel?					ldd		#BaseRightVel
						std		BaseXvelocity
						bra		Space?
Left?					lda 	#$DF
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						bne		None?
Lvel?					ldd		#BaseLeftVel
						std		BaseXvelocity
						bra		Space?
None?					ldd		#$0000
						std		BaseXvelocity
Space?
						lda 	#$7F
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						bne		Up?
						lda		LastShot
						bne		Up?
						lda		#$01
						sta		RequestShot
Up?
						lda		KeyDelay
						beq		CheckUp?
						deca
						sta		KeyDelay
						rts
CheckUp?
						lda 	#$F7
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						beq		DoKey?
						cmpa	#$3F
						bne		Exit?
DoKey?					lda		BaseSpeedState
						eora	#$01
						sta		BaseSpeedState
						bne		GoFast?
GoSlow?					ldd		#BaseRightVel
						std		Rvel?+1
						ldd		#BaseLeftVel
						std		Lvel?+1
						bra		ResetKeyDelay?
GoFast?					ldd		#BaseRightDblVel
						std		Rvel?+1
						ldd		#BaseLeftDblVel
						std		Lvel?+1
ResetKeyDelay?			lda		#$14
						sta		KeyDelay
Exit?					rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Digital Joystick Controls
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetJoystickDigital
						ldb		$FF23      ; Load control register
						andb	#$F7       ; Clear Bit 3 (CB2) to turn off sound enable
						stb		$FF23      ; Update $FF23
						ldb		PIA0_CTLA
						andb  	#$F7
						stb   	PIA0_CTLA

						ldb   	PIA0_CTLB
						orb   	#$08
						stb   	PIA0_CTLB

						lbsr   	ReadJoystick
IsLeft?					cmpa	#$0A
						bhi		IsRight?
Lvel?					ldd		#BaseLeftVel
						std		BaseXvelocity
						bra		CheckButton?
IsRight?				cmpa	#$35
						blo		None?
Rvel?					ldd		#BaseRightVel
						std		BaseXvelocity
						bra		CheckButton?
None?					ldd		#$0000
						std		BaseXvelocity
CheckButton?			lda		$FF00
						anda 	#$03
						eora	#$03
						beq		Button2?
						lda		LastShot
						bne		Button2?
						lda		#$01
						sta		RequestShot
Button2?
						lda		KeyDelay
						beq		CheckButton2?
						deca
						sta		KeyDelay
						rts
CheckButton2?
						lda		$FF00
						anda 	#$0C
						eora	#$0C
						bne   	DoSwitch?
;
						lda 	#$F7
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						beq		DoSwitch?
						cmpa	#$3F
						beq		DoSwitch?
						rts
;
DoSwitch?				lda		BaseSpeedState
						eora	#$01
						sta		BaseSpeedState
						bne		GoFast?
GoSlow?					ldd		#BaseRightVel
						std		Rvel?+1
						ldd		#BaseLeftVel
						std		Lvel?+1
						bra		ResetKeyDelay?
GoFast?					ldd		#BaseRightDblVel
						std		Rvel?+1
						ldd		#BaseLeftDblVel
						std		Lvel?+1
ResetKeyDelay?			lda		#$14
						sta		KeyDelay
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Joystick Successive Approximation
; Uses: a,b,s
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReadJoystick
						clra				; Clear running accumulator
						ldb		#$80        ; Start testing highest DAC bit (Bit 7)
						pshs	b           ; Store current mask bit on the stack
Loop?					tfr		a,b         ; Copy current confirmed value to B
						addb	,s          ; Add the current bit under test
						stb		PIA1_DATA   ; Send test pattern to DAC
						tst		PIA0_DATA   ; Check comparator status (Bit 7)
						bpl		TooHigh?    ; If Bit 7 is 0, test value was too high
						tfr		b,a         ; If Bit 7 is 1, keep the bit
TooHigh?				lsr		,s			; Shift test mask right to next bit
						ldb		,s          ; Fetch shifted bit
						cmpb	#$02        ; CoCo DAC stops at Bit 2 (6 bits total)
						bhi		Loop?       ; Loop if we still have bits left to test
						puls	b           ; Clean up stack mask
						lsra				; Shift result down 2 places
						lsra				; Value is now scaled properly to 0-63
						rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Analog Joystick Controls
; Uses: a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetJoystickAnalog
						ldb		$FF23      ; Load control register
						andb	#$F7       ; Clear Bit 3 (CB2) to turn off sound enable
						stb		$FF23      ; Update $FF23
						ldb		PIA0_CTLA
						andb  	#$F7
						stb   	PIA0_CTLA

						ldb   	PIA0_CTLB
						orb   	#$08
						stb   	PIA0_CTLB

						bsr   	ReadJoystick
						sta   	BaseXpos

						lda		$FF00
						anda 	#$03
						eora	#$03
						beq		Exit?
						lda		LastShot
						bne		Exit?
						lda		#$01
						sta		RequestShot
Exit?					rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets a joystick button or space press
; Uses: a,b
; Returns in a: 0 if no press, 1 if press space or button, 2 if 'C', 3 if 'H'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetSpaceButtonPress
						lda		$FF00
						anda 	#$03
						eora	#$03
						beq		CKey?
						lda		#$01
						rts
CKey?
						lda 	#$F7
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$7E
						bne		HKey?
						lda		#$02
						rts
HKey?
						lda 	#$FE
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$7D
						bne		Space?
						lda		#$03
						rts
Space?
						lda 	#$7F
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						bne		One?
						lda		#$01
						rts
One?					
						lda 	#$FC						
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$6F
						bne		Two?
						clra
						sta		LevelSet+1				
						jsr		ResetLevelThresh
						jmp		NoPress?
Two?					
						lda 	#$FB						
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$6F
						bne		Three?
						lda		#$01
						sta		LevelSet+1				
						jsr		ResetLevelThresh
						ldx		#LevelThreshTable
						ldd		#$0000
						std		,x
						std		2,x
						bra		NoPress?
Three?					
						lda 	#$F7						
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$6F
						bne		Four?
						lda		#$02
						sta		LevelSet+1				
						jsr		ResetLevelThresh
						ldx		#LevelThreshTable
						ldd		#$0000
						std		,x
						std		2,x
						std		4,x
						std		6,x
						bra		NoPress?
Four?					
						lda 	#$EF						
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$6F
						bne		Five?
						lda		#$03
						sta		LevelSet+1				
						jsr		ResetLevelThresh
						ldx		#LevelThreshTable
						ldd		#$0000
						std		,x
						std		2,x
						std		4,x
						std		6,x
						std		8,x
						std		10,x
						bra		NoPress?
Five?					
						lda 	#$DF						
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$6F
						bne		NoPress?
						lda		#$04
						sta		LevelSet+1				
						jsr		ResetLevelThresh
						ldx		#LevelThreshTable
						ldd		#$0000
						std		,x
						std		2,x
						std		4,x
						std		6,x
						std		8,x
						std		10,x
						std		12,x
						std		14,x
NoPress?
						clra
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets keyboard up, down, space or enter, or joystick button
; Uses: a,b
; Returns in a: 0 if no press, 1 if up, 2 if down, 3 if enter, space, or joystick button
; 4 if A key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetUpDownSpaceEnter
						lda		KeyDelay
						beq		Up?
						deca
						sta		KeyDelay
						clra
						rts
Up?
						lda 	#$F7
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						beq		DoUp?
						cmpa	#$3F
						bne		Down?
DoUp?					lda		#$14
						sta		KeyDelay
						lda		#$01
						rts
Down?					lda 	#$EF
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						beq		DoDown?
						cmpa	#$3F
						bne		Space?
DoDown?					lda		#$14
						sta		KeyDelay
						lda		#$02
						rts
Space?
						lda 	#$7F
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$77
						bne		Enter?
						lda		#$14
						sta		KeyDelay
						lda		#$03
						rts
Enter?
						lda 	#$FE
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$3F
						bne		AKey?
						lda		#$14
						sta		KeyDelay
						lda		#$03
						rts
AKey?
						lda 	#$FD
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$7E
						bne		GetJoystickDigital?
						lda		#$14
						sta		KeyDelay
						lda		#$04
						rts
GetJoystickDigital?
						ldb		PIA0_CTLA
						andb  	#$F7
						stb   	PIA0_CTLA
						ldb   	PIA0_CTLB
						orb   	#$08
						stb   	PIA0_CTLB
						lbsr   	ReadJoystick
IsLeft?					cmpa	#$0A
						bhi		IsRight?
						lda		#$14
						sta		KeyDelay
						lda		#$01
						rts
IsRight?				cmpa	#$35
						blo		CheckButton?
						lda		#$14
						sta		KeyDelay
						lda		#$02
						rts
CheckButton?
						lda		$FF00
						anda 	#$03
						eora	#$03
						beq		Exit?
						lda		#$14
						sta		KeyDelay
						lda		#$03
						rts
Exit?					clra
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Monitor Selection key press
; Uses: a
; Returns in a: 0 for nothing, 1 for R, 2 for C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetMonitorKeyPress
						lda 	#$FB
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$7B
						bne		CKey?
						lda		#$01
						rts
CKey?					lda 	#$F7
						sta 	$FF02
						lda 	$FF00
						anda	#$7F
						cmpa	#$7E
						bne		None?
						lda		#$02
						rts
None?					clra
						rts
						