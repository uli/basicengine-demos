# point this to the Engine BASIC system directory, either the one on the SD
# card image (/sys), or the one created using the "init_dir" target of the
# Engine BASIC Makefiles (<source directory>/init_dir/sys)
BE_SYSDIR = ../../../../enginebasic/init_dir/sys

# prefixes of the toolchains for the different CPU architectures
ARM_CROSS_COMPILE = ~/x-tools/arm-unknown-eabihf/bin/arm-unknown-eabihf-
X64_CROSS_COMPILE = 

CFLAGS = -O3 -fpic -Wall -Wno-unused-function -DENGINEBASIC -I$(BE_SYSDIR)/include -nostdlib -ffreestanding -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t -D_GNU_SOURCE
ARM_CFLAGS = $(CFLAGS) -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a7
X64_CFLAGS = $(CFLAGS)

SRCS = lapi.c lauxlib.c lbaselib.c lcode.c lcorolib.c lctype.c \
	ldblib.c ldebug.c ldo.c ldump.c lfunc.c lgc.c linit.c \
	liolib.c llex.c lmathlib.c lmem.c loadlib.c lobject.c \
	lopcodes.c loslib.c lparser.c lstate.c lstring.c lstrlib.c \
	ltable.c ltablib.c ltests.c ltm.c lundump.c lutf8lib.c lvm.c \
	lzio.c \
	lua_be.c lua_bg.c lua_img.c lua_input.c lua_io.c lua_video.c \
	sys.c

OBJS = $(SRCS:.c=.o)

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

all: lua_arm.o lua_x86_64.o

lua_arm.o: $(ARM_OUT_OBJS)
	$(ARM_CROSS_COMPILE)ld -r -o lua_arm.o $(ARM_OUT_OBJS)

lua_x86_64.o: $(X64_OUT_OBJS)
	$(X64_CROSS_COMPILE)ld -r -o lua_x86_64.o $(X64_OUT_OBJS)

clean:
	rm -fr build_arm build_x86_64 lua_arm.o lua_x86_64.o
