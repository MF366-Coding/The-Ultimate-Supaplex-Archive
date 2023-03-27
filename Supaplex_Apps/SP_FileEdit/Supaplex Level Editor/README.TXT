
Hi All,

So you like Supaplex but have played all levels, or you're just stuck on that
unplayable level? Then this program is just for you! With SPedit you can edit
every part of the Supaplex levels. This means you can make subtle changes to
existing levels, or design completely new levels.

Included with the editor are 9 new levels!

How to use SPedit?
==================
Put SPedit in the directory where Supaplex lives and start it from there.
It will create a directory 'levels' where it stores it's level files. From
the start screen you can choose a level file and a level. Use the arrow keys
or:
	Page Up
	Page Down
	Home
	End
<Enter> selects your choice.

Press E or Enter to start editing a selected level. Once you're used to the
symbols used for displaying the levels, everything should be fairly self-
explanatory from there on. Pressing F1 will show you a translation table
for these symbols and associated keys. All other function keys are
displayed on the edit screen.

A description of the gravity functions might be helpfull, so here it is.
Global gravity means the status of gravity when the level starts. You can
toggle this with F2. While playing, the gravity status can be changed by
special uni-directional ports also known as local gravity ports, these are
highlighted in colour mode. Two forms of local gravity ports exist: one
that switches gravity on and one that switches gravity off. To enter a
local gravity port, first enter a normal uni-directional port, then change
it to a local gravity port with one of Shift-F2 or Ctrl-F2. When the cursor
is over a local gravity port, it's type is shown.

The block functions may need some explanation too: Copy or Cut (F9, Shift-F9)
places a selected block in the paste buffer. Now you can place this block
somewhere else (even in a different level or file) by pressing F10. The
outline of the block is shown, you can position it and press <Enter> to
place it. You can also manipulate it in several ways while the outline is
visible:

F10 once again to rotate it 90 degrees clockwise
Shift-F10 to flip the block in horizontal direction
Ctrl-F10 to flip the block in vertical direction

All objects in a manipulated block are changed in such a way that their
behaviour stays the same. So a FlipX-ed right-port becomes a left-port etc.
These manipulations act on the paste buffer, so flip again or rotate three
more times to undo a manipulation.

Dragging with the left mouse button (and shift) depressed has the same effect
as copy (or cut) with the F9 key.
Dragging with the right mouse button depressed has the same effect
as paste with the F9 key.

The Start Supaplex (S) command will only work when SPedit is in the Supaplex
directory and there is enough memory available to start Supaplex on top of
SPedit.

Please note that SPedit is freeware and you may distribute it in unaltered
form freely, but please include this file. There may still be some bugs or
shortcomings, when you contact me I might just try to fix a bug or add an
interesting feature.

Have Fun!

- When you have problems with the colours SPedit uses, you can force SPedit
  in Monochrome mode by starting it with: SPedit -m
- You can switch to a different level file from the command line by typing:
  SPedit -s <levelname>
- You can't change the 'Standard' level file. When you want to change a level
  from the Standard levels, first copy Standard to something like 'StdCopy'
  and then change them there.
- When you want to copy a levelfile to someone else, make sure the copy of
  that level in the levels directory is up to date by first selecting the
  'Standard' level file. Then copy the file you want from the 'levels'
  directory.

SPedit was written by:                   Thanks to:
Gert-Jan de Vos                          Ilja van Rhee
Benedenbeekloop 18                       For the idea, testing and
5662 HL Geldrop                          the new levels
E-Mail: devos@eb.ele.tue.nl

When you have designed some exciting new levels please mail them to me!

