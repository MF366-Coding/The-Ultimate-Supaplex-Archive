// I wrote this way back in 1992.  Sorry for the lack of comments!!!
// It was originally compiled with Borland C, probably version 2 or 3
// Have fun!
// -Tim Dedischew, October 1999
// humbletim@iname.com
//

#include <stdlib.h>
#include <conio.h>
#include <io.h>
#include <fcntl.h>
#include <stdio.h>
#include <ctype.h>
#include <sys\stat.h>
#include <string.h>

char buff[30][65]; // 26,61
char buff2[30][65];
char info[150],info2[150];
int num;

void readlevel(int lev) {
  char temp[150];
  int handle,level,line;
  int n;

  if (lev < 1 | lev > 111) lev = 1;
  num = lev;
  handle = open("levels.dat", O_RDWR | O_BINARY);

  n = 0;
  while (n < lev-1) {
  lseek(handle, 1536L, SEEK_CUR);
  n++;
  }

  for (line = 0; line < 25; line++) {
    read(handle, buff[line], 60);
    buff[line][60] = '\x0' ;
    }

  info[0] = ' ';
  while (info[0] != '\x6') {
    lseek(handle, -2L, SEEK_CUR);
    read(handle, info, 1);
    }
  read(handle, info, 90);
  info[31] = '\x0';
  info[29] = '\x0';
  for (level = 0; level < 5; level++)
    {
    if (info[level] == '\n') info[level] = 'N';
    if (info[level] == '\x13') info[level] = 'R';
    if (info[level] == '\x7') info[level] = 'B';
    if (info[level] == '\x8') info[level] = 'T';
    if (info[level] == '\x0') info[level] = 'Ý';
    }
  close(handle);
} // readlevel(int lev);

void readboard(char *s) {
  char temp[150];
  int handle,level,line;
  int n;

  if ((handle = open(s, O_RDWR | O_BINARY)) != -1) {

  for (line = 0; line < 25; line++) {
    read(handle, buff[line], 60);
    buff[line][60] = '\x0' ;
    }

  info[0] = ' ';
  while (info[0] != '\x6') {
    lseek(handle, -2L, SEEK_CUR);
    read(handle, info, 1);
    }
  read(handle, info, 90);
  info[31] = '\x0';
  info[29] = '\x0';
  for (level = 0; level < 5; level++)
    {
    if (info[level] == '\n') info[level] = 'N';
    if (info[level] == '\x13') info[level] = 'R';
    if (info[level] == '\x7') info[level] = 'B';
    if (info[level] == '\x8') info[level] = 'T';
    if (info[level] == '\x0') info[level] = 'Ý';
    }
  close(handle);
  } // if opened file
} // readboard(char *s);

void writeboard(char *s) {
  char temp[150];
  int handle,level,line;
  int n;

  if ((handle = creat(s, S_IREAD |S_IWRITE)) != -1) {

  write(handle, "\x6", 1);
  lseek(handle, 0L, SEEK_SET);
  for (level = 0; level < 5; level++)
    {
    if (info[level] == 'R') info[level] = '\x13';
    if (info[level] == 'N') info[level] = '\n';
    if (info[level] == 'B') info[level] = '\x7';
    if (info[level] == 'T') info[level] = '\x8';
    if (info[level] == 'Ý') info[level] = '\x0';
    }

  info2[0] = ' ';
  while (info2[0] != '\x6' & !eof(handle)) {
    read(handle, info2, 1);
    }
  lseek(handle, -1L, SEEK_CUR);

  for (line = 0; line < 25; line++) {
    write(handle, buff[line], 60);
    }
  info2[0] = ' ';
  while (info2[0] != '\x6') {
    lseek(handle, -2L, SEEK_CUR);
    read(handle, info2, 1);
    }
  for (level = 0; level < 5; level++)
    if (info[level] == 'Ý') info[level] ='\x0';
  write(handle, info, 90);
  close(handle);

  for (level = 0; level < 5; level++)
    if (info[level] == '\x0') info[level] = 'Ý';
  } // if opened file
} // writeboard(char *s);

