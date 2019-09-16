' Sokoban, for FreeBASIC QB mode/Qbasic/QB64
' web: http://rudih.info
SCREEN 5:FONT 2
DIM sc$(22)

' initial statements
&menu:
COLOR $ac, $d9
CLS
LOCATE CSIZE(0)/2-7, 10
PRINT "---SOKOBAN---"
LOCATE CSIZE(0)/2-7, 12
PRINT "Arrow keys move"
LOCATE CSIZE(0)/2-5, 13
PRINT "<Esc> quits"
LOCATE CSIZE(0)/2-4, 14
PRINT "<R> retry"
LOCATE CSIZE(0)/2-13, 16
PRINT "Cover the dots with boxes."
LOCATE CSIZE(0)/2-14, 18
PRINT "<L> load text file as level."

LOAD PCX "sokoban.pcx" AS BG 0
spr_x = RET(0):spr_y = RET(1)+32

FOR g = 1 TO 22
    sc$(g) = ""
NEXT g

x$ = ""
WHILE x$ = ""
    x$ = INKEY$
WEND
IF x$ = CHR$(27) THEN END
IF x$ = "l" OR x$ = "L" THEN
    CLS
    INPUT "file"; filen$
    OPEN filen$ FOR INPUT AS #1
    l = 1
    WHILE NOT EOF(1)
        INPUT #1, sc$(l)
        l = l + 1
    WEND
    CLOSE #1
    level = 0
    GOTO &lev2
ENDIF
level = 1

' load level
&lev:
FOR g = 1 TO 22
    sc$(g) = ""
NEXT g
&lev2:
IF level = 1 THEN
    sc$(1) = ""
    sc$(2) = ""
    sc$(3) = "         88888"
    sc$(4) = "         8   8"
    sc$(5) = "         8O  8"
    sc$(6) = "       888  O88"
    sc$(7) = "       8  O O 8"
    sc$(8) = "     888 8 88 8   888888"
    sc$(9) = "     8   8 88 88888  **8"
    sc$(10) = "     8 O  O          **8"
    sc$(11) = "     88888 888 8X88  **8"
    sc$(12) = "         8     888888888"
    sc$(13) = "         8888888"
ENDIF
IF level = 2 THEN
    sc$(1) = ""
    sc$(2) = ""
    sc$(3) = ""
    sc$(4) = ""
    sc$(5) = "     8888888888888"
    sc$(6) = "     8**  8      8"
    sc$(7) = "     8**  8 O  O 888"
    sc$(8) = "     8**  8O8888   8"
    sc$(9) = "     8**    X 88   8"
    sc$(10) = "     8**  8 8  O  88"
    sc$(11) = "     888888 88O O  8"
    sc$(12) = "       8 O  O O O  8"
    sc$(13) = "       8    8      8"
    sc$(14) = "       8888888888888"
ENDIF
IF level = 3 THEN
    sc$(1) = ""
    sc$(2) = ""
    sc$(3) = "         88888888"
    sc$(4) = "         8     X8"
    sc$(5) = "         8 O8O 88"
    sc$(6) = "         8 O  O8"
    sc$(7) = "  888888 88O O 8"
    sc$(8) = "  8**  8 8 O 8 888"
    sc$(9) = "  8**  888 O  O  8"
    sc$(10) = "  8**        O   8"
    sc$(11) = "  8**  88888888888"
    sc$(12) = "  8**  8"
    sc$(13) = "  888888"
ENDIF
IF level = 4 THEN
    sc$(1) = ""
    sc$(2) = ""
    sc$(3) = ""
    sc$(4) = "    888888"
    sc$(5) = "    8**  8  888"
    sc$(6) = "    8**  8 88X88"
    sc$(7) = "    8**  888   8"
    sc$(8) = "    8**     OO 8"
    sc$(9) = "    8**  8 8 O 8"
    sc$(10) = "    888888 8 O 8"
    sc$(11) = "       8 O 8O  8"
    sc$(12) = "       8  O8 O 8"
    sc$(13) = "       8 O  O  8"
    sc$(14) = "       8  88   8"
    sc$(15) = "       888888888"
