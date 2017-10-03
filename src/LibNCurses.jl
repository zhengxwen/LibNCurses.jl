# ===========================================================================
#
# LibNCurses.jl: Julia Interface to the ncurses library
#
# Copyright (C) 2017    Xiuwen Zheng
#
# This is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License Version 3 as
# published by the Free Software Foundation.
#
# LibNCurses.jl is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with LibNCurses.jl.
# If not, see <http://www.gnu.org/licenses/>.


module LibNCurses

export WINDOW, NC_OK, NC_ERR,
	COLOR_BLACK, COLOR_RED, COLOR_GREEN, COLOR_YELLOW, COLOR_BLUE,
	COLOR_MAGENTA, COLOR_CYAN, COLOR_WHITE, COLOR_PAIR,
	A_NORMAL, A_ATTRIBUTES, A_COLOR, A_STANDOUT, A_UNDERLINE, A_REVERSE,
	A_BLINK, A_DIM, A_BOLD, A_ALTCHARSET, A_INVIS, A_PROTECT,
	COL_A_BLACK, COL_A_RED, COL_A_GREEN, COL_A_YELLOW,
	COL_A_BLUE, COL_A_MAGENTA, COL_A_CYAN, COL_A_WHITE,
	KEY_TAB, KEY_RETURN, KEY_ESC, KEY_SPACE, KEY_DELETE,
	KEY_CODE_YES, KEY_MIN, KEY_DOWN, KEY_UP, KEY_LEFT, KEY_RIGHT, KEY_HOME, KEY_BACKSPACE, KEY_F0,
	KEY_BTAB,
	KEY_UNDO, KEY_MOUSE, KEY_RESIZE, KEY_EVENT,
	addch,
	addnstr, addstr, attron, attroff, attrset,
	beep, bkgd,
	box, can_change_color, cbreak,
	clear, clearok, clrtobot, clrtoeol,
	delch,
	delwin,
	endwin,
	getch,
	halfdelay, has_colors, has_ic, has_il,
	initscr,
	init_color,
	init_pair,
	keypad, killchar, leaveok, longname, meta, move,
	mvwaddnstr, mvwaddstr,
	newwin, nl, nocbreak, nodelay, noecho, nonl,
	refresh,
	scroll, scrollok,
	start_color,
	subwin,
	ungetch,
	waddch, waddchnstr, waddchstr, mvwaddch, mvwaddchnstr, mvwaddchstr,
	waddnstr, waddstr, wattron, wattroff, wattrset,
	wbkgd,
	werase, wgetch,
	wmove,
	wrefresh,
	getattrs, getcurx, getcury, getbegx, getbegy, getmaxx, getmaxy,
	# extensions
	use_default_colors



####  Link to ncurses library  ####

@static if is_apple()
	libname = "libncurses.dylib"
elseif is_windows()
	libname = "libncurses.dll"
elseif is_unix()
	libname = "libncurses.so"
else
	error("The platform is not supported.")
end

const libnc = libname


####  Types  ####

const WINDOW = Ptr{Void}


####  Status  ####

const NC_OK  = 0
const NC_ERR = -1


####  Color list  ####

const COLOR_BLACK   = 00
const COLOR_RED     = 01
const COLOR_GREEN   = 02
const COLOR_YELLOW  = 03
const COLOR_BLUE    = 04
const COLOR_MAGENTA = 05
const COLOR_CYAN    = 06
const COLOR_WHITE   = 07


####  Attributes   ####

const NCURSES_ATTR_SHIFT = 8
NCURSES_BITS(mask, shift) = mask << (shift + NCURSES_ATTR_SHIFT)

COLOR_PAIR(n) = NCURSES_BITS(n, 0)

const A_NORMAL      = 0
const A_ATTRIBUTES  = NCURSES_BITS(~0, 0)
const A_COLOR       = NCURSES_BITS((1 << 8) - 1, 0)
const A_STANDOUT    = NCURSES_BITS(1, 8)
const A_UNDERLINE   = NCURSES_BITS(1,9)
const A_REVERSE     = NCURSES_BITS(1, 10)
const A_BLINK       = NCURSES_BITS(1, 11)
const A_DIM         = NCURSES_BITS(1, 12)
const A_BOLD        = NCURSES_BITS(1, 13)
const A_ALTCHARSET  = NCURSES_BITS(1, 14)
const A_INVIS       = NCURSES_BITS(1, 15)
const A_PROTECT     = NCURSES_BITS(1, 16)

const COL_A_BLACK   = COLOR_PAIR(0)
const COL_A_RED     = COLOR_PAIR(1)
const COL_A_GREEN   = COLOR_PAIR(2)
const COL_A_YELLOW  = COLOR_PAIR(3)
const COL_A_BLUE    = COLOR_PAIR(4)
const COL_A_MAGENTA = COLOR_PAIR(5)
const COL_A_CYAN    = COLOR_PAIR(6)
const COL_A_WHITE   = COLOR_PAIR(7)


