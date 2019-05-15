@write_str.s
@This is a function that accepts a pointer to a text string and displays
@it on the screen. It returns the number of characters displayed
@Calling sequence:
@       r0 <- address of string to be written
@       bl      write_str

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

    .text
    .align 2
    .global write_str
    .type write_str, %function

write_str:
    sub     sp, sp, 16      @adjust sp for registers
    str     r4, [sp, 0]     @save r4
    str     r5, [sp, 4]     @save r5
    str     fp, [sp, 8]     @save fp
    str     lr, [sp, 12]    @save lr
    add     fp, sp, 12      @set frame pointer

    mov     r4, r0          @address of string
    mov     r5, 0           @count = 0
while:
    ldrb    r3, [r4]        @load a byte
    cmp     r3, NULL        @end of string?
    beq     done            @yes, go to done
    
    mov     r0, STDOUT      @no, write to stdout
    mov     r1, r4          @address of char to print
    mov     r2, 1           @write 1 byte
    bl      write

    add     r4, r4, 1       @next char
    add     r5, r5, 1       @increment count
    b       while

done:
    mov     r0, r5          @return count
    ldr     r4, [sp, 0]     @restore r4
    ldr     r5, [sp, 4]     @restore r5
    ldr     fp, [sp, 8]     @restore fp
    ldr     lr, [sp, 12]    @restore lr
    add     sp, sp, 16      @restore stack
    bx      lr              @return to caller
