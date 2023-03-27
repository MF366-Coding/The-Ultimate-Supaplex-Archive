============
New Supaplex
============

----------
Game idea:
----------
  You should collect enough Infotrons (triangle like objects with rounded corners) and find Exit (looks like orange box with upstairs). The stones (zonks), monsters and other things make game more interesting.

----------
How to play:
----------
  Use arrows to move Murphy and cursors + spacebar for the range eating. You can also setup a Red Disk (with local timer) if you keep spacebar pressed a while, which explode after short time. Sure you should collect one to setup :)

Also, there very much game objects in the game, and things like Gravity, Freeze zonks and Freeze enemies.

-------
Levels:
-------
  The game supports:
- the Supaplex levels (*.dat and *.d?? where ? are numbers)
- *.sp (supaplex demos) single supaplex levels
- *.mpx (megaplex levels and demos)

------
Demos:
------
  The game supports:
- the Supaplex and Megaplex demos (*.sp)

You can get some additional levels from the game site (see url at the end) or just search in the internet.
There are also several level editors around (MegaPlex, Spxed and others).

-----------------------------------
Command line parameters (optional):
-----------------------------------
-fullscreen
 Start a game in a fullscreen mode instead of the default windowed mode.
By default the fullscreen mode runs with 800x600 resolution. You can change
the resolution with -width and -height parameters (see below).

-nosound
 Start a game without sounds and music (for computers without a sound card)

-width [W]
-height [H]
 Start a game with resolution W x H. Works for windowed and fullscreen mode.
Example of usage: NewSupaplex.exe -width 1024 -height 768

-playdemo [demofile]
 Plays a demo without any GUI in silent mode. Return 0 - if successfule, and non zero otherwise.
Also the game writes a result in demo_info.txt file.
Demofile should be located in Demos folder of the game.
Example of usage: NewSupaplex.exe -playdemo Demos\00s004.nsp

-playdemolist [demolistfile]
 Plays a demos in a batch without any GUI in silent mode. The game writes a result in demo_info.txt file.
Demolist file is a text file which contain a list of demos in folowing format: Demos\demoname.
Demo files should be located in Demos folder of the game.
Example of usage: NewSupaplex.exe -playdemolist demolist.txt

----------------------
Command line examples:
----------------------

NewSupaplex.exe -fullscreen
NewSupaplex.exe -fullscreen -width 1280 -height 1024
NewSupaplex.exe -width 1440 -height 900

NewSupaplex.exe -nosound -fullscreen


-----------------------------------
have fun!
-----------------------------------

--------
History:
--------

----------------------
2008/02/17 build 0.605
----------------------
- fixed: The game logic was changed to be much more compatible with old supaplex
- fixed: Now Murphy pass the ports with double speed
- fixed: After each successfuly played level the statistic is saved in user profile
- added: Added support for playing Supaplex and Megaplex demos (*.sp)
- fixed: Changed hot keys for game speed control. Now you can use PageUp/PageDown to control speed.
         The speed changes as folows: (1,5,10,15,25,35,50,75,100,150,200,250,350,500,1000)
- added: In demo play mode you can see now the key presses (arrows and space)
- added: Added support for resolutions other that 800x600 (see the readme.txt file command line parameters)


----------------------
2005/12/04 build 0.510
----------------------
- added: Added support for Megaplex levels (*.mpx). Megaplex levels may be up to 256x256 size.
- fixed: Fixed the game crush at some invalid levelsets.
- added: Added support for levels with a non-english names. The characters with codes > 128 are treated as russian symbols and appropriately transliterate into english counterparts. This allows to play a lot of russian levels.
- fixed: Fixed a lot of bugs in menu logic which may crash a game.
- added: Now the game speed is tracked for each player. The demo playback speed is set to player base speed on every playback (for convenience).
- fixed: The BUG (electro charge in the green base) cooldown time has been increased to allow eat it more safely. Otherwise the BUG can charge at truely random time, even at the next frame after previous time. This is inconvenient. Now the bug cannot charge right after previous charge, it can do so after a small cooldown only. But, I fixed it in such way that old demos should playback correctly.
- added: Added an overwrite prompt in save demo dialog.
- added: Added a force redraw on each level cell at very high game speed. Without that it is possible to set a such speed, that game become non-interactive.
- added: The game speed is now visible at game pannel.

----------------------
2005/05/02 build 0.480
----------------------
- added: Player profiles. Now the game keep history for solved levels for each player
- added: Game menu: Now you can choose the levelset and level to play
- added: Game menu: Now you can save level solutions (demos)
- added: Demos menu: Now you can plaback saved demos
- added: Credits menu: Added some credits
- added: Tracks number of Murphy moves and show them on game panel
- added: Added new music track
- fixed: The snik-snak animation changed (to real snik-snak)
- fixed: Murphy range eating animation and red disk setup animation changed
- bugfix: The bug with lost focus and minimizing the game window
- bugfix: The arrows doesn't work anymore when game is not active
- bugfix: Several minor fixes


----------------------
2003/02/10 build 0.420
----------------------
- There is a long way to that build, game engine was completely rewritten from scratch three or four times.


--------------------
System requirements:
--------------------
CPU: Pentium II 500 or higher
RAM: 128 Mb of higher
Video card: 32 Mb or higher (should support OpenGL acceleration)
OS: Windows 2k/XP with DirectX 8.1 or higher. (Not tested on W98/ME, but will probably work)



---------
One note:
---------
  There are several sprites (Electron and Snik-Snak animation) and few sounds are taken from the similar game "Igor: The time machine".
Those will be replaced with our own sprites as soon as Blacky Gray will have some free time for that (or may be someone volunteer for that).

==============================================================
programming:       Sergey Antonov (zz|sergant)
graphics & design: Blacky Gray
==============================================================

site in russian at http://www.newsupaplex.pp.ru
site in english at http://www.newsupaplex.pp.ru/sup_news_eng.html

site mirror:
site in russian at http://www.sergant.pp.ru (hosted by yx)
site in english at http://www.sergant.pp.ru/sup_news_eng.html


email: sergant_@mail.ru

------------
Other links:
------------

1. Forum where you can get some new levels for supaplex.
http://www.infordigital.com/Forum/index.php

==============================================================
This is only beta version, so not judge too hard.
