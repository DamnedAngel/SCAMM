;----------------------------------------------------------
;		9938_hmmm.s - by Danilo Angelo, 2023
;
;		Implementation of 9938's HMMM command
;----------------------------------------------------------

.include "vdpportmacros.s"

.globl		_waitVdpReady

;----------------------------------------------------------
;	Executes HMMM (High speed move VRAM to VRAM).
;	Make sure to DI before calling
;	Input:
;		HL: Buffer to HMMM command data (14 bytes; dummy reg 44 included)
;			Please check section 4.4.3 of 9938's manual
;	Output: None
;	Changes: AF, BC, HL
;----------------------------------------------------------

_HMMM::
	ld_c_vdpOutPort 3, _HMMM	; 2nd port

	call	_waitVdpReady

	ld		a, #32
	vpd_OutA 2, _HMMMSetup
	ld		a, #17 + #0x80
	vpd_OutA 2, _HMMMSetup		; R17 <- 32

	.rept	14
	outi
	.endm

	ld		a, #0b11010000		; HMMM
	vpd_OutA 3, _HMMMSetup
	ret
