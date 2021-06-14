Example showing how to use the scriptable Famicom emulator module.

- `play.bas` relays input from the (emulated or real) gamepad to the
  emulator.
- `autoplay.bas` contains a simple algorithm that plays Super Mario Bros.

(ROM images are not included and have to be obtained separately. Only
mappers 0, 1, 2 and 4 are supported.)

Shows how to use `#REQUIRE` to ensure specific modules are loaded.

The source code for the emulator module can be found in the
`sys/modules/famicom` directory.
