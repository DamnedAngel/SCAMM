; ----------------------------------------------------------
;	screen.s - by DamnedAngel, 2023
;
;	Changes screen mode
; ----------------------------------------------------------

.include "MSX/BIOS/msxbios.s"

	.area _CODE

;----------------------------------------------------------
;	Set Screen Mode
;	void Screen(unsigned char mode)
;	input:		A: Screen mode
;	output:		none
;	changes:	all regs
;----------------------------------------------------------
_screen::
	ld 		hl, #BIOS_SCRMOD
	ld 		(hl),a

	ld		hl,	#BIOS_DPPAGE
	xor		a
	ld		(hl), a
	inc		hl					; BIOS_ACPAGE
	ld		(hl), a

	push	ix					; by sdcc standard, ix must be preserved by the callee
	ld		ix, #BIOS_CHGMOD
	ld		iy, (BIOS_ROMSLT)
	call	BIOS_CALSLT
	pop		ix
	ret