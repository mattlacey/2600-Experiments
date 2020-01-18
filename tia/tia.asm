
	include "vcs.h"
	include "macro.h"
		
	processor 6502

	seg code

	org $f000

Start:
	CLEAN_START

NextFrame:

	lda #2
	sta	VBLANK
	sta VSYNC

	REPEAT 3
		sta WSYNC
	REPEND

	lda #0
	sta VSYNC

	ldx #37

VBlankLoop:
	sta WSYNC
	dex
	bne VBlankLoop

	ldy #1
	sty CTRLPF

	lda #0
	sta VBLANK

	ldy #$1c
	sty COLUPF


	ldx #7
Top:

	stx COLUBK 
	sta WSYNC
	dex
	bne Top

	ldx #7
	ldy #$e0
	sty PF0
	ldy #$ff
	sty PF1
	sty PF2

Bar1:
	stx COLUBK
	sta WSYNC
	dex
	bne Bar1

	ldx #164
	ldy #0
	sty PF1
	sty PF2
	ldy #40
	sty PF0

Sides:
	stx COLUBK
	sta WSYNC
	dex
	bne Sides

	ldx #7
	ldy #$e0
	sty PF0
	ldy #$ff
	sty PF1
	sty PF2

Bar2:
	stx COLUBK
	sta WSYNC
	dex
	bne Bar2

	ldy #0
	sty PF0
	sty PF1
	sty PF2

	ldx #7
Bottom:
	stx COLUBK
	sta WSYNC
	dex
	bne Bottom

	lda #02
	sta VBLANK

	ldx #30
Overscan:
	sta WSYNC
	dex
	bne Overscan


	jmp NextFrame

	org $fffc
	.word Start
	.word Start

