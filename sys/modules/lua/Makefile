# point this to the Engine BASIC system directory, either the one on the SD
# card image (/sys), or the one created using the "init_dir" target of the
# Engine BASIC Makefiles (<source directory>/init_dir/sys)
BE_SYSDIR = ../../../../enginebasic/init_dir/sys

# point this to the location of the buildroot toolchain bin directory
TOOLCHAIN_BIN_ARM = ../../../../buildroot/output_opi/host/bin
TOOLCHAIN_BIN_X64 = ../../../../buildroot/output_pc/host/bin

# prefixes of the toolchains for the different CPU architectures
ARM_CROSS_COMPILE = $(TOOLCHAIN_BIN_ARM)/arm-buildroot-linux-uclibcgnueabihf-
X64_CROSS_COMPILE = $(TOOLCHAIN_BIN_X64)/x86_64-buildroot-linux-uclibc-

CFLAGS = -O3 -fPIC -Wall -Wno-unused-function -DENGINEBASIC -I$(BE_SYSDIR)/include -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t -D_GNU_SOURCE
ARM_CFLAGS = $(CFLAGS)
X64_CFLAGS = $(CFLAGS)

SRCS =	lua_be.c lua_bg.c lua_img.c lua_input.c lua_io.c lua_video.c \
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

all: lua_arm.so lua_x86_64.so

lua_arm.so: $(ARM_OUT_OBJS)
	$(ARM_CROSS_COMPILE)g++ -nostdlib -shared -o lua_arm.so $(ARM_OUT_OBJS) -llua

lua_x86_64.so: $(X64_OUT_OBJS)
	$(X64_CROSS_COMPILE)g++ -nostdlib -shared -o lua_x86_64.so $(X64_OUT_OBJS) -llua

clean:
	rm -fr build_arm build_x86_64 lua_arm.so lua_x86_64.so
