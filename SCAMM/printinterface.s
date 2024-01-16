;----------------------------------------------------------
;		printinterface.s - by Danilo Angelo, 2023
;
;		Interface for print and debug functionalities.
;----------------------------------------------------------

.globl __print
.globl _linefeed
.globl _ellipsis

.globl _bchput

.macro print msg
	ld		hl, #msg
	call	__print
.endm

.macro dbg msg
.if DEBUG
	.globl	_msgdbg
	print	_msgdbg
	print	msg
.endif
.endm

.macro sdbg msg
.if DEBUG
	print	msg
.endif
.endm
