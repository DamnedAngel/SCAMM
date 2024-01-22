; ----------------------------------------------------------
;	virtualmemory_h.s
; ----------------------------------------------------------
;	240114 - DamnedAngel
; ----------------------------------------------------------
;	Header for virtualmemory.s
; ----------------------------------------------------------

;----------------------------------------------------------
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
.globl _initSVMS

; ----------------------------------------------------------------
;	- Activates a Scamm Data Pack (SDP) in a segment
; ----------------------------------------------------------------
; INPUTS:
;	- HL: pointer to SDP handler
;
; OUTPUTS:
;   - A:  0 = Success
;
; CHANGES:
;   - All registers
; ----------------------------------------------------------------
.globl _activateSDP

; ----------------------------------------------------------------
;	- Releases a segment from a Segment Handler
; ----------------------------------------------------------------
; INPUTS:
;	- A: Release priority
;	- DE: pointer to Segment handler
;
; OUTPUTS:
;   - None
;
; CHANGES:
;   - A, DE, HL
; ----------------------------------------------------------------
.globl _releaseSDP

; ----------------------------------------------------------------
;	- Releases a segment from a Segment Handler
; ----------------------------------------------------------------
; INPUTS:
;	- A: Release priority
;	- HL: pointer to Segment handler
;
; OUTPUTS:
;   - None
;
; CHANGES:
;   - A, DE, HL
; ----------------------------------------------------------------
.globl _releaseSDP_HL
