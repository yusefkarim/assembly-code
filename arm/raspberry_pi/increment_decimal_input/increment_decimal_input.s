@incremtn_decimal_input.s
@Prompts the user for an unsigned decimal number and adds 1 to it.
@Makes use of the write_str, read_str, udec_to_int, and uint_to_dec
@functions

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants
    .equ    max_chars, 11       @max input chars
    .equ    input_str, -16      @for input string
    .equ    output_str, -28     @for output string
    .equ    locals, 32          @space for local vars

@Constant program data
    .section .rodata
    .align 2
prompt:
    .asciz  "Enter an unsigned number (max 4294967294): "

@Program code
    .text
    .align 2
    .global main
    .type   main, %function

main:
    sub     sp, sp, 8       @space for registers
    str     fp, [sp, 0]     @save fp
    str     lr, [sp, 4]     @save lr
    add     fp, sp, 4       @our frame pointer
    sub     sp, sp, locals  @space for local vars

    ldr     r0, prompt_addr @prompt user
    bl      write_str
    
    add     r0, fp, input_str   @user input
    mov     r1, max_chars   @input size limit
    bl      read_str

    add     r0, fp, input_str   @user input
    bl      udec_to_int     @convert it

    add     r1, r0, 1       @increment user input
    add     r0, fp, output_str
    bl      uint_to_dec     @convert it back

    add     r0, fp, output_str
    bl      write_str       @print incremented value

    mov     r0, 0           @return 0
    add     sp, sp, locals  @deallocate local variables
    ldr     fp, [sp, 0]     @restore fp
    ldr     lr, [sp, 4]     @restore lr
    add     sp, sp, 8       @restore stack
    bx      lr              @return to caller

    .align 2
prompt_addr:
    .word   prompt
