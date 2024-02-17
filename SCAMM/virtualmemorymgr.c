// ----------------------------------------------------------
//		virtualmemorymgr.c - by DamnedAngel, 2024
//
//		SCAMM's virtualmemory features
// ----------------------------------------------------------

#include <stdbool.h>
#include "applicationsettings.h"
#include "mdointerface.h"

#include "mdomgr.h"

unsigned char startVirtualMemory (bool primaryMapperOnly) {
	unsigned char r = activateMDO(&MNEMOSYNEX);
	if (r) {
		return r;
	}
	r = initMnemoSyneX_hook(primaryMapperOnly);
	return r;
}

unsigned char stopVirtualMemory(void) {
	finalizeMnemoSyneX_hook();
	return deactivateMDO(&MNEMOSYNEX);
}