####  Key codes   ####

const KEY_TAB       = 0x009
const KEY_RETURN    = 0x00A
const KEY_ESC       = 0x01B
const KEY_SPACE     = 0x020
const KEY_DELETE    = 0x07F

const KEY_CODE_YES  = 0x100		# A wchar_t contains a key code
const KEY_MIN       = 0x101		# Minimum curses key
const KEY_DOWN      = 0x102		# down-arrow key
const KEY_UP        = 0x103		# up-arrow key
const KEY_LEFT      = 0x104		# left-arrow key
const KEY_RIGHT     = 0x105		# right-arrow key
const KEY_HOME      = 0x106		# home key
const KEY_BACKSPACE = 0x107		# backspace key
const KEY_F0        = 0x108		# Function keys.  Space for 64

const KEY_DL        = 0x148		# delete-line key
const KEY_IL        = 0x149		# insert-line key
const KEY_DC        = 0x14A		# delete-character key
const KEY_IC        = 0x14B		# insert-character key
const KEY_EIC       = 0x14C		# sent by rmir or smir in insert mode
const KEY_CLEAR     = 0x14D		# clear-screen or erase key
const KEY_EOS       = 0x14E		# clear-to-end-of-screen key
const KEY_EOL       = 0x14F		# clear-to-end-of-line key

const KEY_SF        = 0x150		# scroll-forward key
const KEY_SR        = 0x151		# scroll-backward key
const KEY_NPAGE     = 0x152		# next-page key
const KEY_PPAGE     = 0x153		# previous-page key
const KEY_STAB      = 0x154		# set-tab key
const KEY_CTAB      = 0x155		# clear-tab key
const KEY_CATAB     = 0x156		# clear-all-tabs key
const KEY_ENTER     = 0x157		# enter/send key

const KEY_BTAB      = 0x161		# back-tab key
const KEY_BEG       = 0x162		# begin key
const KEY_CANCEL    = 0x163		# cancel key
const KEY_CLOSE     = 0x164		# close key
const KEY_COMMAND   = 0x165		# command key
const KEY_COPY      = 0x166		# copy key
const KEY_CREATE    = 0x167		# create key
const KEY_END       = 0x168		# end key
const KEY_EXIT      = 0x169		# exit key
const KEY_FIND      = 0x16A		# find key
const KEY_HELP      = 0x16B		# help key
const KEY_MARK      = 0x16C		# mark key
const KEY_MESSAGE   = 0x16D		# message key
const KEY_MOVE      = 0x16E		# move key
const KEY_NEXT      = 0x16F		# next key

const KEY_UNDO      = 0x198		# undo key
const KEY_MOUSE     = 0x199		# Mouse event has occurred
const KEY_RESIZE    = 0x19A		# Terminal resize event
const KEY_EVENT     = 0x19B		# We were interrupted by an event


####  Functions  ####

addch(ch::Char) = ccall((:addch, libnc), Cint, (Cuint,), ch)

# NCURSES_EXPORT(int) addchnstr (const chtype *, int);		/* generated */
# NCURSES_EXPORT(int) addchstr (const chtype *);			/* generated */

addnstr(s::String, n::Int) = ccall((:addnstr, libnc), Cint, (Cstring, Cint), s, n)
addnstr(s::AbstractString, n::Int) = ccall((:addnstr, libnc), Cint, (Cstring, Cint), s, n)
addstr(s::String) = ccall((:addstr, libnc), Cint, (Cstring,), s)
addstr(s::AbstractString) = ccall((:addstr, libnc), Cint, (Cstring,), s)

attron(a::Int) = ccall((:attron, libnc), Cint, (Cint,), a)
attroff(a::Int) = ccall((:attroff, libnc), Cint, (Cint,), a)
attrset(a::Int) = ccall((:attrset, libnc), Cint, (Cint,), a)

# NCURSES_EXPORT(int) attr_get (attr_t *, Cshort *, void *);	/* generated */
# NCURSES_EXPORT(int) attr_off (attr_t, void *);			/* generated */
# NCURSES_EXPORT(int) attr_on (attr_t, void *);			/* generated */
# NCURSES_EXPORT(int) attr_set (attr_t, Cshort, void *);		/* generated */
# NCURSES_EXPORT(int) baudrate (void);				/* implemented */

beep() = ccall((:beep, libnc), Cint, ())
bkgd(ch::Int) = ccall((:bkgd, libnc), Cint, (Cuint,), ch)

# NCURSES_EXPORT(int) bkgd (chtype);				/* generated */


# NCURSES_EXPORT(void) bkgdset (chtype);				/* generated */
# NCURSES_EXPORT(int) border (chtype,chtype,chtype,chtype,chtype,chtype,chtype,chtype);	/* generated */

box(w::WINDOW, verch::Int, horch::Int) = ccall((:box, libnc), Cint, (WINDOW, Cuint, Cuint), w, verch, horch)

