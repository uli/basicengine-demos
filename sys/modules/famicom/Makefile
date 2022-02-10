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

CFLAGS = -O3 -fPIC -Wall -I$(BE_SYSDIR)/include -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t
ARM_CFLAGS = 
X64_CFLAGS = 

all: famicom_arm.so famicom_x86_64.so

famicom_arm.so: fami.c agnes.h
	$(ARM_CROSS_COMPILE)gcc $(CFLAGS) $(ARM_CFLAGS) -nostdlib -shared -o famicom_arm.so fami.c
famicom_x86_64.so: fami.c agnes.h
	$(X64_CROSS_COMPILE)gcc $(CFLAGS) $(X64_CFLAGS) -nostdlib -shared -o famicom_x86_64.so fami.c

clean:
	rm -f famicom_arm.so famicom_x86_64.so
