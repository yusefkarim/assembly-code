@
@

@Define architecture
    .cpu    cortex-a53
    .fpu    neon-fp-armv8
    .syntax unified

@Source code constants

@Constant program data
    .section .rodata
    .align 2

@Program code
    .text
    .align 2
    .global main
    .type   main, %function

main:
