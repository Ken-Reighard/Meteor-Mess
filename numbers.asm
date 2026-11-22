;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Number Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ScoreLine					equ		($5D*BytesPerLine)+2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw the number
; b position
; a digit
; Uses: a,b,s,u
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawNumber
						std		TempWord1
						lda		InterruptRegister
						anda	#InterruptOffMask
						sta		InterruptRegister
						sts		SaveSp
						lda		TempByte2
						lsla
						lds		#Numbers
						lds		a,s
						clra
						lslb
SetScoreLine			addd	#ScoreLine
						ldu		WorkScreen
						leau	d,u
						puls	d
						pshu	d
						leau	-30,u
						puls	d
						pshu	d
						leau	-30,u
						puls	d
						pshu	d
						leau	-30,u
						puls	d
						pshu	d
						leau	-30,u
						puls	d
						pshu	d
						lds		SaveSp
						lda		InterruptRegister
						ora		#InterruptOnMask
						sta		InterruptRegister
						rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Number Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Numbers
						fdb		ZeroData
						fdb		OneData
						fdb		TwoData
						fdb		ThreeData
						fdb		FourData
						fdb		FiveData
						fdb		SixData
						fdb		SevenData
						fdb		EightData
						fdb		NineData
						fdb		BlankData

NumbersData
ZeroData
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$9A,$9A
						fcb		$9A,$9A
						fcb		$9F,$9A
OneData
						fcb		$95,$90
						fcb		$95,$90
						fcb		$95,$90
						fcb		$95,$90
						fcb		$95,$90
TwoData
						fcb		$9F,$9A
						fcb		$9A,$90
						fcb		$9F,$9A
						fcb		$90,$9A
						fcb		$9F,$9A
ThreeData
						fcb		$9F,$9A
						fcb		$90,$9A
						fcb		$95,$9A
						fcb		$90,$9A
						fcb		$9F,$9A
FourData
						fcb		$90,$9A
						fcb		$90,$9A
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$9A,$9A
FiveData
						fcb		$9F,$9A
						fcb		$90,$9A
						fcb		$9F,$9A
						fcb		$9A,$90
						fcb		$9F,$9A
SixData
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$9F,$9A
						fcb		$9A,$90
						fcb		$9F,$9A
SevenData
						fcb		$90,$9A
						fcb		$90,$9A
						fcb		$90,$9A
						fcb		$90,$9A
						fcb		$9F,$9A
EightData
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$9F,$9A
NineData
						fcb		$90,$9A
						fcb		$90,$9A
						fcb		$9F,$9A
						fcb		$9A,$9A
						fcb		$9F,$9A
BlankData
						fcb		$90,$90
						fcb		$90,$90
						fcb		$90,$90
						fcb		$90,$90
						fcb		$90,$90
