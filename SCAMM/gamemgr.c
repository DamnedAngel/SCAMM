// ----------------------------------------------------------
//		gamemgr.c - by DamnedAngel, 2023
//
//		SCAMM's Game MDO features
// ----------------------------------------------------------

#include "applicationsettings.h"
#include "mdointerface.h"

#include "mdomgr.h"

unsigned char startGame(void) {
	unsigned char r = activateMDO(&GAME);
	if (r) {
		return r;
	}
	gameStart_hook();
	return 0;
}

unsigned char endGame(void) {
	gameEnd_hook();
	return deactivateMDO(&GAME);
}

unsigned char runGame() {
	return 0;
}