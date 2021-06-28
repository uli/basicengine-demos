# point this to the Engine BASIC system directory, either the one on the SD
# card image (/sys), or the one created using the "init_dir" target of the
# Engine BASIC Makefiles (<source directory>/init_dir/sys)
BE_SYSDIR = ../../../../enginebasic/init_dir/sys

# prefixes of the toolchains for the different CPU architectures
ARM_CROSS_COMPILE = ~/x-tools/arm-unknown-eabihf/bin/arm-unknown-eabihf-
X64_CROSS_COMPILE = 

CFLAGS = -O3 -Wall -I. -I$(BE_SYSDIR)/include -nostdlib -ffreestanding  -D_GNU_SOURCE -DPIXEL_TYPE=uint32_t -DIPIXEL_TYPE=uint32_t
ARM_CFLAGS = -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a7
X64_CFLAGS = 

OBJS_ARM = debug_arm.o ESP8266SAM_arm.o reciter_arm.o render_arm.o sam_core_arm.o module_arm.o
OBJS_X64 = debug_x86_64.o ESP8266SAM_x86_64.o reciter_x86_64.o render_x86_64.o sam_core_x86_64.o module_x86_64.o

all: sam_arm.o sam_x86_64.o

sam_arm.o: $(OBJS_ARM)
	$(ARM_CROSS_COMPILE)ld -o $@ -r $(OBJS_ARM)

sam_x86_64.o: $(OBJS_X64)
	$(X64_CROSS_COMPILE)ld -o $@ -r $(OBJS_X64)

%_arm.o: %.c
	$(ARM_CROSS_COMPILE)gcc $(CFLAGS) $(ARM_CFLAGS) -c -o $@ $<
%_x86_64.o: %.c
	$(X64_CROSS_COMPILE)gcc $(CFLAGS) $(X64_CFLAGS) -c -o $@ $<
%_arm.o: %.cpp
	$(ARM_CROSS_COMPILE)g++ $(CFLAGS) $(ARM_CFLAGS) -c -o $@ $<
%_x86_64.o: %.cpp
	$(X64_CROSS_COMPILE)g++ $(CFLAGS) $(X64_CFLAGS) -c -o $@ $<

clean:
	rm -f *.o

