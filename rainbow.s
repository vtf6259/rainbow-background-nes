.segment "CODE"

.org $C000 ; Starting address of the program

; Initialization routine
reset:
    sei ; Disable interrupts
    cld ; Clear decimal mode
    ldx #$FF ; Set initial color index to 255

mainLoop:
    jsr setPaletteColor ; Set current color from palette
    jsr waitVBlank ; Wait for VBlank

    dex ; Decrement color index
    bpl mainLoop ; Loop until color index becomes negative

    jmp mainLoop ; Infinite loop

; Set current color from palette
setPaletteColor:
    lda colorIndex ; Load color index
    clc
    adc basePaletteAddr ; Add base palette address
    sta $2006 ; Set PPU address low byte
    lda $2002 ; Wait for PPU to be ready
    lda colorIndex ; Load color index again
    adc basePaletteAddrHigh ; Add base palette address high byte
    sta $2006 ; Set PPU address high byte
    lda $2002 ; Wait for PPU to be ready
    lda #$03 ; Set palette color
    sta $2007 ; Write to PPU data

    rts

; Wait for VBlank
waitVBlank:
    lda $2002 ; Read PPU status
    bpl waitVBlank ; Wait until VBlank starts
    rts

.segment "DATA"

colorIndex: .byte 255 ; Initial color index
basePaletteAddr: .word $3F00 ; Base address of palette in PPU memory
basePaletteAddrHigh: .byte $00 ; High byte of base palette address

