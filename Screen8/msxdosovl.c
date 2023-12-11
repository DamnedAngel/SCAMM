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

// ----------------------------------------------------------
//	This is the custom initialization function for your C MDO.
//	Invoked when the MDO is loaded.
void initialize (void) {
	dbg("Screen8's MDO initialized!\r\n\0");
}

// ----------------------------------------------------------
//	This is the custom finalization function for your C MDO!
//	Invoked when the MDO is unloaded.
void finalize(void) {
	print("Screen8's MDO finalized!\r\n\0");
}

// ----------------------------------------------------------
//	This is the custom activation function for your C MDO!
//	Invoked when the MDO is linked.
void activate(void) {
	print("Screen8's MDO activated!\r\n\0");
}

// ----------------------------------------------------------
//	This is the custom deactivation function for your C MDO!
//	Invoked when the MDO is unlinked.
void deactivate(void) {
	print("Screen8's MDO deactivated!\r\n\0");
}

// ----------------------------------------------------------
//	These are examples of dinamically linked function
//  which may be called by parent module
void hello(void) {
	print("Hello MSX from dinamically linked function!\r\n\0");
}

void goodbye(void) {
	print("Goodbye MSX from dinamically linked function!\r\n\0");
}
