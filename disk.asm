;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read scores from disk
;
; Uses: a,b,x,y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReadScores				
						ldx		OrigIrqVector						; Load X with the pointer value of our IRQ routine
						stx     IRQvector						; Store the new IRQ address location
						ldy		$C006					; get address of table
						lda		#$02
						sta		,y						; read
						clra
						sta		1,y						; drive 0
						lda		#$22
						sta		2,y						; track 34
						lda		#$0A
						sta		3,y						; sector 10
						ldd		#Buffer
						std		4,y						; buffer address
						pshs	a,cc,dp
						clra
						tfr		a,dp
						jsr		[$C004]					; read
						puls	a,cc,dp
						ldd		Buffer
						cmpd	#$4D4D
						bne 	UpdateGat?
						ldy		#Marker
						ldx		#Buffer
						ldb		#$29
Next?					lda		,x+
						sta		,y+
						decb
						bne		Next?
						clr		$FF40					; stop motor
						ldx		#StartIrq						; Load X with the pointer value of our IRQ routine
						stx     IRQvector						; Store the new IRQ address location
						rts
UpdateGat?				ldy		$C006					; get address of table
						lda		#$02
						sta		,y						; read
						clra
						sta		1,y						; drive 0
						lda		#$11
						sta		2,y						; track 17
						lda		#$02
						sta		3,y						; sector 2
						ldd		#Buffer
						std		4,y						; buffer address
						pshs	a,cc,dp
						clra
						tfr		a,dp
						jsr		[$C004]					; read
						puls	a,cc,dp
						ldx		#Buffer
						lda		#$C1
						sta		$43,x
						lda		#$03
						sta		,y						; write
						clra
						sta		1,y						; drive 0
						lda		#$11
						sta		2,y						; track 17
						lda		#$02
						sta		3,y						; sector 2
						ldd		#Buffer
						std		4,y						; buffer address
						pshs	a,cc,dp
						clra
						tfr		a,dp
						jsr		[$C004]					; write
						puls	a,cc,dp
UpdateDir?
						ldy		$C006					; get address of table
						lda		#$02
						sta		,y						; read
						clra
						sta		1,y						; drive 0
						lda		#$11
						sta		2,y						; track 17
						lda		#$03
						sta		3,y						; sector 3
						ldd		#Buffer
						std		4,y						; buffer address
						pshs	a,cc,dp
						clra
						tfr		a,dp
						jsr		[$C004]					; read
						puls	a,cc,dp
						ldx		#Buffer+$60
						ldd		#$4849
						std		,x++
						ldd		#$5343
						std		,x++
						ldd		#$4F52
						std		,x++
						ldd		#$4553
						std		,x++
						ldd		#$4441
						std		,x++
						lda		#$54
						sta		,x+
						ldd		#$01FF
						std		,x++
						lda		#$43
						sta		,x+
						ldd		#$0029
						lda		#$03
						sta		,y						; write
						clra
						sta		1,y						; drive 0
						lda		#$11
						sta		2,y						; track 17
						lda		#$03
						sta		3,y						; sector 3
						ldd		#Buffer
						std		4,y						; buffer address
						pshs	a,cc,dp
						clra
						tfr		a,dp
						jsr		[$C004]					; write
						puls	a,cc,dp
						clr		$FF40					; turn off motor
						ldx		#StartIrq						; Load X with the pointer value of our IRQ routine
						stx     IRQvector						; Store the new IRQ address location
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write scores to disk
;
; Uses: a,b,x,y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WriteScores				
						ldx		OrigIrqVector						; Load X with the pointer value of our IRQ routine
						stx     IRQvector						; Store the new IRQ address location
						ldy		#Buffer
						ldx		#Marker
						ldb		#$29
Next?					lda		,x+
						sta		,y+
						decb
						bne		Next?
						ldy		$C006					; get address of table
						lda		#$03
						sta		,y						; write
						clra
						sta		1,y						; drive 0
						lda		#$22
						sta		2,y						; track 34
						lda		#$0A
						sta		3,y						; sector 10
						ldd		#Buffer
						std		4,y						; buffer address
						pshs	a,cc,dp
						clra
						tfr		a,dp
						jsr		[$C004]					; write
						puls	a,cc,dp
Exit?					clr		$FF40					; turn off motor
						ldx		#StartIrq						; Load X with the pointer value of our IRQ routine
						stx     IRQvector						; Store the new IRQ address location
						rts

Buffer					rmb		256						; disk buffer