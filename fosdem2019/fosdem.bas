goto &start

rem demo code for slides

10 print "Hello, World!"
20 goto 10

30 FOR i=1 to n
40 CALL build_basicengine
50 NEXT

&start

sprite off
bg off
window off

maxslide=20
slide=0

if slide=0 then
	call setcolcodes
	call cover:while inkey()=0:wend
	slide=1
endif

100 rem restart

sprite off
bg off
window off
screen 2
cls
palette 1
call setcolcodes

if slide<1 then
        slide = 1
elseif slide>maxslide then
        slide=maxslide
endif

do
  gosub slide*1000
  slide=slide+ret(0)+2
loop

proc nav
&navloop:
  @k=inkey()
  if @k=387 then slide=slide+1:run 100
  if @k=386 then slide=slide-1:run 100
  if @k<>0 then return @k
goto &navloop

proc navnb
  @k=inkey()
  if @k=387 then slide=slide+1:run 100
  if @k=386 then slide=slide-1:run 100
  return @k

proc center(t$, em$, y)
  @x=(csize(0)-len(@t$))/2
  locate @x,@y
  print @em$;@t$;cdef$
  return

proc title(t$)
  cls
  locate 0, csize(1)-1:print chi$;"https://basicengine.org/";cdef$;
  locate csize(0)-13, csize(1)-1:print "Ulrich Hecht";
  locate 0,0
  print chi$;"Introduction to the ";cbe$;"BASIC Engine"
  locate csize(0)-11,0:print chi$;"FOSDEM 2019";
  font 2
  call center(@t$, cti$, 3)
  font 0
  print
  return

proc cover
  font 2
  @xc=csize(0)/2
  @yc=csize(1)/2
  locate @xc-15,@yc-2
  print chi$;"Introduction to the ";cbe$;"BASIC Engine"
  locate @xc-5,@yc+4
  print chi$;"FOSDEM 2019"
  locate @xc-5,@yc+6
  print cdef$;"Ulrich Hecht"
  font 0
  return

proc setcolcodes
  call colcode(192,192,192):cdef$=ret$(0)
  call colcode(200,0,0):cbe$=ret$(0)
  call colcode(255,255,255):chi$=ret$(0)
  call colcode(0,255,0):cti$=ret$(0)
  return

proc bul(t$)
  print cbe$;"* ";cdef$;@t$
  print
return

proc bulp(t$)
  call bul(@t$)
  call nav
  return

proc subhdr(t$)
  font2:print chi$;@t$;cdef$:font0:print
  return

proc subhdrp(t$)
  call subhdr(@t$)
  call nav
  return

proc colcode(r,g,b)
  @c$=hex$(rgb(@r,@g,@b))
  while len(@c$)<2
    @c$="0"+@c$
  wend
  return "\f"+@c$

rem === SLIDES

1000 call title("Who am I?")

call bul("My name is Ulrich Hecht.")
call bul("I am a freelance software engineer.")
call bul("I write Linux drivers for embedded systems for a living.")
call bul("I sometimes do fun stuff with small and/or retro systems.")
print
call bul("Professional web site: "+chi$+"http://fpond.eu/"+cdef$)

do:call nav:loop
return

2000 call title("What is the BASIC Engine?")

load pcx "rev1p.pcx" to (psize(0)-240)/2,(psize(1)-140)/2

do
  n=fn nav()
  rem do demo
loop
return

3000 call title("What is the BASIC Engine?")

load pcx "rev1_smallp.pcx" to 0,(psize(1)-140)/2+16

window 25,7,csize(0)-30,csize(1)-10
call bulp("Low-cost single board computer")
call bulp("Programmable in BASIC")
call bulp("Advanced 2D color graphics and sound")
call bulp("Build it at home for less than 10 Euros")

do
  n=fn nav()
  rem do demo
loop
return

4000 call title("Hardware")

load pcx "rev1_smallp.pcx" to 0,(psize(1)-140)/2+16

