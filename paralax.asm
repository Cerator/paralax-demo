//********************************************************************************************
// Radio Paralax Demo
//********************************************************************************************

// Constants
// ZeroPage Addresses
.const TEXTMEMLOW = $FB
.const TEXTMEMHIGH = $FC
.const MOTIFSCREENPOSLOW = $FD
.const MOTIFSCREENPOSHIGH = $FE

.const STARTRASTERLINE = 50
.const SCROLLLINERASTER = 146
.const SWINGLOGORASTER = 194
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
	:SetBorderColour(BLACK)
	:SetBackgroundColour(BLACK)
	lda #GREEN
	jsr setforegroundcolour

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
framecounter:
	.byte $00

textlines:
	.byte $00

.align $100		
rastercolours_musiclines:
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
	.byte BLACK, BLACK			//2
	

	
//********************************************************************************************
// logo swing                                                                                                 
//********************************************************************************************

swinglogo1softscrolloffset: .byte $0
swinglogo1hardscrolloffset: .byte $28
swinglogo1index: .byte $90
swinglogo1active: .byte $1

swinglogo2softscrolloffset: .byte $0
swinglogo2hardscrolloffset: .byte $0
swinglogo2index: .byte $00
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

