@echo off

:First, please change the extention name of this file.
:(.TXT) to (.BAT)
:And you can run this tiny batch job.

:This batch job will give you the graphic sources of SUPAPLEX.
:All pictures will have (.LBM) graphic format.

:If you don't like the current pictures or fonts,
:you can change anywhere you want.


:*** How to change the pictures in SUPAPLEX ***
:
:1. Get the graphic sources.
:2. Change.
:3. Cut the header of the changed picture.
:4. Rename or overwrite.

:-------------------------------------------------------------

copy /b BACK_H.LBM+back.dat back.lbm
copy /b BACK_H2.LBM+back.dat back2.lbm
copy /b CHARS6_H.LBM+chars6.dat chars6.lbm
copy /b CHARS6_H.LBM+chars8.dat chars8.lbm
copy /b CONTRO_H.LBM+controls.dat controls.lbm
copy /b FIXED_H.LBM+fixed.dat fixed.lbm
copy /b GFX_H.LBM+gfx.dat gfx.lbm
copy /b MENU_H.LBM+menu.dat menu.lbm
copy /b MOVING_H.LBM+moving.dat moving.lbm
copy /b PANEL_H.LBM+panel.dat panel.lbm
copy /b TITLE1_H.LBM+title1.dat title1.lbm
copy /b TITLE2_H.LBM+title2.dat title2.lbm
copy /b TITLE_H.LBM+title.dat title.lbm

