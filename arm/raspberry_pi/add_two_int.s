@ add_two_int.s
@ Assigns two variables values then adds them together, storing the value in a different register

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified
    
@Source code constants
    .equ    z, -16
    .equ    local, 8

@Program data
    .section .rodata
    .align 2

msg:
    .asciz "%i + %i = %i\n"

@Program code
    .text
    .align 2
    .global main
    .type main, %function

main:
    sub     sp, sp, 12      @space for registers
    str     fp, [sp, 0]     @save fp
    str     lr, [sp, 4]     @save lr
    str     r5, [sp, 8]     @save r5
    str     r4, [sp, 12]    @save r4
    add     fp, sp, 12      @our frame pointer
    sub     sp, sp, local   @memory for local var, z

    mov     r5, 123         @x = 123
    ldr     r4, y_val       @y = 4567
    add     r3, r5, r4      @x + y
    str     r3, [fp, z]     @z = x + y

    ldr     r0, msg_addr    @msg
    mov     r1, r5          @x
    mov     r2, r4          @y
    ldr     r3, [fp, z]     @z
    bl      printf          @call printf

    mov     r0, 0           @return 0
    add     sp, sp, local   @deallocate local var
    ldr     fp, [sp, 0]     @restore fp
    ldr     lr, [sp, 4]     @restore lr
    ldr     r5, [sp, 8]     @restore r5
    ldr     r4, [sp, 12]    @restore r4
    add     sp, sp, 12      @resotre sp
    bx      lr              @return

    .align 2
y_val:
    .word    4567
msg_addr:
    .word   msg
