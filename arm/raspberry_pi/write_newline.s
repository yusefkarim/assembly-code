@write_newline.s
@This is a function that writes a newline character to STDOUT
@Calling sequence:
@       bl      write_newline

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants
    .equ    STDOUT, 1

@Constant program data
    .section .rodata
    .align 2
newline_char:
    .ascii      "\n"

    .text
    .align 2
    .global write_newline
    .type write_newline, %function

write_newline:
    sub     sp, sp, 8       @adjust sp for registers
    str     fp, [sp, 0]     @save fp
    str     lr, [sp, 4]     @save lr
    add     fp, sp, 4       @set frame pointer

    mov     r0, STDOUT      @write to STDOUT
    ldr     r1, newline_char_addr   @address of newline char
    mov     r2, 1           @write 1 byte
    bl      write

    mov     r0, r5          @return count
    ldr     fp, [sp, 0]     @restore fp
    ldr     lr, [sp, 4]     @restore lr
    add     sp, sp, 8       @restore stack
    bx      lr              @return to caller

newline_char_addr:
    .word   newline_char
