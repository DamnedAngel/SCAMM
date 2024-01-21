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

#include "virtualmemory.h"

SDPHANDLER sdp0, sdp1, sdp2, sdp3, sdp4, sdp5, sdp6, sdp7, sdp8, sdp9, sdp10;

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

	// initialize Scamm Virtual Memory System
	initSVMS();

	// Test Scamm Virtual Memory System features (to be removed)
	sdp0.SDPId = 0x0000;
	sdp0.mode = 1;
	activateSDP(&sdp0);
	sdp1.SDPId = 0x0001;
	sdp1.mode = 1;
	activateSDP(&sdp1);
	sdp2.SDPId = 0x0002;
	sdp2.mode = 1;
	activateSDP(&sdp2);
	sdp3.SDPId = 0x0003;
	sdp3.mode = 1;
	activateSDP(&sdp3);
	sdp4.SDPId = 0x0004;
	sdp4.mode = 1;
	activateSDP(&sdp4);
	sdp5.SDPId = 0x0005;
	sdp5.mode = 1;
	activateSDP(&sdp5);
	sdp6.SDPId = 0x0006;
	sdp6.mode = 1;
	activateSDP(&sdp6);
	sdp7.SDPId = 0x0007;
	sdp7.mode = 1;
	activateSDP(&sdp7);
	sdp8.SDPId = 0x0008;
	sdp8.mode = 1;
	activateSDP(&sdp8);
	sdp9.SDPId = 0x0009;
	sdp9.mode = 1;
	activateSDP(&sdp9);

	sdp10.SDPId = 0x000a;
	sdp10.mode = 1;
	activateSDP(&sdp10);

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

