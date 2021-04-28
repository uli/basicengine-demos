#include <eb_config.h>
#include <eb_conio.h>
#include <eb_sys.h>
#include <eb_video.h>
#include <stdio.h>
#include <stdlib.h>

#include <sys/queue.h>

#include "def.h"

//#define dbg_print(x...) fprintf(stderr, x)
#define dbg_print(x...) do {} while (0)

char	*keystrings[] = {NULL};

int ncol;
int nrow;
int tceeol;
int tcinsl;
int tcdell;
volatile int winch_flag;

void panic(char *s)
{
	printf("WAAAAAAAAAAAAAAH!!! %s\n", s);
	exit(1);
}

void ttinit(void)
{
	dbg_print("ttinit\n");
	eb_cls();
	ncol = eb_csize_width();
	nrow = eb_csize_height();
	tceeol = ncol;
	tcinsl = nrow * ncol;
	tcdell = nrow * ncol;
	ttresize();
}

void ttclose(void)
{
	dbg_print("ebclose\n");
	eb_enable_scrolling(1);
	eb_show_cursor(0);
}

void tttidy(void)
{
	dbg_print("tttidy\n");
}

static int saved = -1;

int charswaiting(void)
{
	return saved != -1 || eb_kbhit();
}

int ttgetc(void)
{
	int c, m;
	if (saved != -1) {
		c = saved;
		saved = -1;
	} else {
		c = eb_getch();
		if (c >= 256) {
			saved = (c & 0x7f) + 1;
			c = 27;
		} else if (c == CCHR('H'))
			c = CCHR('?');

		m = eb_last_key_event();
		fprintf(stderr, "lke %x\n", m);
		if (m & KEY_EVENT_ALT)
			c |= 0x80;//METABIT;
	}
	dbg_print("gc %d\n", c);
	return c;
}

int ttputc(int ch)
{
	eb_putch(ch);
	return ch;
}

void ttmove(int row, int col)
{
	dbg_print("ttmove %d %d\n", row, col);
	eb_locate(col, row);
	ttcol = col;
	ttrow = row;
}

void tteeol(void)
{
	dbg_print("tteeol\n");
	eb_clrtoeol();
	ttrow = eb_pos_y();
	ttcol = eb_pos_x();
}

void tteeop(void)
{
	dbg_print("tteeop\n");
	// Only used in a single place, to clear the whole screen.
	eb_cls();
	ttrow = eb_pos_y();
	ttcol = eb_pos_x();
}

void ttbeep(void)
{
	dbg_print("beep!\n");
}

void ttrev(int state)
{
	if (state)
		eb_puts("\\R");
	else
		eb_puts("\\N");
}

void ttcres(char *res)
{
	dbg_print("cres %s\n", res);
}

void ttcolor(int color)
{
	dbg_print("color %d\n", color);
	if (color == CMODE)
		eb_color(eb_rgb(255,255,255), eb_rgb(192, 0, 0));
	else
		eb_color(eb_theme_color(COL_FG), eb_theme_color(COL_BG));
}

void ttnowindow(void)
{
	dbg_print("nowindow\n");
}

void ttflush(void)
{
	dbg_print("flush\n");
}

void ttopen(void)
{
	dbg_print("ebopen\n");
	eb_enable_scrolling(0);
	eb_show_cursor(1);
}

void ttinsl(int row, int bot, int nchunk)
{
	dbg_print("ttinsl row %d bot %d nchunk %d\n", row, bot, nchunk);
}

void ttdell(int row, int bot, int nchunk)
{
	dbg_print("ttdell row %d bot %d nchunk %d\n", row, bot, nchunk);
}

int ttwait(int msec)
{
	dbg_print("ttwait %d\n", msec);
	unsigned int until = eb_tick() + msec;
	while (eb_tick() < until) {
		if (saved != -1 || eb_kbhit())
			return 0;
		eb_process_events();
	}
	return 1;
}

void ttresize(void)
{
	dbg_print("ttresize\n");
	vtresize(1, nrow, ncol);
}

#include "kbd.h"

void ttykeymapinit(void)
{
	dbg_print("ttykeymapinit\n");
	dobindkey(fundamental_map, "previous-line", "\\E\x02");
	dobindkey(fundamental_map, "next-line", "\\E\x01");
	dobindkey(fundamental_map, "backward-char", "\\E\x03");
	dobindkey(fundamental_map, "forward-char", "\\E\x04");
	dobindkey(fundamental_map, "beginning-of-line", "\\E\x05");
	dobindkey(fundamental_map, "end-of-line", "\\E\x0a");
	dobindkey(fundamental_map, "scroll-up", "\\E\x08");
	dobindkey(fundamental_map, "scroll-down", "\\E\x09");
	dobindkey(fundamental_map, "overwrite-mode", "\\E\x07");
	dobindkey(fundamental_map, "delete-char", "\\E\x06");
}
