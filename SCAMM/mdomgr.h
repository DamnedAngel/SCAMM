// ----------------------------------------------------------
//		mdomgr.h - by DamnedAngel, 2023
//
//		SCAMM's MDO features definitions
// ----------------------------------------------------------

#ifndef  __MDOMGR_H__
#define  __MDOMGR_H__

unsigned char activateMDO(unsigned char* hMDO);
unsigned char deactivateMDO(unsigned char* hMDO);
unsigned char onMDOAbend(void);

#endif	// __MDOMGR_H__