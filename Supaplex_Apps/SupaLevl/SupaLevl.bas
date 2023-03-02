' This program converts Supaplex file LEVELS.DAT into 2 ASCII text files

scnfile$ = "slevels.txt"    ' output file for screen (unformatted PC-"ASCII")
prnfile$ = "plevels.txt"    ' output file for printer (6 screens/page w. FF)

'-------------------------------------------------------------------------
' Written in Quick Basic (QBASIC, which everyone with MS-DOS has).
'
' Feel free to use and change it, although it lacks proper comments.
'
' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
' I made this program back in 93 for my then 3 years old son Daniel.
' He played with several levels at that time already.
' Now he chooses levels from the "book".
' His absolute favorite is "CHAOS", which he finishes! in a jiffy by now.
' (I showed him several tricks, like yield doubling with exploding electrons,
' fusing utility disks)  In several levels he is faster now than I am and he
' manages to create hanging infotrons on demand, which act as RAM chips.
'
' On the Internet I found surprisingly the Supaplex page, and I thought this
' program may be of use.
' I never thought about using it again, so I never commented it properly,
' and I am not going to make time for commenting this program too.
' I only did some trivial commenting, and integrated the HP-Deskjet command
' string into this program, for this "release"
'
' Herman Perk, Berlin, Germany
' Internet/CompuServe:          100327.467@compuserve.com
'-------------------------------------------------------------------------


'-------------------------------------------------------------------------
' Define printer command strings (HP-Deskjet) to print small.
' Change for other printers. Use PC font courier (fixed spacing).
'
FF$ = CHR$(12)          ' Form Feed character
ESC$ = CHR$(27)         ' Escape character
'
PrtSmall$ = ESC$ + "(s20h6V" + ESC$ + "&l12D"
PrtNormal$ = ESC$ + "(s10h12V" + ESC$ + "&l16D"
'-------------------------------------------------------------------------


DIM x%(39, 110), s$(110), t%(110), q$(43), a$(32)


'-------------------------------------------------------------------------
' Definition of representation of stuctures.  Alter at will ...
'
 q$(0) = " ":   ' 00  space             (28 = hardware space ...)
 q$(1) = "o":   ' 01  zonk
 q$(2) = "°":   ' 02  base
 q$(3) = "":   ' 03  Murphy            (2B = hardware inverted Murphy)
 q$(4) = "&":   ' 04  infotron
 q$(5) = "²":   ' 05  small RAM chip
 q$(6) = "Û":   ' 06  hardware (square, standard pyramid shape)
 q$(7) = "E":   ' 07  exit
 q$(8) = "B":   ' 08  brown/orange utility disk
 q$(9) = ">":   ' 09  port 1 left to right  
q$(10) = "":   ' 0A  port 1 up to down
q$(11) = "<":   ' 0B  port 1 right to left  
q$(12) = "":   ' 0C  port 1 down to up
q$(13) = ">":   ' 0D  port 2 left to right (gravity change)  
q$(14) = "":   ' 0E  port 2 up to down    (gravity change)
q$(15) = "<":   ' 0F  port 2 right to left (gravity change)  
q$(16) = "":   ' 10  port 2 down to up    (gravity change)
q$(17) = "{":   ' 11  snik snak
q$(18) = "G":   ' 12  yellow utility disk
q$(19) = "ð":   ' 13  terminal
q$(20) = "R":   ' 14  red utility disk
q$(21) = "|":   ' 15  vertical port
q$(22) = "-":   ' 16  horizontal port
q$(23) = "+":   ' 17  horizontal + vertical port
q$(24) = "*":   ' 18  electron
q$(25) = "±":   ' 19  bug
q$(26) = "²":   ' 1A  horizontal RAM chip, left (pin 1)
q$(27) = "²":   ' 1B  horizontal RAM chip, right
q$(28) = "Û":   ' 1C  hardware (radial blue circular cap + coloured shapes)
q$(29) = "Û":   ' 1D  hardware (green signal lamp)
q$(30) = "Û":   ' 1E  hardware (blue signal lamp)
q$(31) = "Û":   ' 1F  hardware (red signal lamp)
q$(32) = "Û":   ' 20  hardware (yellow/black diagonal stripes)
q$(33) = "Û":   ' 21  hardware (yellow resistor + blue + red shapes)
q$(34) = "Û":   ' 22  hardware (horizontal red capacitor + smd shape)
q$(35) = "Û":   ' 23  hardware (red + yellow + blue horizontal resistors)
q$(36) = "Û":   ' 24  hardware (3 red vertical resistors)
q$(37) = "Û":   ' 25  hardware (3 yellow horizontal resistors)
q$(38) = "²":   ' 26  vertical RAM chip, top (pin 1)
q$(39) = "²":   ' 27  vertical RAM chip, bottom
' Specials to experiment with ...
q$(40) = "X":   ' 28  invisible hardware ... (nice to fool other Supaplexers)
q$(41) = "Û":   ' 29  hardware trash
q$(42) = "Û":   ' 2A  hardware trash
q$(43) = "":   ' 2B  hardware inverted Murphy ... (maybe nice for use?)
'-------------------------------------------------------------------------