can_change_color() = ccall((:can_change_color, libnc), Bool, ())
cbreak() = ccall((:cbreak, libnc), Cint, ())

# NCURSES_EXPORT(int) chgat (int, attr_t, Cshort, const void *);	/* generated */

clear() = ccall((:clear, libnc), Cint, ())
clearok(w::WINDOW, bf::Bool) = ccall((:clearok, libnc), Cint, (WINDOW, Cuchar), w, bf)
clrtobot() = ccall((:clrtobot, libnc), Cint, ())
clrtoeol() = ccall((:clrtoeol, libnc), Cint, ())


# NCURSES_EXPORT(int) color_content (Cshort,Cshort*,Cshort*,Cshort*);	/* implemented */
# NCURSES_EXPORT(int) color_set (Cshort,void*);			/* generated */
# NCURSES_EXPORT(int) copywin (const WINDOW*,WINDOW*,int,int,int,int,int,int,int);	/* implemented */
# NCURSES_EXPORT(int) curs_set (int);				/* implemented */
# NCURSES_EXPORT(int) def_prog_mode (void);			/* implemented */
# NCURSES_EXPORT(int) def_shell_mode (void);			/* implemented */
# NCURSES_EXPORT(int) delay_output (int);				/* implemented */

delch() = ccall((:delch, libnc), Cint, ())

# NCURSES_EXPORT(void) delscreen (SCREEN *);			/* implemented */

delwin(w::WINDOW) = ccall((:delwin, libnc), Cint, (WINDOW,), w)

# NCURSES_EXPORT(int) deleteln (void);				/* generated */
# NCURSES_EXPORT(WINDOW *) derwin (WINDOW *,int,int,int,int);	/* implemented */
# NCURSES_EXPORT(int) doupdate (void);				/* implemented */
# NCURSES_EXPORT(WINDOW *) dupwin (WINDOW *);			/* implemented */
# NCURSES_EXPORT(int) echo (void);					/* implemented */
# NCURSES_EXPORT(int) echochar (const chtype);			/* generated */
# NCURSES_EXPORT(int) erase (void);				/* generated */

endwin() = ccall((:endwin, libnc), Cint, ())

# NCURSES_EXPORT(char) erasechar (void);				/* implemented */
# NCURSES_EXPORT(void) filter (void);				/* implemented */
# NCURSES_EXPORT(int) flash (void);				/* implemented */
# NCURSES_EXPORT(int) flushinp (void);				/* implemented */
# NCURSES_EXPORT(chtype) getbkgd (WINDOW *);			/* generated */

getch() = ccall((:getch, libnc), Cint, ())

# NCURSES_EXPORT(int) getnstr (char *, int);			/* generated */
# NCURSES_EXPORT(int) getstr (char *);				/* generated */
# NCURSES_EXPORT(WINDOW *) getwin (FILE *);			/* implemented */

halfdelay(tenths::Int) = ccall((:halfdelay, libnc), Cint, (Cint,), tenths)
has_colors() = ccall((:has_colors, libnc), Bool, ())
has_ic() = ccall((:has_ic, libnc), Bool, ())
has_il() = ccall((:has_il, libnc), Bool, ())


# NCURSES_EXPORT(int) hline (chtype, int);				/* generated */
# NCURSES_EXPORT(void) idcok (WINDOW *, bool);			/* implemented */
# NCURSES_EXPORT(int) idlok (WINDOW *, bool);			/* implemented */
# NCURSES_EXPORT(void) immedok (WINDOW *, bool);			/* implemented */
# NCURSES_EXPORT(chtype) inch (void);				/* generated */
# NCURSES_EXPORT(int) inchnstr (chtype *, int);			/* generated */
# NCURSES_EXPORT(int) inchstr (chtype *);				/* generated */

initscr() = ccall((:initscr, libnc), WINDOW, ())

init_color(col::Int, r::Int, g::Int, b::Int) =
	ccall((:init_color, libnc), Cint, (Cshort, Cshort, Cshort, Cshort), col, r, g, b)
init_pair(pair::Int, f::Int, b::Int) =
	ccall((:init_pair, libnc), Cint, (Cshort, Cshort, Cshort), pair, f, b)


# NCURSES_EXPORT(int) innstr (char *, int);			/* generated */
# NCURSES_EXPORT(int) insch (chtype);				/* generated */
# NCURSES_EXPORT(int) insdelln (int);				/* generated */
# NCURSES_EXPORT(int) insertln (void);				/* generated */
# NCURSES_EXPORT(int) insnstr (const char *, int);			/* generated */
# NCURSES_EXPORT(int) insstr (const char *);			/* generated */
# NCURSES_EXPORT(int) instr (char *);				/* generated */
# NCURSES_EXPORT(int) intrflush (WINDOW *,bool);			/* implemented */
# NCURSES_EXPORT(bool) isendwin (void);				/* implemented */
# NCURSES_EXPORT(bool) is_linetouched (WINDOW *,int);		/* implemented */
# NCURSES_EXPORT(bool) is_wintouched (WINDOW *);			/* implemented */
# NCURSES_EXPORT(NCURSES_CONST char *) keyname (int);		/* implemented */

