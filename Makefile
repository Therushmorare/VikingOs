# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

kernel.bin: kernel-entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel-entry.o: kernel-entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c $< -o $@

mbr.bin: bootloader.asm
	nasm $< -f bin -o $@

os-image.bin: bootloader.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	rm -f *.bin *.o *.dis
