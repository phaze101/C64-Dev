;==============================================================================
; Character Scroller
; By Prince / Phaze101
; on 13th Jan 2020
;
; Scrolls a whole line one character at a time
; Not Smooth same effect as if doing it from Basic V2
; Scrolltext can be longer than 256 bytes
; Please note - DO NOT USE THE @ SIGN IN THE SCROLLTEXT 
;
; Please use CBM Prog Studio to Assemble this Code
;==============================================================================


; Constants Defenitions
Screen  =       $0400+480   ;middle of screen 40*12

*       =       $C000

Main
; Sclear screen
; Not important what tpe of clear screen routine in this case
        lda     #147            ; Clear Screen Screen Code
        jsr     $ffd2           ; Kernal routine to print a charater

StartScroll
        lda     #<ScrollText
        sta     $fb
        lda     #>ScrollText
        sta     $fc

; Fill In chars
FillChar
        lda     #5
        sta     Frames

        ldy     #$00
        lda     ($fb),y
        beq     StartScroll
        sta     Screen+39
        
        clc
        lda     $fb
        adc     #$01
        sta     $fb
        lda     $fc
        adc     #$00
        sta     $fc

; Create a delay
; Screen Refresh delays are better
;        ldx     #$40
;delayx
;        ldy     #$ff
;delayy
;        dey
;        bne     delayy
;        dex
;        bne     delayx

; Wait for Scan line 250
; To avoid Flicker 
; Not the best solution this way
; Better use interrupts
ScanLine
        lda     $d012
        cmp     #$fa
        bne     ScanLine

; Are we still on raster line 250
SameScanLine
        lda     $d012
        cmp     #$fa
        beq     SameScanLine

; Delay using Screen Refresh Frames
; There are 50 frames per second on a PAL System
; Hence if the Number is 5 that means that ever 10 Frames we Scroll
        dec     Frames
        bne     ScanLine

; Scrolls by one character the whole line
        ldx     #$00
ScrollLine
        lda     Screen+1,x
        sta     Screen,x
        inx
        cpx     #$27
        bne     ScrollLine
;Loopy
        jmp     FillChar

exit
        rts

;==============================================================================
; Our Data
;==============================================================================

ScrollText
        text    'phaze101 rulez :) phaze 101 there can only be one :) '
        text    'phaze 101 what we built can never be destroyed :) '
        text    'seriously joking here but this is what we used to say '
        text    '30 years or more ago. do as you wish with this code. it is free '
        text    'to use. some charity from us. any typos in english I do not care '
        text    'yeah I was never a big fan of languages. they were invented as '
        text    'a mean of communication but some people take this too seriously '
        text    'some people died for a language. doh can't understand it '
        text    '                             '
        byte    0

Frames
        byte    0