keypad(w::WINDOW, bf::Bool) = ccall((:keypad, libnc), Cint, (WINDOW, Cuchar), w, bf)
killchar() = ccall((:killchar, libnc), Char, ())
leaveok(w::WINDOW, bf::Bool) = ccall((:leaveok, libnc), Cint, (WINDOW, Cuchar), w, bf)
longname() = unsafe_string(ccall((:longname, libnc), Cstring, ()))
meta(w::WINDOW, bf::Bool) = ccall((:meta, libnc), Cint, (WINDOW, Cuchar), w, bf)
move(y::Int, x::Int) = ccall((:move, libnc), Cint, (Cint, Cint), y, x)


# NCURSES_EXPORT(int) mvaddch (int, int, const chtype);		/* generated */
# NCURSES_EXPORT(int) mvaddchnstr (int, int, const chtype *, int);	/* generated */
# NCURSES_EXPORT(int) mvaddchstr (int, int, const chtype *);	/* generated */
# NCURSES_EXPORT(int) mvaddnstr (int, int, const char *, int);	/* generated */
# NCURSES_EXPORT(int) mvaddstr (int, int, const char *);		/* generated */
# NCURSES_EXPORT(int) mvchgat (int, int, int, attr_t, Cshort, const void *);	/* generated */
# NCURSES_EXPORT(int) mvcur (int,int,int,int);			/* implemented */
# NCURSES_EXPORT(int) mvdelch (int, int);				/* generated */
# NCURSES_EXPORT(int) mvderwin (WINDOW *, int, int);		/* implemented */
# NCURSES_EXPORT(int) mvgetch (int, int);				/* generated */
# NCURSES_EXPORT(int) mvgetnstr (int, int, char *, int);		/* generated */
# NCURSES_EXPORT(int) mvgetstr (int, int, char *);			/* generated */
# NCURSES_EXPORT(int) mvhline (int, int, chtype, int);		/* generated */
# NCURSES_EXPORT(chtype) mvinch (int, int);			/* generated */
# NCURSES_EXPORT(int) mvinchnstr (int, int, chtype *, int);	/* generated */
# NCURSES_EXPORT(int) mvinchstr (int, int, chtype *);		/* generated */
# NCURSES_EXPORT(int) mvinnstr (int, int, char *, int);		/* generated */
# NCURSES_EXPORT(int) mvinsch (int, int, chtype);			/* generated */
# NCURSES_EXPORT(int) mvinsnstr (int, int, const char *, int);	/* generated */
# NCURSES_EXPORT(int) mvinsstr (int, int, const char *);		/* generated */
# NCURSES_EXPORT(int) mvinstr (int, int, char *);			/* generated */
# NCURSES_EXPORT(int) mvprintw (int,int, const char *,...)		/* implemented */
		# GCC_PRINTFLIKE(3,4);
# NCURSES_EXPORT(int) mvscanw (int,int, NCURSES_CONST char *,...)	/* implemented */
		# GCC_SCANFLIKE(3,4);
# NCURSES_EXPORT(int) mvvline (int, int, chtype, int);		/* generated */


mvwaddch(w::WINDOW, y::Int, x::Int, ch::Char) = ccall((:mvwaddch, libnc), Cint, (WINDOW, Cint, Cint, Cuint), w, y, x, ch)
mvwaddch(w::WINDOW, y::Int, x::Int, ch::Int) = ccall((:mvwaddch, libnc), Cint, (WINDOW, Cint, Cint, Cuint), w, y, x, ch)
mvwaddchnstr(w::WINDOW, y::Int, x::Int, chstr::Vector{Char}, n::Int) = ccall((:mvwaddchnstr, libnc), Cint, (WINDOW, Cint, Cint, Ptr{Cuint}, Cint), w, y, x, chstr, n)
mvwaddchstr(w::WINDOW, y::Int, x::Int, chstr::Vector{Char}) = ccall((:mvwaddchstr, libnc), Cint, (WINDOW, Cint, Cint, Ptr{Cuint}), w, y, x, chstr)
mvwaddnstr(w::WINDOW, y::Int, x::Int, s::String, n::Int) = ccall((:mvwaddnstr, libnc), Cint, (WINDOW, Cint, Cint, Cstring, Cint), w, y, x, s, n)
mvwaddnstr(w::WINDOW, y::Int, x::Int, s::AbstractString, n::Int) = ccall((:mvwaddnstr, libnc), Cint, (WINDOW, Cint, Cint, Cstring, Cint), w, y, x, s, n)
mvwaddstr(w::WINDOW, y::Int, x::Int, s::String) = ccall((:mvwaddstr, libnc), Cint, (WINDOW, Cint, Cint, Cstring), w, y, x, s)
mvwaddstr(w::WINDOW, y::Int, x::Int, s::AbstractString) = ccall((:mvwaddstr, libnc), Cint, (WINDOW, Cint, Cint, Cstring), w, y, x, s)



