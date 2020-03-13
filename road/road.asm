	processor 6502

	#include "vcs.h"
	#include "macro.h"

	seg.u Variables
	org $80

P0X	ds 1;
P0Y	ds 1;
P0F	ds 1;

TEMP	ds 1;
	seg code
	org $f000

Start:
	CLEAN_START	; Macro to clear memory and registers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Initialise variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #30
	sta P0X
	sta P0Y

	lda #0
	sta P0F

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
	ldy #7
ScanLoop:

	txa
	sec
	cmp #92

	bcc DrawRoad
	ldy #$88
	sty COLUBK		; COlour LUminance BacKground
	jmp ScanDone

DrawRoad:
	lda ZLookup,X

	and $3
	tay
	lda RoadTex,Y

	sty COLUBK		; COlour LUminance BacKground
	jmp ScanDone

NoSprite:
	lda #0
	sta GRP0


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

	;; move up
	inc P0Y

	;; next frame of animation
	lda P0F
	clc
	adc #1
	and #15
	sta P0F

	jmp NextFrame

	org $ff9c

RoadTex:

	.byte #$02
	.byte #$04
	.byte #$06
	.byte #$08

	org $ffa0

ZLookup:
	.byte #$23
	.byte #$22
	.byte #$21
	.byte #$20
	.byte #$1F
	.byte #$1E
	.byte #$1D
	.byte #$1C
	.byte #$1B
	.byte #$1A
	.byte #$19
	.byte #$18
	.byte #$17
	.byte #$16
	.byte #$15
	.byte #$14
	.byte #$13
	.byte #$12
	.byte #$11
	.byte #$10
	.byte #$10
	.byte #$F
	.byte #$E
	.byte #$D
	.byte #$D
	.byte #$C
	.byte #$C
	.byte #$B
	.byte #$B
	.byte #$A
	.byte #$A
	.byte #$9
	.byte #$9
	.byte #$9
	.byte #$8
	.byte #$8
	.byte #$8
	.byte #$7
	.byte #$7
	.byte #$7
	.byte #$7
	.byte #$6
	.byte #$6
	.byte #$6
	.byte #$6
	.byte #$6
	.byte #$5
	.byte #$5
	.byte #$5
	.byte #$5
	.byte #$5
	.byte #$4
	.byte #$4
	.byte #$4
	.byte #$4
	.byte #$4
	.byte #$4
	.byte #$4
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$3
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$2
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1
	.byte #$1

	org $fffc
	.word Start		; reset vector
	.word Start		; interrupt vector - not used in Atari but ROM size must be 4k