window 25,7,csize(0)-30,csize(1)-9
call bulp(chi$+"160 MHz CPU"+cdef$+" and "+chi$+"4 MB flash"+cdef$+" memory")
call bulp(chi$+"128 KB video RAM"+cdef$+", "+chi$+"PAL or NTSC"+cdef$+" video")
call bulp("5-bit "+chi$+"PCM sound"+cdef$)
call bulp(chi$+"MicroSD"+cdef$+" card slot")
call bulp("PS/2 and USB"+cti$+"*"+chi$+" keyboard interface"+cdef$)
call bulp(chi$+"PlayStation"+cdef$+" controller port")
call bulp(chi$+"16 GPIOs"+cdef$+", "+chi$+"I2C and SPI"+cdef$+" on expansion"+chr$(10)+"  connector")

do
  n=fn nav()
  rem do demo
loop
return

proc motion
  @of = sx mod 160
  if @of > 80 then @of = 160-@of
  @of1 = sx mod 70
  if @of1 > 35 then @of1 = 70-@of1
  move sprite 0 to x+15+@of,y+5+@of1/3
  move sprite 1 to x+100-@of/1.5,y+100
  move sprite 2 to x+130,y+70-@of1
  move bg 0 to sx,16
  move bg 1 to sx*1.5,0
  move bg 2 to sx*2,0
  sx = sx + 1
  rem rect x-8,y,x,y+h,0,0
  rem rect x+w+16,y,x+w+23,y+h,0,0
  vsync
  return

5000 call title("Graphics and Sound")

window 2,6,csize(0)/2-4,csize(1)-6
call bulp(chi$+"256-color"+cdef$+" graphics, 160x200 to  460x224 pixels (PAL: 508x240)")

rem must set the tile size first for "LOAD PCX ... AS BG" to work
for i=0 to 2:
	bg i size 16,16
next

load pcx "scene_wide.pcx" as bg 0
rem BG doesn't support range yet, have to set the patterns for 1 and 2 manually
px=ret(0):py=ret(1)

bg 1 tiles 16,1 pattern px,py,16
bg 2 tiles 16,1 pattern px,py,16

load bg 0,"scene.bg"

rem grass for the upper layers
for i = 0 to 15
  plot 1,i,0,32+(i mod 8)
  plot 2,i,0,32+(i mod 8)
next

x = psize(0)/2
y = 6*8
w = psize(0)/2-24
h = psize(1)-10*8

bg 0 window x,y,w,h on
bg 1 window x,y+h-40,w,16 off
bg 2 window x,y+h-24,w,16 off

call bul(chi$+"Tiled background graphics"+cdef$+"...")

sx=0
while fn navnb()=0
  move bg 0 to sx,16
  sx = sx + 1
  rem rect x-8,y,x,y+h,0,0
  rem rect x+w+16,y,x+w+23,y+h,0,0
  vsync
wend

rem bg layer 1, 2
print"  ...with up to four layers..."

bg 1 on
bg 2 on
while fn navnb()=0
  move bg 0 to sx,16
  move bg 1 to sx*1.5,0
  move bg 2 to sx*2,0
  sx = sx + 1
  rem rect x-8,y,x,y+h,0,0
  rem rect x+w+16,y,x+w+23,y+h,0,0
  vsync
wend

rem sprites

print"  ...and up to 32 ";chi$;"sprites";cdef$:print

for i=0 to 2
 move sprite i to 0,0
 sprite i size 32,32 key 0 flags 2
next
load pcx "ship.pcx" size 32,32 as sprite 0-2
for i=0 to 2
 sprite i on
next

while fn navnb()=0
  call motion
wend

call bul(chi$+"Wavetable synthesizer"+cdef$+"...")

print"  ...plays music in MML format"
m$="T200a4eef+4e4r4g+4a4"
print"     ";cti$;chr$(34);m$;chr$(34);cdef$
play m$
while fn navnb()=0
  call motion
wend

print"  ...and can be used for sound"
print"  effects."
tim=tick()
count=0
while fn navnb()=0 and count < 5
  if tick()-tim >= 200 then
	sound 1,119,20,40
	tim=tick()
	count=count+1
  endif
  call motion
wend
sound 2,3,10,400

do
while fn navnb()<256
  call motion
wend
loop

return

6000 call title("Origins of the BASIC Engine")

