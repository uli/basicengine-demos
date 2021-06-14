#REQUIRE "famicom"
INPUT "ROM file? ";rom$

FAMIMOVE PSIZE(0)-256, 0
FAMILOAD rom$

DO
  'start screen?
  IF FAMIREAD($0770)=0 THEN 
    inp=16 'start
  ELSE 
    inp=RIGHT
  ENDIF 

  'run?
  IF RND(0)>0.2 THEN inp=inp OR 256 

  FAMINPUT inp
  CALL fam(RND(30)+20)

  inp=inp AND NOT 16 'release start (if set)
  IF RND(0)>0.2 THEN inp=inp OR 256 

  FAMINPUT inp OR 512 'jump
  CALL fam(RND(30)+20)
LOOP

PROC fam(count)
FOR @i=1 TO @count
  FAMULATE
  'VSYNC
NEXT 
RETURN 
