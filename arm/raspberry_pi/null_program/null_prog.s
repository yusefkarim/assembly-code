@A "null" program that just returns 0
@Copied from the book

@Define raspberry pi architecture
    .cpu cortex-a53
    .fpu neon-fp-armv8
    .syntax unified     @modern syntax

@Program code
    .text
    .align 2
    .global main
    .type main, %function

main:
    str    fp, [sp, -4]!   @save caller frame pointer
    add    fp, sp, 0       @establish our frame pointer

    mov    r3, 0           @return 0;
    mov    r0, r3          @return values get stored in r0

    sub    fp, fp, 0       @restore stack pointer
    ldr    fp, [sp], 4     @restore caller's frame pointer
    bx     lr              @back to caller
