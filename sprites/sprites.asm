	processor 6502

	#include "vcs.h"
	#include "macro.h"

	seg.u Variables
	org $80

P0X	ds 1;
P0Y	ds 1;
P0F	ds 1;

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

	lda #0
	sta VBLANK		; turn off v-blank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ready to draw! (192 lines of powah)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldx #192
	ldy #8
ScanLoop:
	stx COLUBK		; COlour LUminance BacKground

	txa
	sec
	sbc P0Y

	; Compare, if A >= operand, set carry
	cmp #8

	bcs NoSprite

	; Draw P0

;	lda P0F
;	asl
;	asl
;	asl


	lda Frame0,Y
	sta GRP0

	lda ColorFrame0,Y
	sta COLUP0

	dey

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
	inc P0Y

	jmp NextFrame

	org $ffcc
;---Graphics Data from PlayerPal 2600---
Frame0
	.byte #%00111100;$04
	.byte #%01111110;$20
	.byte #%11111111;$40
	.byte #%01101101;$42
	.byte #%11111111;$90
	.byte #%01111110;$94
	.byte #%01111110;$96
	.byte #%00111100;$98
Frame1
	.byte #%00111100;$04
	.byte #%01111110;$20
	.byte #%11111111;$40
	.byte #%10110110;$42
	.byte #%11111111;$90
	.byte #%01111110;$94
	.byte #%01111110;$96
	.byte #%00111100;$98
Frame2
	.byte #%00111100;$04
	.byte #%01111110;$20
	.byte #%11111111;$40
	.byte #%11011011;$42
	.byte #%11111111;$90
	.byte #%01111110;$94
	.byte #%01111110;$96
	.byte #%00111100;$98
;---End Graphics Data---


;---Color Data from PlayerPal 2600---

ColorFrame0
	.byte #$04;
	.byte #$20;
	.byte #$40;
	.byte #$42;
	.byte #$90;
	.byte #$94;
	.byte #$96;
	.byte #$98;
ColorFrame1
	.byte #$04;
	.byte #$20;
	.byte #$40;
	.byte #$42;
	.byte #$90;
	.byte #$94;
	.byte #$96;
	.byte #$98;
ColorFrame2
	.byte #$04;
	.byte #$20;
	.byte #$40;
	.byte #$42;
	.byte #$90;
	.byte #$94;
	.byte #$96;
	.byte #$98;
;---End Color Data---

	org $fffc
	.word Start		; reset vector
	.word Start		; interrupt vector - not used in Atari but ROM size must be 4k


