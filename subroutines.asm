//********************************************************************************************
// Subroutines                                                                                                 
//********************************************************************************************
	
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
// Swing the lines
//********************************************************************************************

swinglogo:	
	lda swinglogoactive
	beq continueafterline
	ldx swinglogoindex
	lda swingsine,x
	pha
	and #$07
	eor #$07
	ora #$10
	sta swinglogooffset

	pla
	lsr
	lsr
	lsr
	tax	
	// now the sine char offset is in x and we can draw the line
// 	jsr drawline

	inc swinglogoindex

continueafterline:		
rts

//********************************************************************************************
// Draw the lines
//********************************************************************************************

// drawline:
// 	ldy #$00
// loopline1:
// 	lda (LOGO),x
// 	sta SCREENPOS,y
// 	lda (LOGO)+$40,x
// 	sta SCREENPOS+$28,y
// 	lda demo3+$80,x
// 	sta SCREENPOS+$50,y
// 	lda demo3+$C0,x
// 	sta SCREENPOS+$78,y
// 	inx
// 	iny
// 	cpy #$28
// 	bne loopline1
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