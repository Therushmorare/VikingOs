[bits 16]
[org 0x7C00]

KERNEL_OFFSET equ 0x1000

; Save boot drive
mov [BOOT_DRIVE], dl

; Setup stack
mov bp, 0x9000
mov sp, bp

; Print message
mov si, paragraph
call print_string

call load_kernel
call switch_to_32bit

jmp $


; Load kernel to memory
load_kernel:
    mov bx, KERNEL_OFFSET ; destination offset
    mov dh, 2             ; number of sectors to read
    mov dl, [BOOT_DRIVE]  ; drive number
    call disk_load
    ret

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

; Data
BOOT_DRIVE db 0

paragraph db "VikingOS!This is an OS by Nathaniel Morare,Built by a developer for developers its Open-source and proud.", 0x0A
          db 0

; Include external logic
%include "disk.asm"
%include "gdt.asm"
%include "switch-to-32bit.asm"

; Define the 32-bit entry point here
[bits 32]
BEGIN_32BIT:
    call KERNEL_OFFSET  ; call the 32-bit kernel at offset
    jmp $               ; infinite loop if kernel returns

; Boot signature
times 510 - ($ - $$) db 0
dw 0xAA55