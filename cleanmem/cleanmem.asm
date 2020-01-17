	processor 6502

	seg code
	org $f000

start:
	sei		; disable interrupts
	cld		; clear BCD
	ldx  #$ff
	txs		; transfer x to sp


	lda #0
	ldx #0
loop:
	dex
	sta $0,X
	bne loop


	org $fffc
	.word start		; reset vector
	.word start		; interrupt vector - not used in Atari but ROM size must be 4k


