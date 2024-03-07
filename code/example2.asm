SC_INDEX        equ  03c4h   ;Sequence Controller Index
CRTC_INDEX      equ  03d4h   ;CRT Controller Index
MISC_OUTPUT     equ  03c2h   ;Miscellaneous Output register
SCREEN_SEG      equ  0a000h  ;segment of display memory in mode X
MAP_MASK        equ    02h                ;index in SC of Map Mask register
SCREEN_WIDTH    equ    80  
parms   struc
        dw      2 dup (?)               ;pushed BP and return address
X       dw      ?                       ;X coordinate of pixel to draw
Y       dw      ?                       ;Y coordinate of pixel to draw
PageBase dw     ?                       ;base offset in display memory of page in
                                        ; which to draw pixel
Color   dw      ?                       ;color in which to draw pixel
parms   ends
        .model  small
        .data
; Index/data pairs for CRT Controller registers that differ between
; mode 13h and mode X.
CRTParms label  word
        dw      00d06h  ;vertical total
        dw      03e07h  ;overflow (bit 8 of vertical counts)
        dw      04109h  ;cell height (2 to double-scan)
        dw      0ea10h  ;v sync start
        dw      0ac11h  ;v sync end and protect cr0-cr7
        dw      0df12h  ;vertical displayed
        dw      00014h  ;turn off dword mode
        dw      0e715h  ;v blank start
        dw      00616h  ;v blank end
        dw      0e317h  ;turn on byte mode
CRT_PARM_LENGTH equ     (($-CRTParms)/2)

        .code
        public  _Set320x240Mode
        public _WritePixelX
         
_Set320x240Mode proc    near
        push    bp      ;preserve caller's stack frame
        push    si      ;preserve C register vars
        push    di      ; (don't count on BIOS preserving anything)

        mov     ax,13h  ;let the BIOS set standard 256-color
        int     10h     ; mode (320x200 linear)

        mov     dx,SC_INDEX
        mov     ax,0604h
        out     dx,ax   ;disable chain4 mode
        mov     ax,0100h
        out     dx,ax   ;synchronous reset while setting Misc Output
                        ; for safety, even though clock unchanged
        mov     dx,MISC_OUTPUT
        mov     al,0e3h
        out     dx,al   ;select 25 MHz dot clock & 60 Hz scanning rate

        mov     dx,SC_INDEX
        mov     ax,0300h
        out     dx,ax   ;undo reset (restart sequencer)

        mov     dx,CRTC_INDEX ;reprogram the CRT Controller
        mov     al,11h  ;VSync End reg contains register write
        out     dx,al   ; protect bit
        inc     dx      ;CRT Controller Data register
        in      al,dx   ;get current VSync End register setting
        and     al,7fh  ;remove write protect on various
        out     dx,al   ; CRTC registers
        dec     dx      ;CRT Controller Index
        cld
        mov     si,offset CRTParms ;point to CRT parameter table
        mov     cx,CRT_PARM_LENGTH ;# of table entries
SetCRTParmsLoop:
        lodsw           ;get the next CRT Index/Data pair
        out     dx,ax   ;set the next CRT Index/Data pair
        loop    SetCRTParmsLoop

        mov     dx,SC_INDEX
        mov     ax,0f02h
        out     dx,ax   ;enable writes to all four planes
        mov     ax,SCREEN_SEG ;now clear all display memory, 8 pixels
        mov     es,ax         ; at a time
        sub     di,di   ;point ES:DI to display memory
        sub     ax,ax   ;clear to zero-value pixels
        mov     cx,8000h ;# of words in display memory
        rep     stosw   ;clear all of display memory

        pop     di      ;restore C register vars
        pop     si
        pop     bp      ;restore caller's stack frame
        ret
_Set320x240Mode endp
_WritePixelX    proc    near
        push    bp                      ;preserve caller's stack frame
        mov     bp,sp                   ;point to local stack frame

        mov     ax,SCREEN_WIDTH
        mul     [bp+Y]                  ;offset of pixel's scan line in page
        mov     bx,[bp+X]
        shr     bx,1
        shr     bx,1                    ;X/4 = offset of pixel in scan line
        add     bx,ax                   ;offset of pixel in page
        add     bx,[bp+PageBase]        ;offset of pixel in display memory
        mov     ax,SCREEN_SEG
        mov     es,ax                   ;point ES:BX to the pixel's address

        mov     cl,byte ptr [bp+X]
        and     cl,011b                 ;CL = pixel's plane
        mov     ax,0100h + MAP_MASK     ;AL = index in SC of Map Mask reg
        shl     ah,cl                   ;set only the bit for the pixel's plane to 1
        mov     dx,SC_INDEX             ;set the Map Mask to enable only the
        out     dx,ax                   ; pixel's plane

        mov     al,byte ptr [bp+Color]
        mov     es:[bx],al              ;draw the pixel in the desired color

        pop     bp                      ;restore caller's stack frame
        ret
_WritePixelX    endp
        end