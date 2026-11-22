;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mountain Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LevelMountainLookup		fcb		$8F,$AF,$EF,$DF,$9F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the Mountains
; Uses: a,x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMountain
						lda     #$80
						ldx		WorkScreen
						leax	MountainOffset,x
						sta		96,x
						sta		65,x
						sta		34,x
						sta		67,x
						sta		100,x
						sta		101,x
						sta		70,x
						sta		39,x
						sta		72,x
						sta		105,x
						sta		74,x
						sta		43,x
						sta		44,x
						sta		13,x
						sta		-18,x
						sta		-17,x
						sta		16,x
						sta		49,x
						sta		82,x
						sta		83,x
						sta		52,x
						sta		21,x
						sta		54,x
						sta		87,x
						sta		120,x
						sta		89,x
						sta		58,x
						sta		91,x
						sta		60,x
						sta		29,x
						sta		62,x
						sta		95,x
						rts
