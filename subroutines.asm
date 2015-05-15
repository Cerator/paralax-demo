//********************************************************************************************
// Subroutines                                                                                                 
//********************************************************************************************
	
//********************************************************************************************
// Rasterbars                                                                                                 
//********************************************************************************************

.align $100
rastermusiclines:
	ldx #$05
d1:	dex
	bne d1

	ldx #$00
c1:	ldy #$08
a1:	lda rastercolours_musiclines,x
	sta $d020
	sta $d021
	inx
	dey
	beq c1
	
	txa
	ldx #$03 //7
a2:	dex
	bne a2

	nop
	nop
	ldx #BLACK
	stx $d020
	stx $d021
	
	ldx #$01 //7
b1:	dex
	bne b1
	
	tax
	cpx #82 //End of rasterbars?
	bcc a1
rts


//********************************************************************************************
// Screen                                                                                                 
//********************************************************************************************

emptyscreen:
	lda #%00000000	// disable all sprites
	sta $d015		// disable all sprites
	:FillScreen(32)
rts

printmotif:
	ldy #159
	charloop:
		lda (TEXTMEMLOW),y //(TEXTMEMLOW)
		sta (MOTIFSCREENPOSLOW),y
		dey
		bne charloop

rts

setforegroundcolour:
	ldx #$00
colourscreen:	
	sta COLOURRAMPOS,x
	sta COLOURRAMPOS+$100,x
	sta COLOURRAMPOS+$200,x
	sta COLOURRAMPOS+$300,x
	dex
	bne colourscreen
rts

initlogoforegroundcolourgradient:
	ldx #$27
colourlogoline1:	
	lda #WHITE+%1000
	sta COLOURRAMPOS,x
	sta COLOURRAMPOS+$c8,x
	dex
	bne colourlogoline1
	
	ldx #$27
colourlogoline2:	
	lda #CYAN+%1000
	sta COLOURRAMPOS+$28,x
	sta COLOURRAMPOS+$28+$c8,x
	dex
	bne colourlogoline2
	
	ldx #$27
colourlogoline3:	
	lda #CYAN+%1000
	sta COLOURRAMPOS+$50,x
	sta COLOURRAMPOS+$50+$c8,x
	dex
	bne colourlogoline3
	
	ldx #$27
colourlogoline4:	
	lda #PURPLE+%1000
	sta COLOURRAMPOS+$78,x
	sta COLOURRAMPOS+$78+$c8,x
	dex
	bne colourlogoline4
	
	ldx #$27
colourlogoline5:	
	lda #PURPLE+%1000
	sta COLOURRAMPOS+$a0,x
	sta COLOURRAMPOS+$a0+$c8,x
	dex
	bne colourlogoline5
rts

//********************************************************************************************
// Copy logo to memory
//********************************************************************************************

copylogotomemory:
	ldx #$00
	lda #$20
emptylogoloop:
	sta LOGOMEM,x
	sta LOGOMEM+$100,x
	sta LOGOMEM+$200,x
	sta LOGOMEM+$300,x
	sta LOGOMEM+$400,x
	sta LOGOMEM+$500,x
	sta LOGOMEM+$600,x
	sta LOGOMEM+$700,x
	sta LOGOMEM+$800,x
	sta LOGOMEM+$900,x
	dex
	bne emptylogoloop
	
	ldx #0
	ldy #40
copyloop:
	lda templogomap,x
	sta LOGOMEM,y
	lda templogomap+$28,x
	sta LOGOMEM+$100,y
	lda templogomap+$50,x
	sta LOGOMEM+$200,y
	lda templogomap+$78,x
	sta LOGOMEM+$300,y
	lda templogomap+$A0,x
	sta LOGOMEM+$400,y
	lda templogomap+$C8,x
	sta LOGOMEM+$500,y
	lda templogomap+$F0,x
	sta LOGOMEM+$600,y
	lda templogomap+$118,x
	sta LOGOMEM+$700,y
	lda templogomap+$140,x
	sta LOGOMEM+$800,y
	lda templogomap+$168,x
	sta LOGOMEM+$900,y
	iny
	inx
	cpx #40
	bne copyloop

rts

