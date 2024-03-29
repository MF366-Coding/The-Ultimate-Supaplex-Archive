' *****************************
' *** SUPAPLEX LEVEL EDITOR ***
' ******** Versio 3.4 *********
' ******** by masasoft ********
' ******* (C) 1989-1995 *******
' *****************************


DECLARE SUB ShowKeys () : DECLARE SUB HelpIndex ()
 VIEW PRINT 1 TO 25: DIM dat%(25, 80)
  DEF SEG = 0: change = 0
  KeyFlags = PEEK(1047)
  IF (KeyFlags AND 32) = 0 THEN
    POKE 1047, KeyFlags OR 32
  END IF
  DEF SEG
OPEN "levels1.dat" FOR BINARY AS #1
OPEN "level1.lst" FOR BINARY AS #2
 CLS : DIM levdat%(24, 60): LINE INPUT "  Mit� rataa editoidaan (1-111) ?"; rata$: rata = VAL(rata$): CLS : PRINT
  FOR p = 1 TO 24: FOR t = 1 TO 60 STEP 2: GET #1, ((p - 1) * 60) + t + ((rata - 1) * 1536), levdat%(p, t)
   levdat%(p, t + 1) = INT(levdat%(p, t) / 256): levdat%(p, t) = levdat%(p, t) - (levdat%(p, t + 1) * 256)
   a = levdat%(p, t): b = levdat%(p, t + 1)
  
   GOSUB Showgrid
  NEXT
  IF p < 24 THEN PRINT
  NEXT
 GET #1, 1445 + ((rata - 1) * 1536), gravity%: temp2% = INT(gravity% / 256): gravity% = gravity% - temp2% * 256
  FOR t = 1 TO 23 STEP 2: GET #1, 1446 + t + ((rata - 1) * 1536), nimi%: nimi = nimi%: IF nimi < 0 THEN nimi = (-nimi) + 32767
   nimi2 = INT(nimi / 256): nimi1 = nimi - nimi2 * 256
   nimi$ = nimi$ + CHR$(nimi1) + CHR$(nimi2): NEXT
  LOCATE 1, 35: PRINT LEFT$(nimi$, 23)
 CALL ShowKeys: gravity% = gravity% AND 1


KEY 15, CHR$(40) + CHR$(20): ON KEY(15) GOSUB FileMenu: KEY(15) ON
KEY 16, CHR$(40) + CHR$(18): ON KEY(16) GOSUB EfectMenu: KEY(16) ON
KEY 17, CHR$(40) + CHR$(24): ON KEY(17) GOSUB HelpMenu: KEY(17) ON

x = 1: y = 2: NY = 2: NX = 1: GOTO FIRSTEDIT
EDIT:
 LOCATE y, x: COLOR 7, 0: PRINT CHR$(grid); : x = NX: y = NY

FIRSTEDIT:
 grid = SCREEN(y, x): gridcolor = SCREEN(y, x, 1)
 LOCATE y, x: COLOR 0, 7: PRINT CHR$(grid); : c = 45: D = 1

