;----------------------------------------------------------
;		9938_hmmc.s - by Danilo Angelo, 2023
;
;		Implementation of 9938's HMMC command
;----------------------------------------------------------

.include "vdpportmacros.s"

.globl		_waitVdpReady


;----------------------------------------------------------
;	Sets First HMMC (High speed move CPU to VRAM) of a HMMC 
; 	chain up.
;	Make sure to DI before calling
;	Input:
;		HL:		X pos (regs 36-37)
;		DE:		Y pos (regs 38-39)
;		HL':	Width (regs 40-41)
;		DE':	Height (regs 42-43)
;		B:		Direction (reg 45)
;		Please check section 4.4.1 of 9938's manual
;	Output: C: 3rd VDP port
;	Changes: AF, BC, HL
; 	Note: possible to optimize unrolling _HMMCSetup.
;----------------------------------------------------------
_HMMCFirstSetup::
	ld_c_vdpOutPort 3, _HMMCFirstSetup	; 4th port
	exx
	ld_c_vdpOutPort 3, _HMMCFirstSetup	; 4th port
	exx

	call	_waitVdpReady
	call	_HMMCSetup

	exx

;----------------------------------------------------------
;	Sets following HMMCs (High speed move CPU to VRAM) in a
; 	HMMC chain up.
;	Make sure to DI before calling, and to call _9938Stop 
; 	after the last HMMC of the chain.
;	Input:
;		HL:		X pos (regs 36-37)
;		DE:		Y pos (regs 38-39)
;		HL':	Width (regs 40-41)
;		DE':	Height (regs 42-43)
;		B:		Direction (reg 45)
; 		C: 		2nd port of the VDP.
;		Please check section 4.4.1 of 9938's manual
;	Output: C: 3rd VDP port
;	Changes: AF, BC, HL
;----------------------------------------------------------
_HMMCSetup::

	ld		a, #36
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 36

	out		(c), l					; Reg 36 (X lo)
	out		(c), h					; Reg 37 (X hi)	
	out		(c), e					; Reg 38 (Y lo)
	out		(c), d					; Reg 39 (Y hi)
	exx
	out		(c), l					; Reg 40 (Width lo)
	out		(c), h					; Reg 41 (Width hi)
	ld		a, e
	inc		a						; avoid command to reach the end, allowing command chain
	out		(c), a					; Reg 42 (Height lo (+1))
	out		(c), d					; Reg 43 (Height hi)
	out		(c), a					; Reg 44 (Color, dummy)
	out		(c), b					; Reg 45 (Direction)

	ld		a,	#0b11110000			; HMMC
	out		(c), a					; Reg 46 (execute, dummy)

	; prepare to receive data
	ld		a, #44 + 0x80
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 44, no increment

	ret
