// ----------------------------------------------------------
//		msxdosapp.c - by Danilo Angelo, 2020-2023
//
//		MSX-DOS program (.COM) for MSX example
//		C version
// ----------------------------------------------------------

#include "MSX/BIOS/msxbios.h"
#include "targetconfig.h"
#include "applicationsettings.h"
#include "printinterface.h"
#include "printDec.h"
#include "mnemosyne-x.h"

#include "mdointerface.h"
#include "gamemgr.h"
#include "vdp.h"
#include "screenmgr.h"

#include "virtualmemorymgr.h"

#define 			Poke( address, data )	( *( (volatile unsigned char*)(address) ) = ( (unsigned char)(data) ) )
#define 			Pokew( address, data )	( *( (volatile unsigned int*)(address) ) = ( (unsigned int)(data) ) )
#define 			Peek( address )			( *( (volatile unsigned char*)(address) ) )
#define 			Peekw( address )		( *( (volatile unsigned int*)(address) ) )

LOGSEGHANDLER seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, seg9, seg10;

extern unsigned char WaitKey(void);

void abendMessage(unsigned char r) {
	print("SCAMM Fatal Error: ");
	PrintDec(r);
	print("\r\n\0");
	return;
}

// ----------------------------------------------------------
// SCAMM
unsigned char main(const unsigned char** argv, int argc) {
	if ((int) argv & argc) {}
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
	r = startVirtualMemory(false);
	WaitKey();

	// Test Scamm Virtual Memory System features (to be removed)
	/*
	seg0.logSegNumber = 0x0000;
	seg0.segMode = 1;
	activateLogSeg_hook(&seg0);

	seg1.logSegNumber = 0x0101;
	seg1.segMode = 0;
	activateLogSeg_hook(&seg1);

	seg2.logSegNumber = 0x0004;
	seg2.segMode = 1;
	activateLogSeg_hook(&seg2);

	switchMainPage_hook(&seg0);
	print((const unsigned char*)(0x8008));
	
	*/

//	switchMainPage_hook(&seg2);
//	print((const unsigned char*)(0x8008));
//	WaitKey();

	/*
	releaseseg(1, &seg6);

	activateLogSeg(&seg10);

	activateLogSeg(&seg6);

	activateLogSeg(&seg9);
	*/

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

	// initialize Scamm Virtual Memory System
	r = stopVirtualMemory();

	print("You've been SCAMMed! Goodbye.\r\n\0");
	return 0;
}