# NCURSES_EXPORT(int) mvwchgat (WINDOW *, int, int, int, attr_t, Cshort, const void *);/* generated */
# NCURSES_EXPORT(int) mvwdelch (WINDOW *, int, int);		/* generated */
# NCURSES_EXPORT(int) mvwgetch (WINDOW *, int, int);		/* generated */
# NCURSES_EXPORT(int) mvwgetnstr (WINDOW *, int, int, char *, int);	/* generated */
# NCURSES_EXPORT(int) mvwgetstr (WINDOW *, int, int, char *);	/* generated */
# NCURSES_EXPORT(int) mvwhline (WINDOW *, int, int, chtype, int);	/* generated */
# NCURSES_EXPORT(int) mvwin (WINDOW *,int,int);			/* implemented */
# NCURSES_EXPORT(chtype) mvwinch (WINDOW *, int, int);			/* generated */
# NCURSES_EXPORT(int) mvwinchnstr (WINDOW *, int, int, chtype *, int);	/* generated */
# NCURSES_EXPORT(int) mvwinchstr (WINDOW *, int, int, chtype *);		/* generated */
# NCURSES_EXPORT(int) mvwinnstr (WINDOW *, int, int, char *, int);		/* generated */
# NCURSES_EXPORT(int) mvwinsch (WINDOW *, int, int, chtype);		/* generated */
# NCURSES_EXPORT(int) mvwinsnstr (WINDOW *, int, int, const char *, int);	/* generated */
# NCURSES_EXPORT(int) mvwinsstr (WINDOW *, int, int, const char *);		/* generated */
# NCURSES_EXPORT(int) mvwinstr (WINDOW *, int, int, char *);		/* generated */
# NCURSES_EXPORT(int) mvwprintw (WINDOW*,int,int, const char *,...)	/* implemented */
		# GCC_PRINTFLIKE(4,5);
# NCURSES_EXPORT(int) mvwscanw (WINDOW *,int,int, NCURSES_CONST char *,...)	/* implemented */
		# GCC_SCANFLIKE(4,5);
# NCURSES_EXPORT(int) mvwvline (WINDOW *,int, int, chtype, int);	/* generated */
# NCURSES_EXPORT(int) napms (int);					/* implemented */
# NCURSES_EXPORT(WINDOW *) newpad (int,int);				/* implemented */
# NCURSES_EXPORT(SCREEN *) newterm (NCURSES_CONST char *,FILE *,FILE *);	/* implemented */


newwin(ny::Int, nx::Int, y::Int, x::Int) = ccall((:newwin, libnc), WINDOW, (Cint,Cint,Cint,Cint), ny, nx, y, x)
nl() = ccall((:nl, libnc), Cint, ())
nocbreak() = ccall((:nocbreak, libnc), Cint, ())
nodelay(w::WINDOW, bf::Bool) = ccall((:nodelay, libnc), Cint, (WINDOW, Cuchar), w, bf)
noecho() = ccall((:noecho, libnc), Cint, ())
nonl() = ccall((:nonl, libnc), Cint, ())


# NCURSES_EXPORT(void) noqiflush (void);				/* implemented */
# NCURSES_EXPORT(int) noraw (void);				/* implemented */
# NCURSES_EXPORT(int) notimeout (WINDOW *,bool);			/* implemented */
# NCURSES_EXPORT(int) overlay (const WINDOW*,WINDOW *);		/* implemented */
# NCURSES_EXPORT(int) overwrite (const WINDOW*,WINDOW *);		/* implemented */
# NCURSES_EXPORT(int) pair_content (Cshort,Cshort*,Cshort*);		/* implemented */
# NCURSES_EXPORT(int) PAIR_NUMBER (int);				/* generated */
# NCURSES_EXPORT(int) pechochar (WINDOW *, const chtype);		/* implemented */
# NCURSES_EXPORT(int) pnoutrefresh (WINDOW*,int,int,int,int,int,int);/* implemented */
# NCURSES_EXPORT(int) prefresh (WINDOW *,int,int,int,int,int,int);	/* implemented */
# NCURSES_EXPORT(int) printw (const char *,...)			/* implemented */
		# GCC_PRINTFLIKE(1,2);
# NCURSES_EXPORT(int) putwin (WINDOW *, FILE *);			/* implemented */
# NCURSES_EXPORT(void) qiflush (void);				/* implemented */
# NCURSES_EXPORT(int) raw (void);					/* implemented */
# NCURSES_EXPORT(int) redrawwin (WINDOW *);			/* generated */

