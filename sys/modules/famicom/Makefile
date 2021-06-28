# point this to the Engine BASIC system directory, either the one on the SD
# card image (/sys), or the one created using the "init_dir" target of the
# Engine BASIC Makefiles (<source directory>/init_dir/sys)
BE_SYSDIR = ../../../../enginebasic/init_dir/sys

# prefixes of the toolchains for the different CPU architectures
ARM_CROSS_COMPILE = ~/x-tools/arm-unknown-eabihf/bin/arm-unknown-eabihf-
X64_CROSS_COMPILE = 

CFLAGS = -O3 -Wall -I$(BE_SYSDIR)/include -nostdlib -ffreestanding -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t
ARM_CFLAGS = -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a7
X64_CFLAGS = 

all: famicom_arm.o famicom_x86_64.o

famicom_arm.o: fami.c agnes.h
	$(ARM_CROSS_COMPILE)gcc $(CFLAGS) $(ARM_CFLAGS) -c -o famicom_arm.o fami.c
famicom_x86_64.o: fami.c agnes.h
	$(X64_CROSS_COMPILE)gcc $(CFLAGS) $(X64_CFLAGS) -c -o famicom_x86_64.o fami.c

clean:
	rm -f famicom_arm.o famicom_x86_64.o