scnfile$ = UCASE$(scnfile$)
prnfile$ = UCASE$(prnfile$)

FOR l% = 0 TO 110
  s$(l%) = ""
  FOR I% = 0 TO 39
    x%(I%, l%) = 0
  NEXT I%
NEXT l%

OPEN "levels.dat" FOR BINARY ACCESS READ AS #1
OPEN scnfile$ FOR OUTPUT AS #2
CLS
I% = 0
j% = 1
l% = 0
imax% = 60
mflag% = 0
eflag% = 0
WHILE NOT EOF(1)
  a$ = INPUT$(1, 1)
  IF NOT EOF(1) THEN
    a% = ASC(a$ + CHR$(0))
    IF imax% = 60 THEN
      x%(a%, l%) = x%(a%, l%) + 1
      IF a% = 3 THEN mflag% = 1
      IF a% = 7 THEN eflag% = 1
      a% = ASC(q$(a%))
      'IF a% < 64 THEN a% = a% + 32
      PRINT #2, CHR$(a%);
    ELSE
      IF I% = 6 THEN PRINT #2, "     ";
      IF I% = 29 THEN PRINT #2, "     ";
      IF I% = 33 THEN
        PRINT #2, "   "; k%;
       
        IF scnfile$ = "CON" THEN
         
          WHILE INKEY$ <> ""               ' (flush keyboard buffer)
          WEND
          WHILE INKEY$ = ""                ' (and wait for a key)
          WEND
       
        ELSE
         
          LOCATE 15, 30
          PRINT "Attacking level"; l%     ' show level (progress) on screen
       
        END IF

      END IF
      IF I% = 33 OR I% = 54 OR I% = 75 OR I% = 96 THEN PRINT #2,
      IF I% < 6 OR I% >= 29 THEN
        IF I% = 30 THEN k% = a%
        PRINT #2, RIGHT$("0" + HEX$(a%) + " ", 3);
        IF I% = 30 THEN t%(l% - 1) = a%
      ELSE
        s$(l% - 1) = s$(l% - 1) + a$
        PRINT #2, a$;
      END IF
    END IF
    I% = I% + 1
    IF I% = imax% THEN
      I% = 0
      IF mflag% = 1 THEN
        mflag% = 0
        IF eflag% = 1 THEN
          eflag% = 0
          PRINT #2, "<-"; q$(3); q$(7);
        ELSE
          PRINT #2, "<-"; q$(3);
          IF (j% > 11) AND (j% < 15) THEN PRINT #2, " ";
        END IF
      ELSE
        IF eflag% = 1 THEN
          eflag% = 0
          PRINT #2, "<-"; q$(7);
          IF (j% > 11) AND (j% < 15) THEN PRINT #2, " ";
        ELSE
          IF (j% > 11) AND (j% < 15) THEN PRINT #2, "    ";
        END IF
      END IF
      nbr$ = MID$(STR$(l% + 1), 2)
      IF j% = 12 THEN PRINT #2, "  Ú"; STRING$(LEN(nbr$), "Ä"); "¿";
      IF j% = 13 THEN PRINT #2, "  ³"; nbr$; "³";
      IF j% = 14 THEN PRINT #2, "  À"; STRING$(LEN(nbr$), "Ä"); "Ù";
      PRINT #2,
      j% = j% + 1
      IF j% = 25 THEN
        j% = 0
        imax% = 96
        l% = l% + 1
      ELSE
        IF imax% = 96 THEN
          cflag% = 0
          FOR ii% = 0 TO 39 STEP 10
            FOR jj% = 0 TO 9
              PRINT #2, USING "#####&"; x%(ii% + jj%, l% - 1); q$(ii% + jj%);
              IF (ii% + jj%) = 4 THEN count% = x%(ii% + jj%, l% - 1)
              IF (ii% + jj%) = 24 THEN
                count% = count% + 9 * x%(ii% + jj%, l% - 1)
                cflag% = 1
              END IF
            NEXT jj%
            IF cflag% = 1 THEN
              cflag% = 0
              PRINT #2, "      "; count%;
            END IF
            PRINT #2,
          NEXT ii%
          PRINT #2,
        END IF
        imax% = 60
      END IF
    END IF
  END IF