refresh() = ccall((:refresh, libnc), Cint, ())

# NCURSES_EXPORT(int) resetty (void);				/* implemented */
# NCURSES_EXPORT(int) reset_prog_mode (void);			/* implemented */
# NCURSES_EXPORT(int) reset_shell_mode (void);			/* implemented */
# NCURSES_EXPORT(int) ripoffline (int, int (*)(WINDOW *, int));	/* implemented */
# NCURSES_EXPORT(int) savetty (void);				/* implemented */
# NCURSES_EXPORT(int) scanw (NCURSES_CONST char *,...)		/* implemented */
		# GCC_SCANFLIKE(1,2);
# NCURSES_EXPORT(int) scr_dump (const char *);			/* implemented */
# NCURSES_EXPORT(int) scr_init (const char *);			/* implemented */
# NCURSES_EXPORT(int) scrl (int);					/* generated */

scroll(w::WINDOW) = ccall((:scroll, libnc), Cint, (WINDOW,), w)
scrollok(w::WINDOW, bf::Bool) = ccall((:scrollok, libnc), Cint, (WINDOW, Cuchar), w, bf)


# NCURSES_EXPORT(int) scr_restore (const char *);			/* implemented */
# NCURSES_EXPORT(int) scr_set (const char *);			/* implemented */
# NCURSES_EXPORT(int) setscrreg (int,int);				/* generated */
# NCURSES_EXPORT(SCREEN *) set_term (SCREEN *);			/* implemented */
# NCURSES_EXPORT(int) slk_attroff (const chtype);			/* implemented */
# NCURSES_EXPORT(int) slk_attr_off (const attr_t, void *);		/* generated:WIDEC */
# NCURSES_EXPORT(int) slk_attron (const chtype);			/* implemented */
# NCURSES_EXPORT(int) slk_attr_on (attr_t,void*);			/* generated:WIDEC */
# NCURSES_EXPORT(int) slk_attrset (const chtype);			/* implemented */
# NCURSES_EXPORT(attr_t) slk_attr (void);				/* implemented */
# NCURSES_EXPORT(int) slk_attr_set (const attr_t,Cshort,void*);	/* implemented */
# NCURSES_EXPORT(int) slk_clear (void);				/* implemented */
# NCURSES_EXPORT(int) slk_color (Cshort);				/* implemented */
# NCURSES_EXPORT(int) slk_init (int);				/* implemented */
# NCURSES_EXPORT(char *) slk_label (int);				/* implemented */
# NCURSES_EXPORT(int) slk_noutrefresh (void);			/* implemented */
# NCURSES_EXPORT(int) slk_refresh (void);				/* implemented */
# NCURSES_EXPORT(int) slk_restore (void);				/* implemented */
# NCURSES_EXPORT(int) slk_set (int,const char *,int);		/* implemented */
# NCURSES_EXPORT(int) slk_touch (void);				/* implemented */
# NCURSES_EXPORT(int) standout (void);				/* generated */
# NCURSES_EXPORT(int) standend (void);				/* generated */

start_color() = ccall((:start_color, libnc), Cint, ())


# NCURSES_EXPORT(WINDOW *) subpad (WINDOW *, int, int, int, int);	/* implemented */


subwin(w::WINDOW, ny::Int, nx::Int, y::Int, x::Int) =
	ccall((:subwin, libnc), WINDOW, (WINDOW,Cint,Cint,Cint,Cint), w, ny, nx, y, x)


# NCURSES_EXPORT(int) syncok (WINDOW *, bool);			/* implemented */
# NCURSES_EXPORT(chtype) termattrs (void);				/* implemented */
# NCURSES_EXPORT(char *) termname (void);				/* implemented */
# NCURSES_EXPORT(void) timeout (int);				/* generated */
# NCURSES_EXPORT(int) touchline (WINDOW *, int, int);		/* generated */
# NCURSES_EXPORT(int) touchwin (WINDOW *);				/* generated */
# NCURSES_EXPORT(int) typeahead (int);				/* implemented */

ungetch(ch::Int) = ccall((:ungetch, libnc), Cint, (Cint,), ch)


# NCURSES_EXPORT(int) untouchwin (WINDOW *);			/* generated */
# NCURSES_EXPORT(void) use_env (bool);				/* implemented */
# NCURSES_EXPORT(int) vidattr (chtype);				/* implemented */
# NCURSES_EXPORT(int) vidputs (chtype, int (*)(int));		/* implemented */
# NCURSES_EXPORT(int) vline (chtype, int);				/* generated */

# NCURSES_EXPORT(int) vwprintw (WINDOW *, const char *,va_list);	/* implemented */
# NCURSES_EXPORT(int) vw_printw (WINDOW *, const char *,va_list);	/* generated */
# NCURSES_EXPORT(int) vwscanw (WINDOW *, NCURSES_CONST char *,va_list);	/* implemented */
# NCURSES_EXPORT(int) vw_scanw (WINDOW *, NCURSES_CONST char *,va_list);	/* generated */


