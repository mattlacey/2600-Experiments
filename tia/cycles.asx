	processor 6502

	#include "vcs.h"
	#include "macro.h"

	seg code
	org $f000

Start:
	CLEAN_START	; Macro to clear memory and registers

NextFrame:

	lda	#2
	sta	VSYNC
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	3 scanlines for v-sync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	sta	WSYNC		; wait three scan lines for vertical sync
	sta	WSYNC
	sta WSYNC

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
	sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ready to draw! (192 lines of powah)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #192
ScanLoop:
	stx COLUBK		; COlour LUminance BacKground
	sta	WSYNC
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

	jmp NextFrame

	org $fffc
	.word Start		; reset vector
	.word Start		; interrupt vector - not used in Atari but ROM size must be 4k


