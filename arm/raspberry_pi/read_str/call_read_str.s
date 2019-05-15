@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified
    
@Source code constants
    .equ    max_bytes, 6    @amount of memory for string

@Constant program data
    .section .rodata
    .align 2

prompt:
    .asciz   "Enter some text: "

    .text
    .align 2
    .global main
    .type   main, %function

main:
    sub     sp, sp, 16      @space for registers
    @keep 8-byte sp aligned
    str     r4, [sp, 4]     @save r4
    str     fp, [sp, 8]     @save fp
    str     lr, [sp, 12]    @save lr
    add     fp, sp, 12      @set our frame pointer

    mov     r0, max_bytes   @byte wanted from heap
    bl      malloc
    mov     r4, r0          @pointer to new memory

    ldr     r0, prompt_addr @r0 used as a pointer variable
    bl      write_str

    mov     r0, r4          @get user input
    mov     r1, max_bytes   @max number of bytes to pass
    bl      read_str

    mov     r0, r4          @echo user input
    bl      write_str

    mov     r0, r4          @free heap memory
    bl free

    mov     r0, 0           @return 0
    ldr     r4, [sp, 4]     @restore r4
    ldr     fp, [sp, 8]     @restore fp
    ldr     lr, [sp, 12]    @restore lr
    add     sp, sp, 16      @restore stack
    bx      lr              @return to caller

    .align 2
prompt_addr:
    .word   prompt
