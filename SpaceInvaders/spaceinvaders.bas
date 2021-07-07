100 'spaceinvaders.bas
110 'requires firmware v.398 and above
120 SCREEN 2:PRINT "Space Invaders":WAIT 200
130 LOAD PCX "sptitlemode2.pcx" TO 0,0
132 GPRINT 0,150,"Coded by:";
133 GPRINT 0,160,"Kevin Anderson";
134 GPRINT 0,170,"projektprodukt@yahoo.com";
135 GPRINT 250,150,"BASIC Engine";
136 GPRINT 250,160,"hobby computer";
137 GPRINT 250,170,"basicengine.org";
138 GPRINT 250,180,"Hardware/OS by:";
139 GPRINT 250,190,"Uli @ github.com/uli/";
140 WAIT 3000:CLS 
150 SCREEN 4:BORDER 75,75:FONT 2:COLOR 91,0
170 DIM bulletsense(2,1)
180 DIM bulletsensealien(2,1)
185 cursor=0
190 xp=145:yp=177:x1p=205:y1p=200
200 ys=189:xs=160:pxl=0
210 yas=110:yasmax=110:pxlalien=0
221 WHILE xas<11 OR xas>310:xas=INT(RND(1*305)):WEND 
230 scrol=0:blockboundr=55:direc=3:bullet=0
240 blockspdmax=40:rbounddet=0:alienbullet=0
250 tpbound=20:ships=3:hit=0
260 'setup screen
270 xb=20:yb=20:x1b=20:y1b=30
290 BG 0 TILES 16,14
300 BG 0 PATTERN 0,177,320
310 BG 0 WINDOW 0,177,320,23 ON 
350 LOAD PCX "bl.pcx" AS SPRITE 0
360 SPRITE 0 SIZE 31,21 KEY 0
370 MOVE SPRITE 0 TO xp,yp
380 SPRITE 0 ON 
390 GPRINT 0,0,"SHIPS: ";ships;
400 GPRINT 130,0,"SCORE ";
410 'alien horde
430 LOAD PCX "smalien.pcx" AS SPRITE 1
440 SPRITE 1 SIZE 10,10 KEY 0
450 MOVE SPRITE 1 TO xb,yb
460 SPRITE 1 ON 
470 FOR field=20 TO 220 STEP 20
480   SOUND 0,1,10,50
490   BLIT xb,yb TO xb+field,yb SIZE 10,10
500   SPRITE 1 OFF 
510   WAIT 100
520 NEXT field
530 FOR field=20 TO 96 STEP 20
540   SOUND 0,1,10,1000
550   BLIT xb,yb TO xb,yb+field SIZE 229,10
560   WAIT 500
570 NEXT field
600 'main loop
610 GOSUB &input
620 GOSUB &player
640 GOSUB &shot
660 GOSUB &alienshot
670 GOSUB &block
690 'update loop
720 GOTO 600
730 &input
770 cc=cc+1
780 IF cc>=5 THEN 
790   cursor=PAD(0)
800   IF cursor AND 1 THEN xp=xp-1:x1p=x1p-1 
810   IF cursor AND 4 THEN xp=xp+1:x1p=x1p+1 
820   cc=0
830 ENDIF 
840 IF bullet=0 THEN 
850   IF cursor AND 256 THEN 
860     bullet=1:xs=xp+16
870     shot=shot+1
880     SOUND 0,0,10,100
890   ENDIF 'ends bullet press logic
900 ENDIF 
910 RETURN 
920 &player
930 IF xp<=10 THEN xp=10 
940 IF xp>=283 THEN xp=283 
950 MOVE SPRITE 0 TO xp,yp
970 RETURN 
980 &shot
990 IF bullet=1 THEN PSET xs,ys,15 
1020 IF ys<=191 THEN 
1030   bulletsense(0,0)=xs:bulletsense(0,1)=ys-1
1040   bulletsense(1,0)=xs-1:bulletsense(1,1)=ys-1
1050   bulletsense(2,0)=xs+1:bulletsense(2,1)=ys-1
1060   WHILE pxl<3
1070     px=POINT(bulletsense(pxl,0),bulletsense(pxl,1))
1080     IF px=132 THEN 
1090       RECT bulletsense(pxl,0)-8,bulletsense(pxl,1)-8,bulletsense(pxl,0)+10,bulletsense(pxl,1)+8,0,0
1100       bullet=0
1120       PSET xs,ys,0:ys=189
1130       SOUND 2,0,10,1000
1140       hit=hit+1:GPRINT 180,0,hit;
1150       pxl=3:'get out of/loop
1160       IF hit=60 THEN SOUND 2,110,50,1000:GPRINT 130,85,"YOU WIN!";
1170     ENDIF 
1180     pxl=pxl+1
1190   WEND 
1200 ENDIF 
1205 IF hit=60 THEN WAIT 500:GOSUB &endgame
1210 pxl=0:'reinitialize while/pxl/loop
1230 IF ys<=10 THEN 
1240   PSET xs,ys,0
1250   bullet=0:ys=189
1260 ENDIF:'erase bullet and move
1270 IF bullet=1 THEN 
1280   PSET xs,ys,0
1290   ys=ys-0.3
1300 ENDIF 
1310 ENDIF:REM this ends the bullet=0
1320 RETURN 
1330 &block
1340 block=block+1:'related to hoard speed below
1370 'next if sets speed of hoard
1380 IF block=blockspdmax THEN 
1390   SOUND 1,10,20,50
1400   block=0
1410   scrol=scrol+1
1430   GSCROLL 0,20,319,175,direc:'left 3
1440   IF scrol>=blockboundr THEN 
1450     GOSUB &checkrightboundary
1460     IF scrol>=blockboundr THEN 
1480       IF direc=3 THEN 
1490         direc=2
1500       ELSE 
1510         direc=3
1520       ENDIF 
1530       scrol=0
1540     ENDIF 
1550   ENDIF 
1560 ENDIF 
1570 RETURN 
1710 &checkrightboundary
1720 FOR bound=tpbound TO 176
1730   rbound=bound:lbound=bound
1780   IF POINT(20,lbound)=132 THEN ldetect=1 
1790   IF POINT(300,rbound)=132 THEN rdetect=1 
1800   IF ldetect=1 OR rdetect=1 THEN 
1810     bound=176
1820     tpbound=tpbound+1
1830   ENDIF 
1850 NEXT bound
1860 IF ldetect=0 AND direc=2 THEN blockboundr=blockboundr+20 
1870 IF rdetect=0 AND direc=3 THEN blockboundr=blockboundr+20 
1880 IF ldetect=1 OR rdetect=1 THEN GOSUB &movedown
1890 ldetect=0:rdetect=0
1900 RETURN 
1910 &movedown
1920 DO:GSCROLL 0,20,319,176,1:dn=dn+1:LOOP UNTIL dn=5
1930 dn=0
1935 yasmax=yasmax+5
1950 PSET xs,ys,0:PSET xs,ys+1,0
1960 PSET xs-1,ys,0:PSET xs+1,ys,0
1970 PSET xs-1,ys+1,0:PSET xs+1,ys+1,0
1980 FOR squash=10 TO 309
1990   IF POINT(squash,176)=132 THEN 
2000     GOTO &endgame
2010   ENDIF 
2030 NEXT squash
2040 RETURN 
2390 &alienshot
2400 alienbullet=1
2410 IF alienbullet=1 THEN 
2430   PSET xas,yas,15
2440 ENDIF 
2450 REM speed of alien bullet
2460 alienshotwait=alienshotwait+1
2470 IF alienshotwait<=20 THEN 
2480   PSET xas+1,yas,0:PSET xas-1,yas,0:PSET xas,yas,15
2490   RETURN 
2500 ENDIF 
2510 PSET xas+1,yas,0:PSET xas-1,yas,0:PSET xas,yas,15
2520 alienshotwait=0:REM speed of alien bullet
2540 IF yas>=175 THEN 
2550   bulletsensealien(0,0)=xas:bulletsensealien(0,1)=yas-1
2560   bulletsensealien(1,0)=xas-1:bulletsensealien(1,1)=yas-1
2570   bulletsensealien(2,0)=xas+1:bulletsensealien(2,1)=yas+1
2580   WHILE pxlalien<3
2590     pax=POINT(bulletsensealien(pxlalien,0),bulletsensealien(pxlalien,1))
2610     IF pax=73 THEN 
2620       GOSUB &yourdead
2630       alienbullet=0
2640       PSET xas,yas,0:yas=yasmax
2660       ships=ships-1:GPRINT 56,0,ships;
2670       IF ships=0 THEN GOSUB &endgame
2680       xas=INT(RND(5*305))
2690       WHILE xas<11 OR xas>310:xas=INT(RND(1*305)):WEND 
2700       pxlalien=3:REM get out of/loop
2710     ENDIF 
2720     pxlalien=pxlalien+1
2730   WEND 
2740 ENDIF 
2750 pxlalien=0:REM reinit while/pxlalien/loop
2760 IF yas>=199 THEN 
2770   PSET xas,yas,0
2780   alienbullet=0:yas=yasmax
2790   xas=INT(RND(1*305)):REM don'tdel
2800   WHILE xas<11 OR xas>310:xas=INT(RND(1*305)):WEND 
2810 ENDIF 
2830 IF alienbullet=1 THEN 
2840   PSET xas,yas,0
2850   yas=yas+1
2860 ENDIF 
2870 RETURN 
2880 &yourdead
2885 IF cursor>0 THEN cursor=0 
2890 part=INT(RND(1*20))+5
2900 DIM partsx(part+2)
2905 DIM partsy(part+2)
2910 FOR a=1 TO part
2920   partsx(a)=INT(RND(1*50))
2930   partsy(a)=INT(RND(1*50))
2940 NEXT a
2950 FOR ecl=1 TO 2
2960   IF ecl=1 THEN ec=75 
2970   IF ecl=2 THEN ec=0 
2980   FOR a=1 TO part
2982     IF xas-partsx(a)<5 THEN partsx(a)=0 
2984     IF xas+partsx(a)>305 THEN partsx(a)=0 
2990     LINE xas,195,xas+partsx(a),yas-partsy(a),ec
2995     LINE xas,185,xas-partsx(a),yas-partsy(a),ec
3000   NEXT a
3080   SOUND 2,0,10,1000
3090   WAIT 400
3100 NEXT ecl
3110 RETURN 
3120 &endgame
3130 GPRINT 120,100,"GAME  OVER";
3140 FOR aaa=1 TO 10:PALETTE 1:WAIT 100:PALETTE 0:WAIT 100:NEXT aaa
3150 GPRINT 60,120,"<<<PRESS FIRE TO BEGIN>>>";
3200 WHILE KEY(90)=0:WEND 
3203 BG 0 WINDOW 0,177,320,23 OFF 
3205 GOTO 100
3210 RETURN 
