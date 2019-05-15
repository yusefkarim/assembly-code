    .section ".note.openbsd.ident", "a"
.p2align 2				/* padding */
.long 0x8				/* namesz */
.long 0x4				/* descsz */
.long 0x1				/* type */
.ascii "OpenBSD\0"		/* name */
.long 0x0				/* desc */
.p2align 2

    .section .rodata
msg: .string "Hello, world\n"

    .section .text
.globl _start
.type _start, @function

_start:
# write(1, msg, 13)
movq $4, %rax               # System call for write
movq $1, %rdi               # Write to STDOUT fd
leaq msg(%rip), %rsi        # Load effective address of msg
movq $13, %rdx              # Length of msg
syscall

# exit(0)
movq $1, %rax               # System call for exit
movq $0, %rdi               # Exit code of 0
syscall
