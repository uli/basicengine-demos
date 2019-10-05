10 REM sprite data displayer
20 By Kevin Anderson
30 projektprodukt@yahoo.com
15 SCREEN 4:PALETTE 1
17 x=100:y=40
18 FOR a=1 TO 32
20   FOR b=1 TO 32
30     READ colr
40     PSET b+x,y+a,colr
60   NEXT b
70 NEXT a
