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
.const SCROLLLINEOFFSET = 11*40
.const SCREENPOS = $0400		//!!!
.const COLOURRAMPOS = $d800

// Imports 
//.var music = LoadSid("assets\static.sid")
	
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
	
	
	// Setup IRQ
// 	jsr music.init
//     lda #music.startSong-1

 	jsr emptyscreen	
	
musiclines:
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
// .pc=music.location "Music"
// .fill music.size, music.getData(i)	        

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

swinglogooffset: .byte $0
swinglogoindex: .byte $00
swinglogoactive: .byte $0

swingsine: 
	.fill 256, 105 + floor(70*sin(toRadians(i*360/256)))
	//.for(var i=0;i<150;i++) .print "sine at " + toIntString(i) + " is " + toIntString(logoswingsine.charAt(i))

// scroll vars
scrolllineactive: .byte $00
offset:		.byte $07 			// start at 7 for left scroll
smooth:		.byte $01		
nextchar:	.byte $00

rasterbuffer: .byte $00

