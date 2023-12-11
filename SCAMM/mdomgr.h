// ----------------------------------------------------------
//		mdomgr.h - by DamnedAngel, 2023
//
//		SCAMM's MDO features definitions
// ----------------------------------------------------------

#ifndef  __MDOMGR_H__
#define  __MDOMGR_H__

#include "mdostructures.h"

unsigned char activateMDO(mdoHandler* hMDO);
unsigned char deactivateMDO(mdoHandler* hMDO);
unsigned char onMDOAbend(void);

#endif	// __MDOMGR_H__