askkey:
 LOCATE y, x: c = c + 1: a$ = INKEY$: a$ = UCASE$(a$)
 IF a$ = "" AND c < 50 THEN GOTO askkey ELSE IF c > 49 AND a$ = "" AND D = 1 THEN D = -D: c = 0: COLOR 0, 7: PRINT CHR$(grid); : GOTO askkey ELSE IF c > 49 AND a$ = "" THEN D = -D: COLOR 7: PRINT CHR$(grid); : c = 0: GOTO askkey

 IF a$ = "8" AND y > 2 THEN NY = y - 1: GOTO EDIT
 IF a$ = "2" AND y < 25 THEN NY = y + 1: GOTO EDIT
 IF a$ = "4" AND x > 1 THEN NX = x - 1: GOTO EDIT
 IF a$ = "6" AND x < 60 THEN NX = x + 1: GOTO EDIT

 IF a$ = "W" THEN change = 1: grid = 219: GOTO EDIT: ' Wall
 IF a$ = " " THEN change = 1: grid = 0: GOTO EDIT: ' Empty
 IF a$ = "I" THEN change = 1: grid = 42: GOTO EDIT: ' Infotron
 IF a$ = "V" THEN change = 1: grid = 176: GOTO EDIT: ' Green ram
 IF a$ = "S" THEN change = 1: grid = 6: GOTO EDIT: ' Rock
 IF a$ = "A" THEN change = 1: grid = 65: GOTO EDIT: ' Supaplex
 IF a$ = "R" THEN change = 1: grid = 35: GOTO EDIT: ' Ram
 IF a$ = "E" THEN change = 1: grid = 69: GOTO EDIT: ' Exit
 IF a$ = "O" THEN change = 1: grid = 79: GOTO EDIT: ' Orange bomb
 IF a$ = "Z" THEN change = 1: grid = 27: GOTO EDIT: ' Pipe to left
 IF a$ = "X" THEN change = 1: grid = 26: GOTO EDIT: ' Pipe to right
 IF a$ = "�" OR a$ = "�" THEN change = 1: grid = 25: GOTO EDIT: ' Pipe to down
 IF a$ = "�" OR a$ = "�" THEN change = 1: grid = 24: GOTO EDIT: ' Pipe to up
 IF a$ = "C" THEN change = 1: grid = 88: GOTO EDIT: ' Snik Snak
 IF a$ = "T" THEN change = 1: grid = 251: GOTO EDIT: ' Computer
 IF a$ = "K" THEN change = 1: grid = 75: GOTO EDIT: ' Yellow bomb
 IF a$ = "P" THEN change = 1: grid = 80: GOTO EDIT: ' Red bomb
 IF a$ = "U" THEN change = 1: grid = 18: GOTO EDIT: ' Pipe to up and down
 IF a$ = "-" THEN change = 1: grid = 61: GOTO EDIT: ' Pipe to left and right
 IF a$ = "�" OR a$ = "�" THEN change = 1: grid = 206: GOTO EDIT: ' Pipe to all directions
 IF a$ = "B" THEN change = 1: grid = 64: GOTO EDIT: ' Bug
 IF a$ = "Q" THEN change = 1: grid = 58: GOTO EDIT: ' Stars
 IF a$ = "H" THEN change = 1: grid = 72: GOTO EDIT: ' Hardware
 IF a$ = "." THEN change = 1: grid = 84: GOTO EDIT: ' Tilt

GOTO EDIT

Showgrid:
IF a = 0 THEN PRINT " "; : GOTO ShowB
IF a = 6 THEN PRINT CHR$(219); : GOTO ShowB
IF a = 1 THEN PRINT CHR$(6); : GOTO ShowB
IF a = 2 THEN PRINT CHR$(176); : GOTO ShowB
IF a = 3 THEN PRINT "A"; : GOTO ShowB
IF a = 4 THEN PRINT "*"; : infotr = infotr + 1: GOTO ShowB
IF a = 5 THEN PRINT "#"; : GOTO ShowB
IF a = 7 THEN PRINT "E"; : GOTO ShowB
IF a = 8 THEN PRINT "O"; : GOTO ShowB
IF a = 9 THEN PRINT CHR$(26); : GOTO ShowB
IF a = 10 THEN PRINT CHR$(25); : GOTO ShowB
IF a = 11 THEN PRINT CHR$(27); : GOTO ShowB
IF a = 12 THEN PRINT CHR$(24); : GOTO ShowB
IF a = 13 THEN PRINT CHR$(26); : GOTO ShowB
IF a = 14 THEN PRINT CHR$(25); : GOTO ShowB
IF a = 15 THEN PRINT CHR$(27); : GOTO ShowB
IF a = 16 THEN PRINT CHR$(24); : GOTO ShowB
IF a = 17 THEN PRINT "X"; : GOTO ShowB
IF a = 19 THEN PRINT CHR$(251); : GOTO ShowB
IF a = 18 THEN PRINT "K"; : GOTO ShowB
IF a = 20 THEN PRINT "P"; : GOTO ShowB
IF a = 21 THEN PRINT CHR$(18); : GOTO ShowB
IF a = 22 THEN PRINT "="; : GOTO ShowB
IF a = 23 THEN PRINT CHR$(206); : GOTO ShowB
IF a = 24 THEN PRINT ":"; : GOTO ShowB
IF a = 25 THEN PRINT "@"; : GOTO ShowB
IF a = 26 THEN PRINT "#"; : GOTO ShowB
IF a = 27 THEN PRINT "#"; : GOTO ShowB
IF a > 27 AND a < 38 THEN PRINT "H"; : GOTO ShowB
IF a = 38 OR a = 39 THEN PRINT "#"; : GOTO ShowB
IF a > 39 THEN PRINT "T"; : GOTO ShowB

