; ----------------------------------------------------------------
;	virtualmemory_h.s
; ----------------------------------------------------------------
;	240114 - DamnedAngel
; ----------------------------------------------------------------
;	Scamm Vistual Memory System
; ----------------------------------------------------------------

.include "MSX/BIOS/msxbios.s"
.include "printinterface.s"
.include "damnlib_h.s"



MAPPER_DEVICE_ID			= 4
MAX_NUMBER_OF_SEGMENTS		= 8 * 256						; 256 equals do máx of 4Mb
SEGMENT_TABLE_SIZE			= 2 * MAX_NUMBER_OF_SEGMENTS	; in bytes
MAX_MEMORY_SUPPORTED		= 16 * MAX_NUMBER_OF_SEGMENTS	; in Kbytes
MAPPER_DATA_AREA_ADDR		= 0xc000

;   ==================================
;   ========== CODE SEGMENT ==========
;   ==================================
	.area _CODE
    
; ----------------------------------------------------------------
;	- Init Scamm Virtual Memory System.
; ----------------------------------------------------------------
; INPUTS:
;	- None.
;
; OUTPUTS:
;   - None.
;
; CHANGES:
;   - All registers
; ----------------------------------------------------------------
_initSVMS::
	push	ix

	; init mapper mgr
	print	initializingMapperMsg
	ld		a, #MAPPER_DEVICE_ID
	call	_InitRamMapperInfo

	; get mapperBaseTable address
	call	_GetRamMapperBaseTable
	ex		de, hl
	ld		(#_pMapperBaseTable), hl
	print	okMsg

	print	maxMemorySupportedMsg
	ld		hl, #MAX_MEMORY_SUPPORTED
	call	_PrintDec
	print	kiloBytesMsg

	; allocate all available segments up to MAX_NUMBER_OF_SEGMENTS
	; Note: allocate all other segments needed
	; by the application BEFORE calling _initSVMS!
	print	allocatingSegmentsMsg
	ld		hl, #_segmentTable
	push	hl

_initSVMS_segAllocLoop:
	di
	ld		hl, (#_pMapperBaseTable)
	ld		a, (hl)					; primary mapper slot
	or		#0b00100000				; Try to allocate specified slot and, if it failed, try another slot (if any)
	ld		l, a
	xor		a						; user segment
	call	_AllocateSegment
	pop		hl
	ld		a, d
	or		e
	jr z,	_initSVMS_cont			; No more available segments

	; save entry in segmentTable
	ld		(hl), e
	inc		hl
	ld		(hl), d

	; mark segment's header with SDPId = 0xffff (invalid)
	push	hl
	dec		hl						; hl = pSegHandler
	call	activateSegment
	ld		hl, #0xffff				; invalid SDPId
	ld		(#0x8000), hl			; mark
	pop		hl
	inc		hl						; next table entry

	; check segment table full
	ld		a, #<SEGMENT_TABLE_SIZE
	cp		l
	jr nz,	_initSVMS_printDash
	ld		a, #(>MAPPER_DATA_AREA_ADDR + >SEGMENT_TABLE_SIZE)
	cp		h
	jr z,	_initSVMS_cont			; table full; sacrifies the last dash

_initSVMS_printDash:
	ld		a, #'-'
	push	hl
	call	_bchput
	jr		_initSVMS_segAllocLoop


_initSVMS_cont:
	ld		de, #MAPPER_DATA_AREA_ADDR
	sbc		hl, de
	srl		h
	rr		l						; hl = #segments
	push	hl
	ld		a, l
	ld		(#_numberSegmentInSVMS), a
	ld		a, h
	ld		(#_numberSegmentInSVMS+1), a
	print	okMsg	

	pop		hl
	push	hl
	call	_PrintDec
	print	segmentsAllocatedMsg
	print	virtualMemorySizeMsg
	pop		hl
	add		hl, hl
	add		hl, hl
	add		hl, hl
	add		hl, hl
	call	_PrintDec
	print	kiloBytesMsg

	ei
	pop ix
	ret

; ----------------------------------------------------------------
;	- Activates a Scamm Data Pack (SDP) in a segment
; ----------------------------------------------------------------
; INPUTS:
;	- HL: pointer to SDP handler
;
; OUTPUTS:
;   - Carry:	Success
;
; CHANGES:
;   - All registers
; ----------------------------------------------------------------
_activateSDP::
	di
	push	ix
	; activate segment in SDPHandler
	push	hl
	ld		a, (hl)
	inc		hl
	ld		h, (hl)
	ld		l, a			; hl = SDPHandler.pSegHandler
	call	activateSegment
	pop hl
	push hl

	; check if segment's SDPId = SDPHandler.SDPId
	ld		e, (hl)
	inc		hl
	ld		d, (hl)			; de = pSegHandler (to update SegTable below, if SDP is found)
	inc		hl				; hl = SDPHandler.SDPId
	ld		a, (#0x8000)
	ld		b, a
	cp		(hl)
	jr nz, 	_activateSDP_searchFreeSeg
	inc		(hl)
	ld		a, (#0x8001)
	cp		(hl)
	jr nz,	_activateSDP_searchFreeSeg

	; update SegTable (mark in use)
	; de = p(SegHandler.mapperSlot)
	ex		de, hl
	inc		hl				; hl = p(SegHandler.mapperSlot)
	ld		a, (hl)
	or		#0x00110000		; In use
	ld		(hl), a

	; SDPId already loaded. Check if reload
	ex		de, hl
	inc		hl				; hl = p(SDPHandler.mode)
	ld		a, (hl)
	and		#0x00000010		; Force Re-read?
	jr nz,	_activateSDP_loadSDP
	
	scf						; Carry set = success
	pop hl
	pop ix
	ei
	ret

	; define random starting point fot free segment search
_activateSDP_searchFreeSeg:
	call	_rnd16
	ld		a, (#_numberSegmentInSVMS)
	ld		c, a
	ld		a, (#_numberSegmentInSVMS + 1)
	ld		b, a
	or		a				; reset carry flag

_activateSDP_rndLoop:
	srl		d
	rr		e
	or		a				; reset carry flag
	sla		c
	rl		b
	jr nc,	_activateSDP_rndLoop
	sla		e
	rl		d				; de = pSegHandler (search starting pointer)
	inc		de				; de = p(SegHandler.mapperSlot)

	; search free segment
	ld		d, h
	ld		e, l
	ex		de, hl
	ld		de, #0xffff		; invalid pSegHandler
	ld		c, #3			; best status

_activateSDP_searchLoop:
	ld		a, (hl)
	or		#0b00110000
	srl		a
	srl		a
	srl		a
	srl		a				; status candidate
	cp		c
	jr nc,	_activateSDP_searchLoop_cont1

	; found a better candidate
	ld		c, a
	ld		d, h
	ld		e, l
	or		a
	jr z,	_activateSDP_activateSegment

_activateSDP_searchLoop_cont1:
	dec		hl
	ld		a, h
	sub		#0xc0
	or		l
	jr nz,	_activateSDP_searchLoop_cont2
	ld		hl, #MAPPER_DATA_AREA_ADDR + SEGMENT_TABLE_SIZE

_activateSDP_searchLoop_cont2:
	dec		hl
	ld		a, l
	cp		e
	jr nz,	_activateSDP_searchLoop
	ld		a, h
	cp		d
	jr nz,	_activateSDP_searchLoop

	; end of segTable
	ld		a, c
	cp		#3
	jr nz,	_activateSDP_activateSegment

	pop		hl
	pop		ix
	ei
	ret						; Carry reset = fail

_activateSDP_activateSegment:
	; activate segment
	; de = p(SegHandler.mapperSlot)
	push	de
	ex		de, hl
	dec		hl				; hl = pSegHandler
	call	activateSegment
	pop		hl				; hl = p(SegHandler.mapperSlot)

	; update SegTable (mark in use)
	; de = p(SegHandler.mapperSlot)
	ld		a, (hl)
	or		#0x00110000		; In use
	ld		(hl), a
	
	; update SDPHandler
	pop		de				; de = pSDPHandler
	dec		hl				; hl = pSegHandler
	ex		de, hl			; invert
	ld		(hl), e
	inc		hl
	ld		(hl), d			; SDPHandler.pSegHandler = pSegHandler

	; update Segment Header
	inc		hl				; hl = p(SDPHandler.SDPId)
	ld		de, #0x8000		; de = Segment header
	ld		a, (hl)
	ld		(de), a
	inc		hl
	inc		de
	ld		a, (hl)
	ld		(de), a

	; load?
	inc		hl
	xor		a
	cp		(hl)
	jr z,	_activateSDP_end

_activateSDP_loadSDP:

_activateSDP_end:
	ei
	pop		ix
	scf						; Carry set = success
	ret


; ----------------------------------------------------------------
;	- Activates a segment from a Segment Handler in page 2
; ----------------------------------------------------------------
; INPUTS:
;	- HL: pointer to Segment handler
;
; OUTPUTS:
;   - None
;
; CHANGES:
;   - All registers
; ----------------------------------------------------------------
activateSegment::
	ld		a, (hl)			; segNumber
	call	__PutP2			; select segment a in page 2
	inc		hl
	ld		a, (hl)			; slotid
	ld		h, #0x80		; page 2
	call	BIOS_ENASLT		; select slot
	ret

;   ==================================
;   ========== DATA SEGMENT ==========
;   ==================================
    .area	_DATA
initializingMapperMsg:		.asciz "Initializing mapper manager..."
maxMemorySupportedMsg:		.asciz "Max memory supported is "
allocatingSegmentsMsg:		.asciz "Allocating segments ...\n\r=> "
segmentsAllocatedMsg:		.asciz " segments allocated.\n\r"
virtualMemorySizeMsg:		.asciz "Virtual Memory Size is "
kiloBytesMsg:				.asciz "Kbytes.\n\r"

okMsg::						.asciz " [OK]\n\r"

;   ==================================
;   ======= MAPPER DATA SEGMENT ======
;   ==================================
	.area	_MAPPERDATA (ABS,OVR)
	.org	MAPPER_DATA_AREA_ADDR

_segmentTable::				.ds SEGMENT_TABLE_SIZE
_pMapperBaseTable::			.ds 2
_numberSegmentInSVMS::		.ds 2

