;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get a random number from 0 to 255
; returns in a
; Uses: a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Random					inc 	Randomx
						lda 	Randoma
						eora	Randomc
						eora	Randomx
						sta		Randoma
						lda		Randomb
						adda	Randoma
						sta		Randomb
						lsra
						eora	Randoma
						adda	Randomc
						sta 	Randomc
						rts

