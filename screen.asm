;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphic Mode Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VertScrollReg			equ		$FF9C					; Vertical scroll register for CoCo 3
VSRSG12					equ		$09						; Vertical scroll register setting for SG12
VDGPort					equ		$FF22					; I/O port for control bits for VDG
SG12AndValue			equ		%00000111				; And Value to set SG12
SAMvregs				equ     $FFC0           		; SAM's V-mode registers (3-Bits)
SAMvregsBC				equ		3						; Number of bits for V-mode
SAMpmode4				equ		%100					; Graphics Pmode4 for setting the V1,V2 & V3
SAMmemLoc				equ		$FFC6					; Sam's Video Address registers (7-Bits)
SAMmemLocBC				equ		7						; Number of bits for V-address

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Screen Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScreenMemory			equ    	$0E00					; start of screen memory
ScreenSize				equ		$0C00					; size of screen in memory
Screen1Loc				equ		ScreenMemory			; The first screen in memory
Screen2Loc				equ		Screen1Loc+ScreenSize	; Start of second screen in memory
MountainOffset			equ		$0940
BytesPerLine 			equ		$20						; bytes per line of screen
BlackBlock				equ		$80						; Black byte
DoubleBlackBlock		equ		$8080					; Black word

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ChangeScreen - Reads the status of changing the screen being display
; Code shamelessly stolen from Steve Bjork (if ya gonna steal...)
; SwitchScreen - 0=do noting, 1=Switch to first graphics screen, 2=other screen.
; A, B, X are used used
; Call SetSAMdata
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ChangeScreen			ldb		SwitchScreen					; Is the screen switch flag set?
						beq		ChScrExit						; no then exit.
						lda		#ScreenSize/512					; Get size of a graphics screen
						decb									; 0=first screen, 1=second screen
						mul										; Get SAM's
						addb	#Screen1Loc/512					; move to the start of screen buffers
						lda		#SAMmemLocBC					; Get bit count set
						ldx		#SAMmemLoc						; Get the SAM register to set
;Now, fall in to the SetSAMdata Subroutine (Save a BSR and RTS)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This Subroutine set the SAM chip registers
; Code shamelessly stolen from Steve Bjork (if ya gonna steal...)
; A Register = The number of bits to set
; B Register = The bits to feed into the SAM
; X Register = The address of the first bit to set.
; Only A,B and X are used. They are changed.
; All other registers unchanged
; On the SAM, the even address clears the bit and odd location set it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetSAMdata				lsrb									; move the lower bit of data into the carry flag
						bcs		OddLoc?							; skip if the bit was set
						sta		,x++							; store at even address was 0 and skip two
						bra		CheckCount?						; and then skip
OddLoc?					leax	1,x								; move to odd address
						sta		,x+								; and store there and move pointer by 1
CheckCount?				deca									; any more bits to do?
						bne		SetSAMdata
ChScrExit				rts										; no, then exit setting up SAM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set up graphic mode
; Uses: a,b,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetUpGraphicMode		lda		#VSRSG12						; Get vertical scroll register value for SG12
						sta		VertScrollReg					; Set vertical scroll register
						lda		VDGPort							; Get VDG Port value
						anda	#SG12AndValue					; Reset upper 5 bits for SG12
						sta		VDGPort							; Update VDG Port value
						ldb		#SAMpmode4						; Get the Pmode4 bits to send to the SAM Chip
						lda		#SAMvregsBC						; Get the number of bit to sent it
						ldx		#SAMvregs						; Get the address of V1,V2 & V3 to set
						bsr		SetSAMdata						; This call sets those bit
						clr		SwitchScreen					; Set not to switch screen
						inc		SwitchScreen					; Set switch to screen 1
						clr		WorkScreen						; Set to work screen 1
						ldd		#Screen1Loc						; Get address of first screen
						std		WorkScreen						; Set to work screen pointer
						bsr		ChangeScreen
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Puts the blank blocks in both screen memory areas
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearScreens
						bsr	ClearScreensScore
						bra	ClearScreensTop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Puts the blank blocks in both screen memory areas
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearScreensScore		ldd		#DoubleBlackBlock
						ldx 	#Screen1Loc+ScreenSize-(BytesPerLine*8)
Loop?					std		ScreenSize,x
						std		,x++
						cmpx	#Screen1Loc+ScreenSize
						blo		Loop?
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Puts the blank blocks in both screen memory areas except score line
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearScreensTop			ldd		#DoubleBlackBlock
						ldx 	#Screen1Loc
Loop?					std		ScreenSize,x
						std		,x++
						cmpx	#Screen1Loc+ScreenSize-(BytesPerLine*9)
						blo		Loop?
						ldd		#$CFCF
Loop2?					std		ScreenSize,x
						std		,x++
						cmpx	#Screen1Loc+ScreenSize-(BytesPerLine*8)
						blo		Loop2?
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Puts the blank blocks in both screen memory areas except score line
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetScreensTopBlack		ldd		#DoubleBlackBlock
						bra		Start?
SetScreensTopRed		ldd		#$BFBF
Start?					std		SetD?+1
						std		SetD2?+1
						std		SetX?+1
						std		SetY?+2
						std		SetU?+1
						lda		#$2B
						sta		TempByte0
						lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
						sts		SaveSp
						ldd		#ScreenSize-(BytesPerLine*9)
						lds 	#Screen1Loc
						leas	d,s
SetD?					ldd		#DoubleBlackBlock
SetX?					ldx		#DoubleBlackBlock
SetY?					ldy		#DoubleBlackBlock
SetU?					ldu		#DoubleBlackBlock
Loop1?					pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						dec 	TempByte0
						bne		Loop1?
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						ldd		#ScreenSize-(BytesPerLine*9)
						lds 	#Screen2Loc
						leas	d,s
						lda		#$2B
						sta		TempByte0
SetD2?					ldd		#DoubleBlackBlock
Loop2?					pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						dec 	TempByte0
						bne		Loop2?
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						pshs	d,x,y,u
						lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

