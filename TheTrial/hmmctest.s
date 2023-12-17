;----------------------------------------------------------
;		hmmctest.s - by Danilo Angelo, 2023
;
;		Test 9938's HMMC command
;----------------------------------------------------------

.include "../SCAMM/vdpportmacros.s"

.globl	_HMMCSetup

_HMMCTest::
	di;
	ld		hl, #16		; width
	ld		de, #16		; height
	ld		b, #0xfc	; first color
	exx
	ld		hl, #16		; x pos
	ld		de, #16		; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #0xff
	ld		a, #3
hhh:
	out		(c), a
	djnz	hhh


	ld		hl, #32		; width
	ld		de, #8		; height
	ld		b, #0x1c	; first color
	exx
	ld		hl, #58		; x pos
	ld		de, #40		; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #0xff
	ld		a, #0xff
ggg:
	out		(c), a
	djnz	ggg

next1:
	ld		hl, #4		; width
	ld		de, #64		; height
	ld		b, #0xe0	; first color
	exx
	ld		hl, #200	; x pos
	ld		de, #100	; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #0xff
	ld		a, #0x25
ddd:
	out		(c), a
	djnz	ddd

	ei
	ret
