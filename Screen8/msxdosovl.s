;----------------------------------------------------------
;		msxdosovl.s - by Danilo Angelo, 2020-2023
;
;		MSX-DOS program overlay example
;		Assembly version
;----------------------------------------------------------

	.include "MSX/BIOS/msxbios.s"
	.include "targetconfig.s"
	.include "applicationsettings.s"
	.include "printinterface.s"

	.area	_CODE


; ----------------------------------------------------------
;	This is the custom initialization function for your C MDO.
;	Invoked when the MDO is loaded.
_initialize::
    dbg	_initializemsg
	ret

; ----------------------------------------------------------
;	This is the custom finalization function for your C MDO!
;	Invoked when the MDO is unloaded.
_finalize::
    dbg	_finalizemsg
	ret

; ----------------------------------------------------------
;	This is the custom activation function for your C MDO!
;	Invoked when the MDO is linked.
_activate::
    dbg	_activatemsg
	ret

; ----------------------------------------------------------
;	This is the custom deactivation function for your C MDO!
;	Invoked when the MDO is unlinked.
_deactivate::
    dbg	_deactivatemsg
	ret

; ----------------------------------------------------------
;	Invalidate the region of an object, inserting entry in
;	the invalidatedRegion array.
;	Input: Scamm ScreenObject
;	Output: Nothing
_invalidate::
 	ret

; ----------------------------------------------------------
;	Render invalidated areas.
;	Input: Nothing
;	Output: Nothing
_render::
 	ret

; ----------------------------------------------------------
;	UpdateFrame with rendered images.
;	Input: Nothing
;	Output: Nothing
_updateFrame::
 	ret


; ----------------------------------------------------------
;   Once you replaced the commands in the _main routine
;   above with your own program, you should delete the
;   lines below. They are for demonstration purposes only.
; ----------------------------------------------------------

; ----------------------------------------------------------
;	Messages
_initializemsg::
.asciz		"Screen8 MDO initialized!\r\n"
_finalizemsg::
.ascii		"Screen8 MDO finalized!\r\n\0"
_activatemsg::
.ascii		"Screen8 MDO activated!\r\n\0"
_deactivatemsg::
.ascii		"Screen8 MDO deactivated!\r\n\0"
