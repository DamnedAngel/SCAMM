// ----------------------------------------------------------
//		mdomgr.c - by DamnedAngel, 2023
//
//		SCAMM's MDO features
// ----------------------------------------------------------

#include "applicationsettings.h"
#include "mdointerface.h"
#include "printinterface.h"

unsigned char activateMDO(unsigned char* hMDO) {
	dbg("Loading MDO ");
	sdbg(hMDO + 14);
	sdbg(ellipsis);

	// load MDO
	unsigned char r = mdoLoad(hMDO);
	if (r) {
		dbg("Error loading MDO.\r\n\0");
		return r;
	}
	dbg("MDO loaded successfully.Linking...\r\n\0");

	// link MDO
	r = mdoLink(hMDO);
	if (r) {
		dbg("Error linking MDO.\r\n\0");
		return r;
	}
	dbg("MDO linked successfully.\r\n\0");
	return 0;
}

unsigned char deactivateMDO(unsigned char* hMDO) {
	dbg("Unlinking MDO ");
	sdbg(hMDO + 14);
	sdbg(ellipsis);

	// unlink MDO
	unsigned char r = mdoUnlink(hMDO);
	if (r) {
		dbg("Error unlinking MDO.\r\n\0");
		return r;
	}
	dbg("MDO unlinked successfully.\r\n\0");

	// release MDO
	r = mdoRelease(hMDO);
	if (r) {
		dbg("Error releasing MDO.\r\n\0");
		return r;
	}
	dbg("MDO released successfully.\r\n\0");
	return 0;
}

//	----------------------------------------------------------
//	This is called when an MDO hook is called before it is
//	linked to a child MDO.The application will terminate
//	after the return of this routine.
//	Customize here the finalization of you application.
//  Remove it if you're not using MDOs.
unsigned char onMDOAbend(void) {
	print("Unimplemented hook called.\r\n\0");
	return 0xa1;	// error code to be relayed to MSX-DOS.
}
