10 REM sprite maker
20 GOSUB &instructions
30 GOSUB &setupscreen
40 GOSUB &sprarray
50 GOSUB &usercursor
60 GOSUB &erase
70 GOTO 50
80 &usercursor
90 REM user cursor
100 GPRINT 195,185,"block ";c;"    ";
110 RECT x,y,x+4,y+5,sprarray(c),sprarray(c)
120 a=PAD(0)
130 a$=INKEY$ 
140 IF a AND 8 THEN 
150   IF y>1 THEN y=y-6:c=c-32:cy=cy-1 
160 ENDIF 
170 IF a AND 2 THEN 
180   IF y<186 THEN y=y+6:c=c+32:cy=cy+1 
190 ENDIF 
200 IF a AND 1 THEN 
210   IF x>1 THEN x=x-6:c=c-1:cx=cx-1 
220 ENDIF 
230 IF a AND 4 THEN 
240   IF x<186 THEN x=x+6:c=c+1:cx=cx+1 
250 ENDIF 
260 IF a AND 256 THEN GOSUB &plotpixel
270 IF a AND 512 THEN GOSUB &erasepixel
280 IF a AND 1024 THEN GOSUB &save
290 IF a AND 2048 THEN GOSUB &load
300 IF a$="i" THEN GOSUB &instructions
310 IF a$="q" THEN SCREEN 1:LIST:END
320 IF a$="d" THEN GOSUB &datastatements
330 IF a$="p" THEN 
340   GOSUB &setupscreen
350   GOSUB &sprarray
360 ENDIF 
370 IF a$="3" THEN 
380   IF ccy>140 THEN ccy=140 
390   ccy=ccy+10:ccx=215
400   IF ccy>0 THEN RECT ccx,ccy-10,ccx+11,ccy+11,0,-1 
410   GOSUB &choosecolor
420 ENDIF 
430 ENDIF 
440 IF a$="9" THEN 
450   IF ccy<1 THEN ccy=10 
460   RECT ccx,ccy,ccx+11,ccy+11,0,-1
470   ccy=ccy-10:ccx=215
480   GOSUB &choosecolor
490 ENDIF 
500 IF a$="6" THEN colr=POINT(ccx+5,ccy+5)
510 REM base color palette selector
520 IF a$="1" THEN 
530   IF ccya>140 THEN ccya=140 
540   ccya=ccya+10:ccxa=195
550   IF ccya>0 THEN RECT ccxa,ccya-10,ccxa+11,ccya+11,0,-1 
560   GOSUB &choosebasecolor
570 ENDIF 
580 ENDIF 
590 IF a$="7" THEN 
600   IF ccya<1 THEN ccya=10 
610   RECT ccxa,ccya,ccxa+11,ccya+11,0,-1
620   ccya=ccya-10:ccxa=195
630   GOSUB &choosebasecolor
640 ENDIF 
650 IF a$="4" THEN colr=POINT(ccxa+3,ccya+3)
660 RETURN 
670 &erase:
680 WAIT 25
690 PSET cx,cy,165
700 RECT x,y,x+4,y+5,165,165
710 WAIT 25
720 PSET cx,cy,sprarray(c)
730 RECT x,y,x+4,y+5,sprarray(c),sprarray(c)
740 RETURN 
750 &plotpixel
760 PSET cx,cy,colr
770 sprarray(c)=colr
780 RECT x,y,x+4,y+5,colr,colr
790 RETURN 
800 &erasepixel
810 PSET cx,cy,0
820 sprarray(c)=0
830 RECT x,y,x+4,y+5,0,0
840 RETURN 
850 &save
860 WINDOW 29,11,11,5
870 INPUT "X1?";sxa
880 INPUT "Y1?";sya
882 INPUT "Width?";sxb
884 INPUT "Height?";syb
890 REM RECT 240+sxa,sya,(242+sxa)+sxb,(sya+syb)+2,255,-1
892 RECT 239+sxa,sya-1,(241+sxa)+sxb,(sya+syb)+1,255,-1
895 RECT sxa*4,sya*4,((sxa+sxb)*5)+1,((sya+sxb)*5)+1,168,-1:REM grid box
900 INPUT "Good? y/n";yy$
902 IF yy$="n" THEN 
905   CLS:WINDOW OFF 
907   RECT 239+sxa,sya-1,(241+sxa)+sxb,(sya+syb)+1,0,-1
908   RETURN 
909 ENDIF 
910 INPUT "SName?";nf$
920 REM SAVE PCX nf$+".pcx"POS 241,1 SIZE 32,32
922 SAVE PCX nf$+".pcx"POS 240+sxa,sya SIZE sxb,syb
930 BORDER 75,75:WAIT 250:BORDER 1,75
940 PRINT "saved":WAIT 500:CLS:WINDOW OFF 
950 RETURN 
960 &load
970 GOSUB &setupscreen
980 WINDOW 29,11,11,5
981 INPUT "X1?";sxa
983 INPUT "Y1?";sya
990 INPUT "LName?";nf$
1000 REM LOAD PCX nf$+".pcx" AS SPRITE 0 TO 241,1:REM SIZE 32,32
1005 LOAD PCX nf$+".pcx" AS SPRITE 0 TO 240+sxa,sya:REM SIZE 32,32
1010 BORDER 75,75:WAIT 100:BORDER 1,75
1020 PRINT "loaded":WAIT 150:CLS:WINDOW OFF 
1030 x=1:y=1:c=1
1040 FOR arty=1 TO 32
1050   FOR artx=241 TO 272
1060     colr=POINT(artx,arty)
1070     RECT x,y,x+4,y+5,colr,colr
1080     x=x+6
1090     sprarray(c)=colr
1100     c=c+1
1110   NEXT artx
1120   x=1:y=y+6
1130 NEXT arty
1140 c=1:x=1:y=1:cx=241:cy=1:colr=165
1150 RETURN 
1160 &datastatements
1170 WINDOW 29,11,11,5
1180 INPUT "DSName?";nf$
1190 spraxx=0
1200 OPEN nf$+".spr" FOR OUTPUT AS 0
1210 FOR spray=1 TO 64
1220   PRINT #0,spray+5000;" DATA ";
1230   FOR sprax=1 TO 16
1240     spraxx=spraxx+1
1250     IF sprax<=15 THEN PRINT #0,sprarray(spraxx);",";
1260     IF sprax=16 THEN PRINT #0,sprarray(spraxx)
1270   NEXT sprax
1280 NEXT spray
1290 CLOSE 0
1300 BORDER 75,75:WAIT 250:BORDER 1,75
1310 PRINT "saved":WAIT 500:CLS:WINDOW OFF 
1320 RETURN 
1330 &palette
1340 rootpaly=0:rootpalyy=10
1350 FOR pc=0 TO 15
1360   READ rootc
1370   RECT 195,rootpaly,205,rootpalyy,rootc,rootc
1380   rootpaly=rootpaly+10:rootpalyy=rootpalyy+10
1390   DATA 0,16,32,48,64,80,96,112,128,144,160,176,192,208,224,240
1400 NEXT pc
1410 paly=0:palyy=10
1420 FOR pc=0 TO 15
1430   RECT 215,paly,225,palyy,cc,cc
1440   paly=paly+10:palyy=palyy+10
1450   cc=cc+1
1460 NEXT pc
1470 RESTORE 1390
1480 RETURN 
1490 &choosecolor
1500 cc=POINT(ccx+5,ccy+5)
1510 REM GPRINT 0,150,cc
1520 RECT ccx,ccy,ccx+11,ccy+11,153,-1
1530 RECT ccx+1,ccy+1,ccx+8,ccy+8,cc,cc11690 RETURN 
1540 &choosebasecolor
1550 cc=POINT(ccxa+5,ccya+5)
1560 REM GPRINT 0,150,cc
1570 RECT ccxa,ccya,ccxa+11,ccya+11,153,-1
1580 RECT ccxa+1,ccya+1,ccxa+8,ccya+8,cc,cc
1590 LINE 215,160,225,160,0
1600 GOSUB 1410
1610 ccy=0:GOSUB &choosecolor
1620 RETURN 
1630 &setupscreen
1640 SCREEN 4:FONT 2:BORDER 1,75:PALETTE 1
1650 REM vertical
1660 FOR x=0 TO 192 STEP 6
1670   LINE x,1,x,192,76
1680 NEXT x
1690 REM horizonal
1700 FOR y=0 TO 192 STEP 6
1710   LINE 0,y,192,y,76
1720 NEXT y
1730 REM sprite bounding box
1740 RECT 240,0,274,34,3,-1
1750 GOSUB &palette
1760 c=1:x=1:y=1:cx=241:cy=1
1770 ccx=215:ccy=0:ccxa=195:ccya=0:colr=165
1780 GOSUB &choosebasecolor
1790 GOSUB &choosecolor
1800 RETURN 
1810 &sprarray
1820 DIM sprarray(1025)
1830 FOR spray=0 TO 1025
1840   sprarray(spray)=0
1850 NEXT spray
1860 RETURN 
1870 &instructions
1880 SCREEN 2:PALETTE 1:BORDER 75,75
1890 PRINT "Sprite drawing prg Ver. 1.0  09/14/2019"
1900 PRINT "For the BASIC Engine"
1910 PRINT "Firmware rev. 0.88-alpha-386"
1920 PRINT "Kevin Anderson/projektprodukt@yahoo.com"
1930 WINDOW 0,5,50,19
1940 PRINT "Controls:"
1950 PRINT "  Arrow keys/PSX"
1960 PRINT "  z=plot pixel"
1970 PRINT "  x=del pixel"
1980 PRINT "  s=save"
1990 PRINT "  a=load"
2000 PRINT "  p=erase and start over"
2010 PRINT "  d=save sprite as data statements"
2020 PRINT ""
2030 PRINT "Palette picker(turn on NumLock):"
2040 PRINT "Base Color controls:    Sub Color Controls:"
2050 PRINT "7=Up                    9=up"
2060 PRINT "1=Down                  3=down"
2070 PRINT "4=Choose color          6=Choose Color"
2080 PRINT ""
2090 INPUT "press <Enter> to go into program";z$
2100 RETURN 
