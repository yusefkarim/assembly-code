@Define architecture
    .cpu cortex-a53   
    .fpu neon-fp-armv8
    .syntax unified

@program code
    .text
    .align 2
    .global f
    .type f, %function

f:
    str fp, [sp, -4]!   @Save caller frame pointer
    add fp, sp, 0       @f frame pointer

    mov r0, 1337        @Move return value into r0

    sub sp, fp, 0       @delete allocated memory
    ldr fp, [sp], 4     @restore caller's frame pointer
    bx lr               @branch back to caller
