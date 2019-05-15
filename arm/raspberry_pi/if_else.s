@if_else.s
@Prompts the user to enter a y/n response

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants
    .equ    STDOUT, 1
    .equ    STDIN, 0
    .equ    NULL, 0
    .equ    response, -20
    .equ    local, 8

@Constant program data
    .section .rodata
    .align 2
prompt:
    .asciz  "Save changes? "
    .align 2
yes:
    .asciz  "Changes saved.\n"
    .align 2
no:
    .asciz  "Changes discarded.\n"
    .align 2

@Program start
    .text
    .align 2
    .global main
    .type   main. %function

main:
    sub     sp, sp, 16      @space for registers
    @keeping 8-byte sp align
    str     r4, [sp, 4]     @save r4
    str     fp, [sp, 8]     @save fp
    str     lr, [sp, 12]    @save sp
    add     fp, sp, 12      @our frame pointer
    sub     sp, sp, local   @local variable

    ldr     r4, prompt_addr @prompt user
prompt_loop:
    ldrb    r3, [r4]        @get a char
    cmp     r3, NULL        @end of string?
    beq     get_response    @yes, get response

    mov     r0, STDOUT      @no, write to STDOUT
    mov     r1, r4          @address of current char
    mov     r2, 1           @write 1 byte
    bl      write

    add     r4, r4, 1       @increment index
    b       prompt_loop     @back to top

get_response:
    mov     r0, STDIN       @read from STDIN
    add     r1, fp, response @address of response
    mov     r2, 2           @read 1 char + enter key
    bl      read

    ldrb    r3, [fp, response]  @load response
    cmp     r3, 'y          @was it 'y'?
    bne     discard         @no, go to discard

    ldr     r4, yes_addr    @yes, print "Changes saved"
yes_loop:
    ldrb    r3, [r4]        @get a char
    cmp     r3, NULL        @end of string?
    beq     done            @yes, go to done

    mov     r0, STDOUT      @no, write to STDOUT
    mov     r1, r4          @address of current char
    mov     r2, 1           @write 1 char
    bl      write

    add     r4, r4, 1       @increment index
    b       yes_loop        @back to top

discard:
    ldr     r4, no_addr     @no, print "changes discarded"
no_loop:
    ldrb    r3, [r4]        @get a char
    cmp     r3, NULL        @end fo string?
    beq     done            @yes, go to done

    mov     r0, STDOUT      @no, write to STDOUT
    mov     r1, r4          @address of current char
    mov     r2, 1           @write 1 char
    bl      write

    add     r4, r4, 1       @increment index
    b       no_loop         @back to top

done:
    mov     r0, 0           @return 0
    add     sp, sp, local   @deallocate local var
    ldr     r4, [sp, 4]     @restore r4
    ldr     fp, [sp, 8]     @restore fp
    ldr     lr, [sp, 12]    @restore lr
    sub     sp, sp, 16      @restore stack
    bx      lr              @return to caller

    .align 2
prompt_addr:
    .word   prompt
yes_addr:
    .word   yes
no_addr:
    .word   no
