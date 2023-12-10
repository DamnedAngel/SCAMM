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

// ----------------------------------------------------------
//	This is the custom initialization function for your C MDO.
//	Invoked when the MDO is loaded.
void initialize (void) {
	dbg("The Trial's MDO initialized!\r\n\0");
}

// ----------------------------------------------------------
//	This is the custom finalization function for your C MDO!
//	Invoked when the MDO is unloaded.
void finalize(void) {
	dbg("The Trial's MDO finalized!\r\n\0");
}

// ----------------------------------------------------------
//	This is the custom activation function for your C MDO!
//	Invoked when the MDO is linked.
void activate(void) {
	dbg("The Trial's MDO activated!\r\n\0");
}

// ----------------------------------------------------------
//	This is the custom deactivation function for your C MDO!
//	Invoked when the MDO is unlinked.
void deactivate(void) {
	dbg("The Trial's MDO deactivated!\r\n\0");
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
