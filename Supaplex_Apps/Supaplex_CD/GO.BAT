@echo off
rem
rem ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
rem ³                    Supaplex                    ³
rem ³                                                ³
rem ³  Copyright (c) 1995 Digital Integration Ltd.   ³
rem ³                                                ³
rem ³  Modified for CD-ROM by Rob Northen Computing  ³
rem ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
rem
@echo off
cd action16\supaplex
if exist cdpatch.exe lh cdpatch c:
action16
supaplex.exe %1 %2 %3 %4
if exist cdpatch.exe cdpatch x
cd \


