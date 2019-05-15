        .text
        .align  2
        .globl  main
        .type   main, @function
main:
        add     sp,sp,-16
        sw      ra,12(sp)
        sw      s0,8(sp)
        add     s0,sp,16
        li      a1, 32
        lui     a0,%hi(string1)
        addi    a0,a0,%lo(string1)
        call    printf
        lw      ra,12(sp)
        lw      s0,8(sp)
        add     sp,sp,16
        jr      ra
        .section .rodata
        .balign   4
string1:
        .string "Hello World, %d\n"

