// ----------------------------------------------------------
//		msxdosapp.c - by Danilo Angelo, 2020-2023
//
//		MSX-DOS program (.COM) for MSX example
//		C version
// ----------------------------------------------------------

#include <stdbool.h>

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
extern unsigned int rnd16(void);

bool b[1024];

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

	seg0.logSegNumber = 1024;
	seg0.segMode = 3;
	activateLogSeg_hook(&seg0);
	Pokew(0x8008, 1024);
	mnemo_releaseLogSeg_hook(0x10, &seg0);

	seg1.logSegNumber = 1025;
	seg1.segMode = 3;
	activateLogSeg_hook(&seg1);
	Pokew(0x8008, 1025);
	mnemo_releaseLogSeg_hook(0x10, &seg1);

	seg2.logSegNumber = 1026;
	seg2.segMode = 3;
	activateLogSeg_hook(&seg2);
	Pokew(0x8008, 1026);
	PrintDec(Peekw(0x8008));
	print("\n\r\--==--\n\r\0");
	mnemo_releaseLogSeg_hook(0x10, &seg2);

	activateLogSeg_hook(&seg0);

	PrintDec(Peekw(0x8008));
	print("\n\r\0");
	mnemo_releaseLogSeg_hook(0x10, &seg0);

	/*
	activateLogSeg_hook(&seg0);
	PrintDec(Peekw(0x9000));
	print("\n\r\0");
	activateLogSeg_hook(&seg1);
	PrintDec(Peekw(0x9000));
	print("\n\r\0");
	activateLogSeg_hook(&seg2);
	PrintDec(Peekw(0x9000));
	print("\n\r\0");
	*/
	/*
	for (int i = 0; i < 1024; i++) {
		b[i] = false;
	}

	for (int i = 0; i < 1024; i++) {
		unsigned int rw = rnd16() & 1023;
		unsigned char rb = ((unsigned char)(rnd16())) & 3;

		seg0.logSegNumber = rw + 1024;
		seg0.segMode = 3;
		activateLogSeg_hook(&seg0);
		b[rw] = true;
		Pokew(0x9000, rw);
		mnemo_releaseLogSeg_hook(rb, &seg0);

		if ((i & 127) == 127) {
			PrintDec(i + 1);
			print("\r\0");
		}
	}
	print("\n\0");

	unsigned int errors = 0;
	for (int i = 0; i < 1024; i++) {
		if (b[i]) {
			seg0.logSegNumber = i + 1024;
			seg0.segMode = 3;
			activateLogSeg_hook(&seg0);
			if (Peekw(0x9000) != i) {
				errors++;
			}
			mnemo_releaseLogSeg_hook(1, &seg0);
		}
	}

	print("-------\r\n\0");
	PrintDec(errors);
	*/

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

