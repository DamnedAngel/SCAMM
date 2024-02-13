;----------------------------------------------------------
;		9938_hmmc.s - by Danilo Angelo, 2023
;
;		Implementation of 9938's HMMC command
;----------------------------------------------------------

.include "MSX/VDP/vdpportmacros.s"

.globl		_waitVdpReady

;----------------------------------------------------------
;	Sets HMMC (High speed move CPU to VRAM) up.
;	Make sure to DI before calling
;	Input:
;		HL:		X pos (regs 36-37)
;		DE:		Y pos (regs 38-39)
;		B: 		Direction (Reg 45)
;		HL':	Width (regs 40-41)
;		DE':	Height (regs 42-43)
;		B':		First Color (reg 44)
;		Please check section 4.4.1 of 9938's manual
;	Output: C: 3rd VDP port
;	Changes: AF, BC, HL, invert (EXX)
;----------------------------------------------------------
_HMMCSetup::
	ld_c_vdpOutPort 3, _HMMCSetup	; 4th port
	exx
	ld_c_vdpOutPort 3, _HMMCSetup	; 4th port
	exx

	call	_waitVdpReady
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

	out		(c), e					; Reg 42 (Height lo (+1))
	out		(c), d					; Reg 43 (Height hi)
	out		(c), b					; Reg 44 (Color, dummy)

	exx
	out		(c), b					; Reg 45 (Direction)

	ld		a,	#0b11110000			; HMMC
	out		(c), a					; Reg 46 (execute, dummy)

	exx
;	ld		a, l
;	vdp_OutA 1, _HMMCSetup			; 2nd port
;	ld		a, #40 + 0x80
;	vdp_OutA 1, _HMMCSetup			; Repeat Reg 40 (Width lo)
;
;	ld		a, e
;	vdp_OutA 1, _HMMCSetup			; 2nd port
;	ld		a, #42 + 0x80
;	vdp_OutA 1, _HMMCSetup			; Repeat Reg 42 (Height lo)

	ld		a, #0b11110000
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #46 + 0x80
	vdp_OutA 1, _HMMCSetup			; Repeat Reg 46 (execute, for real)

	; prepare to receive data
	ld		a, #44 + 0x80
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 44, no increment
	
	ret
