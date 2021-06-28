This module contains the SAM speech synthesizer that was previously built
into the BASIC Engine firmware.

To be able to use the `SAY` command, you have to either run `LOADMOD "sam"`,
or add the line `#REQUIRE "sam"` at the start of your BASIC program.

This module also shows how to implement modules in C++ using the (very
limited) run-time support provided by the Engine BASIC API. It cannot be
compiled using the on-board TCC compiler because TCC does not support C++.

To re-compile the SAM module using a cross-compiler, edit `Makefile` and
change `BE_SYSDIR` to point to the `/sys/include` file of a BASIC Engine SD
card image.
