;----------------------------------------------------------
;		hmmctest.s - by Danilo Angelo, 2023
;
;		Test 9938's HMMC command
;----------------------------------------------------------

;.include "../SCAMM/MSX/VDP/vdpportmacros.s"

.globl	_HMMCSetup

_HMMCTest::
	di
	ld		hl, #16		; width
	ld		de, #16		; height
	ld		b, #0xfc	; first color
	exx
	ld		hl, #16		; x pos
	ld		de, #16		; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #0
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

	ld		b, #0
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

	ld		b, #0
	ld		a, #0x25
ddd:
	out		(c), a
	djnz	ddd

	ei
	ret

_showBackGround1::
	di
	ld		hl, #256	; width
	ld		de, #63		; height
	exx
	ld		hl, #0		; x pos
	ld		de, #12		; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #63

_showBackGround_end::
	ld		hl, #0x8008			; TODO: Remove hard coded address
_bg1_loop:
	push	bc
	ld		b, #0
	otir
	pop		bc
	djnz	_bg1_loop
	ret

_showBackGround2::
	di
	ld		hl, #256	; width
	ld		de, #63		; height
	exx
	ld		hl, #0		; x pos
	ld		de, #75		; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #63
	jr		_showBackGround_end

_showBackGround3::
	di
	ld		hl, #256	; width
	ld		de, #168-126; height
	exx
	ld		hl, #0		; x pos
	ld		de, #133	; y pos
	ld		b, #0		; direction
	call	_HMMCSetup

	ld		b, #168-126
	jr		_showBackGround_end