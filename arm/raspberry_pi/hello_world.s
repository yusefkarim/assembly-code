@ hello_world.s
@ Hello world program in assembly

@ Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified
@ Useful source code constants
    .equ    STDOUT, 1

@ Constant program data
    .section .rodata
    .align  2
hello_msg:
    .asciz "Hello, World!\n"
    .equ hello_len, .-hello_msg

@ Program code
    .text
    .align 2
    .global main
    .type main, %function

main:
    sub     sp, sp, 8       @space for fp and lr
    str     fp, [sp, 0]     @save fp
    str     lr, [sp, 4]     @save lr
    add     fp, sp, 4       @set our frame pointer

    mov     r0, STDOUT      @STDOUT_FILENO to write
    ldr     r1, msg_addr   @pointer to string
    mov     r2, hello_len   @number of bytes to write
    bl      write           @write the message

    mov     r0, 0           @retrun 0
    ldr     fp, [sp, 0]     @resotre caller fp
    ldr     lr, [sp, 4]     @restore lr
    add     sp, sp, 8       @restore stack
    bx      lr              @return

    .align 2
msg_addr:
    .word hello_msg