ShowB:
IF b = 0 THEN PRINT " "; : RETURN
IF b = 6 THEN PRINT CHR$(219); : RETURN
IF b = 1 THEN PRINT CHR$(6); : RETURN
IF b = 2 THEN PRINT CHR$(176); : RETURN
IF b = 3 THEN PRINT "A"; : RETURN
IF b = 4 THEN PRINT "*"; : infotr = infotr + 1: RETURN
IF b = 5 THEN PRINT "#"; : RETURN
IF b = 7 THEN PRINT "E"; : RETURN
IF b = 8 THEN PRINT "O"; : RETURN
IF b = 9 THEN PRINT CHR$(26); : RETURN
IF b = 10 THEN PRINT CHR$(25); : RETURN
IF b = 11 THEN PRINT CHR$(27); : RETURN
IF b = 12 THEN PRINT CHR$(24); : RETURN
IF b = 13 THEN PRINT CHR$(26); : RETURN
IF b = 14 THEN PRINT CHR$(25); : RETURN
IF b = 15 THEN PRINT CHR$(27); : RETURN
IF b = 16 THEN PRINT CHR$(24); : RETURN
IF b = 17 THEN PRINT "X"; : RETURN
IF b = 19 THEN PRINT CHR$(251); : RETURN
IF b = 18 THEN PRINT "K"; : RETURN
IF b = 20 THEN PRINT "P"; : RETURN
IF b = 21 THEN PRINT CHR$(18); : RETURN
IF b = 22 THEN PRINT "="; : RETURN
IF b = 23 THEN PRINT CHR$(206); : RETURN
IF b = 24 THEN PRINT ":"; : RETURN
IF b = 25 THEN PRINT "@"; : RETURN
IF b = 26 THEN PRINT "#"; : RETURN
IF b = 27 THEN PRINT "#"; : RETURN
IF b > 27 AND b < 38 THEN PRINT "H"; : RETURN
IF b = 38 OR b = 39 THEN PRINT "#"; : RETURN
IF b > 39 THEN PRINT "T"; : RETURN
RETURN


SaveFile:
LOCATE 1, 1: PRINT "   WAIT - Saving level"; SPACE$(50)
infotr = 0: FOR p = 1 TO 24: FOR t = 1 TO 60 STEP 2: a$ = CHR$(SCREEN(p + 1, t)): b$ = CHR$(SCREEN(p + 1, t + 1))
GOSUB savegrid: c% = a% + b% * 256
PUT #1, ((p - 1) * 60) + t + ((rata - 1) * 1536), c%
NEXT: NEXT
  CLS : LOCATE 3, 18
  FOR t = 1 TO 23 STEP 2: GET #1, 1446 + t + ((rata - 1) * 1536), nimi%: nimi = nimi%: IF nimi < 0 THEN nimi = (-nimi) + 32767
  nimi2 = INT(nimi / 256): nimi1 = nimi - nimi2 * 256
  nimi$ = nimi$ + CHR$(nimi1) + CHR$(nimi2): NEXT: PRINT LEFT$(nimi$, 23), ;
  GET #1, 1471 + ((rata - 1) * 1536), kerata%: temp1% = INT(kerata% / 256): kerata% = kerata% - temp1% * 256
  PRINT "  Ker�tt�v�t:"; kerata%; "("; STR$(infotr); " )"
