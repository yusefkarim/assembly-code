@ uint_to_dec.s
@Converts an int to the corresponding unsigned
@decimal text string.
@ Calling sequence:
@       r0 <- address of place to store string
@       r1 <- int to convert
@       bl uint_to_dec

@Define my architecture
        .cpu    cortex-a53
        .fpu    neon-fp-armv8
        .syntax unified

@Source code constants
        .equ    tmp_str, -40     @for temp string
        .equ    locals, 16       @space for local vars
        .equ    zero, 0x30       @ascii code for 0
        .equ    NULL, 0

@ The program
        .text
        .align  2
        .global uint_to_dec
        .type   uint_to_dec, %function

uint_to_dec:
        sub     sp, sp, 24          @space for saving regs
        str     r4, [sp, 0]         @save r4
        str     r5, [sp, 4]         @      r5
        str     r6, [sp, 8]         @      r6
        str     r7, [sp, 12]        @      r7
        str     fp, [sp, 16]        @      fp
        str     lr, [sp, 20]        @      lr
        add     fp, sp, 20          @set our frame pointer
        sub     sp, sp, locals      @for local vars
        
        mov     r4, r0              @caller's string pointer
        add     r5, fp, tmp_str     @temp string
        mov     r7, 10              @decimal constant
        
        mov     r0, NULL        @end of string
        strb    r0, [r5]
        add     r5, r5, 1       @move to char storage

        mov     r0, zero        @assume the int is 0
        strb    r0, [r5]
        movs    r6, r1          @int to convert
        beq     copy_loop       @zero is special case

convert_loop:
        cmp     r6, 0           @end of int?
        beq     copy            @yes, copy for caller
        udiv    r0, r6, r7      @no, div to get quotient
        mls     r2, r0, r7, r6  @the mod (remainder)
        mov     r6, r0          @the quotient
        orr     r2, r2, zero    @convert to numeral
        strb    r2, [r5]
        add     r5, r5, 1       @next char position
        b       convert_loop
copy:
        sub     r5, r5, 1       @last char stored locally
copy_loop:
        ldrb    r0, [r5]        @get local char
        strb    r0, [r4]        @store the char for caller
        cmp     r0, NULL        @end of local string?
        beq     done            @yes, we're done
        add     r4, r4, 1       @no, next caller location
        sub     r5, r5, 1       @next local char
        b       copy_loop
        
done:        
        strb    r0, [r4]        @end string
        add     sp, sp, locals  @deallocate local var
        ldr     r4, [sp, 0]     @restore r4
        ldr     r5, [sp, 4]     @      r5
        ldr     r6, [sp, 8]     @      r6
        ldr     r7, [sp, 12]    @      r7
        ldr     fp, [sp, 16]    @      fp
        ldr     lr, [sp, 20]    @      lr
        add     sp, sp, 24      @      sp
        bx      lr              @return

