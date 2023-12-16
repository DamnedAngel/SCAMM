; ----------------------------------------------------------
;	color.s - by DamnedAngel, 2023
;
;	Changes screen color
; ----------------------------------------------------------

.include "MSX/BIOS/msxbios.s"

	.area _CODE
    
;----------------------------------------------------------
;	Set screen colors
;	void color (unsigned char foreground, unsigned char background, unsigned char border)
;	input:
;       A: foreground
;       L: background
;       (SP+2): border
;	output:		none
;	changes:	all regs
;----------------------------------------------------------
_color::
    ld      b, l
    ld      hl, #BIOS_FORCLR
    ld      (hl), a
    inc     hl                  ; BIOS_BAKCLR
    ld      (hl), b
    push    ix
    ld      ix, #0
    add     ix, sp
    ld      a, 4(ix)
    inc     hl                  ; BIOS_BDRCLR
    ld      (hl), a      
	ld		ix, #BIOS_CHGCLR
	ld		iy, (BIOS_ROMSLT)
	call	BIOS_CALSLT
	pop		ix

    ; clean stack (sdcccall 1)
    pop     hl
    inc     sp
    push    hl
	ret