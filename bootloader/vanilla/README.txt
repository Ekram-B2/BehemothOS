Author: Ekram Bhuiyan
Date: May 26, 2020

Notes and tools used for this project are availible here at these links:

- https://www.cs.princeton.edu/courses/archive/fall16/cos318/projects/project1/p1.html
- http://3zanders.co.uk/2017/10/13/writing-a-bootloader/ 
- https://wiki.qemu.org/Main_Page
- https://cs.lmu.edu/~ray/notes/nasmtutorial/

This is a vanilla implementation with none of my design decisions incorporated. Rather, the code
written here is help me get to a point where I can make my own design decisions on my bootloader.

The assembler used for this project is the netwide assembler (nasm) and the tool used for virtualization
is QEMU (a generic an open source machine emulator and virtualizer)


# Start Instructions

Ubuntu 16.04 LTS
64-bit OS

- Install nasm and qemu executables on your system. The apt-get package manager can be used here
    sudo apt-get install nasm qemu

The basic hello world code in nasm can be found here:
    
    bits 16 ; tell NASM this is 16 bit code
    org 0x7c00 ; tell NASM to start outputting stuff at offset 0x7c00
    boot:
        mov si,hello ; point si register to hello label memory location
        mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
    .loop:
        lodsb
        or al,al ; is al == 0 ?
        jz halt  ; if (al == 0) jump to halt label
        int 0x10 ; runs BIOS interrupt 0x10 - Video Services
        jmp .loop
    halt:
        cli ; clear interrupt flag
        hlt ; halt execution
    hello: db "Hello world!",0

    times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
    dw 0xaa55 ; magic bootloader magic - marks this 512 byte sector bootable!

These can be compiled to a binary that can then be run on an x86 architecture by running
    
    nasm -f bin boot1.asm -o boot1.bin

To run the code using the qemu machine emulator, run this command
    qemu-system-x86_64 -fda boot1.bin



