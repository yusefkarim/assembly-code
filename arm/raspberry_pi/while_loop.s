@while_loop.s
@Prints "Hello, world" one char at a time


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
    .asciz   "Hello, World.\n"

    .text
    .align 2
    .global main
    .type   main, %function

main:
    sub     sp, sp, 16      @space for registers
    @Keep 8-byte sp aligned
    str     r4, [sp, 4]     @save r4
    str     fp, [sp, 8]     @save fp
    str     lr, [sp, 12]    @save lr
    add     fp, sp, 12      @set our frame pointer

    ldr     r4, my_str_addr @r4 used as a pointer variable
while:
    ldrb    r3, [r4]        @get a char (load byte)
    cmp     r3, NULL        @end of string?
    beq     all_done        @yes, all done

    mov     r0, STDOUT      @no, write to screen
    mov     r1, r4          @address of current char
    mov     r2, 1           @write 1 byte
    bl write

    add     r4, r4, 1       @increment pointer var
    b       while           @back to top

all_done:
    mov     r0, 0           @return 0
    ldr     r4, [sp, 4]     @restore r4
    ldr     fp, [sp, 8]     @restore fp
    ldr     lr, [sp, 12]    @restore lr
    add     sp, sp, 16      @restore stack
    bx      lr              @return to caller

    .align 2
my_str_addr:
    .word   my_str
