' Sokoban, for FreeBASIC QB mode/Qbasic/QB64
' web: http://rudih.info
screen 5
DIM sc$(22)

' initial statements
&menu:
CLS
' XXX COLOR 10, 0
LOCATE 30, 10
PRINT "---SOKOBAN---"
LOCATE 5, 12
PRINT "Arrow keys move - <esc> quits - <R> retry."
LOCATE 5, 13
PRINT "To play, cover the '*' with 'O's."
LOCATE 5, 14
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


BG 0 TILES 40,22 SIZE 16,16 WINDOW 0,0,PSIZE(0),PSIZE(1)-40 ON
' empty field
FOR i=0 TO 39:FOR j=0 TO 21:PLOT 0,i,j,3:NEXT:NEXT

tmap_from$ = "8* OX."
DIM tmap_to(6) = 0,2,1,4,1,3
FOR i=0 TO LEN(tmap_from$)
  PLOT 0 MAP tmap_from$[i] TO tmap_to(i)
NEXT

SPRITE 0 PATTERN spr_x,spr_y SIZE 16,16 FRAME 0,0 KEY 217
SPRITE 0 ON

' main loop
&main:
found = 0
FOR g = 1 TO 22
    f = INSTR(sc$(g), "*")
    IF f >= 0 THEN found = found + 1
NEXT g
IF found = 0 AND star = 0 THEN
    BG 0 OFF
    CLS
    PRINT "level complete..."
    WHILE INKEY$="":WEND 'SLEEP
    IF level = 0 THEN GOTO &menu
    level = level + 1
    IF level > 5 THEN GOTO &menu
    GOTO &lev
ENDIF
'CLS
s_x=(x-1)*16
s_y=y*16
b_x=s_x-PSIZE(0)/2
b_y=s_y-PSIZE(1)/2
MOVE BG 0 TO b_x,b_y
MOVE SPRITE 0 TO s_x-b_x,s_y-b_y

FOR g = 1 TO 22
    PLOT0,0,g,sc$(g)
    gg=LEN(sc$(g))
    WHILE gg<40
        PLOT 0,gg,g,3
        gg=gg+1
    WEND
    'PRINT sc$(g)
NEXT g

'PRINT "level:"; level
user$ = ""
WHILE user$ = ""
    user$ = INKEY$
WEND
IF MID$(sc$(y), x, 3) = "OO8" OR MID$(sc$(y), x - 4, 3) = "8OO" THEN star = 0
IF MID$(sc$(y), x, 3) = "O*8" OR MID$(sc$(y), x - 4, 3) = "8*O" THEN star = 0
IF user$ = CHR$(27) GOTO &menu
IF user$ = "r" OR user$ = "R" GOTO &lev
' up
IF user$ = CHR$(1) + CHR$($81) THEN
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
            ENDIF
            IF star = 1 THEN
                mi$ = "*"
                star = 2
            ELSE
                mi$ = " "
            ENDIF
            IF MID$(sc$(y - 2), x - 1, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x, 22)
            sc$(y) = le$ + mi$ + ri$
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
        CALL animwalk(UP)
        le$ = LEFT$(sc$(y), x - 1)
        IF star = 1 THEN
            mi$ = "*"
            star = 0
        ELSE
            mi$ = " "
        ENDIF
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x, 22)
        sc$(y) = le$ + mi$ + ri$
        le$ = LEFT$(sc$(y - 1), x - 1)
        mi$ = "X"
        ri$ = MID$(sc$(y - 1), x)
        sc$(y - 1) = le$ + mi$ + ri$
    ENDIF
    y = y - 1
ENDIF
' down
IF user$ = CHR$(1) + CHR$($80) THEN
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
            ENDIF
            IF star = 1 THEN
                mi$ = "*"
                star = 2
            ELSE
                mi$ = " "
            ENDIF
            IF MID$(sc$(y + 2), x - 1, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x, 22)
            sc$(y) = le$ + mi$ + ri$
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
        CALL animwalk(DOWN)
        le$ = LEFT$(sc$(y), x - 1)
        IF star = 1 THEN
            mi$ = "*"
            star = 0
        ELSE
            mi$ = " "
        ENDIF
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x, 22)
        sc$(y) = le$ + mi$ + ri$
        le$ = LEFT$(sc$(y + 1), x - 1)
        mi$ = "X"
        ri$ = MID$(sc$(y + 1), x)
        sc$(y + 1) = le$ + mi$ + ri$
    ENDIF
    y = y + 1
ENDIF
' left
IF user$ = CHR$(1) + CHR$($82) THEN
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
            IF MID$(sc$(y), x - 3, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x, 22)
            sc$(y) = le$ + mi$ + ri$
        ELSE
            GOTO &main
        ENDIF
    ENDIF
    IF dest$ = " " OR dest$ = "*" THEN
        CALL animwalk(LEFT)
        le$ = LEFT$(sc$(y), x - 2)
        IF star = 1 THEN
            mi$ = "X*"
            star = 0
        ELSE
            mi$ = "X "
            star = 0
        ENDIF
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x, 22)
        sc$(y) = le$ + mi$ + ri$
    ENDIF
    x = x - 1
ENDIF
' right
IF user$ = CHR$(1) + CHR$($83) THEN
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
            IF MID$(sc$(y), x + 1, 1) = "*" THEN star = 1 ELSE star = 0
            ri$ = MID$(sc$(y), x + 2, 22)
            sc$(y) = le$ + mi$ + ri$
        ELSE
            GOTO &main
        ENDIF
    ENDIF
    IF dest$ = " " OR dest$ = "*" THEN
        CALL animwalk(RIGHT)
        le$ = LEFT$(sc$(y), x - 1)
        IF star = 1 THEN
            mi$ = "*X"
            star = 0
        ELSE
            mi$ = " X"
            star = 0
        ENDIF
        IF dest$ = "*" THEN star = 1 ELSE star = 0
        ri$ = MID$(sc$(y), x + 1, 22)
        sc$(y) = le$ + mi$ + ri$
    ENDIF
    x = x + 1
ENDIF

GOTO &main

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

PROC animwalk(direction)
    IF @direction=UP THEN
        @f=1:@fl=0
    ELSE IF @direction=DOWN THEN
        @f=0:@fl=0
    ELSE IF @direction=LEFT THEN
        @f=2:@fl=0
    ELSE IF @direction=RIGHT THEN
        @f=2:@fl=2
    ENDIF
    SPRITE 0 FRAME @f,0 FLAGS @fl
RETURN
