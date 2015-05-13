//********************************************************************************************
// Macros                                                                                                 
//********************************************************************************************

.macro FillScreen(filler) {
	lda #filler 					// should be an empty char!
	ldx #$00
writescreen:	
	sta SCREENPOS,x
	sta SCREENPOS+$100,x
	sta SCREENPOS+$200,x
	sta SCREENPOS+$300,x
	dex
	bne writescreen
}

.macro ScrollingOff() {
	lda $d016			// default to no scroll on start of screen
	and #248			// mask register to maintain higher bits
	sta $d016
}

.macro IncTextPos() {
	inc textpos+1
	bne incend
	inc textpos+2
incend:
}

.macro SetBorderColour(col){
	lda #col
	sta $d020
}

.macro SetBackgroundColour(col){
	lda #col
	sta $d021
}

.macro SetROMCharset(){
    lda $d018
    and #%11110001
    ora #%00000100        // set chars location to $1000 for displaying the ROM font
    sta $d018
}

.macro SetScrollCharset(){
    lda $d018
    and #%11110001
    ora #%00001010        // set chars location to $2800 for displaying the custom font
    sta $d018
}

.macro SetLogoCharSet() {
    lda $d018
    and #%11110001
    ora #%00001110        // set chars location to $3800 for displaying the custom font
    sta $d018
}


.macro SetRasterLine(whichcolours,colourscheme) {
	ldx #08
colourloop:
	lda colourscheme,x
	sta whichcolours,x
	dex
	bpl colourloop	
}


.macro Delay(time) {
    ldx #time
delayx:    
    ldy #$FF
delayy:
    dey
    bne delayy
    dex
    bne delayx
}

.macro DelayFrames(frames) {
	lda theendisnigh
	bne nomoredelay
    lda #frames
    sta framecounter
delayframe:    
    lda framecounter
    bne delayframe
nomoredelay:
}

