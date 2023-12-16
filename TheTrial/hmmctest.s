;----------------------------------------------------------
;		hmmctest.s - by Danilo Angelo, 2023
;
;		Test 9938's HMMC command
;----------------------------------------------------------

.include "..\SCAMM\vdpportmacros.s"

.globl	_HMMCSetup

_HMMCTest::
	di
	ld		hl, #16		; width
	ld		de, #16		; height
	ld		b, #0		; direction
	exx
	ld		hl, #16		; x pos
	ld		de, #16		; y pos
	call	_HMMCSetup

	ld		b, #0
	ld		a, #255
hhh:
	out		(c), a
	djnz	hhh
	ret
	otir
	ei
	ret