askname:
  LINE INPUT "Uusi radan nimi: "; a$: IF LEN(a$) <> 23 THEN GOTO askname ELSE nimi$ = a$ + CHR$(0)
  PRINT : LINE INPUT "  Tarvittavat Infotronit ? "; a$: kerata% = VAL(a$)
  PUT #1, 1471 + ((rata - 1) * 1536), kerata%
  FOR t = 1 TO 23 STEP 2: nimi1 = ASC(MID$(nimi$, t, 1)): nimi2 = ASC(MID$(nimi$, t + 1, 1))
  nimi% = nimi1 + nimi2 * 256: PUT #1, 1446 + t + ((rata - 1) * 1536), nimi%
  PUT #2, 4 + t + ((rata - 1) * 28), nimi%: NEXT
END
savegrid:
IF a$ = " " THEN a% = 0
IF a$ = CHR$(6) THEN a% = 1
IF a$ = "�" THEN a% = 2
IF a$ = "A" THEN a% = 3
IF a$ = "*" THEN a% = 4: infotr = infotr + 1
IF a$ = "#" THEN a% = 5
IF a$ = CHR$(219) THEN a% = 6
IF a$ = "E" THEN a% = 7
IF a$ = "O" THEN a% = 8
IF a$ = CHR$(26) THEN a% = 9
IF a$ = CHR$(25) THEN a% = 10
IF a$ = CHR$(27) THEN a% = 11
IF a$ = CHR$(24) THEN a% = 12
IF a$ = "X" THEN a% = 17
IF a$ = "K" THEN a% = 18
IF a$ = "�" THEN a% = 19
IF a$ = "P" THEN a% = 20
IF a$ = CHR$(18) THEN a% = 21
IF a$ = "=" THEN a% = 22
IF a$ = "�" THEN a% = 23
IF a$ = ":" THEN a% = 24
IF a$ = "@" THEN a% = 25
IF a$ = "H" THEN num = INT(RND(1) * 10): a% = 28 + num
IF a$ = "T" THEN a% = 40

IF b$ = " " THEN b% = 0
IF b$ = CHR$(6) THEN b% = 1
IF b$ = "�" THEN b% = 2
IF b$ = "A" THEN b% = 3
IF b$ = "*" THEN b% = 4: infotr = infotr + 1
IF b$ = "#" THEN b% = 5
IF b$ = CHR$(219) THEN b% = 6
IF b$ = "E" THEN b% = 7
IF b$ = "O" THEN b% = 8
IF b$ = CHR$(26) THEN b% = 9
IF b$ = CHR$(25) THEN b% = 10
IF b$ = CHR$(27) THEN b% = 11
IF b$ = CHR$(24) THEN b% = 12
IF b$ = "X" THEN b% = 17
IF b$ = "K" THEN b% = 18
IF b$ = "�" THEN b% = 19
IF b$ = "P" THEN b% = 20
IF b$ = CHR$(18) THEN b% = 21
IF b$ = "=" THEN b% = 22
IF b$ = "�" THEN b% = 23
IF b$ = ":" THEN b% = 24
IF b$ = "@" THEN b% = 25
IF b$ = "H" THEN num = INT(RND(1) * 10): b% = 28 + num
IF b$ = "T" THEN b% = 40
RETURN

FileMenu:
FOR yt = 2 TO 5: FOR xt = 1 TO 12
dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT: COLOR 7, 0
LOCATE 2, 1: PRINT "����������Ŀ"
LOCATE 3, 1: PRINT "�"; : COLOR 15, 0: PRINT "T"; : COLOR 7: PRINT "allenna  �"
LOCATE 4, 1: PRINT "�"; : COLOR 15, 0: PRINT "L"; : COLOR 7: PRINT "opetus   �"
LOCATE 5, 1: PRINT "������������"
SLEEP 0
FOR yt = 2 TO 5: FOR xt = 1 TO 12: LOCATE yt, xt
PRINT CHR$(dat%(yt, xt)): NEXT: NEXT: COLOR 7, 0
a$ = INPUT$(1): a$ = UCASE$(a$)
IF a$ = "T" THEN GOTO SaveFile
IF a$ = "L" THEN IF change = 0 THEN GOTO ExitProgram ELSE GOTO Asksave
b$ = INKEY$

