# point this to the Engine BASIC system directory, either the one on the SD
# card image (/sys), or the one created using the "init_dir" target of the
# Engine BASIC Makefiles (<source directory>/init_dir/sys)
BE_SYSDIR = ../../../../enginebasic/init_dir/sys

# prefixes of the toolchains for the different CPU architectures
ARM_CROSS_COMPILE = ~/x-tools/arm-unknown-eabihf/bin/arm-unknown-eabihf-
X64_CROSS_COMPILE = 

CFLAGS = -O3 -Wall -DENGINEBASIC -I$(BE_SYSDIR)/include -nostdlib -ffreestanding -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t -U __UINT32_TYPE__ -U__INT32_TYPE__ -D__UINT32_TYPE__="unsigned int" -D__INT32_TYPE__=int
ARM_CFLAGS = $(CFLAGS) -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a7
X64_CFLAGS = $(CFLAGS)

SRCS = lapi.cpp lauxlib.cpp lbaselib.cpp lcode.cpp lcorolib.cpp lctype.cpp \
	ldblib.cpp ldebug.cpp ldo.cpp ldump.cpp lfunc.cpp lgc.cpp linit.cpp \
	liolib.cpp llex.cpp lmathlib.cpp lmem.cpp loadlib.cpp lobject.cpp \
	lopcodes.cpp loslib.cpp lparser.cpp lstate.cpp lstring.cpp lstrlib.cpp \
	ltable.cpp ltablib.cpp ltests.cpp ltm.cpp lundump.cpp lutf8lib.cpp lvm.cpp \
	lzio.cpp
OBJS = $(SRCS:.cpp=.o)

ARM_OUT_OBJS = $(addprefix build_arm/, $(OBJS))
X64_OUT_OBJS = $(addprefix build_x86_64/, $(OBJS))

build_arm/%.o: %.c
	@mkdir -p $(@D)
	$(ARM_CROSS_COMPILE)gcc $(ARM_CFLAGS) -o $@ -c $<

build_arm/%.o: %.cpp
	@mkdir -p $(@D)
	$(ARM_CROSS_COMPILE)g++ $(ARM_CFLAGS) -o $@ -c $<

build_arm/%.o: %.S
	@mkdir -p $(@D)
	$(ARM_CROSS_COMPILE)gcc $(ARM_CFLAGS) -o $@ -c $<

build_x86_64/%.o: %.c
	@mkdir -p $(@D)
	$(X64_CROSS_COMPILE)gcc $(X64_CFLAGS) -o $@ -c $<

build_x86_64/%.o: %.cpp
	@mkdir -p $(@D)
	$(X64_CROSS_COMPILE)g++ $(X64_CFLAGS) -o $@ -c $<

build_x86_64/%.o: %.S
	@mkdir -p $(@D)
	$(X64_CROSS_COMPILE)gcc $(X64_CFLAGS) -o $@ -c $<

lua_arm.o: $(ARM_OUT_OBJS)
	$(ARM_CROSS_COMPILE)ld -r -o lua_arm.o $(ARM_OUT_OBJS)

lua_x86_64.o: $(X64_OUT_OBJS)
	$(X64_CROSS_COMPILE)ld -r -o lua_x86_64.o $(X64_OUT_OBJS)

clean:
	rm -fr build_arm build_x86_64 lua_arm.o lua_x86_64.o
