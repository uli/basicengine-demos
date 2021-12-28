10 CLS
20 PALETTE 1
30 SCREEN 14
40 pi=3.14159265
50 GOSUB &SetupPlayer
60 yellow=RGB(255,255,0):orange=RGB(255,165,0):red=RGB(200,30,30):blue=RGB(50,50,255):black=RGB(0,0,0)
70 brown=RGB(165,42,42):green=RGB(30,200,30):white=RGB(255,255,255)
80 level=1
90 colDist=32  'collision distance for asteroids
100 maxVel=3  'Particle variables
110 minLife=7
120 maxLife=15
130 gameState=0  'Game states 0=Title Screen, 1=Level screen, 2=Game playing, 3=Game over
140 partAmount=250:GOSUB &setupParticles
150 lives=3:score=0:highScore=0
160 DIM pLasers(10,7)
170 &main
180 DO
190   State=PAD(0)
200   IF gameState=0 THEN
210     GOSUB &TitleScreen
220   ELSE IF gameState=1 THEN
230     GOSUB &LevelScreen
240   ELSE IF gameState=2 THEN
250     GOSUB &Gameplay
260   ELSE IF gameState=3 THEN
270     GOSUB &GameOver
280   ENDIF
290   timer=TICK(1)
300   VSYNC f+2
310   f=f+2
320 LOOP
330 &drawPlayer
340 LINE player(1,0)+player(8,0),player(1,1)+player(8,1),player(2,0)+player(8,0),player(2,1)+player(8,1)
350 LINE player(2,0)+player(8,0),player(2,1)+player(8,1),player(3,0)+player(8,0),player(3,1)+player(8,1)
360 LINE player(3,0)+player(8,0),player(3,1)+player(8,1),player(1,0)+player(8,0),player(1,1)+player(8,1)
370 IF player(12,0)=1 THEN
380   LINE player(9,0)+player(8,0),player(9,1)+player(8,1),player(10,0)+player(8,0),player(10,1)+player(8,1),yellow
390   LINE player(10,0)+player(8,0),player(10,1)+player(8,1),player(11,0)+player(8,0),player(11,1)+player(8,1),yellow
400 ENDIF
410 IF player(14,0)<timer THEN
420   CIRCLE player(0,0)+player(8,0),player(0,1)+player(8,1),1,green,green
430 ELSE
440   CIRCLE player(0,0)+player(8,0),player(0,1)+player(8,1),1,red,red
450 ENDIF
460 RETURN
470 PROC rotateX(px,py,cx,cy,ar)
480 @radian=@ar*(pi/180)
490 @costheta=COS(@radian)
500 @sintheta=SIN(@radian)
510 @x=(@costheta*(@px-@cx)-@sintheta*(@py-@cy)+@cx)
520 RETURN @x
530 PROC rotateY(px,py,cx,cy,ar)
540 @radian=@ar*(pi/180)
550 @costheta=COS(@radian)
560 @sintheta=SIN(@radian)
570 @y=(@sintheta*(@px-@cy)+@costheta*(@py-@cy)+@cy)
580 RETURN @y
590 &controlPlayer
600 IF State=1 OR State=9 OR State=3 OR State=513 OR State=521 OR State=515 THEN
610   player(4,0)=-6
620 ELSE IF State=4 OR State=12 OR State=6 OR State=516 OR State=524 OR State=518 THEN
630   player(4,0)=6
640 ELSE
650   player(4,0)=0
660 ENDIF
670 IF State=8 OR State=9 OR State=12 OR State=520 OR State=521 OR State=524 THEN
680   player(5,0)=player(5,0)+(SIN(FN playerDirection(player(0,0),player(0,1),player(1,0),player(1,1)))*player(6,0))
690   player(5,1)=player(5,1)+(COS(FN playerDirection(player(0,0),player(0,1),player(1,0),player(1,1)))*player(6,0))
700   player(12,0)=1
710 ELSE player(12,0)=0
720 ENDIF
730 IF player(5,0)>player(7,0) THEN   'clipping ship to max speed if it exceeds
740   player(5,0)=player(7,0)
750 ENDIF
760 IF player(5,1)>player(7,0) THEN
770   player(5,1)=player(7,0)
780 ENDIF
790 IF player(5,0)<0 THEN
800   IF player(5,0)<-player(7,0) THEN
810     player(5,0)=-player(7,0)
820   ENDIF
830 ENDIF
840 IF player(5,1)<0 THEN
850   IF player(5,1)<-player(7,0) THEN
860     player(5,1)=-player(7,0)
870   ENDIF
880 ENDIF
890 IF player(4,0)<>0 THEN
900   FOR p=1 TO 3  'Rotate points around centre point 0,0
910     tempx=FN rotateX(player(p,0),player(p,1),player(0,0),player(0,1),player(4,0))
920     tempy=FN rotateY(player(p,0),player(p,1),player(0,0),player(0,1),player(4,0))
930     player(p,0)=tempx
940     player(p,1)=tempy
950   NEXT p
960   FOR p=9 TO 11
970     tempx=FN rotateX(player(p,0),player(p,1),player(0,0),player(0,1),player(4,0))
980     tempy=FN rotateY(player(p,0),player(p,1),player(0,0),player(0,1),player(4,0))
990     player(p,0)=tempx
1000     player(p,1)=tempy
1010   NEXT p
1020 ENDIF
1030 player(7,1)=player(7,1)-1
1040 IF State=512 OR State=520 OR State=513 OR State=514 OR State=516 OR State=521 OR State=524 OR State=518 OR State=515 THEN
1050   GOSUB &fireLaser
1060 ENDIF
1070 IF (State=256 OR State=264 OR State=265 OR State=268 OR State=260 OR State=262 OR State=258 OR State=259) AND player(14,0)<timer THEN
1080   GOSUB &playerTeleport:player(14,0)=timer+3
1090 ENDIF
1100 RETURN
1110 PROC DIST(x1,y1,x2,y2)  'Finds distance between two points
1120 @xdist=@x2-@x1
1130 @ydist=@y2-@y1
1140 @distance=SQR((@x2-@x1)^2+(@y2-@y1)^2)
1150 RETURN @distance
1160 PROC playerDirection(x1,y1,x2,y2)
1170 @y=@y2-@y1
1180 @x=@x2-@x1
1190 @a=ATN2(@x,@y)
1200 RETURN @a
1210 &movePlayer
1220 player(8,0)=(player(8,0)+player(5,0))
1230 player(8,1)=(player(8,1)+player(5,1))
1240 RETURN
1250 &screenWrap
1260 IF player(8,0)<-107 THEN
1270   player(8,0)=387
1280 ELSE IF player(8,0)>387 THEN
1290   player(8,0)=-107
1300 ELSE IF player(8,1)<-107 THEN
1310   player(8,1)=177
1320 ELSE IF player(8,1)>177 THEN
1330   player(8,1)=-107
1340 ENDIF
1350 FOR i=0 TO (level+3*8)
1360   IF Asteroids(i,9,0)<-100-(25*Asteroids(i,13,0)) THEN
1370     Asteroids(i,9,0)=380+(25*Asteroids(i,13,0))
1380   ENDIF
1390   IF Asteroids(i,9,1)<-100-(25*Asteroids(i,13,0)) THEN
1400     Asteroids(i,9,1)=170+(25*Asteroids(i,13,0))
1410   ENDIF
1420   IF Asteroids(i,9,0)>380+(25*Asteroids(i,13,0)) THEN
1430     Asteroids(i,9,0)=-100-(25*Asteroids(i,13,0))
1440   ENDIF
1450   IF Asteroids(i,9,1)>170+(25*Asteroids(i,13,0)) THEN
1460     Asteroids(i,9,1)=-100-(25*Asteroids(i,13,0))
1470   ENDIF
1480 NEXT i
1490 FOR i=0 TO 9
1500   IF pLasers(i,0)=1 THEN
1510     IF pLasers(i,1)<0 THEN pLasers(i,1)=480
1520     IF pLasers(i,1)>480 THEN pLasers(i,1)=0
1530     IF pLasers(i,2)>270 THEN pLasers(i,2)=0
1540     IF pLasers(i,2)<0 THEN pLasers(i,2)=270
1550   ENDIF
1560 NEXT i
1570 RETURN
1580 &SetupPlayer
1590 DIM player(15,2)
1600 player(0,0)=100
1610 player(0,1)=100
1620 player(1,0)=player(0,0)
1630 player(1,1)=player(0,1)-8
1640 player(2,0)=player(0,0)-5
1650 player(2,1)=player(0,1)+8
1660 player(3,0)=player(0,0)+5
1670 player(3,1)=player(0,1)+8
1680 player(4,0)=0  'Ship Rotation
1690 player(5,0)=0:player(5,1)=0  'Player X and Y speeds
1700 player(6,0)=0.1  'player thrust
1710 player(7,0)=3:player(7,1)=7  'player max speed and player laser timer
1720 player(8,0)=140  'Ship x offset
1730 player(8,1)=35  'Ship y offset. Offsets are needed or rotation wont work
1740 player(9,0)=player(0,0)-3  'points for thrust triangle
1750 player(9,1)=player(0,1)+8  '
1760 player(10,0)=player(0,0)  '
1770 player(10,1)=player(0,1)+14  '
1780 player(11,0)=player(0,0)+3  '
1790 player(11,1)=player(0,1)+8  '
1800 player(12,0)=0  'Switch for thrust drawing
1810 player(13,0)=1  'player alive?
1820 player(14,0)=0  'teleport timer
1830 RETURN
1840 &SetupAsteroid
1850 DIM asteroid(15,2)
1860 asteroid(13,0)=a
1870 asteroid(0,0)=100  'Asteroid points
1880 asteroid(0,1)=100
1890 asteroid(1,0)=asteroid(0,0)
1900 asteroid(1,1)=asteroid(0,1)-(32*asteroid(13,0))
1910 asteroid(2,0)=asteroid(0,0)+(18*asteroid(13,0))
1920 asteroid(2,1)=asteroid(0,1)-(26*asteroid(13,0))
1930 asteroid(3,0)=asteroid(0,0)+(31*asteroid(13,0))
1940 asteroid(3,1)=asteroid(0,1)-(12*asteroid(13,0))
1950 asteroid(4,0)=asteroid(0,0)+(24*asteroid(13,0))
1960 asteroid(4,1)=asteroid(0,1)+(24*asteroid(13,0))
1970 asteroid(5,0)=asteroid(0,0)
1980 asteroid(5,1)=asteroid(0,1)+(30*asteroid(13,0))
1990 asteroid(6,0)=asteroid(0,0)-(27*asteroid(13,0))
2000 asteroid(6,1)=asteroid(0,1)+(24*asteroid(13,0))
2010 asteroid(7,0)=asteroid(0,0)-(29*asteroid(13,0))
2020 asteroid(7,1)=asteroid(0,1)-(2*asteroid(13,0))
2030 asteroid(8,0)=asteroid(0,0)-(25*asteroid(13,0))
2040 asteroid(8,1)=asteroid(0,1)-(28*asteroid(13,0))
2050 RETURN
2060 &LevelSetup
2070 AstLeft=0:UFOleft=0
2080 DIM uLasers(level,7)
2090 DIM Asteroids((level+3)*8,15,2)  'Need to add the *4 to account for asteroid splitting
2100 DIM UFOS(level,4,2)  '1 UFO per level number
2110 ufoSpawn=timer+10
2120 a=1
2130 GOSUB &SetupAsteroid
2140 FOR i=0 TO level+2
2150   GOSUB &spawnAsteroid  'FOR a=0 TO 9
2160   AstLeft=AstLeft+7
2170 NEXT i
2180 RETURN
2190 &DrawAsteroids
2200 FOR i=0 TO (level+3*8)-1
2210   IF Asteroids(i,12,0)=1 THEN
2220     LINE Asteroids(i,1,0)+Asteroids(i,9,0),Asteroids(i,1,1)+Asteroids(i,9,1),Asteroids(i,2,0)+Asteroids(i,9,0),Asteroids(i,2,1)+Asteroids(i,9,1),brown
2230     LINE Asteroids(i,2,0)+Asteroids(i,9,0),Asteroids(i,2,1)+Asteroids(i,9,1),Asteroids(i,3,0)+Asteroids(i,9,0),Asteroids(i,3,1)+Asteroids(i,9,1),brown
2240     LINE Asteroids(i,3,0)+Asteroids(i,9,0),Asteroids(i,3,1)+Asteroids(i,9,1),Asteroids(i,4,0)+Asteroids(i,9,0),Asteroids(i,4,1)+Asteroids(i,9,1),brown
2250     LINE Asteroids(i,4,0)+Asteroids(i,9,0),Asteroids(i,4,1)+Asteroids(i,9,1),Asteroids(i,5,0)+Asteroids(i,9,0),Asteroids(i,5,1)+Asteroids(i,9,1),brown
2260     LINE Asteroids(i,5,0)+Asteroids(i,9,0),Asteroids(i,5,1)+Asteroids(i,9,1),Asteroids(i,6,0)+Asteroids(i,9,0),Asteroids(i,6,1)+Asteroids(i,9,1),brown
2270     LINE Asteroids(i,6,0)+Asteroids(i,9,0),Asteroids(i,6,1)+Asteroids(i,9,1),Asteroids(i,7,0)+Asteroids(i,9,0),Asteroids(i,7,1)+Asteroids(i,9,1),brown
2280     LINE Asteroids(i,7,0)+Asteroids(i,9,0),Asteroids(i,7,1)+Asteroids(i,9,1),Asteroids(i,8,0)+Asteroids(i,9,0),Asteroids(i,8,1)+Asteroids(i,9,1),brown
2290     LINE Asteroids(i,8,0)+Asteroids(i,9,0),Asteroids(i,8,1)+Asteroids(i,9,1),Asteroids(i,1,0)+Asteroids(i,9,0),Asteroids(i,1,1)+Asteroids(i,9,1),brown
2300   ENDIF
2310 NEXT i
2320 RETURN
2330 &MoveAsteroids
2340 FOR i=0 TO (level+3*8)-1
2350   IF Asteroids(i,12,0)=1 THEN
2360     Asteroids(i,9,0)=Asteroids(i,9,0)+Asteroids(i,10,0)
2370     Asteroids(i,9,1)=Asteroids(i,9,1)+Asteroids(i,10,1)
2380     FOR p=1 TO 8
2390       tempx=FN rotateX(Asteroids(i,p,0),Asteroids(i,p,1),Asteroids(i,0,1),Asteroids(i,0,1),Asteroids(i,11,0))
2400       tempy=FN rotateY(Asteroids(i,p,0),Asteroids(i,p,1),Asteroids(i,0,1),Asteroids(i,0,1),Asteroids(i,11,0))
2410       Asteroids(i,p,0)=tempx:Asteroids(i,p,1)=tempy
2420     NEXT p
2430   ENDIF
2440 NEXT i
2450 RETURN
2460 &fireLaser
2470 FOR i=0 TO 8
2480   IF pLasers(i,0)=0 AND player(7,1)<0 THEN   'If laser doesnt exist and player can shoot
2490     SOUND 1,118,100,100,0.1  'play laser sound
2500     player(7,1)=10
2510     pLasers(i,0)=1  'Set laser Existence to 1
2520     pLasers(i,5)=2.2  'Set laser speed
2530     pLasers(i,6)=35  'Set laser range
2540     pLasers(i,1)=player(1,0)+player(8,0)  'set laser x to player point 1x+offset
2550     pLasers(i,2)=player(1,1)+player(8,1)  'same again for y values
2560     pLasers(i,3)=(SIN(FN playerDirection(player(0,0),player(0,1),player(1,0),player(1,1)))*pLasers(i,5))
2570     pLasers(i,4)=(COS(FN playerDirection(player(0,0),player(0,1),player(1,0),player(1,1)))*pLasers(i,5))
2580   ENDIF
2590 NEXT i
2600 RETURN
2610 &moveLasers
2620 FOR i=0 TO 8
2630   IF pLasers(i,0)=1 THEN
2640     pLasers(i,1)=pLasers(i,1)+(pLasers(i,3)*pLasers(i,5))
2650     pLasers(i,2)=pLasers(i,2)+(pLasers(i,4)*pLasers(i,5))
2660     pLasers(i,6)=pLasers(i,6)-1
2670   ENDIF
2680   IF pLasers(i,6)<0 THEN pLasers(i,0)=0
2690 NEXT i
2700 GOSUB &updateULasers
2710 RETURN
2720 &drawLasers
2730 FOR i=0 TO 8
2740   IF pLasers(i,0)=1 THEN
2750     CIRCLE pLasers(i,1),pLasers(i,2),1,green,green
2760   ENDIF
2770 NEXT i
2780 FOR i=0 TO level-1
2790   IF uLasers(i,0)=1 THEN
2800     CIRCLE uLasers(i,1),uLasers(i,2),1,red,red
2810   ENDIF
2820 NEXT i
2830 RETURN
2840 &collision
2850 FOR i=0 TO (level+2)*8
2860   FOR l=0 TO 8
2870     IF pLasers(l,0)=1 THEN
2880       IF Asteroids(i,12,0)=1 THEN
2890         distance=INT(FN DIST((Asteroids(i,0,0)+Asteroids(i,9,0)),(Asteroids(i,0,1)+Asteroids(i,9,1)),pLasers(l,1),pLasers(l,2)))
2900         IF distance<(colDist*Asteroids(i,13,0)) THEN
2910           SOUND 0,0,0,500  'play explosion
2920           AstLeft=AstLeft-1  'minus one asteroid from level total
2930           pLasers(l,0)=0
2940           Asteroids(i,12,0)=0
2950           tempOffsetx=Asteroids(i,9,0)
2960           tempOffsety=Asteroids(i,9,1)
2970           IF Asteroids(i,13,0)=1 THEN
2980           a=0.75
2990           CALL AddScore(1)
3000           GOSUB &spawnAsteroid2:CALL addParticles(Asteroids(i,0,0)+Asteroids(i,9,0),Asteroids(i,0,1)+Asteroids(i,9,1),75)
3010           GOSUB &spawnAsteroid2
3020           ELSE IF Asteroids(i,13,0)=0.75 THEN
3030           a=0.35
3040           CALL AddScore(2)
3050           GOSUB &spawnAsteroid2:CALL addParticles(Asteroids(i,0,0)+Asteroids(i,9,0),Asteroids(i,0,1)+Asteroids(i,9,1),50)
3060           GOSUB &spawnAsteroid2
3070           ELSE IF Asteroids(i,13,0)=0.35 THEN
3080           CALL AddScore(3)
3090           CALL addParticles(Asteroids(i,0,0)+Asteroids(i,9,0),Asteroids(i,0,1)+Asteroids(i,9,1),25)
3100           ENDIF
3110         ENDIF
3120       ENDIF
3130     ENDIF
3140   NEXT l
3150 NEXT i
3160 GOSUB &UFOcollision
3170 RETURN
3180 PROC triColl(x0,y0,x1,y1,x2,y2,px,py)  'Orphan collision Function, it works but it too slow'
3190 'Get area of triangle
3200 @areaOrig=ABS((@x1-@x0)*(@y2-@y0)-(@x2-@x0)*(@y1-@y0))
3210 @area1=ABS((@x0-@px)*(@y1-@py)-(@x1-@px)*(@y0-@py))
3220 @area2=ABS((@x1-@px)*(@y2-@py)-(@x2-@px)*(@y1-@py))
3230 @area3=ABS((@x2-@px)*(@y0-@py)-(@x0-@px)*(@y2-@py))
3240 IF @area1+@area2+@area3=@areaOrig THEN
3250   RETURN 1
3260 ELSE
3270   RETURN 0
3280 ENDIF
3290 RETURN
3300 &spawnAsteroid  'needs to be in a for loop with i
3310 FOR r=0 TO 9
3320   Asteroids(i,r,0)=asteroid(r,0)
3330   Asteroids(i,r,1)=asteroid(r,1)
3340 NEXT r
3350 Asteroids(i,9,0)=(RND(0)*480)-100
3360 Asteroids(i,9,1)=RND(0)*270-100
3370 IF FN DIST(Asteroids(i,9,0)+100,Asteroids(i,9,1)+100,240,135)<60 THEN GOTO 3350
3380 Asteroids(i,10,0)=(RND(2)*0.1)-(RND(2)*0.2):Asteroids(i,10,1)=(RND(2)*0.2)-(RND(2)*0.2)
3390 Asteroids(i,11,0)=(RND(2)-RND(2))*1
3400 Asteroids(i,12,0)=1  'Existance variable
3410 Asteroids(i,13,0)=asteroid(13,0)  'size
3420 RETURN
3430 &spawnAsteroid2
3440 GOSUB &SetupAsteroid
3450 spawn=1  'number of spawns. Stops it from filling screen
3460 FOR b=0 TO (level+3*8)-1
3470   IF Asteroids(b,12,0)=0 AND spawn=1 THEN
3480     spawn=0
3490     FOR r=0 TO 9
3500       Asteroids(b,r,0)=asteroid(r,0)
3510       Asteroids(b,r,1)=asteroid(r,1)
3520     NEXT r
3530     Asteroids(b,9,0)=tempOffsetx+(RND(20)-RND(20))
3540     Asteroids(b,9,1)=tempOffsety+(RND(20)-RND(20))
3550     Asteroids(b,10,0)=(RND(4)*0.1)-(RND(4)*0.1):Asteroids(b,10,1)=(RND(4)*0.1)-(RND(4)*0.2)
3560     Asteroids(b,11,0)=(RND(2)-RND(2))*1
3570     Asteroids(b,12,0)=1  'Existance variable
3580     Asteroids(b,13,0)=asteroid(13,0)  'size
3590     Asteroids(b,14,0)=0  'Used for respawn distance calculation
3600   ENDIF
3610 NEXT b
3620 RETURN
3630 &setupParticles
3640 DIM particles(partAmount,6)
3650 RETURN
3660 PROC addParticles(px,py,pa)
3670 @particleX=@px
3680 @particleY=@py
3690 FOR p=0 TO partAmount-1
3700   IF particles(p,0)=0 AND @pa>0 THEN
3710     particles(p,1)=@particleX+(RND(5)-RND(5))  'set particle x coord
3720     particles(p,2)=@particleY+(RND(5)-RND(5))  'set particle y coord
3730     particles(p,3)=RND(maxVel)-RND(maxVel)  'set x speed
3740     particles(p,4)=RND(maxVel)-RND(maxVel)  'set y speed
3750     particles(p,5)=RND(maxLife)+minLife  'set particle life
3760     particles(p,0)=1  'set existence to on
3770     @pa=@pa-1
3780   ENDIF
3790 NEXT p
3800 RETURN
3810 &updateParticles
3820 FOR p=0 TO partAmount-1
3830   IF particles(p,0)=1 THEN
3840     particles(p,1)=particles(p,1)+particles(p,3)
3850     particles(p,2)=particles(p,2)+particles(p,4)
3860     particles(p,5)=particles(p,5)-1
3870   ENDIF
3880   IF particles(p,5)<0 THEN
3890     particles(p,0)=0
3900   ENDIF
3910 NEXT p
3920 RETURN
3930 &drawParticles
3940 FOR p=0 TO partAmount-1
3950   IF particles(p,0)=1 THEN
3960     CIRCLE particles(p,1),particles(p,2),1,orange,orange
3970   ENDIF
3980 NEXT p
3990 RETURN
4000 &Gameplay
4010 IF player(13,0)=1 THEN   'If player is alive then
4020   GOSUB &drawPlayer
4030   GOSUB &controlPlayer
4040   GOSUB &movePlayer
4050   GOSUB &playerCollision
4060 ELSE GOSUB &drawCorpse:IF respawntime<timer THEN GOSUB &playerRespawn
4070 ENDIF
4080 GOSUB &MoveAsteroids
4090 GOSUB &controlUFO
4100 GOSUB &updateParticles
4110 GOSUB &DrawAsteroids
4120 GOSUB &screenWrap
4130 GOSUB &moveLasers
4140 GOSUB &drawLasers
4150 GOSUB &collision
4160 GOSUB &UlaserColl
4170 GOSUB &DrawAsteroids
4180 GOSUB &drawParticles
4190 GOSUB &drawUFOS
4200 GOSUB &levelControl
4210 GOSUB &HUD
4220 CLS
4230 GOSUB &HUD
4240 IF player(13,0)=1 THEN GOSUB &drawPlayer:ELSE GOSUB &drawCorpse
4250 GOSUB &DrawAsteroids
4260 GOSUB &drawLasers:GOSUB &drawParticles:GOSUB &drawUFOS
4270 RETURN
4280 &TitleScreen
4290 State=PAD(0)
4300 FONT "hp100lx"SIZE 50,50
4310 COLOR white:GPRINT 20,110,"ASTEROIDS         "
4320 FONT "hp100lx"SIZE 10,10
4330 COLOR red:GPRINT 130,80,"A Shameless Ripoff Of                        "
4340 GPRINT 90,170,"Written for the Basic Engine NG               "
4350 GPRINT 160,185,"By Anthony Clarke                       "
4360 COLOR green:GPRINT 150,230,"Press Fire to Start                      "
4370 IF State=512 THEN
4380   gameState=1
4390 ELSE GOTO 4290
4400 ENDIF
4410 FONT 0:COLOR white:CLS
4420 RETURN
4430 &LevelScreen
4440 FONT "cpc"SIZE 30,30
4450 COLOR white:GPRINT 140,120,"Level ";level;"            "
4460 gameState=2:FONT 0
4470 SOUND 0,53,40,300,0.5:WAIT 300:SOUND 0,53,45,300,0.5:WAIT 300:SOUND 0,53,50,500,0.5
4480 WAIT 3000
4490 GOSUB &LevelSetup
4500 f=FRAME()
4510 RETURN
4520 &GameOver
4530 CLS
4540 FONT "cpc"SIZE 30,30
4550 COLOR white GPRINT 90,110," GAME OVER            "
4560 level=1
4570 SOUND 0,64,60,500,0.5:WAIT 500:SOUND 0,64,55,500,0.5:WAIT 500:SOUND 0,64,50,500,0.5
4580 gameState=0:WAIT 3000:score=0
4590 RETURN
4600 &levelControl
4610 IF AstLeft=0 AND UFOleft=0 THEN
4620   CLS
4630   GOSUB &SetupPlayer
4640   WAIT 1000
4650   CLS
4660   level=level+1
4670   gameState=1
4680   FOR p=0 TO partAmount-1
4690     particles(p,0)=0
4700   NEXT p
4710   FOR i=0 TO 8
4720     pLasers(i,0)=0
4730   NEXT i
4740 ENDIF
4750 IF ufoSpawn<timer THEN GOSUB &spawnUFO:ufoSpawn=timer+10
4760 IF lives=0 THEN gameState=3:lives=3:CLS
4770 RETURN
4780 &killPlayer
4790 player(13,0)=0
4800 DIM corpse(10,2)
4810 FOR i=1 TO 3  'changed
4820   corpse(i,0)=player(i,0)
4830   corpse(i,1)=player(i,1)
4840 NEXT i
4850 SOUND 1,127,30,100  'player death sound
4860 respawntime=timer+3
4870 lives=lives-1
4880 corpse(4,0)=corpse(1,0):corpse(4,1)=corpse(1,1)
4890 corpse(5,0)=corpse(2,0):corpse(5,1)=corpse(2,1)
4900 corpse(6,0)=corpse(3,0):corpse(6,1)=corpse(3,1)
4910 corpse(7,0)=-0.15:corpse(7,1)=0.15:corpse(8,0)=-0.2
4920 corpse(9,0)=player(8,0):corpse(9,1)=player(8,1)
4930 RETURN
4940 &drawCorpse
4950 LINE corpse(1,0)+corpse(9,0),corpse(1,1)+corpse(9,1),corpse(5,0)+corpse(9,0),corpse(5,1)+corpse(9,1),white
4960 LINE corpse(2,0)+corpse(9,0),corpse(2,1)+corpse(9,1),corpse(6,0)+corpse(9,0),corpse(6,1)+corpse(9,1),white
4970 LINE corpse(3,0)+corpse(9,0),corpse(3,1)+corpse(9,1),corpse(4,0)+corpse(9,0),corpse(4,1)+corpse(9,1),white
4980 tempx=FN rotateX(corpse(1,0),corpse(1,1),corpse(5,0),corpse(5,1),corpse(7,0))
4990 tempy=FN rotateY(corpse(1,0),corpse(1,1),corpse(5,0),corpse(5,1),corpse(7,0))
5000 corpse(1,0)=tempx:corpse(1,1)=tempy
5010 tempx=FN rotateX(corpse(6,0),corpse(6,1),corpse(2,0),corpse(2,1),corpse(7,1))
5020 tempy=FN rotateY(corpse(6,0),corpse(6,1),corpse(2,0),corpse(2,1),corpse(7,1))
5030 corpse(6,0)=tempx:corpse(6,1)=tempy
5040 tempx=FN rotateX(corpse(4,0),corpse(4,1),corpse(3,0),corpse(3,1),corpse(8,0))
5050 tempy=FN rotateY(corpse(4,0),corpse(4,1),corpse(3,0),corpse(3,1),corpse(8,0))
5060 corpse(4,0)=tempx:corpse(4,1)=tempy
5070 RETURN
5080 &playerCollision
5090 FOR i=0 TO (level+2)*8
5100   IF Asteroids(i,12,0)=1 THEN   'if Asteroid still exists
5110     FOR p=1 TO 3
5120       distance2=INT(FN DIST((Asteroids(i,0,0)+Asteroids(i,9,0)),(Asteroids(i,0,1)+Asteroids(i,9,1)),(player(p,0)+player(8,0)),(player(p,1)+player(8,1))))
5130       IF distance2<(colDist*Asteroids(i,13,0)) THEN
5140         GOSUB &killPlayer
5150       ENDIF
5160     NEXT p
5170   ENDIF
5180 NEXT i
5190 FOR l=0 TO level-1
5200   IF uLasers(l,0)=1 THEN   'if UFO laser still exists
5210     distance2=INT(FN DIST(uLasers(l,1),uLasers(l,2),(player(0,0)+player(8,0)),(player(0,1)+player(8,1))))
5220     IF distance2<7 THEN
5230       GOSUB &killPlayer
5240       uLasers(l,0)=0
5250     ENDIF
5260   ENDIF
5270 NEXT l
5280 FOR l=0 TO level-1
5290   IF UFOS(l,0,0)=1 THEN   'if UFO laser still exists
5300     distance2=INT(FN DIST(UFOS(l,1,0),UFOS(l,1,1),(player(0,0)+player(8,0)),(player(0,1)+player(8,1))))
5310     distance3=INT(FN DIST(UFOS(l,1,0)-15,UFOS(l,1,1),(player(0,0)+player(8,0)),(player(0,1)+player(8,1))))
5320     distance4=INT(FN DIST(UFOS(l,1,0)+15,UFOS(l,1,1),(player(0,0)+player(8,0)),(player(0,1)+player(8,1))))
5330     IF distance2<7 OR distance3<7 OR distance4<7 THEN
5340       GOSUB &killPlayer
5350     ENDIF
5360   ENDIF
5370 NEXT l
5380 RETURN
5390 &playerRespawn
5400 flag=0:player(13,0)=0  'used to see if any asteroids are too close
5410 player(8,0)=(RND(0)*480)-100
5420 player(8,1)=(RND(0)*270)-100
5430 FOR i=0 TO (level+2)*8
5440   IF Asteroids(i,12,0)=1 THEN
5450     Asteroids(i,14,0)=INT(FN DIST((Asteroids(i,0,0)+Asteroids(i,9,0)),(Asteroids(i,0,1)+Asteroids(i,9,1)),(player(0,0)+player(8,0)),(player(0,1)+player(8,1))))
5460     IF Asteroids(i,14,0)<60 THEN flag=1
5470   ENDIF
5480 NEXT i
5490 IF flag=1 THEN
5500   GOTO 5400
5510 ENDIF
5520 player(13,0)=1:SOUND 1,100,40
5530 player(5,0)=0:player(5,1)=0
5540 RETURN
5550 &playerTeleport
5560 flag=0:player(13,0)=0  'used to see if any asteroids are too close
5570 player(8,0)=(RND(0)*480)-100
5580 player(8,1)=(RND(0)*270)-100
5590 FOR i=0 TO (level+2)*8
5600   IF Asteroids(i,12,0)=1 THEN
5610     Asteroids(i,14,0)=INT(FN DIST((Asteroids(i,0,0)+Asteroids(i,9,0)),(Asteroids(i,0,1)+Asteroids(i,9,1)),(player(0,0)+player(8,0)),(player(0,1)+player(8,1))))
5620     IF Asteroids(i,14,0)<60 THEN flag=1
5630   ENDIF
5640 NEXT i
5650 IF flag=1 THEN
5660   GOTO 5400
5670 ENDIF
5680 player(13,0)=1:SOUND 1,100,40
5690 RETURN
5700 PROC drawUFO(ufx,ufy)
5710 CIRCLE @ufx,@ufy,8,blue,black
5720 RECT @ufx-15,@ufy,@ufx+15,@ufy+10,white,black
5730 CIRCLE @ufx-15,@ufy+5,5,white,black
5740 CIRCLE @ufx+15,@ufy+5,5,white,black
5750 CIRCLE @ufx-5,@ufy+5,5,white,black
5760 CIRCLE @ufx+5,@ufy+5,5,white,black
5770 RETURN
5780 &setupUFO
5790 DIM UFO(4,2)
5800 UFO(0,0)=1  'Existance variable
5810 UFO(1,0)=500  'X position
5820 UFO(1,1)=RND(240)+10  'Y position
5830 UFO(2,0)=-1  'X speed
5840 UFO(2,1)=-1  'Direction -1 for Left, 1 for right
5850 UFO(3,0)=timer+3  'Shoot timer
5860 RETURN
5870 &spawnUFO
5880 GOSUB &setupUFO
5890 spawn=1  'Stops spawning all the UFOS
5900 FOR i=0 TO level-1
5910   IF UFOS(i,0,0)=0 AND spawn=1 THEN
5920     spawn=0
5930     FOR p=0 TO 3
5940       FOR k=0 TO 1
5950         UFOS(i,p,k)=UFO(p,k)
5960       NEXT k
5970     NEXT p
5980     UFOleft=UFOleft+1
5990     SOUND 2,123,60,9000,0.2
6000   ENDIF
6010 NEXT i
6020 RETURN
6030 &controlUFO
6040 FOR i=0 TO level-1
6050   IF UFOS(i,0,0)=1 THEN
6060     UFOS(i,1,0)=UFOS(i,1,0)+UFOS(i,2,0)
6070     IF UFOS(i,3,0)<timer THEN
6080       CALL fireUFO(UFOS(i,1,0),UFOS(i,1,1),i)
6090       UFOS(i,3,0)=timer+3
6100     ENDIF
6110     IF UFOS(i,1,0)<-50 THEN
6120       UFOS(i,1,0)=550
6130       UFOS(i,1,1)=RND(240)+10
6140       SOUND 2,123,60,9000,0.2
6150     ENDIF
6160   ENDIF
6170 NEXT i
6180 RETURN
6190 &drawUFOS
6200 FOR i=0 TO level-1
6210   IF UFOS(i,0,0)=1 THEN
6220     CALL drawUFO(UFOS(i,1,0),UFOS(i,1,1))
6230   ENDIF
6240 NEXT i
6250 RETURN
6260 &UFOcollision
6270 FOR i=0 TO level-1
6280   FOR k=0 TO 8
6290     IF UFOS(i,0,0)=1 THEN
6300       IF pLasers(k,0)=1 THEN
6310         IF pLasers(k,1)>(UFOS(i,1,0))-17 AND pLasers(k,1)<(UFOS(i,1,0)+17) AND pLasers(k,2)>(UFOS(i,1,1)-3) AND pLasers(k,2)<(UFOS(i,1,1)+10) THEN
6320           UFOS(i,0,0)=0
6330           ufoSpawn=timer+10
6340           pLasers(k,0)=0
6350           CALL addParticles(UFOS(i,1,0),UFOS(i,1,1),50)
6360           CALL AddScore(1)
6370           SOUND 2,0,0,500
6380           UFOleft=UFOleft-1
6390         ENDIF
6400       ENDIF
6410     ENDIF
6420   NEXT k
6430 NEXT i
6440 RETURN
6450 PROC fireUFO(x,y,n)
6460 IF uLasers(@n,0)=0 THEN
6470   uLasers(@n,0)=1  'Set existence to on
6480   uLasers(@n,1)=@x  'Set X coord
6490   uLasers(@n,2)=@y  'Set y coord
6500   uLasers(@n,3)=4  'Set speed
6510   uLasers(@n,4)=(SIN(FN playerDirection(@x,@y,(player(0,0)+player(8,0)),(player(0,1)+player(8,1)))))  'RND(1)-RND(1)  'Set X direction
6520   uLasers(@n,5)=(COS(FN playerDirection(@x,@y,(player(0,0)+player(8,0)),(player(0,1)+player(8,1)))))  'RND(1)-RND(1)  'Set Y direction
6530   uLasers(@n,6)=50  'Set range
6540 ENDIF
6550 SOUND 1,118,90,120,0.1
6560 RETURN
6570 &updateULasers
6580 FOR i=0 TO level-1
6590   IF uLasers(i,0)=1 THEN
6600     uLasers(i,1)=uLasers(i,1)+(uLasers(i,4)*uLasers(i,3))
6610     uLasers(i,2)=uLasers(i,2)+(uLasers(i,5)*uLasers(i,3))
6620     uLasers(i,6)=uLasers(i,6)-1
6630     IF uLasers(i,6)<0 THEN uLasers(i,0)=0
6640   ENDIF
6650 NEXT i
6660 RETURN
6670 &UlaserColl  'collision detection for UFO lasers and Asteroids
6680 FOR i=0 TO (level+2)*8
6690   FOR l=0 TO level-1
6700     IF uLasers(l,0)=1 THEN
6710       IF Asteroids(i,12,0)=1 THEN
6720         distance=INT(FN DIST((Asteroids(i,0,0)+Asteroids(i,9,0)),(Asteroids(i,0,1)+Asteroids(i,9,1)),uLasers(l,1),uLasers(l,2)))
6730         IF distance<(colDist*Asteroids(i,13,0)) THEN
6740           SOUND 0,0,0,500  'play explosion
6750           AstLeft=AstLeft-1  'minus one asteroid from level total
6760           uLasers(l,0)=0
6770           Asteroids(i,12,0)=0
6780           tempOffsetx=Asteroids(i,9,0)
6790           tempOffsety=Asteroids(i,9,1)
6800           IF Asteroids(i,13,0)=1 THEN
6810           a=0.75
6820           GOSUB &spawnAsteroid2:CALL addParticles(Asteroids(i,0,0)+Asteroids(i,9,0),Asteroids(i,0,1)+Asteroids(i,9,1),75)
6830           GOSUB &spawnAsteroid2
6840           ELSE IF Asteroids(i,13,0)=0.75 THEN
6850           a=0.35
6860           GOSUB &spawnAsteroid2:CALL addParticles(Asteroids(i,0,0)+Asteroids(i,9,0),Asteroids(i,0,1)+Asteroids(i,9,1),50)
6870           GOSUB &spawnAsteroid2
6880           ELSE IF Asteroids(i,13,0)=0.35 THEN
6890           CALL addParticles(Asteroids(i,0,0)+Asteroids(i,9,0),Asteroids(i,0,1)+Asteroids(i,9,1),25)
6900           ENDIF
6910         ENDIF
6920       ENDIF
6930     ENDIF
6940   NEXT l
6950 NEXT i
6960 RETURN
6970 PROC AddScore(t)
6980 IF @t=1 THEN score=score+10
6990 IF @t=2 THEN score=score+20
7000 IF @t=3 THEN score=score+50
7010 IF score>highScore THEN highScore=score
7020 RETURN
7030 &HUD
7040 GPRINT 10,0,"Score: ";score
7050 GPRINT 220,0,"HiScore: ";highScore
7060 GPRINT 430,0,"Lives: ";lives
7070 RETURN