RETURN

EfectMenu:
FOR yt = 2 TO 6: FOR xt = 11 TO 24
dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT: COLOR 7, 0
LOCATE 2, 11: PRINT "������������Ŀ"
LOCATE 3, 11: PRINT "�"; : COLOR 15, 0: PRINT "T"; : COLOR 7: PRINT "yhjennys   �"
LOCATE 4, 11: PRINT "�"; : COLOR 15, 0: PRINT "V"; : COLOR 7: PRINT "ihre�      �"
LOCATE 5, 11: PRINT "�"; : COLOR 15, 0: PRINT "P"; : COLOR 7: PRINT "ainovoima "; : IF gravity% = 1 THEN PRINT "��" ELSE PRINT " �"
LOCATE 6, 11: PRINT "��������������"
SLEEP 0
FOR yt = 2 TO 6: FOR xt = 11 TO 24: LOCATE yt, xt
PRINT CHR$(dat%(yt, xt)): NEXT: NEXT: COLOR 7, 0
a$ = INPUT$(1): a$ = UCASE$(a$)
IF a$ = "T" THEN GOSUB ClearGrids
IF a$ = "V" THEN GOSUB Greengrids
IF a$ = "P" THEN gravity% = gravity% XOR 1
b$ = INKEY$

RETURN

HelpMenu:
FOR yt = 2 TO 8: FOR xt = 20 TO 31
dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT: COLOR 7, 0
LOCATE 2, 20: PRINT "����������Ŀ"
LOCATE 3, 20: PRINT "�"; : COLOR 15, 0: PRINT "S"; : COLOR 7: PRINT "is�llys  �"
LOCATE 4, 20: PRINT "�"; : COLOR 15, 0: PRINT "I"; : COLOR 7: PRINT "nfo      �"
LOCATE 5, 20: PRINT "������������"
SLEEP 0
FOR yt = 2 TO 5: FOR xt = 20 TO 31: LOCATE yt, xt
PRINT CHR$(dat%(yt, xt)): NEXT: NEXT: COLOR 7, 0
a$ = INPUT$(1): a$ = UCASE$(a$)
IF a$ = "S" THEN CALL HelpIndex
IF a$ = "I" THEN GOSUB ShowInfo
b$ = INKEY$

RETURN


ClearGrids:
LOCATE 2, 1: PRINT STRING$(60, "�")
FOR yt = 3 TO 24: LOCATE yt, 1: PRINT "�"; STRING$(58, " "); "�": NEXT
PRINT STRING$(60, "�");
FOR yt = 2 TO 5: FOR xt = 11 TO 22
dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT: COLOR 7, 0
grid = SCREEN(y, x): gridcolor = SCREEN(y, x, 1)
RETURN

Greengrids:
LOCATE 2, 1: PRINT STRING$(60, "�")
FOR yt = 3 TO 24: LOCATE yt, 1: PRINT "�"; STRING$(58, "�"); "�": NEXT
PRINT STRING$(60, "�");
FOR yt = 2 TO 5: FOR xt = 11 TO 22
dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT: COLOR 7, 0
grid = SCREEN(y, x): gridcolor = SCREEN(y, x, 1)
RETURN

Asksave:
FOR yt = 4 TO 6: FOR xt = 10 TO 50: dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT
LOCATE 4, 10: PRINT "��������������������������������Ŀ"
LOCATE 5, 10: PRINT "� Tallennetaanko muutokset (K/E) �"
LOCATE 6, 10: PRINT "����������������������������������"
AskSaveKey:
a$ = INKEY$: a$ = UCASE$(a$): IF a$ <> "K" AND a$ <> "E" THEN GOTO AskSaveKey
FOR yt = 4 TO 6: FOR xt = 10 TO 50: LOCATE yt, xt: PRINT CHR$(dat%(yt, xt)); : NEXT: NEXT
IF a$ = "E" THEN GOTO ExitProgram
IF a$ = "K" THEN GOTO SaveFile