void writelevel(int lev) {
  char temp[150];
  int handle,level,line;
  int n;

  if (lev < 1 | lev > 111) lev = 1;
  num = lev;
  handle = open("levels.dat", O_RDWR | O_BINARY);

  n = 0;
  while (n < lev-1) {
  lseek(handle, 1536L, SEEK_CUR);
  n++;
  }

  for (level = 0; level < 5; level++)
    {
    if (info[level] == 'R') info[level] = '\x13';
    if (info[level] == 'N') info[level] = '\n';
    if (info[level] == 'B') info[level] = '\x7';
    if (info[level] == 'T') info[level] = '\x8';
    if (info[level] == 'Ý') info[level] = '\x0';
    }



  info2[0] = ' ';
  while (info2[0] != '\x6' & !eof(handle)) {
    read(handle, info2, 1);
    }
  lseek(handle, -1L, SEEK_CUR);

  for (line = 0; line < 25; line++) {
    write(handle, buff[line], 60);
    }
  info2[0] = ' ';
  while (info2[0] != '\x6') {
    lseek(handle, -2L, SEEK_CUR);
    read(handle, info2, 1);
    }
  for (level = 0; level < 5; level++)
    if (info[level] == 'Ý') info[level] ='\x0';
  write(handle, info, 90);
  close(handle);

  if ((handle = open("level.lst", O_RDWR | O_TEXT)) != -1) {

  itoa(lev, temp, 10);
  strcpy(info2,"000");
  n = strlen(temp)-1;
  info2[2-n] = temp[0];
  if (n > 0) info2[2-n+1] = temp[1];
  if (n > 1) info2[2-n+2] = temp[2];
  info2[3] = ' ';
  n = 0;
  while (info[n+6] != '\x0') {
    info2[4+n] = info[n+6];
    n++;
  }
  info2[4+n] = '\x0A';
  for (n = 0; n < lev-1; n++)
    lseek(handle, 28L, SEEK_CUR);
  write(handle, info2, 27);
  close(handle);
  } // if level.lst opened
  for (level = 0; level < 5; level++)
    if (info[level] == '\x0') info[level] = 'Ý';
} // writelevel(int lev);

void putlevel(int start, int stop) {
  int line;
  int a,b;

  _setcursortype(_NOCURSOR);
  b = 0;
  if (start == -1) b = 1;
  if (start < 0) start = 0;
  if (stop > 24) stop = 24;

  textcolor(7);
  textbackground(0);
  if (b) clrscr();
  gotoxy(1,start+1);
  for (line = start; line < stop; line++) {
    for (a = 0; a < 60; a++)
      switch(buff[line][a]) {
	case '\x1':  textcolor(8); putch('O'); break;
	case '\x2':  textcolor(2); putch('°'); break;
	case '\x3':  textcolor(12+BLINK); putch(''); break;
	case '\x4':  textcolor(12); putch('&'); break;
	case '\x5':  textcolor(7); putch('Î'); break;
	case '\x6':  textcolor(0); textbackground(7); putch(' '); textbackground(0); break; // solid
	case '\x7':  textcolor(14); putch('E'); break;
	case '\x8':  textcolor(7); putch(''); break; // orange disk
	case '\xD':
	case '\x9':  textcolor(4); putch(''); break;
	case '\xE':
	case '\xA':  textcolor(4); putch(''); break;
	case '\xF':
	case '\xB':  textcolor(4); putch(''); break;
	case '\x10':
	case '\xC':  textcolor(4); putch(''); break;

	case '\x11': textcolor(4); putch('\xE0'); break; // snick snack
	case '\x12': textcolor(14); putch('\xF1'); break; // yellow disk
	case '\x13': textcolor(14); putch('\xF0'); break; // computer
	case '\x14': textcolor(12); putch('\xEF'); break; // red disk
	case '\x15': textcolor(4); putch('\x12'); break;  // up-down
	case '\x16': textcolor(4); putch('\x1D'); break;  // left-right
	case '\x17': textcolor(4); putch('\xC5'); break;  // 4-way
	case '\x18': textcolor(9); putch('\x25'); break;  // electron
	case '\x19': textcolor(15); putch('\x15'); break;  // bug
	case '\x1A': textcolor(7); putch('Í'); break;  // 1st h #
	case '\x1B': textcolor(7); putch('Ø'); break;  // 2nd h #
	case '\x1C':
	case '\x1D':
	case '\x1E':
	case '\x1F':
	case '\x20':
	case '\x21':
	case '\x22':
	case '\x23':
	case '\x24':
	case '\x25': textcolor(3); putch('\x7F'); break; // hardware

	case '\x26': textcolor(7); putch('º'); break; // 1st v chip
	case '\x27': textcolor(7); putch('×'); break; // 2nd v chip
	case '\x0' : textcolor(7); putch(' '); break;
	default:  textcolor(7); putch(' '); break;
	} // switch
     putch('\n');
     putch('\r');
     } //for line

  textcolor(7);
  gotoxy(1,25);
  printf("Info: %-30s    Total: %3u    Board: %5d    ",info,info[30],num);
  if (b) {
  gotoxy(61,2);
  printf("   REG | SHFT | CNT");
  gotoxy(61,3);
  printf("F1  O           E");
  gotoxy(61,4);
  printf("F2  °     \xE0      ");
  gotoxy(61,5);
  printf("F3  Î     %      ");
  gotoxy(61,6);
  printf("F4  Û     \x15      ");
  gotoxy(61,7);
  printf("F5  Í     &      ");
  gotoxy(61,8);
  printf("F6  Ø     \xF0      \x12");
  gotoxy(61,9);
  printf("F7  º     \xF1      \x1D");
  gotoxy(61,10);
  printf("F8  ×           \xC5");
  gotoxy(61,11);
  printf("F9  \x7F     \xEF   ");
  gotoxy(61,12);
  printf("F10                ");
  gotoxy(62,13);
  printf("Alt-L = Load");
  gotoxy(62,14);
  printf("Alt-S = Save");
  gotoxy(62,15);
  printf("Alt-C = Clear");
  gotoxy(62,16);
  printf("Alt-G = Gravity");
  gotoxy(62,17);
  printf("Alt-T = Total");
  gotoxy(62,18);
  printf("Alt-N = Name Board");
  gotoxy(62,19);
  printf("Alt-B = Load Board");
  gotoxy(62,20);
  printf("Alt-X = Save Board");
  gotoxy(62,21);
  printf("] = Goto Next Board");
  gotoxy(62,22);
  printf("[ = Goto Prev Board");
  gotoxy(62,23);
  printf("D = Draw on/off");
  gotoxy(62,24);
  printf("<ESC> exit");
} // if b
  _setcursortype(_NORMALCURSOR);
} // putlevel()

