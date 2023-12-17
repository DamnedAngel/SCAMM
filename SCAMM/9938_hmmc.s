;----------------------------------------------------------
;		9938_hmmc.s - by Danilo Angelo, 2023
;
;		Implementation of 9938's HMMC command
;----------------------------------------------------------

.include "vdpportmacros.s"

.globl		_waitVdpReady

;----------------------------------------------------------
;	Sets HMMC (High speed move CPU to VRAM) up.
;	Make sure to DI before calling
;	Input:
;		HL: HMMC command registry data buffer. 10 bytes:
;			- regs 36 to 45; dummy reg 44 included
;			Please check section 4.4.1 of 9938's manual
;	Output: C: 3rd VDP port, HL points to next byte after 
;				registry data buffer
;	Changes: AF, BC, HL
;----------------------------------------------------------

_HMMCSetupBuffer::
	ld_c_vdpOutPort 3, _HMMCSetupBuffer	; 2nd port

	call	_waitVdpReady
	
	ld		a, #36
	vdp_OutA 2, _HMMCSetupBuffer
	ld		a, #17 + 0x80
	vdp_OutA 2, _HMMCSetupBuffer		; R17 <- 32

	.rept	10
	outi
	.endm
	ret


;----------------------------------------------------------
;	Sets HMMC (High speed move CPU to VRAM) up.
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
;----------------------------------------------------------

_HMMCSetupOld::
	ld_c_vdpOutPort 3, _HMMCSetup	; 4th port
	exx
	ld_c_vdpOutPort 3, _HMMCSetup	; 4th port
	exx

	call	_waitVdpReady
	
	ld		a, #36
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 32

	out		(c), l					; Reg 36 (X lo)
	out		(c), h					; Reg 37 (X hi)	
	out		(c), e					; Reg 38 (Y lo)
	out		(c), d					; Reg 39 (Y hi)
	exx
	out		(c), l					; Reg 40 (Width lo)
	out		(c), h					; Reg 41 (Width hi)
	out		(c), e					; Reg 42 (Height lo)
	out		(c), d					; Reg 43 (Height hi)
	out		(c), a					; Reg 44 (Color, dummy)
	out		(c), b					; Reg 45 (Direction)
	ld		a,	#0b11110000			; HMMC
	out		(c), a					; Reg 46 (execute, dummy)

	; forces VDP to wait for first byte of data again
	ld		a, #40
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 40
	out		(c), l					; Reg 40 (Width lo)
	out		(c), h					; Reg 41 (Width hi)
	out		(c), e					; Reg 42 (Height lo)
	ld		a, #46
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 46
	ld		a,	#0b11110000			; HMMC
	out		(c), a					; Reg 46 (execute, dummy)
	ld		a, #44 + 0x80
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 44, no increment

	exx
	ret	



_HMMCSetup1::
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
	xor		a
	out		(c), c					; Reg 40 (Width lo)
	out		(c), a					; Reg 41 (Width hi)
	out		(c), c					; Reg 42 (Height lo)
	out		(c), a					; Reg 43 (Height hi)
	out		(c), a					; Reg 44 (Color, dummy)
	out		(c), a					; Reg 45 (Direction)
	ld		a,	#0b11110000			; HMMC
	out		(c), a					; Reg 46 (execute, dummy)

	ret

_HMMCSetup2::
	; forces VDP to wait for first byte of data again
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
	inc		a
	out		(c), a					; Reg 42 (Height lo)
	out		(c), d					; Reg 43 (Height hi)
	out		(c), a					; Reg 44 (Color, dummy)
	out		(c), b					; Reg 45 (Direction)
	ld		a,	#0b11110000			; HMMC
	out		(c), a					; Reg 46 (execute, dummy)

	ld		a, #44 + 0x80
	vdp_OutA 1, _HMMCSetup			; 2nd port
	ld		a, #17 + 0x80
	vdp_OutA 1, _HMMCSetup			; R17 <- 44, no increment

	ret

_HMMCFirstSetup::
	ld_c_vdpOutPort 3, _HMMCFirstSetup	; 4th port
	exx
	ld_c_vdpOutPort 3, _HMMCFirstSetup	; 4th port
	exx

	call	_waitVdpReady
	call	_HMMCSetup

	exx

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
	out		(c), a					; Reg 42 (Height lo)
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

;.ifdef HMMC
;----------------------------------------------------------
;	Sets HMMC (High speed move CPU to VRAM) up.
;	Make sure to DI before calling
;	Input:
;		HL: HMMC command setup data buffer. 14 bytes:
;			- regs 36 to 45; dummy reg 44 included
;			- a pointer to data in the end
;			- number of bytes to transfer
;			Please check section 4.4.1 of 9938's manual
;	Output: C: 3rd VDP port
;	Changes: AF, BC, HL
;----------------------------------------------------------
;_HMMC::
;	call	_HMMCSetup

;	ld		b, (hl)
;	inc		hl
;	ld		e, (hl)
;	xor		a
;	cp		b
;	jp z,	_HMMC_getBufferPointer
;	inc		e

;_HMMC_getBufferPointer
;	inc		hl
;	ld		a, (hl)
;	inc		hl
;	ld		h, (hl)
;	ld		l, a				; HL -> data

;	ld		a, #44 + #0x80		; auto-increment disabled
;	vpd_OutA 2, _HMMC
;	ld		a, #17 + #0x80
;	vpd_OutA 2, _HMMC
;	outi
;	ld		a, #0b11110000		; HMMC
;	vpd_OutA 3, _HMMC

;_HMMC_loop

;	ld		a, #0b11010000		; HMMM
;	out    (c), a				; execute
;	ret
;.endif