ExitProgram:
  DEF SEG = 0                         ' Restore NumLock state
  POKE 1047, KeyFlags
  DEF SEG
  CLS : SYSTEM

ShowInfo:
FOR yt = 4 TO 12: FOR xt = 4 TO 28: dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT
LOCATE 4, 4: PRINT "�����������������������Ŀ"
LOCATE 5, 4: PRINT "� Supaplex level editor �"
LOCATE 6, 4: PRINT "�                       �"
LOCATE 7, 4: PRINT "� Versio 3.4  (C) 1995  �"
LOCATE 8, 4: PRINT "�                       �"
LOCATE 9, 4: PRINT "� By Masasoft 1989-1995 �"
LOCATE 10, 4: PRINT "�                       �"
LOCATE 11, 4: PRINT "�     Press any key     �"
LOCATE 12, 4: PRINT "�������������������������"
askkey1:
ab$ = INKEY$: IF ab$ = "" THEN GOTO askkey1
FOR yt = 4 TO 12: FOR xt = 4 TO 28
LOCATE yt, xt: PRINT CHR$(dat%(yt, xt)): NEXT: NEXT
RETURN

SUB HelpIndex
DIM dat%(25, 80), dat2%(80): a = 7
FOR yt = 2 TO 25: FOR xt = 1 TO 60: dat%(yt, xt) = SCREEN(yt, xt): NEXT: NEXT
MainHelp:
CLS : LOCATE 2, 8: PRINT "Supaplex Level Editorin Ohjeet"
PRINT : PRINT " ����������������������������������������ͻ "
PRINT " �  Valitse aihe:                         �"
PRINT " �                                        �"
PRINT " �  Tiedosto-valikon komennot             �"
PRINT " �  Efektit-valikon komennot              �"
PRINT " �  Ohjeet-valikon komennot               �"
PRINT " �  N�pp�imist�n k�ytt�                   �"
PRINT " �  Yleist�                               �"
PRINT " �                                        �"
PRINT " �  ESC - Ohjeista poistuminen            �"
PRINT " �  ENTER - Aiheen valinta                �"
PRINT " ����������������������������������������ͼ"
BackRoundOn:
FOR t = 5 TO 30: dat2%(t) = SCREEN(a, t): LOCATE a, t: COLOR 0, 7: PRINT CHR$(dat2%(t)): NEXT
askkey3:
a$ = INKEY$: IF a$ = "" THEN GOTO askkey3
IF a$ = CHR$(27) THEN GOTO ExitSub
IF a$ = CHR$(13) THEN ON a - 6 GOTO TiedostoMenu, EfectitMenu, OhjeetMenu, Keybord, Overview
IF VAL(a$) = 0 THEN GOTO askkey3 ELSE na = VAL(a$)
IF na = 8 AND a <> 7 THEN GOSUB BackroundOff: a = a - 1: GOTO BackRoundOn
IF na = 2 AND a <> 11 THEN GOSUB BackroundOff: a = a + 1: GOTO BackRoundOn

GOTO askkey3

BackroundOff:
FOR t = 5 TO 30: dat2%(t) = SCREEN(a, t): LOCATE a, t: COLOR 7, 0: PRINT CHR$(dat2%(t)): NEXT: RETURN

TiedostoMenu:
COLOR 7, 0, 0: CLS : LOCATE 2, 4: PRINT "Supaplex Level Editorin Ohjeet (Tiedosto-valikko)"
PRINT : PRINT " ��������������������������������������������������ͻ "
PRINT " �                                                  �"
PRINT " �   Tallennus:                                     �"
PRINT " � Jos valitset t�m�n vaihtoehdon, ruudulla oleva   �"
PRINT " � rata tallennetaan ja sen j�lkeen kysyt��n radan  �"
PRINT " � nimi ja tarvittavat infotronit.                  �"
PRINT " �                                                  �"
PRINT " �   Lopetus:                                       �"
PRINT " � T�lle vaihtoehdolla poistutaan rataeditorista ja �"
PRINT " � jos muutoksia on tehty, kysyt��n talletetaanko   �"
PRINT " � ne.                                              �"
PRINT " �                                                  �"
PRINT " �  Paina ENTER palataksesi ohjeiden p��valikkoon   �"
PRINT " ��������������������������������������������������ͼ"
askkey4:
a$ = INKEY$: IF a$ <> CHR$(13) THEN GOTO askkey4
b$ = INKEY$
GOTO MainHelp

