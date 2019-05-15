@Define architecture
    .cpu cortex-a53
    .fpu neon-fp-armv8
    .syntax unified

@Program code
    .text
    .align 2
    .global h
    .type h, %function

h:
    str fp, [sp, -4]!       @save caller frame pointer
    add fp, sp, 0           @g frame pointer

    mov r0, 1177            @return value

    sub sp, fp, 0           @delete allocated memory
    ldr fp, [sp], 4         @restore caller's frame pointer
    bx lr                   @return to caller
