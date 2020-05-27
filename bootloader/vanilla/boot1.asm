; Tell NASM this is 16 bit code that assumes 16 bit registers

bits 16

; This instruction is to indicate to nasm the origin address to assume
; that the program begins at. The program is crammed within the
; 7C00-7DFF segment area (512 memory address starting at 7C00 up to (exclusive) 
; 7DFF

org 0x7c00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main Logic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; For readability, label this section as 'boot' wherein the memory address
; aliased at 'hello' is stored in register si. Add an operand to the
; ah register so that when I made BIOS calls as a service, it will write
; in teletype mode. To the screen, it will write one character to the
; cursor's current location, and then advance the cursor

boot:
    mov si,hello ; point si register to hello label memory location
    mov ah,0x0e ; 0x0e means write in TTY mode

; This logic will load the least significant byte from the data stored at
; the addess si. The result of the load will store in the al register. If
; the al register is a 0, then it's 'or' calculation with itself
; will be 0 as well and we can halt; Otherwise, use the BIOS to write
; to the screen using tty mode.
.loop:
    lodsb
    or al,al ; is al == 0 ?
    jz halt  ; if (al == 0) jump to halt label
    int 0x10 ; runs BIOS interrupt 0x10 to write to the screen using TTY mode
    jmp .loop

; Perform clean up operations
halt:
    cli ; clear interrupt flag
    hlt ; halt execution

; Define a sequence of bytes in big-endian that ends with 0
hello: db "Hello world!",0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; perform padding up to the last two bytes of the sector

times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes

; attach this at the very end so the system can know when the sector begins
dw 0xaa55
