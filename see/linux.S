.set EXIT_SUCCESS, 0
.set EXIT_FAILURE, 1

.set SYS_READ,  0
.set SYS_WRITE, 1
.set SYS_OPEN,  2
.set SYS_EXIT,  0x3c
.set SYS_MMAP,  9
.set SYS_FSTAT, 5

.set FD_STDOUT, 1
.set FD_STDERR, 2

.set O_RDONLY, 0

.macro exit status
	movq $SYS_EXIT, %rax
	movq \status, %rdi
	syscall
.endm

.macro read fd, buf, count
	movq $SYS_READ, %rax
	movq \fd, %rdi
	movq \buf, %rsi
	movq \count, %rdx
	syscall
.endm

.macro write fd, buf, count
	movq $SYS_WRITE, %rax
	movq \fd, %rdi
	movq \buf, %rsi
	movq \count, %rdx
	syscall
.endm

.macro open filename, flags
	movq $SYS_OPEN, %rax
	movq \filename, %rdi
	movq \flags, %rsi
	syscall
.endm

.macro mmap len, addr=$0, prot=$3, flags=$33, fd=$-1, offset=$0
	movq $SYS_MMAP, %rax
	movq \addr, %rdi
	movq \len, %rsi
	movq \prot, %rdx
	movq \flags, %r10
	movq \fd, %r8
	movq \offset, %r9
	syscall
.endm

.macro fstat fd, statbuf
	movq $SYS_FSTAT, %rax
	movq \fd, %rdi
	movq \statbuf, %rsi
	syscall
.endm