waddch(w::WINDOW, ch::Char) = ccall((:waddch, libnc), Cint, (WINDOW, Cuint), w, ch)
waddch(w::WINDOW, ch::Int) = ccall((:waddch, libnc), Cint, (WINDOW, Cuint), w, ch)
waddchnstr(w::WINDOW, chstr::Vector{Char}, n::Int) = ccall((:waddchnstr, libnc), Cint, (WINDOW, Ptr{Cuint}, Cint), w, chstr, n)
waddchstr(w::WINDOW, chstr::Vector{Char}) = ccall((:waddchstr, libnc), Cint, (WINDOW, Ptr{Cuint}), w, chstr)
waddnstr(w::WINDOW, s::String, n::Int) = ccall((:waddnstr, libnc), Cint, (WINDOW, Cstring, Cint), w, s, n)
waddnstr(w::WINDOW, s::AbstractString, n::Int) = ccall((:waddnstr, libnc), Cint, (WINDOW, Cstring, Cint), w, s, n)
waddstr(w::WINDOW, s::String) = ccall((:waddstr, libnc), Cint, (WINDOW, Cstring), w, s)
waddstr(w::WINDOW, s::AbstractString) = ccall((:waddstr, libnc), Cint, (WINDOW, Cstring), w, s)
wattron(w::WINDOW, a::Int) = ccall((:wattron, libnc), Cint, (WINDOW, Cint), w, a)
wattroff(w::WINDOW, a::Int) = ccall((:wattroff, libnc), Cint, (WINDOW, Cint), w, a)
wattrset(w::WINDOW, a::Int) = ccall((:wattrset, libnc), Cint, (WINDOW, Cint), w, a)

# NCURSES_EXPORT(int) wattr_get (WINDOW *, attr_t *, Cshort *, void *);	/* generated */
# NCURSES_EXPORT(int) wattr_on (WINDOW *, attr_t, void *);		/* implemented */
# NCURSES_EXPORT(int) wattr_off (WINDOW *, attr_t, void *);	/* implemented */
# NCURSES_EXPORT(int) wattr_set (WINDOW *, attr_t, Cshort, void *);	/* generated */

wbkgd(w::WINDOW, ch::Int) = ccall((:wbkgd, libnc), Cint, (WINDOW, Cuint), w, ch)


# NCURSES_EXPORT(void) wbkgdset (WINDOW *,chtype);			/* implemented */
# NCURSES_EXPORT(int) wborder (WINDOW *,chtype,chtype,chtype,chtype,chtype,chtype,chtype,chtype);	/* implemented */
# NCURSES_EXPORT(int) wchgat (WINDOW *, int, attr_t, Cshort, const void *);/* implemented */
# NCURSES_EXPORT(int) wclear (WINDOW *);				/* implemented */
# NCURSES_EXPORT(int) wclrtobot (WINDOW *);			/* implemented */
# NCURSES_EXPORT(int) wclrtoeol (WINDOW *);			/* implemented */
# NCURSES_EXPORT(int) wcolor_set (WINDOW*,Cshort,void*);		/* implemented */
# NCURSES_EXPORT(void) wcursyncup (WINDOW *);			/* implemented */
# NCURSES_EXPORT(int) wdelch (WINDOW *);				/* implemented */
# NCURSES_EXPORT(int) wdeleteln (WINDOW *);			/* generated */
# NCURSES_EXPORT(int) wechochar (WINDOW *, const chtype);		/* implemented */

werase(w::WINDOW) = ccall((:werase, libnc), Cint, (WINDOW,), w)
wgetch(w::WINDOW) = ccall((:wgetch, libnc), Cint, (WINDOW,), w)


# NCURSES_EXPORT(int) wgetnstr (WINDOW *,char *,int);		/* implemented */
# NCURSES_EXPORT(int) wgetstr (WINDOW *, char *);			/* generated */
# NCURSES_EXPORT(int) whline (WINDOW *, chtype, int);		/* implemented */
# NCURSES_EXPORT(chtype) winch (WINDOW *);				/* implemented */
# NCURSES_EXPORT(int) winchnstr (WINDOW *, chtype *, int);		/* implemented */
# NCURSES_EXPORT(int) winchstr (WINDOW *, chtype *);		/* generated */
# NCURSES_EXPORT(int) winnstr (WINDOW *, char *, int);		/* implemented */
# NCURSES_EXPORT(int) winsch (WINDOW *, chtype);			/* implemented */
# NCURSES_EXPORT(int) winsdelln (WINDOW *,int);			/* implemented */
# NCURSES_EXPORT(int) winsertln (WINDOW *);			/* generated */
# NCURSES_EXPORT(int) winsnstr (WINDOW *, const char *,int);	/* implemented */
# NCURSES_EXPORT(int) winsstr (WINDOW *, const char *);		/* generated */
# NCURSES_EXPORT(int) winstr (WINDOW *, char *);			/* generated */

