;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VSYNC Frequency settings for timer interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PAL         			equ		50						; PAL region uses 50hz for VSYNC
NTSC        			equ		60						; NTSC region uses 60hz for VSYNC
VsyncFreq   			equ		NTSC					; Change this to either NTSC or PAL depending on your region

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; IRQ Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IRQvector				equ		$010D					; the address of the jump on IRQ
IRQdisable				equ		%01010000				; disable the fast & normal Interrupts.
IRQenable				equ		%11101111				; enble the fast & normal Interrupts.
HSYNCregister			equ		$FF01					; detect HSYNC here
HSYNCdisable			equ		%11111110				; value to disable HSYNC
VSYNCregister			equ		$FF03					; detect VSYNC here
VSYNCenable				equ		%00000001				; value to enable VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set up interrupts
; Code taken largely from Glen Hewlett's blog
; uses registers a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IrqSetup			    orcc	#IRQdisable  					; Disable the IRQ and FIRQ
																; Setup Vectored IRQ using VSYNC
						ldx		IRQvector
						stx		OrigIrqVector
						ldx		#StartIrq						; Load X with the pointer value of our IRQ routine
						stx     IRQvector						; Store the new IRQ address location
						lda     HSYNCregister					; PIA 0 side A control reg - PIA0AC
						anda    #HSYNCdisable					; Clear bit 0 - HSYNC IRQ Disabled
						sta     HSYNCregister					; Save settings
						lda		$FF00
						lda     VSYNCregister					; PIA 0 side B control reg - PIA0BC
						ora     #VSYNCenable					; VSYNC IRQ enabled
						sta     VSYNCregister					; Save Settings
						andcc	#IRQenable						; = %11101111 this will Enable the IRQ to start
						lda		$FF02							; PIA 0 side B data register - PIA0BD We need to either CLR  $FF02, TST  $FF02 or LDA,LDB  $FF02 to activate the IRQ now and every time inside the IRQ too.
																; Glen uses LDA because it is only 2 CPU cycles. "Acknowledge the VSYNC IRQ"
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle the IRQ
; Code taken largely from Glen Hewlett's blog
; Uses register a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartIrq				tst		VSYNCregister					; Check for (VSYNC) Interrupt bit 7 of $FF03 is set to 1 when the VSYNC is triggered
						bpl		Exit?							; Not a VSYNC, exit
						lda     $FF02							; acknowlege Irq
						jsr	    ChangeScreen    				; display the right screen
						clr     SwitchScreen    				; reset the switch screen flag
Exit?					rti