ENDIF
IF level = 5 THEN
    sc$(1) = ""
    sc$(2) = ""
    sc$(3) = ""
    sc$(4) = "      8888888888"
    sc$(5) = "      8**  8   8"
    sc$(6) = "      8**      8"
    sc$(7) = "      8**  8  8888"
    sc$(8) = "     8888888  8  88"
    sc$(9) = "     8            8"
    sc$(10) = "     8  8  88  8  8"
    sc$(11) = "   8888 88  8888 88"
    sc$(12) = "   8  O  88888 8  8"
    sc$(13) = "   8 8 O  O  8 O  8"
    sc$(14) = "   8 XO  O   8   88"
    sc$(15) = "   8888 88 8888888"
    sc$(16) = "      8    8"
    sc$(17) = "      888888"
ENDIF

FOR g = 1 TO 22
    s$=sc$(g)
    FOR gg = 0 TO LEN(s$)
      IF s$[gg]=ASC(" ") THEN
        s$[gg]=ASC(".")
      ELSE
        gg=LEN(s$)
      ENDIF
    NEXT
    sc$(g)=s$
NEXT

FOR g = 1 TO 22
    x = INSTR(sc$(g), "X") + 1
    IF x > 0 THEN
        y = g
        g=22 'GOTO &main
    ENDIF
NEXT g


BG 0 TILES 40,22 SIZE 16,16 WINDOW 0,0,PSIZE(0),PSIZE(1) ON
' empty field
FOR i=0 TO 39:FOR j=0 TO 21:PLOT 0,i,j,3:NEXT:NEXT

tmap_from$ = "8* OX."
DIM tmap_to(6) = [0,2,1,4,1,3]
FOR i=0 TO LEN(tmap_from$)
  PLOT 0 MAP tmap_from$[i] TO tmap_to(i)
NEXT

SPRITE 0 PATTERN spr_x,spr_y SIZE 16,16 FRAME 0,0 KEY 217
SPRITE 0 ON
SPRITE 1 PATTERN spr_x,spr_y-32 SIZE 16,16 FRAME 4,0
MOVE SPRITE 1 TO PSIZE(0),0
SPRITE 1 ON
re_draw_from=1
re_draw_to=22

' main loop
&main:
found = 0
FOR g = 1 TO 22
    f = INSTR(sc$(g), "*")
    IF f >= 0 THEN found = found + 1
NEXT g
IF found = 0 AND star = 0 THEN
    BG 0 OFF
    WINDOW CSIZE(0)/2-10,CSIZE(1)/2-3,20,1
    PRINT "\fac\bd9  LEVEL COMPLETE!  "
    WINDOW OFF
    WHILE INKEY$<>"" OR PAD(0):WEND
    WHILE INKEY$="" AND PAD(0)=0:WEND 'SLEEP
    IF level = 0 THEN GOTO &menu
    level = level + 1
    IF level > 5 THEN GOTO &menu
    GOTO &lev
ENDIF

s_x=(x-1)*16
s_y=y*16
CALL movplayer(s_x, s_y)

IF re_draw_from < 1 THEN re_draw_from=1
IF re_draw_to > 22 THEN re_draw_to=22
FOR g = re_draw_from TO re_draw_to
    PLOT0,0,g,sc$(g)
    gg=LEN(sc$(g))
    WHILE gg<40
        PLOT 0,gg,g,3
        gg=gg+1
    WEND
    'PRINT sc$(g)
NEXT g

'hide box
MOVE SPRITE 1 TO PSIZE(0),0

'PRINT "level:"; level
user$ = ""
WHILE user$ = "" AND PAD(0)=0
    user$ = INKEY$
