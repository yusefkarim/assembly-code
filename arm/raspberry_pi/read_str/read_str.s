@read_str.s
@This is a function that accepts a pointer to allocated memory for an input string
@and the number of bytes allocated for it. It reads from STDIN until '\n'. Extra
@characters and '\n' are ignored. Stores a NULL-terminated string, returns the
@number of characters read, excluding the NULL.
@Calling sequence:
@       r0 <- address of place to store the input string
@       r1 <-max string size in bytes
@       bl      read_str

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants
    .equ    STDIN, 0
    .equ    NULL, 0
    .equ    LF, 10      @ascii code for new line character ('\n') in decimal

@Constant program data
    .section .rodata
    .align 2

    .text
    .align 2
    .global read_str
    .type read_str, %function

read_str:
    sub     sp, sp, 24      @adjust sp for registers
    @keep 8-byte sp aligned
    str     r4, [sp, 4]     @save r4
    str     r5, [sp, 8]     @save r5
    str     r6, [sp, 12]    @save r6
    str     fp, [sp, 16]    @save fp
    str     lr, [sp, 20]    @save lr
    add     fp, sp, 20      @set frame pointer

    mov     r4, r0          @address of string
    mov     r5, 0           @count = 0
    mov     r6, r1          @max count
    sub     r6, 1           @get rid of null character

    mov     r0, STDIN       @read from STDIN
    mov     r1, r4          @address of current storage
    mov     r2, 1           @read 1 byte
    bl      read
while:
    ldrb    r3, [r4]        @load a byte
    cmp     r3, LF          @end of input?
    beq     string_end      @yes, go to string_end
    cmp     r5, r6          @max chars?
    bge     ignore          @yes, go to ignore
    add     r4, r4, 1       @no, increment address pointer
    add     r5, r5, 1       @increment count
ignore:
    mov     r0, STDIN       @read from STDIN
    mov     r1, r4          @address of current storage
    mov     r2, 1           @read 1 byte
    bl      read
    b       while           @back to top, check for end
string_end:
    mov     r0, NULL        @string terminator
    strb    r0, [r4]        @write over '\n'

    mov     r0, r5          @return count
    ldr     r4, [sp, 4]     @restore r4
    ldr     r5, [sp, 8]     @restore r5
    ldr     r6, [sp, 12]    @restore r6
    ldr     fp, [sp, 16]    @restore fp
    ldr     lr, [sp, 20]    @restore lr
    add     sp, sp, 24      @restore stack
    bx      lr              @return to caller
