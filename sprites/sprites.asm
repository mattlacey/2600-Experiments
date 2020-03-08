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
	stx COLUBK		; COlour LUminance BacKground

	txa
	sec
	sbc P0Y

	; Compare, if A >= operand, set carry
	cmp #9

	bcs NoSprite

	sty TEMP
	
	;; multiply frame by 8 (after shifting right for slower animation)
	lda P0F
	lsr
	lsr
	asl
	asl
	asl

	;; clear carry and add y (i.e. the line of the sprite)
	clc
	adc TEMP
	tay

	lda Frame0,Y
	sta GRP0

	lda ColorFrame0,Y
	sta COLUP0

	ldy TEMP
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

	;; move up
	inc P0Y

	;; next frame of animation
	lda P0F
	clc
	adc #1
	and #15
	sta P0F

	jmp NextFrame

	org $ffbc
;---Graphics Data from PlayerPal 2600---

;---Graphics Data from PlayerPal 2600---

Frame0
        .byte #%01011010;$02
        .byte #%01111110;$04
        .byte #%11111111;$06
        .byte #%11111111;$08
        .byte #%01111110;$0A
        .byte #%00111100;$A6
        .byte #%00111100;$98
        .byte #%00011000;$9A
Frame1
        .byte #%00110100;$02
        .byte #%01111110;$04
        .byte #%11111111;$06
        .byte #%11111111;$08
        .byte #%01111110;$0A
        .byte #%00111100;$A6
        .byte #%00111100;$98
        .byte #%00011000;$9A
Frame2
        .byte #%01011010;$02
        .byte #%01111110;$04
        .byte #%11111111;$06
        .byte #%11111111;$08
        .byte #%01111110;$0A
        .byte #%00111100;$A6
        .byte #%00111100;$98
        .byte #%00011000;$9A
Frame3
        .byte #%00101100;$02
        .byte #%01111110;$04
        .byte #%11111111;$06
        .byte #%11111111;$08
        .byte #%01111110;$0A
        .byte #%00111100;$A6
        .byte #%00111100;$98
        .byte #%00011000;$9A
;---End Graphics Data---


;---Color Data from PlayerPal 2600---

ColorFrame0
        .byte #$02;
        .byte #$04;
        .byte #$06;
        .byte #$08;
        .byte #$0A;
        .byte #$A6;
        .byte #$98;
        .byte #$9A;
ColorFrame1
        .byte #$02;
        .byte #$04;
        .byte #$06;
        .byte #$08;
        .byte #$0A;
        .byte #$A6;
        .byte #$98;
        .byte #$9A;
ColorFrame2
        .byte #$02;
        .byte #$04;
        .byte #$06;
        .byte #$08;
        .byte #$0A;
        .byte #$A6;
        .byte #$98;
        .byte #$9A;
ColorFrame3
        .byte #$02;
        .byte #$04;
        .byte #$06;
        .byte #$08;
        .byte #$0A;
        .byte #$A6;
        .byte #$98;
        .byte #$9A;
;---End Color Data---

	org $fffc
	.word Start		; reset vector
	.word Start		; interrupt vector - not used in Atari but ROM size must be 4k


