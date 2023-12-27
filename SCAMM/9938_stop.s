;----------------------------------------------------------
;		9938_stop.s - by Danilo Angelo, 2023
;
;		Implementation of 9938's STOP command
;----------------------------------------------------------

.include "MSX/VDP/vdpportmacros.s"

_9938Stop::
	ld		a, #46
	vdp_OutA 1, _9938Stop			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _9938Stop			; R17 <- 46
    xor     a                       ; STOP!
	vdp_OutA 3, _9938Stop			; Reg 46 (execute)
    ret