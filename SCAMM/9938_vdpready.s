;----------------------------------------------------------
;		9938_vdpready.s - by Danilo Angelo, 2023
;
;		Getting 9938's vdpReady
;----------------------------------------------------------

.include "MSX/VDP/vdpportmacros.s"

;----------------------------------------------------------
;	Test if VDP is ready to receive commands.
;	Make sure to DI before calling
;	Input: None
;	Output: Zero flag: VDP Ready
;	Changes: a
;----------------------------------------------------------
_isVdpReady::
	ld		a, #2
	vdp_OutA, 1, _isVdpReady
	ld		a,	#128 + #15
	vdp_OutA, 1, _isVdpReady
	vdp_InA, 1, _isVdpReady
	and		#1
	ret

;----------------------------------------------------------
;	Wait until VDP ready.
;	Make sure to DI before calling
;	Input: None
;	Output: None
;	Changes: a
;----------------------------------------------------------
_waitVdpReady::
	ld		a,#2
	vdp_OutA, 1, _isVdpReady
	ld		a, #15 + #0x80
	vdp_OutA, 1, _isVdpReady
	vdp_InA, 1, _isVdpReady
	and		#1
	jp	nz, _waitVdpReady

	xor	a
	vdp_OutA, 1, _isVdpReady
	ld		a, #15 + #0x80
	vdp_OutA, 1, _isVdpReady
	ret