drawlogo1:
	ldy #39
	ldx swinglogo1hardscrolloffset
	txa
	clc
	adc	#46 	//39
	tax 
drawlogo1loop:
	lda LOGOMEM,x
	sta SCREENPOS,y
	lda LOGOMEM+$100,x
	sta SCREENPOS+$28,y
	lda LOGOMEM+$200,x
	sta SCREENPOS+$50,y
	lda LOGOMEM+$300,x
	sta SCREENPOS+$78,y
	lda LOGOMEM+$400,x
	sta SCREENPOS+$A0,y
	dex
	dey
	bpl drawlogo1loop
rts

drawlogo2:
	ldy #39
	ldx swinglogo1hardscrolloffset
	txa
	clc
	adc	#46 	//39
	tax 
drawlogo2loop:
	lda LOGOMEM+$500,x
	sta SCREENPOS+$C8,y
	lda LOGOMEM+$600,x
	sta SCREENPOS+$F0,y
	lda LOGOMEM+$700,x
	sta SCREENPOS+$118,y
	lda LOGOMEM+$800,x
	sta SCREENPOS+$140,y
	lda LOGOMEM+$900,x
	sta SCREENPOS+$168,y
	dex
	dey
	bpl drawlogo2loop
rts

//********************************************************************************************
// Swing the lines
//********************************************************************************************

swinglogo1:	
	lda swinglogo1active
	beq continueafterlogo1
	ldx swinglogo1index
	lda swingsine,x
	pha
	and #$07
	eor #$07
	ora #$10
	sta swinglogo1softscrolloffset

	pla
	lsr
	lsr
	lsr
	tax	
	// now the sine char offset is in x and we can draw the logo
	stx swinglogo1hardscrolloffset

	inc swinglogo1index

continueafterlogo1:		
rts

//********************************************************************************************
// Draw the lines
//********************************************************************************************

// drawlogo1:
// 	ldy #$00
// looplogo1:
// 	lda logo1,x
// 	sta SCREENPOS,y
// 	lda logo1+$40,x
// 	sta SCREENPOS+$28,y
// 	lda logo1+$80,x
// 	sta SCREENPOS+$50,y
// 	lda logo1+$C0,x
// 	sta SCREENPOS+$78,y
// 	lda logo1+$100,x
// 	sta SCREENPOS+$A0,y
// 	inx
// 	iny
// 	cpy #$28
// 	bne looplogo1
// 
// rts


//********************************************************************************************
// Scroller
//********************************************************************************************

// initscrolllinecolours:
// 	ldx #33
// 	lda #LIGHT_GREEN
// scrolltextcolourloop:	
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+2],x
// 	dex
// 	bne scrolltextcolourloop
// 	
// 
// 	lda #DARK_GRAY
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+0]
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+38]
// 	lda #GRAY
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+1]
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+37]
// 	lda #GREEN
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+2]
// 	sta [COLOURRAMPOS+SCROLLLINEOFFSET+36]
// 
// rts


shiftrow:	
	ldx #00 			// shift characters to the left
	lda SCREENPOS+SCROLLLINEOFFSET+1, x		//$07c1
	sta SCREENPOS+SCROLLLINEOFFSET, x		//$07c0
	inx
	cpx #39
	bne shiftrow+2
textpos:
	lda $dead			// load char from memory (modified at the beginning ) 
	cmp #$FF			// Scrollend char?
	bne printchar		// no? then print char
	lda #<message		// reset textpos
	sta textpos+1
	lda #>message
	sta textpos+2
	bne andincpos			
printchar:			
	sta SCREENPOS+SCROLLLINEOFFSET+$27			// print char at the end of the line
andincpos:
	:IncTextPos() 		

	lda #DARK_GRAY
	sta [COLOURRAMPOS+SCROLLLINEOFFSET+0]
	sta [COLOURRAMPOS+SCROLLLINEOFFSET+38]
	lda #GRAY
	sta [COLOURRAMPOS+SCROLLLINEOFFSET+1]
	sta [COLOURRAMPOS+SCROLLLINEOFFSET+37]
	lda #GREEN
	sta [COLOURRAMPOS+SCROLLLINEOFFSET+2]
	sta [COLOURRAMPOS+SCROLLLINEOFFSET+36]
	
rts