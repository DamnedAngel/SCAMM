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

	// Test Scamm Virtual Memory System features (to be removed)
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
	WaitKey();

	switchMainPage_hook(&seg2);
	print((const unsigned char*)(0x8008));
	WaitKey();

	switchMainPage_hook(&seg0);
	Poke(0xB000, 0x30);
	Poke(0xB001, 0);

	switchMainPage_hook(&seg1);
	Poke(0xB000, 0x31);
	Poke(0xB001, 0);

	switchMainPage_hook(&seg2);
	Poke(0xB000, 0x32);
	Poke(0xB001, 0);

	switchMainPage_hook(&seg0);
	print((const unsigned char*)(0xB000));
	switchMainPage_hook(&seg1);
	print((const unsigned char*)(0xB000));
	switchMainPage_hook(&seg2);
	print((const unsigned char*)(0xB000));

	seg9.logSegNumber = 0x0410;
	seg9.segMode = 1;
	activateLogSeg_hook(&seg9);
	switchMainPage_hook(&seg9);


/*	seg2.logSegNumber = 0x0002;
	seg2.mode = 1;
	activateLogSeg(&seg2);
	seg3.logSegNumber = 0x0003;
	seg3.mode = 1;
	activateLogSeg(&seg3);
	seg4.logSegNumber = 0x0004;
	seg4.mode = 1;
	activateLogSeg(&seg4);
	seg5.logSegNumber = 0x0005;
	seg5.mode = 1;
	activateLogSeg(&seg5);
	seg6.logSegNumber = 0x0006;
	seg6.mode = 1;
	activateLogSeg(&seg6);
	seg7.logSegNumber = 0x0007;
	seg7.mode = 1;
	activateLogSeg(&seg7);
	seg8.logSegNumber = 0x0008;
	seg8.mode = 1;
	activateLogSeg(&seg8);
	seg9.logSegNumber = 0x0009;
	seg9.mode = 1;
	activateLogSeg(&seg9);

	seg10.logSegNumber = 0x000a;
	seg10.mode = 1;
	activateLogSeg(&seg10);

	releaseseg(1, &seg6);

	activateLogSeg(&seg10);

	activateLogSeg(&seg6);

	activateLogSeg(&seg9);
	*/

	WaitKey();

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

