5 SCREEN 4:PALETTE 1:FONT 2:BORDER 6,60
10 white=RGB(255,255,255):black=RGB(0,0,0):lblue=RGB(32,0,192):gray=RGB(128,128,128)
12 DIM tcolor(7)=[0,88,82,168,175,150,114,34]
15 gover=0:RESTORE
20 COLOR white,black:CLS:PRINT " BASIC TETRIS ┌──────────┐     ┌───────┐";
30 PRINT "     2014     │          ├─────┤ \f46SCORE\f0f │";
40 PRINT " DAVID MURRAY │          │     │       │";
50 PRINT "              │          │     └───────┘";
60 PRINT "              │          │"
70 PRINT "              │          │  ┌────┐"
80 PRINT "              │          ├──┤\f46NEXT\f0f│"
90 PRINT "              │          │  │    │"
100 PRINT "     ┌─────┐  │          │  │    │"
110 PRINT "     │\f46LEVEL\f0f├──┤          │  │    │"
120 PRINT "     │     │  │          │  │    │"
130 PRINT "     └─────┘  │          │  └────┘"
140 PRINT " \f08▂\f0f            │          │"
150 PRINT " \f08\RZ\N ROTATE\f0f     │          │"
160 PRINT " \f08▂\f0f            │          │"
170 PRINT " \f08\R,\N LEFT\f0f       │          │"
180 PRINT " \f08▂\f0f            │          │"
190 PRINT " \f08\R.\N DROP\f0f       │          │"
200 PRINT " \f08▂\f0f            │          │"
210 PRINT " \f08\R/\N RIGHT\f0f      │          │"
220 PRINT "              │          │"
230 PRINT "              └──────────┘"
240 PRINT "                          "
250 PRINT "                          ":LOCATE 0,0
255 CALL initcols
260 GOTO 500
270 PROC setfield(of,v)
272 cols((@of+1) MOD 40,@of/40)=@v
274 COLOR @v,0
275 CHAR @of MOD 40+15,@of/40+1,61450
276 RETURN
280 PROC getfield(of):RETURN cols((@of+1) MOD 40,@of/40)
290 PROC set(x,y,of,v)
292 COLOR @v,0
293 CHAR @x+@of MOD 40,@y+@of/40,61450:RETURN
294 PROC rvon:COLOR black,white:RETURN
295 PROC rvoff:COLOR white,black:RETURN
296 PROC rvgon:COLOR black,gray:RETURN
297 PROC rvgoff:COLOR gray,black:RETURN
299 :
300 PROC drawtetrimino
310 CALL setfield(q,c):CALL setfield(w,c):CALL setfield(e,c):CALL setfield(r,c):RETURN
319 :
320 PROC erasetetrimino
330 CALL setfield(q,0):CALL setfield(w,0):CALL setfield(e,0):CALL setfield(r,0):RETURN
339 :
340 PROC definetetrimino
350 q=tetrodat(piece,1):w=tetrodat(piece,2):e=tetrodat(piece,3):r=tetrodat(piece,4):RETURN
395 REM Engine BASIC does not have color
396 REM memory, so we remember the colors
397 REM in an array.
400 PROC initcols
410 DIM cols(11,20)
420 FOR y=0 TO 19:cols(0,y)=255:cols(11,y)=255:FOR x=1 TO 9:cols(x,y)=0:NEXT:NEXT
425 FOR x=0 TO 11:cols(x,20)=255:NEXT
430 RETURN
499 :
500 DIM tetrodat(7,4):DIM tetrorot(7,4,4)
510 score=0:level=0:droptimer=25:piece=0:nxtpiece=0:rot=1:REM score level piece next rotation
520 FOR x=1 TO 7:FOR y=1 TO 4
530     READ tetrodat(x,y):NEXT y:NEXT x
540 DATA 1,41,81,121:REM i piece
550 DATA 2,42,82,81:REM j piece
560 DATA 1,41,81,82:REM l piece
570 DATA 41,42,81,82:REM o piece
580 DATA 41,42,80,81:REM s piece
590 DATA 40,41,42,81:REM t piece
600 DATA 40,41,81,82:REM z piece
700 REM rotational data
701 DATA 39,0,-39,-78:REM i
702 DATA -39,0,39,78:REM i
703 DATA 39,0,-39,-78:REM i
704 DATA -39,0,39,78:REM i
705 DATA 39,0,-39,2:REM j
706 DATA 41,0,-41,-80:REM j
707 DATA -39,0,39,-2:REM j
708 DATA -41,0,41,80:REM j
709 DATA 39,0,-39,-80:REM l
710 DATA 41,0,-41,-2:REM l
711 DATA -39,0,39,80:REM l
712 DATA -41,0,41,2:REM l
713 DATA 0,0,0,0:REM o
714 DATA 0,0,0,0:REM o
715 DATA 0,0,0,0:REM o
716 DATA 0,0,0,0:REM o
717 DATA 0,-41,2,-39:REM s
718 DATA 0,41,-2,39:REM s
719 DATA 0,-41,2,-39:REM s
720 DATA 0,41,-2,39:REM s
721 DATA 41,0,-41,-39:REM t
722 DATA -39,0,39,-41:REM t
723 DATA -41,0,41,39:REM t
724 DATA 39,0,-39,41:REM t
725 DATA 41,0,-39,-80:REM z
726 DATA -41,0,39,80:REM z
727 DATA 41,0,-39,-80:REM z
728 DATA -41,0,39,80:REM z
810 FOR y=1 TO 7:FOR x=1 TO 4:FOR z=1 TO 4
820       READ tetrorot(y,x,z):NEXT z:NEXT x:NEXT y
900 nxtpiece=4:CALL updatelevel:CALL updatescore:CALL newpiece:GOTO 5000
999 :
1000 PROC drawnextpiece
1005 COLOR black
1010 FOR x=7 TO 10:LOCATE 29,x:PRINT "    ";:NEXT
1050 nc=tcolor(nxtpiece)
1060 FOR x=1 TO 4:CALL set(29,7,tetrodat(nxtpiece,x),nc):NEXT x:RETURN
1099 :
1100 PROC updatelevel
1120 LOCATE 6,10:COLOR white:PRINT "     ";:LOCATE 8,10:PRINT level;:RETURN
1129 :
1130 PROC updatescore
1140 LOCATE 32,2:COLOR white:PRINT "       ":LOCATE 32,2:PRINT score
1150 @b=INT(score/5000):IF @b<>level THEN level=@b:CALL updatelevel:droptimer=25-l*2
1160 RETURN
4998 :
4999 REM *** Main Loop
5000 DO
5005   IN$=INKEY$
5010   IF FRAME()-t>=droptimer THEN t=FRAME():CALL lowerpiece
5020   IF IN$="z" THEN CALL rotatepiece
5022   IF IN$="w" THEN CALL rotatepiece
5024   IF IN$="8" THEN CALL rotatepiece
5030   IF IN$="," THEN CALL moveleft
5032   IF IN$="a" THEN CALL moveleft
5034   IF IN$="4" THEN CALL moveleft
5040   IF IN$="/" THEN CALL moveright
5042   IF IN$="d" THEN CALL moveright
5044   IF IN$="6" THEN CALL moveright
5050   IF IN$="." THEN CALL lowerpiece
5052   IF IN$="s" THEN CALL lowerpiece
5054   IF IN$="5" THEN CALL lowerpiece
5100 LOOP UNTIL gover=1
5102 GOTO 15
5109 :
5110 PROC moveright
5120 CALL erasetetrimino
5130 q=q+1:w=w+1:e=e+1:r=r+1
5140 @b=(FN getfield(q)<>0) OR (FN getfield(w)<>0) OR (FN getfield(e)<>0) OR (FN getfield(r)<>0)
5150 IF @b=0 THEN CALL drawtetrimino:RETURN
5170 q=q-1:w=w-1:e=e-1:r=r-1:CALL drawtetrimino:RETURN
5179 :
5180 PROC moveleft
5190 CALL erasetetrimino
5200 q=q-1:w=w-1:e=e-1:r=r-1
5210 @b=(FN getfield(q)<>0) OR (FN getfield(w)<>0) OR (FN getfield(e)<>0) OR (FN getfield(r)<>0)
5220 IF @b=0 THEN CALL drawtetrimino:RETURN
5240 q=q+1:w=w+1:e=e+1:r=r+1:CALL drawtetrimino:RETURN
5249 :
5250 PROC lowerpiece
5260 CALL erasetetrimino
5270 q=q+40:w=w+40:e=e+40:r=r+40
5280 @b=(FN getfield(q)<>0) OR (FN getfield(w)<>0) OR (FN getfield(e)<>0) OR (FN getfield(r)<>0)
5290 IF @b=0 THEN CALL drawtetrimino:RETURN
5310 q=q-40:w=w-40:e=e-40:r=r-40:CALL drawtetrimino:CALL scanthefield:CALL newpiece:RETURN
5499 :
5500 PROC newpiece
5510 piece=nxtpiece:c=tcolor(piece):nxtpiece=INT(RND(1)*7)+1:CALL drawnextpiece:score=score+5:CALL updatescore
5520 CALL definetetrimino:q=q+4:w=w+4:e=e+4:r=r+4:rot=1
5523 @bl=FN blocked
5524 CALL drawtetrimino
5525 IF @bl THEN CALL gameover
5530 RETURN
5599 :
5600 PROC rotatepiece
5610 CALL erasetetrimino
5615 qq=q:ww=w:ee=e:rr=r
5620 q=q+tetrorot(piece,rot,1):w=w+tetrorot(piece,rot,2):e=e+tetrorot(piece,rot,3):r=r+tetrorot(piece,rot,4)
5625 REM printq","w","e","r
5630 @b=(FN getfield(q)<>0) OR (FN getfield(w)<>0) OR (FN getfield(e)<>0) OR (FN getfield(r)<>0)
5640 IF @b=0 THEN
5650   CALL drawtetrimino:rot=rot+1:IF rot=5 THEN rot=1
5660   RETURN
5665 ENDIF
5670 q=qq:w=ww:e=ee:r=rr:CALL drawtetrimino:RETURN
5999 :
6000 PROC scanthefield
6010 zz=0:sf=INT(q/40):CALL detectline
6020 sg=INT(w/40):IF sg<>sf THEN sf=sg:CALL detectline
6030 sg=INT(e/40):IF sg<>sf THEN sf=sg:CALL detectline
6040 sg=INT(r/40):IF sg<>sf THEN sf=sg:CALL detectline
6050 IF zz<>0 THEN
6052   CALL clearlines
6054   score=score+(zz*100)*2
6056   CALL updatescore
6058 ENDIF
6060 RETURN
6099 :
6100 PROC detectline
6110 @ss=sf*40:@z=0
6120 FOR x=@ss TO @ss+9:IF FN getfield(x)<>0 THEN @z=@z+1
6130 NEXT x
6140 IF @z<>10 THEN RETURN
6150 FOR x=@ss TO @ss+9:CALL setfield(x,255):NEXT x:zz=zz+1:RETURN
6199 :
6200 PROC clearlines
6210 FOR y=0 TO 760 STEP 40
6220   IF (FN getfield(y))=255 THEN CALL scrolldown
6230 NEXT y:RETURN
6238 :
6239 PROC scrolldown
6240 FOR x=0 TO 9:FOR yy=y TO 40 STEP -40
6250     CALL setfield(yy+x,FN getfield(yy+x-40)):NEXT yy:NEXT x:RETURN
10000 PROC blocked
10010 RETURN (FN getfield(q)<>0) OR (FN getfield(w)<>0) OR (FN getfield(e)<>0) OR (FN getfield(r)<>0)
12000 PROC gameover
12010 LOCATE 10,10
12020 PRINT "GAME OVER!"
12030 WAIT 2000
12040 gover=1
12050 RETURN
