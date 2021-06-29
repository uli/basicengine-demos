10 SCREEN 5:PALETTE 2:COLOR 0,RGB(0,108,252):CLS:FONT 1
20 BG 0 TILES 16,14 SIZE 16,16
30 LOAD PCX "scene.pcx" AS BG 0 KEY RGB(0,108,252)
40 LOAD BG 0,"scene.bg"
50 LOAD PCX "charwalk.pcx" AS SPRITE 0
70 SPRITE 0 SIZE 32,32 KEY RGB(167,221,98)
80 MOVE SPRITE 0 TO 20,20
90 SPRITE 0 ON
100 LOAD PCX "explosion.pcx":EXx=RET(0):EXy=RET(1)
110 LOAD PCX "ship.pcx" AS SPRITE 10-15:shx=RET(0):shy=RET(1)
120 FOR i=10 TO 15:SPRITE i SIZE 32,32:NEXT
122 LOAD PCX "bullet.pcx" AS SPRITE 16-26
124 FOR i=16 TO 26:SPRITE i SIZE 16,16 KEY RGB(0,67,171):NEXT
130 maxships=5
140 DIM spactive(maxships)
141 DIM spvx(maxships):DIM spvy(maxships)
142 DIM spx(maxships):DIM spy(maxships)
150 speedship=1
160 maxbullets=10
170 DIM buactive(maxbullets)
171 DIM bux(maxbullets):DIM buy(maxbullets)
172 buspeed=4
180 scoreship=100
182 plspeedx=2:plspeedy=2
185 BG 0 WINDOW 0,8,256,216 ON
186 MOVE BG 0 TO 0,8
187 REM PLAY "cdefg4graaaag4r4aaaag4r4ffffe4erddddc2"
190 CALL main:END
200 PROC doships
210 r=RND(256)
220 IF (r AND $7E)=2 THEN
230   FOR i=0 TO maxships-1
240     IF spactive(i)=0 THEN
250       spactive(i)=1
260       IF r AND 1 THEN
270         SPRITE 10+i FLAGS 2
275         spvx(i)=speedship
280         spvy(i)=0
290         spx(i)=-32
300       ELSE
305         SPRITE 10+i FLAGS 0
310         spvx(i)=-speedship
320         spvy(i)=0
330         spx(i)=256
340       ENDIF
350       spy(i)=RND(202)+8
355       SPRITE 10+i PATTERN shx,shy KEY RGB(0,0,0)
360       SPRITE 10+i ON
370       i=maxships-1:REM break
380     ENDIF
390   NEXT
400 ENDIF
410 FOR i=0 TO maxships-1
420   IF spactive(i) THEN
430     MOVE SPRITE 10+i TO spx(i),spy(i)
440     IF spactive(i)>1 THEN
450       SPRITE 10+i PATTERN EXx,EXy KEY RGB(0,248,0)
460       SPRITE 10+i FRAME spactive(i)>>5,(spactive(i)>>3) AND 3
470       spactive(i)=spactive(i)+1
480       IF spactive(i)=64 THEN
490         spactive(i)=0
500         SPRITE 10+i OFF
510       ENDIF
520     ELSE
530       FOR j=0 TO maxbullets-1
540         IF SPRCOLL(10+i,16+j) THEN
550           spactive(i)=2
560           spvx(i)=0:spvy(i)=0
570           buactive(j)=0
580           SPRITE 16+j OFF
590           score=score+scoreship
592           speedship=1+score/10000
595           LOCATE 7,0:PRINT score
600           SOUND 2,3,10,400
610         ENDIF
620       NEXT
630     ENDIF
640     spx(i)=spx(i)+spvx(i)
650     spy(i)=spy(i)+spvy(i)
660     IF spx(i)>256 OR spx(i)<-32 THEN
670       spactive(i)=0
680       SPRITE 10+i OFF
690     ENDIF
700   ENDIF
710 NEXT
720 RETURN
730 PROC main
740 REM XXX: sound
750 hiscore=0
760 DO
764   LOCATE 0,0:PRINT " SCORE 0                        ";
765   LOCATE 16,0:PRINT "HI ";hiscore
770   tic=0
780   dead=0
790   plx=104
800   ply=153
810   bulletwait=0
820   pldir=1
830   MOVE SPRITE 0 TO plx,ply
840   FOR i=0 TO maxbullets-1
850     SPRITE 16+i OFF
860     buactive(i)=0
870   NEXT
880   FOR i=0 TO maxships-1
890     SPRITE 10+i OFF
900     spactive(i)=0
910   NEXT
915   SPRITE 0 FLAGS 2
917   fr=FRAME()
920   DO
930     VSYNC fr+1
935     fr=FRAME()
940     p=PAD(0)
950     REM XXX: pause
960     IF p AND LEFT THEN
965       pldir=-1
970       SPRITE 0 FLAGS 0
980       IF plx>-8 THEN plx=plx-plspeedx
985       tic=tic+1
990     ENDIF
1000     IF p AND RIGHT THEN
1005       pldir=1
1010       SPRITE 0 FLAGS 2
1020       IF plx<232 THEN plx=plx+plspeedx
1025       tic=tic+1
1030     ENDIF
1040     IF (p AND UP) AND ply>9 THEN ply=ply-plspeedy
1050     IF (p AND DOWN) AND ply<212 THEN ply=ply+plspeedy
1060     IF (p AND 512) AND bulletwait=0 THEN
1070       FOR i=0 TO maxbullets-1
1080         IF buactive(i)=0 THEN
1090           buactive(i)=pldir
1100           bux(i)=plx+8+pldir*16
1110           buy(i)=ply+10
1120           bulletwait=10
1130           IF pldir>0 THEN SPRITE 16+i FLAGS 2:ELSE SPRITE 16+i FLAGS 0
1140           SOUND 1,119,20,40
1150           SPRITE 16+i ON
1155           i=maxbullets-1:REM break
1160         ENDIF
1170       NEXT
1180     ENDIF
1190     IF bulletwait<>0 THEN bulletwait=bulletwait-1
1200     FOR i=0 TO maxbullets-1
1210       IF buactive(i)<>0 THEN
1220         MOVE SPRITE 16+i TO bux(i),buy(i)
1230         bux(i)=bux(i)+buactive(i)*buspeed
1240         IF bux(i)>256 OR bux(i)<-16 THEN
1250           buactive(i)=0
1260           SPRITE 16+i OFF
1270         ENDIF
1280       ENDIF
1290     NEXT
1300     CALL doships
1310     FOR i=0 TO maxships-1
1320       IF spactive(i)=1 AND SPRCOLL(0,10+i) THEN
1325         REM SPRITE 0 FLAGS 4:VSYNC
1326         FOR j=0 TO 180 STEP 8
1327           MOVE SPRITE 0 TO plx-(SPRW(0)-32)/2,ply-SIN(j/360*3.14152*2)*60
1328           SPRITE 0 ANGLE j:VSYNC
1329         NEXT j
1338         LOCATE 11,9:BG 0 OFF:PRINT "GAME OVER"
1340         SOUND 1,91,38,500:WAIT 500:SOUND 1,91,34,1500:WAIT 2500
1345         LOCATE 11,9:PRINT "         ":BG 0 ON
1350         dead=1
1360         IF score>hiscore THEN hiscore=score
1365         score=0:speedship=1
1366         SPRITE 0 ANGLE 0
1370       ENDIF
1380     NEXT
1390     MOVE SPRITE 0 TO plx,ply
1400     SPRITE 0 FRAME 0,(tic>>2) AND 3
1420   LOOP UNTIL dead=1
1430 LOOP