WEND
CLOSE #1                      ' we don't need the input file anymore

' append big totals information
'
PRINT #2,
PRINT #2,
PRINT #2, "Big totals:"
FOR I% = 0 TO 39 STEP 10
  FOR j% = 0 TO 9
    y = 0
     FOR l% = 0 TO 110
      y = y + x%(I% + j%, l%)
    NEXT l%
    PRINT #2, USING "#######"; y;
  NEXT j%
  PRINT #2,
NEXT I%
PRINT #2, CHR$(12);
CLOSE #2                      ' single column screen file is done now



'-------------------------------------------------------------------------


' columnize:                  ' squeeze the screen file it into 2 columns

OPEN scnfile$ FOR INPUT AS #1
OPEN prnfile$ FOR OUTPUT AS #2

count = 0                     ' counter for levels vertical per page
cnt = 0                       ' level pointer (to show progress on screen)

PRINT #2, PrtSmall$;          ' attach "let printer print small"

WHILE NOT EOF(1)
  PRINT #2,
  PRINT #2,
  PRINT #2,

                              ' get odd level
  FOR I = 0 TO 32
    IF NOT EOF(1) THEN LINE INPUT #1, a$(I) ELSE a$(I) = ""
  NEXT I

                              ' get even level
  FOR I = 0 TO 32
    IF NOT EOF(1) THEN LINE INPUT #1, a$ ELSE a$ = ""
    IF a$ = CHR$(12) THEN a$ = ""
    IF (a$(I) + a$) <> "" THEN PRINT #2, "         "; a$(I); SPACE$(78 - LEN(a$(I))); a$
  NEXT I

  IF NOT EOF(1) THEN
    cnt = cnt + 2             ' count levels
    LOCATE 15, 30
    PRINT "Shaping levels"; cnt; "+"; cnt + 1'show progress on screen
  END IF

  count = count + 1           ' count levels vertical per page

  IF (count = 3) OR EOF(1) THEN
    PRINT #2, FF$;            ' Form Feed
    count = 0
  ELSE
    PRINT #2,                 ' else space
    PRINT #2,
    PRINT #2,
    PRINT #2,
  END IF
WEND

PRINT #2, PrtNormal$;         ' attach "let printer be normal again"

CLOSE #2
CLOSE #1



LOCATE 13, 15
PRINT "Done: files "; scnfile$; " and "; prnfile$; " are generated."
LOCATE 15, 15
PRINT "look at "; scnfile$; " with any text viewer, and"
LOCATE 17, 15
PRINT "print "; prnfile$; " to your HP-Deskjet as follows:"
LOCATE 19, 15
PRINT "COPY "; prnfile$; " PRN       (or whatever print command you like)"

END

