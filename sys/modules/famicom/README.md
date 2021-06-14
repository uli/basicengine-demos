Module that extends Engine BASIC with a scriptable Famicom emulator.

If the module resides in `/sys/modules/famicom`, it can be loaded using
`LOADMOD "famicom"`, or by adding a `#REQUIRE "famicom"` directive at the
start of a BASIC program.

When loaded, the following additional BASIC commands/functions are
available:

- `FAMILOAD "<rom image>" initializes the emulator and loads a Famicom/NES
  ROM file in iNES format
- `FAMULATE` emulates one frame.
- `FAMIEND` ends the emulator.
- `FAMIREAD(addr)` returns the contents of the emulated memory at `addr`.
- `FAMIMOVE x,y` moves the emulated screen to the given position.

This demo shows how to:
- extend Engine BASIC with new commands and functions
- provide custom background layers for the BG/sprite engine
- cross-compile Engine BASIC modules

(The module can be compiled from source from within Engine BASIC using `TCC
"fami.c"` and `TCCLINK "famicom"`, but due to the near-absence of
optimizations in the built-in TCC compiler it will then not run at full
speed on most devices.)

Please note that the emulation engine is neither complete nor optimized for
speed.
