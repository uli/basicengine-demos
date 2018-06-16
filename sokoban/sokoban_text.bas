' Sokoban, for FreeBASIC QB mode/Qbasic/QB64
' web: http://rudih.info
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
    x = INSTR(sc$(g), "X") + 1
    IF x > 0 THEN
        y = g
        g=22 'GOTO &main
    ENDIF
NEXT g


' main loop
&main:
found = 0
FOR g = 1 TO 22
    f = INSTR(sc$(g), "*")
    IF f >= 0 THEN found = found + 1
NEXT g
IF found = 0 AND star = 0 THEN
    CLS
    PRINT "level complete..."
    WHILE INKEY$="":WEND 'SLEEP
    IF level = 0 THEN GOTO &menu
    level = level + 1
    IF level > 5 THEN GOTO &menu
    GOTO &lev
ENDIF
CLS
FOR g = 1 TO 22
    PRINT sc$(g)
NEXT g
PRINT "level:"; level
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
