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

# link with -nostdlib to make modules compatible with both glibc and uclibc builds
CFLAGS = -O3 -fPIC -Wall -I. -I$(BE_SYSDIR)/include -nostdlib -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t
ARM_CFLAGS = 
X64_CFLAGS = 

OBJS_ARM = debug_arm.o ESP8266SAM_arm.o reciter_arm.o render_arm.o sam_core_arm.o module_arm.o
OBJS_X64 = debug_x86_64.o ESP8266SAM_x86_64.o reciter_x86_64.o render_x86_64.o sam_core_x86_64.o module_x86_64.o

all: sam_arm.so sam_x86_64.so

sam_arm.so: $(OBJS_ARM)
	$(ARM_CROSS_COMPILE)g++ $(CFLAGS) $(ARM_CFLAGS) -o $@ -shared $(OBJS_ARM)

sam_x86_64.so: $(OBJS_X64)
	$(X64_CROSS_COMPILE)g++ $(CFLAGS) $(X64_CFLAGS) -o $@ -shared $(OBJS_X64)

%_arm.o: %.c
	$(ARM_CROSS_COMPILE)gcc $(CFLAGS) $(ARM_CFLAGS) -c -o $@ $<
%_x86_64.o: %.c
	$(X64_CROSS_COMPILE)gcc $(CFLAGS) $(X64_CFLAGS) -c -o $@ $<
%_arm.o: %.cpp
	$(ARM_CROSS_COMPILE)g++ $(CFLAGS) $(ARM_CFLAGS) -c -o $@ $<
%_x86_64.o: %.cpp
	$(X64_CROSS_COMPILE)g++ $(CFLAGS) $(X64_CFLAGS) -c -o $@ $<

clean:
	rm -f *.o *.so

