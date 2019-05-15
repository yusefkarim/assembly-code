@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified
    
@Source code constants
    .equ    STDOUT, 1
    .equ    NULL, 0

@Constant program data
    .section .rodata
    .align 2

my_str:
    .asciz   "My name is Yusef Karim.\n"

    .text
    .align 2
    .global main
    .type   main, %function

main:
    sub     sp, sp, 8       @space for registers
    str     fp, [sp, 0]     @save fp
    str     lr, [sp, 4]     @save lr
    add     fp, sp, 4       @set our frame pointer

    ldr     r0, my_str_addr @r0 used as a pointer variable
    bl      write_str

    mov     r0, 0           @return 0
    ldr     fp, [sp, 0]     @restore fp
    ldr     lr, [sp, 4]     @restore lr
    add     sp, sp, 8       @restore stack
    bx      lr              @return to caller

    .align 2
my_str_addr:
    .word   my_str
