// ********************************************************************************************
// IRQ loops                                                                                                 
// ********************************************************************************************

initirqs:
	sei             // set up interrupt
    lda #$7f
    sta $dc0d       // turn off the CIA interrupts
    sta $dd0d
    and $d011       // clear high bit of raster line
    sta $d011		

// 	lda #00
// 	sta nextchar
    
    ldy #0			
    sty $d012
    lda #<startofscreen	// load interrupt address
    ldx #>startofscreen
    sta $0314
    stx $0315
	
    lda #$01        // enable raster interrupts
    sta $d01a
    cli
rts

startofscreen:
//	:ScrollingOff()
	
	dec framecounter

	jsr music.play		// more time at the bottom of the screen!
	
	:SetLogoCharSet()
	
   	lda swinglogo1softscrolloffset
  	sta $d016
 	
	ldy #STARTRASTERLINE
    sty $d012
    lda #<musiclineraster	// load interrupt address
    ldx #>musiclineraster
    sta $0314
    stx $0315
    
	ldx #$00
	ldy #$7f
	inc $d019			// acknowledge interrupt
	jmp $ea81


musiclineraster:
	lda #$ff
	sta $d019

	jsr rastermusiclines
	
	ldy #SCROLLLINERASTER
    sty $d012
    lda #<scrolllineraster	// load interrupt address
    ldx #>scrolllineraster
    sta $0314
    stx $0315
    
	ldx #$00
	ldy #$7f
	inc $d019			// acknowledge interrupt
	jmp $ea81

scrolllineraster:
	lda #$ff
	sta $d019

	:SetScrollCharset()
	lda scrolllineactive
	bne scroll
    ldy #SWINGLOGORASTER
    sty $d012
    lda #<swinglogoraster
    ldx #>swinglogoraster
    jmp scrollend

scroll:	
// 	lda $d016			// grab scroll register
// 	and #224			// mask lower 3 bits 248
// 	ora offset			// apply scroll
// 	sta $d016

	// prepare raster interrupt to be overwritten when the row has to be shifted
    ldy #SWINGLOGORASTER
    sty $d012
    lda #<swinglogoraster
    ldx #>swinglogoraster

	dec smooth			// smooth scroll
	bne scrollend

	dec offset			// update scroll
	dec offset			// update scroll
	bpl resetsmooth
	lda #07				// reset scroll offset
	sta offset

    ldy #SCROLLLINERASTER + 16
    sty $d012
    lda #<rowshiftraster	// load interrupt address
    ldx #>rowshiftraster

resetsmooth:	
	ldy #01				// set smoothing // orig #01
	sty smooth			
	
scrollend:	

    sta $0314
    stx $0315
	ldx #$00
	ldy #$7f
	inc $d019			// acknowledge interrupt
	jmp $ea81

	

rowshiftraster:
	lda #$ff
	sta $d019

	jsr shiftrow

    ldy #SWINGLOGORASTER
    sty $d012
    lda #<swinglogoraster
    ldx #>swinglogoraster

    sta $0314
    stx $0315
	ldx #$00
	ldy #$7f
	inc $d019			// acknowledge interrupt
	jmp $ea81
	
swinglogoraster:
	lda #$ff
	sta $d019

	jsr swinglogo1
	
 	jsr drawlogo1
 	jsr drawlogo2
	
    ldy #0
    sty $d012
    lda #<startofscreen
    ldx #>startofscreen

    sta $0314
    stx $0315
	ldx #$00
	ldy #$7f
	inc $d019			// acknowledge interrupt
	jmp $ea81
	
		