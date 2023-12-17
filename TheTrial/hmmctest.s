;----------------------------------------------------------
;		hmmctest.s - by Danilo Angelo, 2023
;
;		Test 9938's HMMC command
;----------------------------------------------------------

.include "../SCAMM/vdpportmacros.s"

.globl	_HMMCFirstSetup
.globl	_HMMCSetup
.globl	_HMMCSetup1
.globl	_HMMCSetup2
.globl  _9938Stop

_HMMCTest::
	di;
	ld		hl, #16		; width
	ld		de, #16		; height
	ld		b, #0		; direction
	exx
	ld		hl, #16		; x pos
	ld		de, #16		; y pos
	call	_HMMCFirstSetup

	ld		b, #0
	ld		a, #255
hhh:
	out		(c), a
	djnz	hhh


	ld		hl, #32		; width
	ld		de, #8		; height
	ld		b, #0		; direction
	exx
	ld		hl, #8		; x pos
	ld		de, #20		; y pos

	call	_HMMCSetup

	ld		b, #0
	ld		a, #73
ggg:
	out		(c), a
	djnz	ggg

	call	_9938Stop

	ei
	ret
