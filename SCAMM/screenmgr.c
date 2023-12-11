// ----------------------------------------------------------
//		screenmgr.c - by DamnedAngel, 2023
//
//		SCAMM's Screen operations.
// ----------------------------------------------------------

#include "applicationsettings.h"
#include "mdointerface.h"

#include "screen.h"
#include "mdomgr.h"

unsigned char setScreen(unsigned char mode) {
	unsigned char r = deactivateMDO(&SCREEN);
	if (r) {
		return r;
	}
	screen(mode);
	SCREEN.fileName[6] = r + '0';
	return activateMDO(&SCREEN);
}

void finalizeScreen() {
	deactivateMDO(&SCREEN);
}

