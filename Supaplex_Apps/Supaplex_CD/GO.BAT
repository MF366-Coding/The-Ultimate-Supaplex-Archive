@echo off
rem
rem 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
rem �                    Supaplex                    �
rem �                                                �
rem �  Copyright (c) 1995 Digital Integration Ltd.   �
rem �                                                �
rem �  Modified for CD-ROM by Rob Northen Computing  �
rem 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
rem
@echo off
cd action16\supaplex
if exist cdpatch.exe lh cdpatch c:
action16
supaplex.exe %1 %2 %3 %4
if exist cdpatch.exe cdpatch x
cd \