void main(void) {
  div_t d;
  int x,y;
  char ch,ch2;
  char board[28], boardt[28];
  int exit;
  int temp, temp2;
  char tim, sp[] = " ";
  textbackground(0);
  clrscr();
  exit = 0;
  x = 2; y = 2;
  readlevel(1);
  putlevel(-1,24);
  tim = 'c';
  temp = 1;
  while (!exit) {
    gotoxy(x,y);

    ch = 1;
    if (kbhit()) {
      ch = toupper(getch());
      if (ch == 0) ch2 = getch();
    } // kbhit

    switch(ch) {


      case 0:   switch(ch2) {
		case 16: exit = 1; break; // Alt-Q
		case 31: writelevel(num); break; // Alt-S
		case 34: if (info[4] == '\x1') info[4] = 'Ý'; // Alt-G
			   else info[4] = '\x1';
			 putlevel(23,24);
			 break;
		case 20: gotoxy(1,25);
			 printf("Enter Total Number Of Infotrons: %37s",sp);
			 gotoxy(34,25);
			 scanf("%d",&temp);
			 info[30] = temp;
			 putlevel(-1,24);
			 break; // Alt-T

		case 38: gotoxy(1,25);
			 printf("Enter Level # To Load:          %47s",sp);
			 gotoxy(24,25);
			 scanf("%d",&temp);
			 tim = 'c';
			 num = temp;
			 readlevel(temp);
			 putlevel(-1,24);
			 break;
			 // Alt-L

		case 46: gotoxy(1,25);
			 printf("Clear Board? (Y/N)              %47s",sp);
			 gotoxy(19,25);
			 ch2 = toupper(getch());
			 if (ch2 == 'Y') {
			 ch2 = buff[y-1][x-1];
			 for (temp = 1; temp < 23; temp++)
			 for (temp2 = 1; temp2 < 59; temp2++)
			   buff[temp][temp2] = ch2;
			 }
			 putlevel(-1,24);
			 ch2 = 46;
			 break;

		case 45: gotoxy(1,25);
			 printf("Enter Board NAME To Save As:    %47s",sp);
			 gotoxy(30,25);
			 scanf("%s",board);
			 tim = 'c';
			 writeboard(board);
			 putlevel(-1,24);
			 break;
			 // Alt-X

		case 48: gotoxy(1,25);
			 printf("Enter Board NAME To Load:       %47s",sp);
			 gotoxy(30,25);
			 scanf("%s",board);
			 tim = 'c';
			 readboard(board);
			 putlevel(-1,24);
			 break;
			 // Alt-B

		case 49: gotoxy(1,25);
			 printf("Enter New Name For Board:       %47s",sp);
			 gotoxy(30,25);
			 tim = ' ';
			 temp = 0;
			 while (tim != 13 & temp < 24) {
			   gotoxy(30+temp,25);
			   tim = toupper(getch());
			   if (tim == 8 & temp > 0) temp --;
			   if (tim != 13 & tim != 8) {
			     board[temp] = tim;
			     putch(tim);
			     temp++;
			   }
			 }
			 board[temp] = '\x0';
			 strcpy(boardt,"=======================");
			 ch = strlen(board);
			 d = div(ch,2);
			 tim = d.quot;
			 temp = 11 - tim;
			 boardt[temp-1] = ' ';
			 boardt[temp+ch] = ' ';
			 for (temp2 = 0; temp2 < ch; temp2++) {
			   boardt[temp2+temp] = board[temp2];
			 }
			 for (temp = 0; temp < 24; temp++) {
			   info[temp+6] = boardt[temp];
			 }
			 tim = 'c';
			 putlevel(-1,24);
			 break;
			 // Alt-N

		case 'K': if (x > 2) x--;  break;
		case 'M': if (x < 59) x++;  break;
		case 'H': if (y > 2) y--;  break;
		case 'P': if (y < 23) y++;  break;
		case 59: buff[y-1][x-1] = '\x1'; putlevel(y-1,y);break; // boulder
		case 60: buff[y-1][x-1] = '\x2'; putlevel(y-1,y);break; // circut
		case 61: buff[y-1][x-1] = '\x5'; putlevel(y-1,y);break; // single chip
		case 62: buff[y-1][x-1] = '\x6'; putlevel(y-1,y);break; // solid
		case 63: buff[y-1][x-1] = '\x1A'; putlevel(y-1,y);break; //1st hor chip
		case 64: buff[y-1][x-1] = '\x1B'; putlevel(y-1,y);break; // 2nd hor chip
		case 65: buff[y-1][x-1] = '\x26'; putlevel(y-1,y);break; // 1st ver chip
		case 66: buff[y-1][x-1] = '\x27'; putlevel(y-1,y);break; // 2nd ver chip
		case 67: buff[y-1][x-1] = '\x1C'; putlevel(y-1,y);break; // modem
		case 68: buff[y-1][x-1] = '\x23'; putlevel(y-1,y);break; // RESISTORS
		case 84: buff[y-1][x-1] = '\x3'; putlevel(y-1,y);break; // murphy
		case 85: buff[y-1][x-1] = '\x11'; putlevel(y-1,y);break; // snick snack
		case 86: buff[y-1][x-1] = '\x18'; putlevel(y-1,y);break; // electron
		case 87: buff[y-1][x-1] = '\x19'; putlevel(y-1,y);break; // bug
		case 88: buff[y-1][x-1] = '\x4'; putlevel(y-1,y);break; // info
		case 89: buff[y-1][x-1] = '\x13'; putlevel(y-1,y);break; // computer
		case 90: buff[y-1][x-1] = '\x12'; putlevel(y-1,y);break; // yellow
		case 91: buff[y-1][x-1] = '\x8'; putlevel(y-1,y);break; // orange
		case 92: buff[y-1][x-1] = '\x14'; putlevel(y-1,y);break; // red
		case 93: buff[y-1][x-1] = '\x14'; putlevel(y-1,y);break;
		case 94: buff[y-1][x-1] = '\x7'; putlevel(y-1,y);break; // exit
		case 95: buff[y-1][x-1] = '\x9'; putlevel(y-1,y);break; // >
		case 96: buff[y-1][x-1] = '\xA'; putlevel(y-1,y);break; // down
		case 97: buff[y-1][x-1] = '\xB'; putlevel(y-1,y);break; // <
		case 98: buff[y-1][x-1] = '\xC'; putlevel(y-1,y);break; // up
		case 99: buff[y-1][x-1] = '\x15'; putlevel(y-1,y);break; // up-down
		case 100: buff[y-1][x-1] = '\x16'; putlevel(y-1,y);break; // <>
		case 101: buff[y-1][x-1] = '\x17'; putlevel(y-1,y);break; // 4-way
		case 102: buff[y-1][x-1] = '\x0'; putlevel(y-1,y);break; //
		case 103: buff[y-1][x-1] = '\x0'; putlevel(y-1,y);break;
		//case 32: buff[y-1][x-1] = '\x0'; putlevel(y-1,y);break; // nothing

	      } // switch ch2
	      break;

      case 27: exit = 1; break;
      case '[': gotoxy(1,25);
		printf("Press '[' to load next board    %47s",sp);

		ch = getch();
		if (ch == '[') {
		  tim = 'c';
		  if (num > 1) num--;
		    else num = 111;
		   readlevel(num);
		}
		putlevel(-1,24);
		break;
		// [

	    case ']': gotoxy(1,25);
		printf("Press ']' to load next board    %47s",sp);

		ch = getch();
		if (ch == ']') {
		  tim = 'c';
		  if (num < 111) num++;
		    else num = 1;
		  readlevel(num);
		}
		putlevel(-1,24);
		break;
		// ]

      case 'D': if (tim == 'c') tim = buff[y-1][x-1];
		  else tim = 'c';
		break;
      case 32: buff[y-1][x-1] = '\x0'; putlevel(y-1,y);break; // nothing
      }// switch(ch);
    if (tim != 'c') {buff[y-1][x-1] = tim; putlevel(y-1,y);}
    } // !exit
  textbackground(0);
  clrscr();
  printf("Supaplex Board Editor v1.1á\n");
  printf("Copyright (c) 1992, Tim Dedischew\n\n");
}