WEND
IF MID$(sc$(y), x, 3) = "OO8" OR MID$(sc$(y), x - 4, 3) = "8OO" THEN star = 0
IF MID$(sc$(y), x, 3) = "O*8" OR MID$(sc$(y), x - 4, 3) = "8*O" THEN star = 0
IF user$ = CHR$(27) GOTO &menu
IF user$ = "r" OR user$ = "R" GOTO &lev
' up
IF PAD(0)=UP THEN
    'collision detection
    dest$ = MID$(sc$(y - 1), x - 1, 1)
    IF MID$(sc$(y + 2), x - 1, 1) = "O" THEN star = 0
    IF dest$ = "8" GOTO &main
    IF dest$ = "O" THEN
        CALL animpush(UP)
        IF MID$(sc$(y - 2), x - 1, 1) = " " OR MID$(sc$(y - 2), x - 1, 1) = "*" THEN
            le$ = LEFT$(sc$(y), x - 1)
            IF star = 2 THEN
                mi$ = "*"
                star = 0
            'ENDIF
            ELSE IF star = 1 THEN
                mi$ = "*"
                star = 2
            ELSE
                mi$ = " "
            ENDIF
            IF MID$(sc$(y - 2), x - 1, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x, 22)
            sc$(y) = le$ + mi$ + ri$

            PLOT 0,x-1,y,mi$
            PLOT 0,x-1,y-1," "
            CALL xanimpush(UP)

            le$ = LEFT$(sc$(y - 1), x - 1)
            mi$ = "X"
            ri$ = MID$(sc$(y - 1), x)
            sc$(y - 1) = le$ + mi$ + ri$
            le$ = LEFT$(sc$(y - 2), x - 1)
            mi$ = "O"
            ri$ = MID$(sc$(y - 2), x, 22)
            sc$(y - 2) = le$ + mi$ + ri$
        ELSE
            GOTO &main
        ENDIF
    ENDIF
    IF dest$ = " " OR dest$ = "*" THEN
        le$ = LEFT$(sc$(y), x - 1)
        IF star = 1 THEN
            mi$ = "*"
            star = 0
        ELSE
            mi$ = " "
        ENDIF
        PLOT 0,x-1,y,mi$
        CALL animwalk(UP)
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x, 22)
        sc$(y) = le$ + mi$ + ri$
        le$ = LEFT$(sc$(y - 1), x - 1)
        mi$ = "X"
        ri$ = MID$(sc$(y - 1), x)
        sc$(y - 1) = le$ + mi$ + ri$
    ENDIF
    y = y - 1
' down
ELSE IF PAD(0)=DOWN THEN
    'collision detection
    dest$ = MID$(sc$(y + 1), x - 1, 1)
    IF MID$(sc$(y - 2), x - 1, 1) = "O" THEN star = 0
    IF dest$ = "8" GOTO &main
    IF dest$ = "O" THEN
        CALL animpush(DOWN)
        IF MID$(sc$(y + 2), x - 1, 1) = " " OR MID$(sc$(y + 2), x - 1, 1) = "*" THEN
            le$ = LEFT$(sc$(y), x - 1)
            IF star = 2 THEN
                mi$ = "*"
                star = 0
            'ENDIF
            ELSE IF star = 1 THEN
                mi$ = "*"
                star = 2
            ELSE
                mi$ = " "
            ENDIF
            IF MID$(sc$(y + 2), x - 1, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x, 22)
            sc$(y) = le$ + mi$ + ri$

            PLOT 0,x-1,y,mi$
            PLOT 0,x-1,y+1," "
            CALL xanimpush(DOWN)

            le$ = LEFT$(sc$(y + 1), x - 1)
            mi$ = "X"
            ri$ = MID$(sc$(y + 1), x)
            sc$(y + 1) = le$ + mi$ + ri$
            le$ = LEFT$(sc$(y + 2), x - 1)
            mi$ = "O"
            ri$ = MID$(sc$(y + 2), x, 22)
            sc$(y + 2) = le$ + mi$ + ri$
        ELSE
            GOTO &main
        ENDIF
    ENDIF
    IF dest$ = " " OR dest$ = "*" THEN
        le$ = LEFT$(sc$(y), x - 1)
        IF star = 1 THEN
            mi$ = "*"
            star = 0
        ELSE
            mi$ = " "
        ENDIF
        PLOT 0,x-1,y,mi$
        CALL animwalk(DOWN)
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x, 22)
        sc$(y) = le$ + mi$ + ri$
        le$ = LEFT$(sc$(y + 1), x - 1)
        mi$ = "X"
        ri$ = MID$(sc$(y + 1), x)
        sc$(y + 1) = le$ + mi$ + ri$
    ENDIF
    y = y + 1
