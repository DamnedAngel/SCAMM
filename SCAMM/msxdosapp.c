// ----------------------------------------------------------
//		msxbinapp.c - by Danilo Angelo, 2020-2023
//
//		BIN program(BLOAD'able) for MSX example
//		C version
// ----------------------------------------------------------

#include "MSX/BIOS/msxbios.h"
#include "targetconfig.h"
#include "applicationsettings.h"
#include "printinterface.h"

#include "mdointerface.h"
#include "gamemgr.h"
#include "vdp.h"
#include "screenmgr.h"

void abendMessage(unsigned char r) {
	print("SCAMM Fatal Error.\r\n\0");
	//TO DO: print r
	return;
}

// ----------------------------------------------------------
// SCAMM
unsigned char main(const unsigned char** argv, int argc) {
	print("Starting SCAMM engine.\r\n\0");

#ifdef CMDLINE_PARAMETERS
	print("Parameters:\r\n\0");
	for (int i = 0; i < argc; i++) {
		print(argv[i]);
		print(linefeed);
	}
	print(linefeed);
#endif
	unsigned char r;

	// initialize Game
	dbg("Initializing game...\r\n\0");
	r = startGame();
	if (r) {
		abendMessage(r);
		return r;
	}
	dbg("Game initialized.\r\n\0");

	// game Loop
	dbg("Executing game...\r\n\0");
	r = runGame();
	if (r) {
		abendMessage(r);
		return r;
	}
	dbg("Game executed...\r\n\0");

	// To Do: remove
	extern unsigned char WaitKey();
	WaitKey();

	// Finalize game
	dbg("Finalizing game...\r\n\0");
	r = endGame();
	if (r) {
		abendMessage(r);
		return r;
	}
	dbg("Game finalized.\r\n\0");

	// Finalize screen
	dbg("Returning to text mode...\r\n\0");
	finalizeScreen();

	color(15, 4, 4);
	screen(0);
	dbg("Text mode activated.\r\n\0");

	print("You've been SCAMMed! Goodbye.\r\n\0");
	return 0;
}