wmove(w::WINDOW, y::Int, x::Int) = ccall((:wmove, libnc), Cint, (WINDOW, Cint, Cint), w, y, x)


# NCURSES_EXPORT(int) wnoutrefresh (WINDOW *);			/* implemented */
# NCURSES_EXPORT(int) wprintw (WINDOW *, const char *,...)		/* implemented */
		# GCC_PRINTFLIKE(2,3);
# NCURSES_EXPORT(int) wredrawln (WINDOW *,int,int);		/* implemented */

wrefresh(w::WINDOW) = ccall((:wrefresh, libnc), Cint, (WINDOW,), w)

# NCURSES_EXPORT(int) wscanw (WINDOW *, NCURSES_CONST char *,...)	/* implemented */
		# GCC_SCANFLIKE(2,3);
# NCURSES_EXPORT(int) wscrl (WINDOW *,int);			/* implemented */
# NCURSES_EXPORT(int) wsetscrreg (WINDOW *,int,int);		/* implemented */
# NCURSES_EXPORT(int) wstandout (WINDOW *);			/* generated */
# NCURSES_EXPORT(int) wstandend (WINDOW *);			/* generated */
# NCURSES_EXPORT(void) wsyncdown (WINDOW *);			/* implemented */
# NCURSES_EXPORT(void) wsyncup (WINDOW *);				/* implemented */
# NCURSES_EXPORT(void) wtimeout (WINDOW *,int);			/* implemented */
# NCURSES_EXPORT(int) wtouchln (WINDOW *,int,int,int);		/* implemented */
# NCURSES_EXPORT(int) wvline (WINDOW *,chtype,int);		/* implemented */

getattrs(w::WINDOW) = ccall((:getattrs, libnc), Cint, (WINDOW,), w)
getcurx(w::WINDOW) = ccall((:getcurx, libnc), Cint, (WINDOW,), w)
getcury(w::WINDOW) = ccall((:getcury, libnc), Cint, (WINDOW,), w)
getbegx(w::WINDOW) = ccall((:getbegx, libnc), Cint, (WINDOW,), w)
getbegy(w::WINDOW) = ccall((:getbegy, libnc), Cint, (WINDOW,), w)
getmaxx(w::WINDOW) = ccall((:getmaxx, libnc), Cint, (WINDOW,), w)
getmaxy(w::WINDOW) = ccall((:getmaxy, libnc), Cint, (WINDOW,), w)

# NCURSES_EXPORT(int) getparx (const WINDOW *);			/* generated */
# NCURSES_EXPORT(int) getpary (const WINDOW *);			/* generated */




# These functions are extensions - not in X/Open Curses.

#undef  NCURSES_EXT_FUNCS
#define NCURSES_EXT_FUNCS 20081102
# NCURSES_EXPORT(bool) is_term_resized (int, int);
# NCURSES_EXPORT(char *) keybound (int, int);
# NCURSES_EXPORT(const char *) curses_version (void);
# NCURSES_EXPORT(int) assume_default_colors (int, int);
# NCURSES_EXPORT(int) define_key (const char *, int);
# NCURSES_EXPORT(int) key_defined (const char *);
# NCURSES_EXPORT(int) keyok (int, bool);
# NCURSES_EXPORT(int) resize_term (int, int);
# NCURSES_EXPORT(int) resizeterm (int, int);
# NCURSES_EXPORT(int) set_escdelay (int);
# NCURSES_EXPORT(int) set_tabsize (int);

use_default_colors() = ccall((:use_default_colors, libnc), Cint, ())


# NCURSES_EXPORT(int) use_extended_names (bool);
# NCURSES_EXPORT(int) use_legacy_coding (int);
# NCURSES_EXPORT(int) use_screen (SCREEN *, NCURSES_SCREEN_CB, void *);
# NCURSES_EXPORT(int) use_window (WINDOW *, NCURSES_WINDOW_CB, void *);
# NCURSES_EXPORT(int) wresize (WINDOW *, int, int);
# NCURSES_EXPORT(void) nofilter(void);

# These extensions provide access to information stored in the WINDOW even
# when NCURSES_OPAQUE is set:

# NCURSES_EXPORT(WINDOW *) wgetparent (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_cleared (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_idcok (const WINDOW *);		/* generated */
# NCURSES_EXPORT(bool) is_idlok (const WINDOW *);		/* generated */
# NCURSES_EXPORT(bool) is_immedok (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_keypad (const WINDOW *);		/* generated */
# NCURSES_EXPORT(bool) is_leaveok (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_nodelay (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_notimeout (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_scrollok (const WINDOW *);	/* generated */
# NCURSES_EXPORT(bool) is_syncok (const WINDOW *);		/* generated */
# NCURSES_EXPORT(int) wgetscrreg (const WINDOW *, int *, int *); /* generated */


end
