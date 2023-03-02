;----------------------------------------------------------------------------
; This file: SUPA_ASM.ASM,  support file for QuickBasic 4.x programs
; Author:    Herman Perk, Berlin, Germany
; Version:   1.2, modified back to 1.1
; Date:      1.0 - june 7 1996:	Original version: 2 procedures
; Modified:  1.1 - oct 25 1996:	ShowLevel now returns numbers of Infotrons
;				and Electrons as a longinteger function.
;				Therefore macro Trailer has been changed
;				not to contain the return to QB anymore.
;				Changes can be found: search for ;V1.1
;	     1.2 - oct 27,1996: Fast procedure added to partly calculate
;				demo time, but not listed here for reasons
;				of fairness: this knowledge might be abused
;				to create cheated demos.
;				(I only informed Maarten Egmond how it works,
;				so he could use it for his high-score lists.)
;
;
; Contents:
;
; Two routines to quickly paint Supaplex levels on screen in mini format:
;
;   ShowMiniLevel paints 1 pixel per sprite
;
;   ShowLevel	  paints 8*8 pixels per sprite (original is 16*16 pixels)
;		  and returns Infotron count and Electron count ;V1.1: added
;
; This file can be used as example for ASM file calls in QB, and for use
; as information for Pascal and C programs to paint Supaplex mini levels.
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; This file is organized as follows:
;----------------------------------------------------------------------------
; These Comments showing what these routines do and how variables are passed
; Definitions:
;   Routine names to pass to QB (PUBLIC)
;   MASM setup (.MODEL, .CODE)
;   Function return value, defined in data segment (.DATA)	;V1.1: added
;   Macro's
;     Leader   (common routine entry: setup video, 'fetch' QB variables)
;     Setpoint (put single dot on screen, update video mask)
;     SetSpriteLine (8 times SetPoint, in-line coded for speed reasons)
;     SetSprite (8 times SetSpriteLine: display 8*8 sprite as in-line code)
;     Trailer  (common routine: cleanup, almost return to QB)	;V1.1: changed
; Routines:
;   ShowMiniLevel
;     Leader (macro call)
;     loop with SetPoint (macro call) inside
;     Trailer (macro call)
;     return							;V1.1: moved
;   ShowLevel
;     Leader (macro call)
;     loop with SetSprite (macro call) inside			;V1.1: changed
;     Trailer (macro call)
;     return							;V1.1: moved
; END
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; The calling program in this case is SUPASHOW.BAS, written in Quick Basic 4.5
; and I used MASM 6.11d for this file SUPA_ASM.ASM, but TASM and earlier
; versions of MASM might work too, with minor changes.
;
; I used following batch to compile SUPASHOW.BAS, assemble SUPA_ASM.ASM and
; link both resulting OBJ files together to a stand-alone EXE file:
;----------------------------------------------------------------------------
; @echo off
; bc supashow.bas /e/o/t/ah/x/c:512;
; ml /Fosupa_asm /Cx /c supa_asm.asm
; link supashow supa_asm,,,bcom45.lib /EXEPACK /FAR
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; Following two QB routines needed ASM speed up:
;----------------------------------------------------------------------------
;  idx = 0		' prevent multiplications: idx = (yj-1) * xwidth
;  FOR yj = 1 TO ywidth
;    FOR xi = 1 TO xwidth
;      PSET (xi + xoffset, yj + yoffset), col(ASC(MID$(full$, xi + idx, 1)))
;    NEXT
;    idx = idx + xwidth
;  NEXT
;----------------------------------------------------------------------------
;  idx = 0		' prevent multiplications: idx = (yj-1) * xwidth
;			' and use only repeated additions for speed reasons
;  j = yoffset - 8
;  FOR j = 1 TO ywidth
;    j = j + 8
;    xi = xoffset - 8
;    FOR i = 1 TO xwidth
;      z = ASC(MID$(full$, i + idx, 1))
;      xi = xi + 8
;      FOR y = 0 TO 7
;	 yj = y + j
;	 FOR x = 0 TO 7
;	   PSET (x + xi, yj), colors(z, x, y)
;	 NEXT
;      NEXT
;    NEXT
;    idx = idx + xwidth
;  NEXT
;----------------------------------------------------------------------------
; where:
;   xwidth=60,ywidth=24		     : field dimensions
;   xoffset,yoffset		     : screen offsets of (mini)level, integers
;   full$=60*24+96 byte string	     : one complete level or SpEdit *.SP file
;   col(0 TO 255)		     : dot color info, integer array
;   colors(0 TO 255, 0 TO 7, 0 TO 7) : sprite info (sprite#,x,y), int array
; These routines do not pass any return values.
;V1.1: (QB examples up here are NOT changed to count Infotrons/Electrons.)
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
;These ASM routines translate to two QB 4.x calls ShowMiniLevel and ShowLevel:
;----------------------------------------------------------------------------
;DEFINT A-Z
;DECLARE SUB ShowMiniLevel(BYVAL x%,BYVAL y%,BYVAL soff AS INTEGER,_
;			   BYVAL ASeg AS INTEGER, BYVAL AOff AS INTEGER)
;
;V1.1: changed to longinteger& function declaration below
;'DECLARE SUB ShowLevel(BYVAL x%,BYVAL y%,BYVAL soff AS INTEGER,_
;'		        BYVAL ASeg AS INTEGER, BYVAL AOff AS INTEGER)
;
;DECLARE FUNCTION ShowLevel&(BYVAL x%,BYVAL y%,BYVAL soff AS INTEGER,_
;			     BYVAL ASeg AS INTEGER, BYVAL AOff AS INTEGER)
;
;DIM colors(0 TO 255, 0 TO 7, 0 TO 7) AS INTEGER
;DIM col(0 to 255) AS INTEGER
;SCREEN 12		' switch to 640*480*16
;... (several QB lines: fill vars, arrays and string)
;CALL ShowMiniLevel(xoffset,yoffset,SADD(full$),VARSEG(col(0)),VARPTR(col(0)))
;... (more QB lines)
;
;V1.1: changed to longinteger& function call plus separation of both counts
;'CALL ShowLevel(xoffset,yoffset,SADD(full$),VARSEG(colors(0,0,0)),_
;'		 VARPTR(colors(0,0,0)))
;
;Count&=ShowLevel&(xoffset,yoffset,SADD(full$),VARSEG(colors(0,0,0)),_
;		   VARPTR(colors(0,0,0)))
;
;Infotrons=Count& AND &HFFFF&		     ' lower word.   WATCH OUT!:
;					     ' &HFFFF& MUST BE LONGINT&!
;Electrons=(Count& AND &HFFFF0000)/&H10000   ' upper word, shifted low.
;
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; The array col(i) is organized by QB as:
;----------------------------------------------------------------------------
;	col(  0) at offset 0000h*2=0000h
;	col(  1) at offset 0001h*2=0002h
;	...
;	col(255) at offset 00FFh*2=01FEh
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; The array colors(i,j,k) is organized by QB as:
;----------------------------------------------------------------------------
;	colors(  0,0,0) at offset 0000h*2=0000h
;	colors(  1,0,0) at offset 0001h*2=0002h
;	...
;	colors(255,0,0) at offset 00FFh*2=01FEh
;	colors(  0,1,0) at offset 0100h*2=0200h
;	...
;	colors(255,1,0) at offset 01FFh*2=03FEh
;	...
;	colors(255,7,0) at offset 07FFh*2=0FFEh
;	colors(  0,0,1) at offset 0800h*2=1000h
;	...
;	colors(255,0,1) at offset 08FFh*2=11FEh
;	...
;	colors(255,7,7) at offset 3FFFh*2=7FFEh
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; The stack segment is used as follows:
;----------------------------------------------------------------------------
;	[bp+14]	= Argument 1: = xoffset
;	[bp+12]	= Argument 2: = yoffset
;	[bp+10]	= Argument 3: = Address of string 'full$' (in DS segment)
;	[bp+8]	= Argument 4: = Segment of array col(i) or array colors(i,j,k)
;	[bp+6]	= Argument 5: = Offset	of array col(i) or array colors(i,j,k)
;	[bp+4]	= return address (segment)
;	[bp+2]	= return address (offset)
;	[bp+0]	= saved BP
;	[bp-2]	= local var:	initial VGA bit mask (low byte only)
;	[bp-4]	= local var:	past-end-of-level compare
;	[bp-6]	= etc.: saved ES, DI, BX, CX on local stack
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
; The video mode is assumed to be mode 12: 640*480*16
; The VGA electronics is initialized by QB to accept data for all four color
; planes: all bits 0 of 8 pixels go in a single byte to plane 0, all bits 1 of
; the same 8 pixels go in a single byte to plane 1 etc.
; This VGA organization makes it possible to update the screen very fast,
; but only if the data is already present in this 'strange' format.
; Our data is coded pixelwise: a byte contains only the 4 bits of one pixel.
; I chose for the easy way out without the bit manupilations to pack 8 pixels
; into 4 bytes, with all the problems of the free offsets.
;
; This code changes the VGA electronics to accept the data as we have it:
;
;		mov	dx,3CEh 	; 03CEh, VGA index reg
;		mov	al,5		;  al = 5, mode
;		out	dx,al		; port 3CEh, EGA graphic index
;		inc	dx		; 03CFh
;		mov	al,2		; write mode 2: nibble to all planes
;		out	dx,al		; port 3CFh, EGA graphic func
;
; There are two problems with this method:
;
; 1:the lower 4 bits of a byte is copied to all those 8 pixels if the VGA
;   bit mask is not programmed to let only 1 pixel be written.
;   We need a rotating bit mask, filled with 7 zero's an one 1.
;   Since we do not always start on a byte-boundary in video-RAM, we need
;   to calculate the initial bit mask from the xoffset, passed by QB:
;
;		mov	cx,[bp+14]	; xoffset: 0...639
;		and	cl,07h		; xoffset:skew
;		mov	al,80h		; bit mask if on byte boundary
;		shr	al,cl		; calculate initial VGA bit mask
;
;   The yoffset can be ignored since each line contains 640 pixels, which
;   is an exact multiple of 8.	The bit mask can be set by:
;
;		mov	dx,3CEh 	; 03CEh, VGA index reg
;		mov	al,8		;  al = 8, data bit mask
;		out	dx,al		; port 3CEh, EGA graphic index
;		inc	dx		; 03CFh: leave the VGA index this way!
;		mov	al,bitmask	; (example: See macro SetPoint)
;		out	dx,al		; port 3CFh, set VGA bit mask
;
;   which I simplified here by keeping everything unchanged:
;
;		out	dx,al		; port 3CFh, set VGA bit mask
;
;   After a pixel has been written we have to update the bit mask, and
;   if the (plane-)byte has been done, we must update the video RAM pointer:
;
;		ror	al,1		; update VGA bit mask by rotating
;		adc	bx,0		; next screen position
;
; 2:the pixel cannot be just written since the other 7 pixels are to be
;   treated with care: they must be fetched into 4 latches internally in the
;   VGA electronics first: one byte (latch) per color plane, 4 planes.
;   These latches will hold the information of the other 7 pixels which we
;   masked out, and will be written back to all 4 planes together with our
;   8th pixel, which we mask in.
;   The latches are filled by just reading the video RAM at the pixeladdress.
;   We cannot use the OR to combine, since we read a byte from one color plane
;   and not a pixel in our format.  (We would need 4 bytes at once!)
;
;   Either we do a dummy read and then write pixel (ds=Video RAM, bx=offset):
;		test	ah,ds:[bx]	; dummy read: fill VGA latches!
;		mov	ds:[bx],ah	; put color nibble on screen
;   or do both at once, as done in these routines:
;		xchg	ds:[bx],ah	; dummy read: fill VGA latches!
;					; and put color nibble on screen
;----------------------------------------------------------------------------

	PUBLIC ShowMiniLevel, ShowLevel	; QB needs to know the routine names

	.MODEL MEDIUM, BASIC		; MASM 6.11 has predefined definitions
					;   for QB, so why not use those.

;V1.1: added function return value
	.DATA				; defined in DS segment
LongNumber	LABEL	DWORD		; long integer return value, split
					;   into 2 words for local use:
InfotronCount	dw	?		; low order portion, goes to AX
ElectronCount	dw	?		; high order portion, goes to DX


	.CODE


Leader		MACRO
		push	bp		; QB passes arguments on stack
		mov	bp,sp
		sub	sp,4		; create 2 temporary local variables

		push	es		; save QB regs
		push	di
		push	si
		push	bx
		push	cx

		mov	dx,3CEh 	; 03CEh, VGA index reg
		mov	al,5
		out	dx,al		; port 3CEh, EGA graphic index
					;  al = 5, mode
		inc	dx		; 03CFh
		in	al,dx
		push	ax		; save original setting

		mov	al,2		; write mode 2: nibble to all planes
		out	dx,al		; port 3CFh, EGA graphic func

		dec	dx		; 03CEh
		mov	al,8
		out	dx,al		; port 3CEh, EGA graphic index
					;  al = 8, data bit mask
					; leave the VGA index this way!

					;BUILD SCREEN POINTER
		mov	ax,[bp+12]	; yoffset: 0...479
		mov	bx,80		; (=640/8)
		mul	bx		; 0...38320 in AX, 0 in DX

		mov	bx,[bp+14]	; xoffset: 0...639
		shr	bx,1		;  /2
		shr	bx,1		;  /4
		shr	bx,1		;  /8
		add	bx,ax		; 0A000:BX=(xoffset+640*yoffset)/8
		push	bx		; save line start position

		mov	cx,[bp+14]	; xoffset: 0...639
		and	cl,07h		; xoffset:skew
		mov	al,80h
		shr	al,cl		; calculate initial VGA bit mask
		mov	[bp-2],ax	; initial VGA bit mask


		les	di,[bp+6]	; fetch array addr (0..40..(255))
		mov	si,[bp+10]	; fetch string addr (DS:SI)

		mov	cx,si		; save string addr (DS:SI)
		add	cx,25*60	; calculate 1st sprite past end
		mov	[bp-4],cx	; past-end-of-level compare
		sub	cx,24*60	; begin of next line (field width)
		ENDM



SetPoint	MACRO
		out	dx,al		; port 3CFh, set VGA bit mask
		mov	ah,es:[di]	; fetch color nibble from QB array
		xchg	ds:[bx],ah	; dummy read: fill VGA latches!
					; and put color nibble on screen
		ror	al,1		; update VGA bit mask by rotating
		adc	bx,0		; next screen position
		ENDM



SetSpriteLine	MACRO
		SetPoint		; 1	Fast
		add	di,200h 	; next color-array index
		SetPoint		; 2	  in-line
		add	di,200h 	; next color-array index
		SetPoint		; 3	    code
		add	di,200h 	; next color-array index
		SetPoint		; 4	      for
		add	di,200h 	; next color-array index
		SetPoint		; 5		one
		add	di,200h 	; next color-array index
		SetPoint		; 6		  line
		add	di,200h 	; next color-array index
		SetPoint		; 7		    of
		add	di,200h 	; next color-array index
		SetPoint		; 8		      sprite
		ENDM



SetSprite	MACRO
		SetSpriteLine		; 1
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 2
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 3
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 4
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 5
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 6
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 7
		add	di,200h 	; next color-array index
		add	bx,(640/8)-1	; next screen line of sprite

		SetSpriteLine		; 8
		sub	bx,7*(640/8)	; screen line we came from + 8 pixels
		ENDM



Trailer		MACRO
		pop	bx		; discard line start screen position
					; pushed in leader

		mov	al,0FFh 	; assume index=8: VGA bit mask
		out	dx,al		; port 3CFh, EGA graphic func

		dec	dx
		mov	al,5
		out	dx,al		; port 3CEh, EGA graphic index
					;  al = 5, mode
		inc	dx
		pop	ax		; restore original register contents
		out	dx,al		; port 3CFh, EGA graphic func

		pop	cx		; restore QB regs
		pop	bx
		pop	si
		pop	di
		pop	es

;V1.1: moved out of macro to just after macro call, to insert return values
;		mov	sp,bp		; remove temporary local variables
;		pop	bp		; back to QB:
;		ret	10		; return and flush 5 arguments

		ENDM



;----------------------------------------------------------------------------


ShowMiniLevel	PROC

		Leader			; init screen and fetch pointers

;    ES:DI=array base address
;    DS:SI=string base+offset address
;	AL=VGA bit mask
;	CX=string base+offset of begin of next line
;	BX=current screen pointer
; 0A000:stack=screen pointer of beginning of line
;    AH,DX available

SML_Loop:
		push	di		; save QB color-array init-index
		mov	dl,al		; save rotating VGA bit mask
		mov	al,ds:[si]	; fetch stringbyte (0..40..(255))
		xor	ah,ah		; convert to ..
		shl	ax,1		;  .. word array offset
		add	di,ax
		mov	al,dl		; restore rotating VGA bit mask

		push	ds
		mov	dx,0A000h	; video memory segment
		mov	ds,dx
		mov	dx,03CFh	; (index kept to 8: data bit mask)

		SetPoint		; display 1 pixel

		pop	ds		; restore QB level-string segment
		pop	di		; restore QB color-array init-index

		inc	si		; point to next char
		cmp	si,cx		; arrived on next line?
		jb	SML_Loop	; no--proceed sequentially

		add	cx,60		; update line compare
		cmp	cx,[bp-4]	; past game field size?
		jae	SML_End 	; yes--end

		pop	bx		; get old start
		add	bx,640/8	; advance 1 line = 640 pixels
		push	bx		; save line start position

		mov	ax,[bp-2]	; VGA bitmask starts equal on each line
		jmp	SML_Loop

SML_End:
		Trailer 		; cleanup

;V1.1: moved out of macro to here
		mov	sp,bp		; remove temporary local variables
		pop	bp		; back to QB:
		ret	10		; return and flush 5 arguments

ShowMiniLevel	ENDP


;----------------------------------------------------------------------------


ShowLevel	PROC

		Leader			; init screen and fetch pointers

;    ES:DI=array base address
;    DS:SI=string base+offset address
;	AL=VGA bit mask
;	CX=string base+offset of begin of next line
;	BX=current screen pointer
; 0A000:stack=screen pointer of beginning of line
;    AH,DX available: DX used for VGA port address 03CFh
;		      AH free for universal use
;

;V1.1: inserted code to clear both counters, no registers changed
		mov	[InfotronCount],0	; clear Infotron counter
		mov	[ElectronCount],0	; clear Electron counter
;V1.1: end of inserted code

SL_Loop:
		push	di		; save QB color-array init-index
		mov	dl,al		; save rotating VGA bit mask
		mov	al,ds:[si]	; fetch stringbyte (0..40..(255))

;V1.1: inserted code to count Infotrons and Electrons in level
		cmp	al,4		; Infotron?
		jne	NoInfotron
		inc	[InfotronCount]	; count Infotrons
		jmp	NoElectron
NoInfotron:
		cmp	al,24		; Electron?
		jne	NoElectron
		inc	[ElectronCount]	; count Electrons
NoElectron:
;V1.1: end of inserted code

		xor	ah,ah		; convert to ..
		shl	ax,1		;  .. word array offset
		add	di,ax
		mov	al,dl		; restore rotating VGA bit mask

		push	ds		; save QB level-string segment
		mov	dx,0A000h	; video memory segment
		mov	ds,dx
		mov	dx,03CFh	; (index kept to 8: data bit mask)

		SetSprite		; display 8*8 pixels = 1 sprite

		pop	ds		; restore QB level-string segment
		pop	di		; restore QB color-array init-index

		inc	si		; point to next char
		cmp	si,cx		; arrived on next line?
		jb	SL_Loop 	; no--proceed sequentially

		add	cx,60		; update line compare (level=60*24)
		cmp	cx,[bp-4]	; past game field size?
		jae	SL_End		; yes--end

		pop	bx		; get old line start
		add	bx,8*(640/8)	; advance 8 lines = 8*640 pixels
		push	bx		; save line start position

		mov	ax,[bp-2]	; VGA bitmask starts equal on each line
		jmp	SL_Loop 	; next line of sprites

SL_End:
		Trailer 		; cleanup

;V1.1: inserted code to return 2 word values on long-integer-function return
		mov	ax,[InfotronCount] ; low order portion, into AX
		mov	dx,[ElectronCount] ; high order portion, into DX
;V1.1: end of inserted code

;V1.1: moved out of macro to here
		mov	sp,bp		; remove temporary local variables
		pop	bp		; back to QB:
		ret	10		; return and flush 5 arguments

ShowLevel	ENDP


;----------------------------------------------------------------------------
; Here used to be code to calculate the demo time ... This is removed.
;----------------------------------------------------------------------------


		END
