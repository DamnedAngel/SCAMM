// ----------------------------------------------------------
//		msxdosovl.c - by Danilo Angelo, 2020-2023
//
//		MSX - DOS program overlay example
//		C version
// ----------------------------------------------------------

#include "MSX/BIOS/msxbios.h"
#include "targetconfig.h"
#include "applicationsettings.h"
#include "printinterface.h"

#include "../SCAMM/Debug/objs/parentinterface.h"

#include "mnemosyne-x.h"
#include "thetrial._00.h"

#include "../SCAMM/vdp.h"
#include "../SCAMM/screenmgr.h"

LOGSEGHANDLER seg0, seg1, seg2;

extern unsigned char activateLogSeg_hook(LOGSEGHANDLER*);
extern void mnemo_releaseLogSeg_hook(unsigned char, LOGSEGHANDLER*);

extern void switchMainPage_hook(LOGSEGHANDLER*);
extern void switchAuxPage_hook(LOGSEGHANDLER*);

extern void invalidate_hook(void);
extern void render_hook(void);
extern void updateFrame_hook(void);

extern void HMMCTest(void);
extern void showBackGround1(void);
extern void showBackGround2(void);
extern void showBackGround3(void);

extern unsigned char WaitKey(void);


// ----------------------------------------------------------
//	This is the custom initialization function for your C MDO.
//	Invoked when the MDO is loaded.
unsigned char initialize(void) {
	dbg("The Trial's MDO initialized!\r\n\0");
	return 0;
}

// ----------------------------------------------------------
//	This is the custom finalization function for your C MDO!
//	Invoked when the MDO is unloaded.
unsigned char finalize(void) {
	dbg("The Trial's MDO finalized!\r\n\0");
	return 0;
}

// ----------------------------------------------------------
//	This is the custom activation function for your C MDO!
//	Invoked when the MDO is linked.
unsigned char activate(void) {
	unsigned char r;
	color(255, 0, 0);
	r = setScreen(8);

	seg0.logSegNumber = MNEMO_SEG_PLACE1;
	seg0.segMode = 1;
	activateLogSeg_hook(&seg0); 
	showBackGround1();
	mnemo_releaseLogSeg_hook(0, &seg0);

	seg1.logSegNumber = MNEMO_SEG_PLACE1 + 1;
	seg1.segMode = 1;
	activateLogSeg_hook(&seg1);
	showBackGround2();
	mnemo_releaseLogSeg_hook(0, &seg1);

	seg2.logSegNumber = MNEMO_SEG_PLACE1 + 2;
	seg2.segMode = 1;
	activateLogSeg_hook(&seg2);
	showBackGround3();
	mnemo_releaseLogSeg_hook(0, &seg2);

	WaitKey();

	/*
	switchMainPage_hook(&seg1);
	showBackGround1();

	switchMainPage_hook(&seg2);
	showBackGround2();
	
	switchMainPage_hook(&seg0);
	showBackGround3();

	WaitKey();

	activateLogSeg_hook(&seg0);
	activateLogSeg_hook(&seg1);
	activateLogSeg_hook(&seg2);

	switchMainPage_hook(&seg0);
	showBackGround1();
	switchMainPage_hook(&seg1);
	showBackGround2();
	switchMainPage_hook(&seg2);
	showBackGround3();
	*/

	//HMMCTest();

	if (r) {
		dbg("The Trial's MDO activation failed!\r\n\0");
	}
	else {
		dbg("The Trial's MDO activated!\r\n\0");
	}
	return r;
}

// ----------------------------------------------------------
//	This is the custom deactivation function for your C MDO!
//	Invoked when the MDO is unlinked.
unsigned char deactivate(void) {
	dbg("The Trial's MDO deactivated!\r\n\0");
	return 0;
}

// ----------------------------------------------------------
//	These are examples of dinamically linked function
//  which may be called by parent module
void gameStart(void) {
	dbg("The Trial starting...\r\n\0");
}

void gameEnd(void) {
	dbg("The Trial ending...\r\n\0");
}
