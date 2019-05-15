@for_loop.s
@Prints "Hello, World." one char at a time, using a for loop

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants
    .equ    STDOUT, 1

@Constant program data
    .section .rodata
    .align 2

my_str:
    .asciz  "Hello World.\n"
    .equ    str_len, .-my_str

@Program begin
    .text
    .align 2
    .global main
    .type   main, %function

main:
    sub     sp, sp, 16      @space for registers
    str     r4, [sp, 0]     @save r4
    str     r5, [sp, 4]     @save r5
    str     fp, [sp, 8]     @save fp
    str     lr, [sp, 12]    @save lr
    add     fp, sp, 12      @our frame pointer
    ldr     r5, my_str_addr @address of string
    mov     r4, 0           @index = 0

for:
    mov     r0, STDOUT      @write to stdout
    mov     r1, r5          @current char
    mov     r2, 1           @one byte
    bl      write
    add     r5, r5, 1       @next char in array
    add     r4, r4, 1       @index++
    cmp     r4, str_len     @at the end?
    ble     for             @no, keep er goin

    mov     r0, 0           @yes, return 0
    ldr     r4, [sp, 0]     @restore r4
    ldr     r5, [sp, 4]     @restore r5
    ldr     fp, [sp, 8]     @restore fp
    ldr     lr, [sp, 12]    @restore lr
    add     sp, sp, 16      @restore stack
    bx      lr              @return to caller

    .align 2
my_str_addr:
    .word   my_str