font2:print chi$;"I wanted a computer that";cdef$:font0
print
call bulp("connects to a TV and a keyboard")
call bulp("can be programmed in BASIC and is self-hosted")
call bulp("is colorful and noisy")
call bulp("can be made at home for cheap without obsolete parts")
font2:print chi$;"Why did I want that?";cdef$:font0
print
call bulp("https://basicengine.org/history.html")
call subhdrp("Somebody must have done that already, right?")
call bulp("Short answer: No.")
call bulp("Long answer: Almost...")

do:call nav:loop
return

7000 call title("The Inspiration: Toyoshiki Tiny BASIC System")

load pcx "toyoshikip.pcx" to 40,36

do
  n=fn nav()
  rem do demo
loop
return

8000 call title("What is the Toyoshiki Tiny BASIC System?")

load pcx "toyoshiki_smallp.pcx" to 16,(psize(1)-140)/2+16
window 25,7,csize(0)-30,csize(1)-8

call bulp("An STM32 Blue Pill board")
call bulp("A CR2032 battery")
call bul("A few connectors:")
print "  * Keyboard"
print "  * SD card"
print "  * Video out"
print
call nav
call bulp("That's it. Nothing else.")
call bulp("Software-generated video via SPI")
call bulp("Runs Tiny BASIC")
call bulp("Costs virtually nothing")

do
  n=fn nav()
  rem do demo
loop
return

9000 call title("Toyoshiki System: The Catch")

load pcx "toyoshiki_smallp.pcx" to 16,(psize(1)-140)/2+8
window 25,6,csize(0)-30,csize(1)-7

call bulp("Monochrome video only")
call bulp("No free memory worth speaking of")
call bulp("Firmware may or may not fit the device")
call subhdrp("Can it be fixed?")
call bulp("Additional circuit for color generation   consumes lots of resources")
call bulp("Color graphics hog more memory")
call bulp("No way to expand memory with reasonable   performance")
call bulp("Better STM controllers are very pricy")

do:call nav:loop
return

10000 call title("Designing the BASIC Engine")

load pcx "be_proto1p.pcx" to psize(0)/2, psize(1)/6
y=pos(1)
locate csize(0)/1.7,csize(1)/1.8:print"BASIC Engine prototype"
locate 0,y

call subhdrp("Keep the good stuff:")
call bulp("Cheap and simple")
call bulp("Runs BASIC")
call bulp("Text system with screen editor")

call subhdr("Fix the shortcomings:")
call bulp("Add color")
call bulp("More free memory for BASIC")
call bulp("Better sound")

call subhdr("Dump burgeois luxuries:")
call bulp("A battery? Seriously?")

do:call nav:loop
return

11000 call title("Does Compute: Espressif ESP8266")

load pcx "esp8266p.pcx" to psize(0)/1.9,psize(1)/2

call nav
call subhdrp("What is an ESP8266?")
call bulp("Super-low-cost microcontroller for Internet of Things")
call bulp("Go-to solution for amateur IoT projects")
call bulp("Lots of power for bloated networking protocols...")
call bulp("...but no more than absolutely necessary...")
call bulp("...and thus feels a bit sluggish.")
call subhdrp("Why use it then?")
call bulp("We don't really need networking.")
call bul("Drop network support, and you are left")
print "\u  with a device that is ";chi$;"faster";cdef$;", ";chi$;"cheaper";cdef$;" and"
print "  has ";chi$;"more memory";cdef$;" than any comparable MCU."
print:call nav

do:call nav:loop
return

12000 call title("Moves the block: VLSI VS23S010")

load pcx "vs23s010p.pcx" to psize(0)/1.6, psize(1)/2
call nav
call subhdrp("What is a VS23S010?")
call bulp("128 KB SRAM chip with an SPI interface...")
call bulp("...and a video controller!")
call bulp("Turns the contents of its memory into composite video.")
call bulp("Has a blitter!")
call bulp("Cheapest"+cti$+"*"+cdef$+" analog video controller available!")
call bulp("Only analog video controller available.")
call subhdr("=> SOLD!")

do:call nav:loop
return

13000 call title("Engine BASIC")

rem window 37,5,35,5
window 42,5,28,5
list 10-20

