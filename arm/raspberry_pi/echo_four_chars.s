@ echo_four_chars.s
@ Prompts the user to enter four characters and echeos them

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Useful constants
    .equ    STDIN, 0
    .equ    STDOUT, 1
    .equ    char1, -8
    .equ    char2, -7
    .equ    char3, -6
    .equ    char4, -5
    .equ    nchars, 4
    .equ    local, 8

@Constant program data
    .section .rodata
    .align 2

prompt:
    .asciz  "Enter four characters: "
    .equ    prompt_len, .-prompt
response:
    .asciz "You enetered: "
    .equ    response_len, .-response

@Program code
    .text
    .align 2
    .global main
    .type   main, %function

main:
    sub     sp, sp, 8       @space for fp, lr
    str     fp, [sp, 0]     @save fp
    str     lr, [sp, 4]     @save lr
    add     fp, sp , 4      @set our frame pointer
    sub     sp, sp, local   @allocate memory for a local variable

    @prompt user for input
    mov     r0, STDOUT
    ldr     r1, prompt_addr
    mov     r2, prompt_len
    bl      write

    @read character from STDIN
    mov     r0, STDIN
    add     r1, fp, char1   @address of a_char
    mov     r2, 1           @one character
    bl      read

    @read character from STDIN
    mov     r0, STDIN
    add     r1, fp, char2   @address of a_char
    mov     r2, 1           @one character
    bl      read

    @read character from STDIN
    mov     r0, STDIN
    add     r1, fp, char3   @address of a_char
    mov     r2, 1           @one character
    bl      read

    @read character from STDIN
    mov     r0, STDIN
    add     r1, fp, char4   @address of a_char
    mov     r2, 1           @one character
    bl      read

    @echo user's character input
    mov     r0, STDOUT
    ldr     r1, response_addr
    mov     r2, response_len
    bl      write
    
    mov     r0, STDOUT
    add     r1, fp, char1  @address of a_char
    mov     r2, nchars
    bl      write

    mov     r0, 0           @return 0
    add     sp, sp, local   @deallocate local variables
    ldr     fp, [sp, 0]     @restore fp
    ldr     lr, [sp, 4]     @restore lr
    add     sp, sp, 8       @restore sp
    bx      lr              @return


@Addresses of messages
    .align 2
prompt_addr:
    .word   prompt
response_addr:
    .word   response
