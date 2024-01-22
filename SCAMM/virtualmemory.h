/*
; ----------------------------------------------------------------
;	virtualmemory_h.s
; ----------------------------------------------------------------
;	240114 - DamnedAngel
; ----------------------------------------------------------------
;	Header for virtualmemory.s
; ----------------------------------------------------------------
*/

#ifndef  __VIRTUALMEMORY_H__							
#define  __VIRTUALMEMORY_H__

#include "rammapper.h"

typedef struct {
	SEGMENTHANDLER* pSegHandler;
	unsigned int SDPId;
	unsigned char mode;
} SDPHANDLER;

/*
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
*/
extern void initSVMS(void);

/*
; ----------------------------------------------------------------
;	- Activates a Scamm Data Pack(SDP) in a segment
; ----------------------------------------------------------------
; INPUTS:
;	- SDPHANDLER* pSDPHandler: pointer to SDP handler
;
; OUTPUTS:
;   - unsigned char:	0 = success
;
; CHANGES:
;   - All registers
; ----------------------------------------------------------------
*/
unsigned char activateSDP(SDPHANDLER* pSDPHandler);

/*
; ----------------------------------------------------------------
;	- Releases a segment from a Segment Handler
; ----------------------------------------------------------------
; INPUTS:
;	- unsigned char priority: Release priority (0 - 2)
;	- SDPHANDLER* pSDPHandler: pointer to SDP handler
;
; OUTPUTS:
;   - None
;
; CHANGES:
;   - A, DE, HL
; ----------------------------------------------------------------
*/
void releaseSDP(unsigned char priority, SDPHANDLER* pSDPHandler);

#endif	//  __VIRTUALMEMORY_H__
