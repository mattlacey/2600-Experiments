	processor 6502

	#include "vcs.h"
	#include "macro.h"

	seg.u Variables
	org $80

TEMP	ds 1;
	seg code
	org $f000

Start:
	CLEAN_START	; Macro to clear memory and registers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Initialise variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NextFrame:

	lda	#2
	sta	VSYNC
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	3 scanlines for v-sync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	REPEAT 3
		sta	WSYNC
	REPEND

	lda #0
	sta VSYNC		; turn off v-sync

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	37 lines for v-blank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #37
VBlankLoop:
	sta WSYNC
	dex
	bne VBlankLoop

	lda #0
	sta VBLANK		; turn off v-blank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ready to draw! (192 lines of powah)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #192
ScanLoop:
	stx COLUBK		; COlour LUminance BacKground

ScanDone:

	sta WSYNC
	dex
	bne ScanLoop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Overscan (30 lines)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #2
	sta VBLANK

	ldx #30
OverscanLoop:
	sta	WSYNC
	dex
	bne OverscanLoop

FrameDone:

	jmp NextFrame

	org $fffc
	.word Start		; reset vector
	.word Start		; interrupt vector - not used in Atari but ROM size must be 4k


