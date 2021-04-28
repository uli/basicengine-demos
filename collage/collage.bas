' Slideshow program that randomly blends together JPG images from a
' directory; requires an Engine BASIC platform with true color support.

alpha_border_width=30
max_img_scale=0.8
min_img_scale=0.2

SCREEN 20:PALETTE 2	' 1920x1080, true color

FILES:INPUT "directory? ";dr$

OPEN dr$ FOR DIRECTORY AS #1
' Reading large directories from SD can take some time, so we only
' load the first couple of entries and do the rest while the slideshow is
' running.
CALL scandir(400)

'PRINT
'PRINT LEN(~imgs$)

alpha_scale=255/alpha_border_width
offoff=PSIZE(1)         ' first line in off-screen pixel memory

DO 
  f$=~imgs$(RND(LEN(~imgs$)))

  IMGINFO f$
  img_w=RET(0)
  img_h=RET(1)

  ' pick a random position for the image
  posx=RND(PSIZE(0)*1.2)-PSIZE(0)*0.3
  posy=RND(PSIZE(1)*1.2)-PSIZE(1)*0.3

  ' pick a random scale, within the given parameters
  min_scal=PSIZE(0)*min_img_scale/img_w
  min_scal_h=PSIZE(1)*min_img_scale/img_h
  IF min_scal_h>min_scal THEN min_scal=min_scal_h

  max_scal=PSIZE(0)*max_img_scale/img_w
  max_scal_h=PSIZE(1)*max_img_scale/img_h
  IF max_scal_h<max_scal THEN max_scal=max_scal_h

  scal=RND(0)*(max_scal-min_scal)+min_scal

  out_w=INT(img_w*scal)
  out_h=INT(img_h*scal)

  'PRINT f$;" ";posx;" ";posy

  ' load the image, scale it and put it in off-screen pixel memory
  LOAD IMAGE f$ TO 0,offoff SCALE scal,scal

  ' fade the image borders by setting the alpha channel around the edges
  FOR d=0 TO alpha_border_width
    alpha_value=INT(d*alpha_scale)<<24
    FOR x=d TO out_w-d-1
      PSET x,d+offoff,(POINT(x,d+offoff) AND $00FFFFFF) OR alpha_value
      PSET x,offoff+out_h-d-1,POINT(x,offoff+out_h-d-1) AND $00FFFFFF OR alpha_value
    NEXT 
    FOR y=d TO out_h-d-1
      PSET d,offoff+y,POINT(d,offoff+y) AND $00FFFFFF OR alpha_value
      PSET out_w-d-1,offoff+y,POINT(out_w-d-1,offoff+y) AND $00FFFFFF OR alpha_value
    NEXT 
  NEXT 

  ' blend the image onto the visible screen
  BLIT 0,offoff TO posx,posy SIZE out_w,out_h ALPHA 

  CALL scandir(100)	' find more files
LOOP 

END 

PROC debug
FOR i=0 TO alpha_border_width+10
  FOR j=0 TO alpha_border_width+10
    ?HEX$(POINT(i,j+offoff)>>24);" ";
  NEXT 
  ?
NEXT 
RETURN

PROC scandir(max)
@count=0
DO 
  @f$=DIR$(1)
  IF RIGHT$(@f$,4)=".jpg" OR RIGHT$(@f$,5)=".jpeg" THEN 
    APPEND ~imgs$,dr$+"/"+@f$
    'LOCATE 0,POS(1)-1:?LEN(~imgs$)
    @count=@count+1
  ENDIF 
LOOP UNTIL @f$="" or @count>@max
RETURN