EfectitMenu:
COLOR 7, 0, 0: CLS : LOCATE 2, 4: PRINT "Supaplex Level Editorin Ohjeet (Efectit-valikko)"
PRINT : PRINT " ��������������������������������������������������ͻ "
PRINT " �                                                  �"
PRINT " �   Tyhjennys:                                     �"
PRINT " � Jos valitset t�m�n vaihtoehdon, ruudulla oleva   �"
PRINT " � rata tyhjennet��n ja reunat muutetaan seiniksi.  �"
PRINT " �                                                  �"
PRINT " �   Vihre�:                                        �"
PRINT " � T�m� vaihtoehto t�ytt�� ruudun vihre�ll� ja      �"
PRINT " � muuttaa reunat seiniksi.                         �"
PRINT " �                                                  �"
PRINT " �   Painovoima:                                    �"
PRINT " � T�m� vaihtoehto kytkee painovoiman p��lle tai    �"
PRINT " � pois. Jos painovoima on p��ll�, t�m�n vaihtoeh-  �"
PRINT " � don per�ss� n�kyy �-merkki.                      �"
PRINT " �                                                  �"
PRINT " �  Paina ENTER palataksesi ohjeiden p��valikkoon   �"
PRINT " ��������������������������������������������������ͼ"
askkey5:
a$ = INKEY$: IF a$ <> CHR$(13) THEN GOTO askkey5
b$ = INKEY$
GOTO MainHelp

OhjeetMenu:
COLOR 7, 0, 0: CLS : LOCATE 2, 4: PRINT "Supaplex Level Editorin Ohjeet (Tiedosto-valikko)"
PRINT : PRINT " ��������������������������������������������������ͻ "
PRINT " �                                                  �"
PRINT " �   Sis�llys:                                      �"
PRINT " � Jos valitset t�m�n vaihtoehdon, p��set ohjeiden  �"
PRINT " � sis�llysluetteloon.                              �"
PRINT " �                                                  �"
PRINT " �   Info:                                          �"
PRINT " � T�lle vaihtoehdolla saat tietoja ohjelmasta ja   �"
PRINT " � sen tekij�st�.                                   �"
PRINT " �                                                  �"
PRINT " �  Paina ENTER palataksesi ohjeiden p��valikkoon   �"
PRINT " ��������������������������������������������������ͼ"
askkey6:
a$ = INKEY$: IF a$ <> CHR$(13) THEN GOTO askkey6
b$ = INKEY$

GOTO MainHelp

Keybord:
COLOR 7, 0, 0: CLS : LOCATE 2, 2: PRINT "Supaplex Level Editorin Ohjeet (N�pp�imist�n k�ytt�)"
PRINT : PRINT " ��������������������������������������������������ͻ "
PRINT " �                                                  �"
PRINT " �   Nuolin�pp�imet:                                �"
PRINT " � K�yt� numeron�pp�imist�n nuolin�pp�imi� ohjauk-  �"
PRINT " � seen.                                            �"
PRINT " �                                                  �"
PRINT " �   Valikot:                                       �"
PRINT " � Paina ALT+valikon alkukirjain p��st�ksesi valik- �"
PRINT " � koon.                                            �"
PRINT " �                                                  �"
PRINT " �   Muut:                                          �"
PRINT " � Ruudun oikeassa laidassa n�kyv�t kaikki muut     �"
PRINT " � n�pp�imet.                                       �"
PRINT " �                                                  �"
PRINT " �  Paina ENTER palataksesi ohjeiden p��valikkoon   �"
PRINT " ��������������������������������������������������ͼ"
askkey7:
a$ = INKEY$: IF a$ <> CHR$(13) THEN GOTO askkey7
b$ = INKEY$

