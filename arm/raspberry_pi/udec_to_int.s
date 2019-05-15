@udec_to_int.s
@This is a function that converts a decimal text string to
@an unsigned int, returns equivalent integer value
@Calling sequence:
@       r0 <-address of string
@       bl udec_to_int

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants
    .equ    no_ascii, 0xf
    .equ    NULL, 0

    .text
    .align 2
    .global udec_to_int
    .type   udec_to_int, %function

udec_to_int:
    sub     sp, sp, 24      @space for registers
    str     r4, [sp, 0]     @save r4
    str     r5, [sp, 4]     @save r5
    str     r6, [sp, 8]     @save r6
    str     r7, [sp, 12]    @save r7
    str     fp, [sp, 16]    @save fp
    str     lr, [sp, 20]    @save lr
    add     fp, sp, 20      @our frame pointer

    mov     r4, r0          @string pointer
    mov     r5, 0           @accumulator = 0
    mov     r7, 10          @decimal constant

while:
    ldrb    r6, [r4]        @get char
    cmp     r6, NULL        @end of string?
    beq     done            @yes, go to done
    mov     r0, r5          @no, mul wants a 2nd source reg
    mul     r5, r0, r7      @accumulator *= 10
    and     r6, r6, no_ascii @strip off ascii
    add     r5, r5, r6      @add in the new value
    add     r4, r4, 1       @next char
    b       while

done:
    mov     r0, r5          @return accumulator
    ldr     r4, [sp, 0]     @restore r4
    ldr     r5, [sp, 4]     @restore r5
    ldr     r6, [sp, 8]     @restore r6
    ldr     r7, [sp, 12]    @restore r7
    ldr     fp, [sp, 16]    @restore fp
    ldr     lr, [sp, 20]    @restore lr
    add     sp, sp, 24      @restore sp 
    bx      lr              @return to caller