' left
ELSE IF PAD(0)=LEFT THEN
    'collision detection
    dest$ = MID$(sc$(y), x - 2, 1)
    IF MID$(sc$(y), x + 1, 1) = "O" THEN star = 0
    IF dest$ = "8" GOTO &main
    IF dest$ = "O" THEN
        CALL animpush(LEFT)
        IF MID$(sc$(y), x - 3, 1) = " " OR MID$(sc$(y), x - 3, 1) = "*" THEN
            le$ = LEFT$(sc$(y), x - 3)
            IF star = 2 THEN
                mi$ = "OX*"
                star = 0
            ELSE
                mi$ = "OX "
            ENDIF
            IF star = 1 THEN
                mi$ = "OX "
                star = 2
            ELSE
                mi$ = "OX "
            ENDIF

            PLOT 0,x-2,y,RIGHT$(mi$,1)
            CALL xanimpush(LEFT)

            IF MID$(sc$(y), x - 3, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x, 22)
            sc$(y) = le$ + mi$ + ri$
        ELSE
            GOTO &main
        ENDIF
    ENDIF
    IF dest$ = " " OR dest$ = "*" THEN
        le$ = LEFT$(sc$(y), x - 2)
        IF star = 1 THEN
            mi$ = "X*"
            star = 0
        ELSE
            mi$ = "X "
            star = 0
        ENDIF
        PLOT 0,x-1,y,RIGHT$(mi$,1)
        CALL animwalk(LEFT)
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x, 22)
        sc$(y) = le$ + mi$ + ri$
    ENDIF
    x = x - 1
' right
ELSE IF PAD(0)=RIGHT THEN
    'collision detection
    dest$ = MID$(sc$(y), x, 1)
    IF MID$(sc$(y), x - 3, 1) = "O" THEN star = 0
    IF dest$ = "8" GOTO &main
    IF dest$ = "O" THEN
        CALL animpush(RIGHT)
        IF MID$(sc$(y), x + 1, 1) = " " OR MID$(sc$(y), x + 1, 1) = "*" THEN
            le$ = LEFT$(sc$(y), x - 1)
            IF star = 2 THEN
                mi$ = "*XO"
                star = 0
            ELSE
                mi$ = " XO"
            ENDIF
            IF star = 1 THEN
                mi$ = " XO"
                star = 2
            ELSE
                mi$ = " XO"
            ENDIF

            PLOT 0,x,y,LEFT$(mi$,1)
            CALL xanimpush(RIGHT)

            IF MID$(sc$(y), x + 1, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x + 2, 22)
            sc$(y) = le$ + mi$ + ri$
        ELSE
            GOTO &main
        ENDIF
    ENDIF
    IF dest$ = " " OR dest$ = "*" THEN
        le$ = LEFT$(sc$(y), x - 1)
        IF star = 1 THEN
            mi$ = "*X"
            star = 0
        ELSE
            mi$ = " X"
            star = 0
        ENDIF
        PLOT 0,x-1,y,LEFT$(mi$,1)
        CALL animwalk(RIGHT)
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x + 1, 22)
        sc$(y) = le$ + mi$ + ri$
    ENDIF
    x = x + 1
ENDIF

GOTO &main

PROC movplayer(s_x, s_y)
    @b_x=@s_x-PSIZE(0)/2
    @b_y=@s_y-PSIZE(1)/2
    MOVE BG 0 TO @b_x,@b_y
    MOVE SPRITE 0 TO @s_x-@b_x,@s_y-@b_y
