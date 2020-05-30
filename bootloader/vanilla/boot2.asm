bits 16
org 0x7C00

boot:
    mov ax, 0x2401
    int 0x15; Send an interrupt to the BIOS to enable the A20 line; Originally, there were 20 address lines and thus memory access
            ; was up to 1 MB 2^20. When systems supportng 24 address lines came to be, there was a backwards compatibility issue (old
            ; software perform overflow sort of operations) that broke some software. This was fixed by setting the 4 lines off (i.e 
            ; setting the A20 line to 0). The convention now by default is this line is disabled during the boot procedure. Setting the
            ; A20 line before entering protected mode is necessary to support it (within protected mode, the behaviour of the system
            ; should be such that it can access more address lines. By entering protected mode, we're able to make use of the
            ; 32 bit registers to store memory addresses
    mov ax, 0x3
    int 0x10; Send an interrupt to the BIOS to set the VGA text mode. This is necessary for the
            ; presentation of the textUI 

    lgdt [gdt_pointer] ; load the referant of the memory address
    
    mov eax, cr0 ; The CR0 register is a control register that modifies the general behaviour of the whole system 
    or eax, 0x1 ; set the protected bit. In doing it this way, I can preserve the flags of the other bits for this register
    mov cr0, eax
    jmp CODE_SEG:boot2; jump to the code segment of the global descriptor table


; define the global descriptor table
gdt_start:
    dq 0x0
gdt_code:
    dw 0XFFFF
    dw 0x0
    dw 0x0
    db 0x0 ; note that in 16 bit mode, 2 bytes are one word
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:


gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax




