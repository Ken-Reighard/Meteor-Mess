;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Find the address offset for screen
; Input: a = x coordinate
;        b = y coordinate
; Returns address offset in d
; Uses register a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FindAddessOffset		clr 	AddessOffsetSaveData				; clear msb of save
						lsra
						inca
						sta		AddessOffsetSaveData+1				; Save x coord from a reg
						lda		#BytesPerLine						; get the bytes per line on the screen
						mul											; find the line one the screen
						addd	AddessOffsetSaveData				; add the x coord
Exit?					rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Find the address offset for screen if a may be negative
; Input: a = x coordinate assumes cc is set for a
;        b = y coordinate
; Returns address offset in d
; Uses register a,b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FindAddessOffsetNeg
						bmi		Negative?
						bra		FindAddessOffset
Negative?				nega
						inca
						lsra
						sta		Subtract?+2
						clra
						bsr		FindAddessOffset
Subtract?				subd	#$00FF
						rts
