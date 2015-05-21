//********************************************************************************************
// Radio Paralax Demo
//********************************************************************************************

// Constants
// ZeroPage Addresses
.const TEXTMEMLOW = $FB
.const TEXTMEMHIGH = $FC
.const MOTIFSCREENPOSLOW = $FD
.const MOTIFSCREENPOSHIGH = $FE

.const LOGOYOFFSET = 3*40

.const STARTRASTERLINE = 50
.const SCROLLLINERASTER = 170
.const SWINGLOGORASTER = 216
.const SCROLLLINEOFFSET = 11*40
.const SCREENPOS = $0400		//!!!
.const COLOURRAMPOS = $d800
.const LOGOMEM = $7000

// Imports 
.var music = LoadSid("assets\HUBBARDIZE_v2.sid")
//.var music = LoadSid("assets\acid@night.sid")
	
.import source "macros.asm"
.pc = $5000 "Subroutines"
.import source "subroutines.asm"
.import source "irqs.asm"
	
// .pc = $2800 "Scrollfont"
// .import binary "assets\line_8px_psd.bin"


	:BasicUpstart2(start)
	
	.pc = $810 "Main Program"

start:
	:MultiColourTextMode()
	:SetBorderColour(BLACK)
	:SetBackgroundColour(BLACK)
	:SetMultiColours(LIGHT_BLUE,DARK_GRAY)
	lda #GREEN
	jsr setforegroundcolour
	
	jsr initlogoforegroundcolourgradient

	// init scrolltext	
	lda #<message	// reset textpos
	sta textpos+1
	lda #>message
	sta textpos+2
	
	jsr copylogotomemory
	

  	jsr emptyscreen	
	
musiclines:
	// Setup IRQ
	jsr music.init
    lda #music.startSong-1
	jsr initirqs
//	:MultiColourTextMode()

mainloop:	jmp mainloop
	



//********************************************************************************************
// Scrolltext                                                                                                 
//********************************************************************************************
.pc = $6000 "Scrolltext"
.import source "message.asm"


//********************************************************************************************
// Data                                                                                                 
//********************************************************************************************
.pc=music.location "Music"
.fill music.size, music.getData(i)

//********************************************************************************************
// Logo1+2
//********************************************************************************************
.pc = $3800 "Logofont"
.import binary "assets\radio_paralax_logo.imap"

.pc = $2300 "Logo Tilemap"
.var logoscr = LoadBinary("assets\radio_paralax_logo.iscr")

templogomap: .fill logoscr.getSize(), logoscr.get(i)

.pc = $4000 "Data"
rastercolours_musiclines:
	//.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8

	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, LIGHT_GRAY, GRAY, DARK_GRAY			//4 <-
	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, BLACK, BLACK, BLACK 					//4
	.byte BLACK, LIGHT_GRAY, GRAY, DARK_GRAY			//4 <-
	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, BLACK, BLACK, BLACK 					//4
	.byte BLACK, LIGHT_GRAY, GRAY, DARK_GRAY			//4 <-
	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, BLACK, BLACK, BLACK 					//4
	.byte BLACK, LIGHT_GRAY, GRAY, DARK_GRAY			//4 <-
	.byte BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK 			//8
	.byte BLACK, BLACK, BLACK, BLACK 					//4
	.byte BLACK, LIGHT_GRAY, GRAY, DARK_GRAY			//4 <-
	.byte BLACK, BLACK, BLACK, BLACK 					//4
	//.byte YELLOW, YELLOW			//2

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
	cpx #96 //End of rasterbars? 82/80
	bcc a1
rts

	
		
framecounter:
	.byte $00

textlines:
	.byte $00


	
//********************************************************************************************
// logo swing                                                                                                 
//********************************************************************************************

swinglogo1softscrolloffset: .byte $0
swinglogo1hardscrolloffset: .byte $28
swinglogo1index: .byte $90
swinglogo1active: .byte $1

swinglogo2softscrolloffset: .byte $0
swinglogo2hardscrolloffset: .byte $28
swinglogo2index: .byte $90
swinglogo2active: .byte $0

.pc = $4200 "Sine"
swingsine: 
	.fill 256, 255-floor(255*abs(sin(toRadians(i*180/256))))
	//.for(var i=0;i<150;i++) .print "sine at " + toIntString(i) + " is " + toIntString(logoswingsine.charAt(i))

// scroll vars
scrolllineactive: .byte $00
offset:		.byte $07 			// start at 7 for left scroll
smooth:		.byte $01		
nextchar:	.byte $00

rasterbuffer: .byte $00

