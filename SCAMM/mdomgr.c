// ----------------------------------------------------------
//		mdomgr.c - by DamnedAngel, 2023
//
//		SCAMM's MDO features
// ----------------------------------------------------------

#include "applicationsettings.h"
#include "mdointerface.h"
#include "printinterface.h"
#include "mdostructures.h"


unsigned char activateMDO(mdoHandler* hMDO) {
	unsigned char r;

	dbg("Activating MDO ");
	sdbg(&(hMDO->mdoName));
	sdbg(ellipsis);

	if (!(hMDO->status & mdoStatus_loaded)) {
		// load MDO
		dbg("Loading MDO...\r\n\0");
		r = mdoLoad(hMDO);
		if (r) {
			dbg("Error loading MDO.\r\n\0");
			return r;
		}
		dbg("MDO loaded successfully.\r\n\0");
	}

	if (!(hMDO->status & mdoStatus_linked)) {
		// link MDO
		dbg("Linking MDO...\r\n\0");
		r = mdoLink(hMDO);
		if (r) {
			dbg("Error linking MDO.\r\n\0");
			return r;
		}
		dbg("MDO linked successfully.\r\n\0");
	}
	return 0;
}

unsigned char deactivateMDO(mdoHandler* hMDO) {
	unsigned char r;
	dbg("Deactivating MDO ");
	sdbg(&(hMDO->mdoName));
	sdbg(ellipsis);

	// unlink MDO
	if (hMDO->status & mdoStatus_linked) {
		dbg("Unlinking MDO...\r\n\0");
		r = mdoUnlink(hMDO);
		if (r) {
			dbg("Error unlinking MDO.\r\n\0");
			return r;
		}
		dbg("MDO unlinked successfully.\r\n\0");
	}

	// release MDO
	if (hMDO->status & mdoStatus_loaded) {
		dbg("Releasing MDO...\r\n\0");
		r = mdoRelease(hMDO);
		if (r) {
			dbg("Error releasing MDO.\r\n\0");
			return r;
		}
		dbg("MDO released successfully.\r\n\0");
	}
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