GOTO MainHelp

Overview:
COLOR 7, 0, 0: CLS : LOCATE 2, 6: PRINT "Supaplex Level Editorin Ohjeet (Yleist�)"
PRINT : PRINT " ��������������������������������������������������ͻ "
PRINT " �                                                  �"
PRINT " �   Hardware ja tiltti:                            �"
PRINT " � Tiltti tarkoittaa n�kym�t�nt� sein��. Kun tie-   �"
PRINT " � dosto tallennetaan, kaikkien hardwarejen tarkka  �"
PRINT " � tyyppi arvotaan.                                 �"
PRINT " �                                                  �"
PRINT " �   Oikeanlaidan selitykset:                       �"
PRINT " � Ensimm�inen merkki ilmoittaa mit� ruudulla n�-   �"
PRINT " � kyy ja suluissa oleva merkki sen mill� n�pp�i-   �"
PRINT " � mell� sen saa esille.                            �"
PRINT " �                                                  �"
PRINT " �   Osittainen painovoima:                         �"
PRINT " � Joissakin radoissa saattaa olla valmiina osit-   �"
PRINT " � tainen painovoima. T�ll� hetkell� t�mm�isten ra- �"
PRINT " � tojen osittainen painovoima s�ilyy.              �"
PRINT " �                                                  �"
PRINT " �  Paina ENTER palataksesi ohjeiden p��valikkoon   �"
PRINT " ��������������������������������������������������ͼ"
askkey8:
a$ = INKEY$: IF a$ <> CHR$(13) THEN GOTO askkey8
b$ = INKEY$
GOTO MainHelp

ExitSub:
COLOR 7, 0, 0: CLS : b$ = INKEY$
FOR yt = 2 TO 25: FOR xt = 1 TO 60: LOCATE yt, xt: PRINT CHR$(dat%(yt, xt)); : NEXT: NEXT
CALL ShowKeys
END SUB

SUB ShowKeys
LOCATE 1, 1
COLOR 15: PRINT "T"; : COLOR 7: PRINT "iedosto";
COLOR 15: PRINT "  E"; : COLOR 7: PRINT "fektit";
COLOR 15: PRINT "  O"; : COLOR 7: PRINT "hjeet";
 
LOCATE 2, 62: PRINT "� (W) - Sein�"
LOCATE 3, 62: PRINT "  ( ) - Tyhj�"
LOCATE 4, 62: PRINT "* (I) - Infotron"
LOCATE 5, 62: PRINT "� (V) - Vihre�"
LOCATE 6, 62: PRINT "� (S) - Kivi"
LOCATE 7, 62: PRINT "A (A) - Alku"
LOCATE 8, 62: PRINT "# (R) - Ram"
LOCATE 9, 62: PRINT "E (E) - Loppu"
LOCATE 10, 62: PRINT "O (O) - O.pommi"
LOCATE 11, 62: PRINT CHR$(27); " (Z) - Putki v."
LOCATE 12, 62: PRINT CHR$(26); " (X) - Putki o."
LOCATE 13, 62: PRINT CHR$(25); " (�) - Putki a."
LOCATE 14, 62: PRINT CHR$(24); " (�) - Putki y."
LOCATE 15, 62: PRINT "X (C) - Saksi"
LOCATE 16, 62: PRINT "� (T) - Tietok."
LOCATE 17, 62: PRINT "K (K) - K.pommi"
LOCATE 18, 62: PRINT "P (P) - P.pommi"
LOCATE 19, 62: PRINT CHR$(18); " (U) - P.putki"
LOCATE 20, 62: PRINT "= (-) - V.putki"
LOCATE 21, 62: PRINT "� (�) - Putki k."
LOCATE 22, 62: PRINT "@ (B) - Bugi"
LOCATE 23, 62: PRINT ": (Q) - T.ryhm�"
LOCATE 24, 62: PRINT "H (H) - Hardware";
LOCATE 25, 62: PRINT "T (.) - Tiltti";



END SUB

