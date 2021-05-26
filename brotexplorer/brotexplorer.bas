REM Brotexplorer by SanguineBrah
REM modified by Ulrich Hecht

screen 1:palette 0

REM set initial conditions
capnum=0
maxiteration=100
ioffsetx=-0.5
ioffsety=0
iscale=3
offsetx=ioffsetx
offsety=ioffsety
renderscale=iscale
CPOSX=0
CPOSY=0
cxspeed=PSIZE(0)*0.005
cyspeed=PSIZE(1)*0.005
zoomfactor=3
colsalt=RND(1)*255

REM load graphics
LOAD PCX "border.pcx" AS BG 0:LOAD PCX "border.pcx" AS BG 1
BG 0 TILES 1,CSIZE(1)WINDOW PSIZE(0)-9,0,9,PSIZE(1)-8 ON 
BG 1 TILES CSIZE(0)-1,1 WINDOW 0,PSIZE(1)-9,PSIZE(0),9 ON 
LOAD PCX "xcursor.pcx" AS SPRITE 0 KEY 0
SPRITE 0 ON 
LOAD PCX "ycursor.pcx" AS SPRITE 1 KEY 0
SPRITE 1 ON 
CALL wipeit

REM main loop
DO 
  REM cursor and input handling
  CALL updatepad
  IF pad1<>0 THEN 
    renderscale=renderscale*zoomfactor
    CALL wipeit
  ENDIF 
  IF pad2<>0 THEN 
    coffsetx=(CPOSX/(PSIZE(0)-9))-0.5
    coffsety=(CPOSY/(PSIZE(1)-9))-0.5
    offsetx=offsetx+(coffsetx*renderscale)
    offsety=offsety+(coffsety*renderscale)
    renderscale=renderscale/zoomfactor
    CALL wipeit
  ENDIF 
  IF pad3<>0 THEN colsalt=RND(0)*255:CALL wipeit
  IF pad4<>0 THEN 
    SAVE PCX STR$(capnum)+".pcx"SIZE PSIZE(0)-8,PSIZE(1)-8
    GPRINT 0,0,"Captured render as "+STR$(capnum)+".pcx";
    capnum=capnum+1
  ENDIF 
  IF padup<>0 THEN CPOSY=CPOSY-cyspeed 
  IF paddown<>0 THEN CPOSY=CPOSY+cyspeed 
  IF padleft<>0 THEN CPOSX=CPOSX-cxspeed 
  IF padright<>0 THEN CPOSX=CPOSX+cxspeed 
  IF CPOSX<0 THEN CPOSX=0 
  IF CPOSX>PSIZE(0)-9 THEN CPOSX=PSIZE(0)-9 
  IF CPOSY<0 THEN CPOSY=0 
  IF CPOSY>PSIZE(1)-9 THEN CPOSY=PSIZE(1)-9 
  MOVE SPRITE 0 TO CPOSX-4,PSIZE(1)-9
  MOVE SPRITE 1 TO PSIZE(0)-9,CPOSY-4

  REM render as many pixels as possible this frame
  DO 
    IF yp<PSIZE(1)-9 THEN 
      x=0
      y=0
      x0=((xp/(PSIZE(0)-8))-0.5)
      x0=x0*renderscale
      x0=x0+offsetx
      y0=((yp/(PSIZE(1)-8))-0.5)
      y0=y0*renderscale
      y0=y0+offsety
      iteration=0
      WHILE x*x+y*y<=(2*2) AND iteration<maxiteration
        xtemp=x*x-y*y+x0
        y=2*x*y+y0
        x=xtemp
        iteration=iteration+1
      WEND 
      IF iteration<>maxiteration THEN c=iteration ELSE c=0 
      PSET xp,yp,c+colsalt MOD 255
      xp=xp+8
      IF xp>PSIZE(0)-10 THEN yp=yp+1:xp=(yp*3+xoff) and 7
      if yp>PSIZE(1)-10 then yp=0:xoff=xoff+3
    ENDIF 
  LOOP UNTIL f<FRAME()

  VSYNC f+1
  f=f+1
LOOP 

PROC wipeit
CLS 
xp=0
yp=0
xoff = 0
f=FRAME()
RETURN 

PROC updatepad
@padstate=PAD(0,1)
padup=RET(2) AND UP
paddown=RET(2) AND DOWN
padleft=RET(2) AND LEFT
padright=RET(2) AND RIGHT
pad1=@padstate AND 256
pad2=@padstate AND 512
pad3=@padstate AND 1024
pad4=@padstate AND 2048
RETURN 