RETURN

PROC movbox(d_x, d_y)
    MOVE SPRITE 1 TO SPRX(0)+@d_x,SPRY(0)+@d_y
RETURN

PROC animpush(direction)
    IF @direction=UP THEN
        @f=5:@fl=0
    ELSE IF @direction=DOWN THEN
        @f=4:@fl=0
    ELSE IF @direction=LEFT THEN
        @f=6:@fl=0
    ELSE IF @direction=RIGHT THEN
        @f=6:@fl=2
    ENDIF
    SPRITE 0 FRAME @f,0 FLAGS @fl
RETURN

PROC xanimpush(direction)
    @s_x=(x-1)*16
    @s_y=y*16
    IF @direction=UP THEN
        FOR @i = 1 TO 16
            IF @i AND 4 THEN @fl=2 ELSE @fl=0
            SPRITE 0 FRAME 5,0 FLAGS @fl
            CALL movplayer(@s_x, @s_y-@i)
            CALL movbox(0,-16)
            VSYNC
        NEXT
        IF PAD(0)=0 THEN SPRITE 0 FRAME 1,0
    ELSE IF @direction=DOWN THEN
        FOR @i = 1 TO 16
            IF @i AND 4 THEN @fl=2 ELSE @fl=0
            SPRITE 0 FRAME 4,0 FLAGS @fl
            CALL movplayer(@s_x, @s_y+@i)
            CALL movbox(0,16)
            VSYNC
        NEXT
        IF PAD(0)=0 THEN SPRITE 0 FRAME 0,0
    ELSE IF @direction=LEFT THEN
        FOR @i = 0 TO 15
            IF @i AND 4 THEN @f=6 ELSE @f=7
            SPRITE 0 FRAME @f,0 FLAGS 0
            CALL movplayer(@s_x-@i, @s_y)
            CALL movbox(-16,0)
            VSYNC
        NEXT
        IF PAD(0)=0 THEN SPRITE 0 FRAME 2,0 FLAGS 0
    ELSE IF @direction=RIGHT THEN
        FOR @i = 0 TO 15
            IF @i AND 4 THEN @f=6 ELSE @f=7
            SPRITE 0 FRAME @f,0 FLAGS 2
            CALL movplayer(@s_x+@i, @s_y)
            CALL movbox(16,0)
            VSYNC
        NEXT
        IF PAD(0)=0 THEN SPRITE 0 FRAME 2,0 FLAGS 2
    ENDIF
    re_draw_from=y-2:re_draw_to=y+2
RETURN

PROC animwalk(direction)
    @s_x=(x-1)*16
    @s_y=y*16
    IF @direction=UP THEN
        FOR @i = 1 TO 16
            IF @i AND 4 THEN @fl=2 ELSE @fl=0
            SPRITE 0 FRAME 1,0 FLAGS @fl
            CALL movplayer(@s_x, @s_y-@i)
            VSYNC
        NEXT
    ELSE IF @direction=DOWN THEN
        FOR @i = 1 TO 16
            IF @i AND 4 THEN @fl=2 ELSE @fl=0
            SPRITE 0 FRAME 0,0 FLAGS @fl
            CALL movplayer(@s_x, @s_y+@i)
            VSYNC
        NEXT
    ELSE IF @direction=LEFT THEN
        FOR @i = 0 TO 15
            IF @i AND 4 THEN @f=2 ELSE @f=3
            SPRITE 0 FRAME @f,0 FLAGS 0
            CALL movplayer(@s_x-@i, @s_y)
            VSYNC
        NEXT
    ELSE IF @direction=RIGHT THEN
        FOR @i = 0 TO 15
            IF @i AND 4 THEN @f=2 ELSE @f=3
            SPRITE 0 FRAME @f,0 FLAGS 2
            CALL movplayer(@s_x+@i, @s_y)
            VSYNC
        NEXT
    ENDIF
    re_draw_from=y-2:re_draw_to=y+2
RETURN