window off:locate 0,5
call bulp(chi$+"Traditional BASIC"+cdef$+" interpreter")
call bul(chi$+"Structured programming"+cdef$+" constructs:")
print "  DO/LOOP, WHILE/WEND, IF/THEN/ELSE/ENDIF blocks"
print:call nav
call bulp(chi$+"Labels"+cdef$+" and named "+chi$+"procedures"+cdef$+" with "+chi$+"local variables"+cdef$)
call bulp("Numbers are "+chi$+"double-precision"+chi$+" floating point")
call bulp("String and numeric "+chi$+"list types"+cdef$)
call bul(chi$+"Escape codes"+cdef$+" for PRINT")
print "  Similar to the control characters in Commodore BASIC"
print:call nav
call bul(chi$+"Event handlers"+cdef$+":")
print "  Sprite collision, end-of-music, errors, game controller input"
call nav
locate csize(0)/2,csize(1)/2+2
print cbe$;"           For more features, go to";
locate csize(0)/2,csize(1)/2+3
print cti$;"https://basicengine.org/manual.html";cdef$
do:call nav:loop
return

14000 call title("Build one!")

call subhdrp("DO's:")
call bulp("Go to "+chi$+"https://basicengine.org/hardware.html"+cdef$)
call bulp("Buy parts and (very reasonably priced) tools.")
call bulp("Watch the assembly video.")
call bul("")
y=pos(1)
window 2,y-2,csize(0)-2,6
list30-50
window off
locate 0,y+2
call nav

call subhdrp("DONT's:")

call bulp("DO NOT listen to people claiming SMD soldering is hard.")
call bulp("DO NOT use solder paste.")

do:call nav:loop
return

15000 call title("Contribute!")

call bulp(chi$+"Build a BASIC Engine!"+cdef$+" -> https://basicengine.org/hardware.html")
call bulp(chi$+"Build ten BASIC Engines, then give them away!"+cdef$)
call bulp(chi$+"Write a demo!"+cdef$+" -> https://github.com/uli/basicengine-demos")
call bul(chi$+"Report a bug!"+cdef$+" -> https://github.com/uli/basicengine-firmware/issues")
print "  (You will find enough of those when writing that demo."
print "  Don't forget to include a test case!)"
print:call nav
call bulp(chi$+"Fix a bug!"+cdef$+" -> https://github.com/uli/basicengine-firmware/pulls")
print "  (Don't forget to run the test suite!)"
print
do:call nav:loop
return

16000 call title("Questions?")

do:call nav:loop
return

17000 call title("Bonus Content: BASIC Engine Shuttle")

load pcx "be_shuttlep.pcx" to 0,(psize(1)-140)/2
window csize(0)/2+4,5,csize(0)/2-6,csize(1)-6
call nav

call bulp("Faster")
call bulp("Smaller")
call bulp("Cheaper")
call bulp("More memory")
call bulp("Easier to build")
call bulp("Doesn't need VS23S010")
call subhdrp("BUT...")
call bulp("Doesn't work on every TV")
call bulp("That is probably not fixable")
window off
locate csize(0)/2-11, csize(1)-4
print "https://basicengine.org/hardware_shuttle.html"

do:call nav:loop
return

18000 do

call title("Bonus Content: XYZZY")
call nav
color rgb(192,192,192),rgb(0,0,128)
xyzzy "zork1.z3"
color 0,0:print cdef$;

loop

19000 call title("Work in Progress: Lua")

call bulp("Almost as simple as BASIC")
call bulp("Better at handling complex data structures")
call bulp("Not bloated or restricted or otherwise crap")
call bulp("Implemented: basic I/O, cls(), locate()")
call bulp("Not implemented: Everything else.")
call subhdr("=> Your chance to help out!")

do:call nav:loop

20000 call title("Bonus Content: Speech")

call bulp("SAM Speech Synthesizer")
call bulp("Reverse-engineered from C64 code")
call bulp("Stephen Hawking for pedestrians")

t$="Life would be tragic if it wasn't funny."
call center(chr$(34)+t$+chr$(34), chi$, 12)
rem Workaround: hosted build sometimes fails to render speech correctly.
rem Does not happen when run in valgrind, or in native build.
rem Can be avoided by "saying" a period first.
say ". "+t$

do:call nav:loop
return

