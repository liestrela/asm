/* see - reads filename as a command-line argument, reads the file
   contents from the filesystem and writes it to the standard output .
   i made this program to practice my x86_64 assembly skills, i do not
   recommend using this (come on, you have cat (1) on coreutils).
   this program doesn't work well with large files and has an absolute
   limit of 2 GB. trying to 'see' large files will result in huge memory
   use. i.e., this software is absolute shit. don't use it.
*/

.data
ERR0: .asciz "no filename given\n"
ERR1: .asciz "could not open file\n"
ERR2: .asciz "could not allocate memory\n"
ERR3: .asciz "could not fetch file info\n"
ERR4: .asciz "could not read from file\n"
ERR5: .asciz "error while reading file (incomplete read)\n"
ERR6: .asciz "could not write to terminal\n"
ERR7: .asciz "error while writing to terminal (incomplete write)\n"

.text
.globl _start

.include "linux.S"
.include "error.S"

.macro print_s str, fd=$FD_STDOUT
	movq \str, %rdi
	call strlen
	movq %rdi, %r8
	movq %rax, %r9
	write \fd, %r8, %r9
.endm

die:
	print_s %rdi, $FD_STDERR
	exit $EXIT_FAILURE
	ret

strlen:
	pushq %rdi
	movq %rdi, %rsi
	strlen_nextchar:
	cmpb $0, (%rsi)
	jz strlen_end
	inc %rsi
	jmp strlen_nextchar
	strlen_end:
	sub %rdi, %rsi
	movq %rsi, %rax
	popq %rdi
	ret


_start:
	movq (%rsp), %rcx
	cmp $2, %rcx
	jl no_args
	
	open 16(%rsp), $O_RDONLY /* open argv[1] as file descriptor */
	cmp $0, %rax
	jl open_error
	movq %rax, -4(%rsp)
	
	mmap $144 /* allocate bytes enough for struct stat on heap */
	cmp $0, %rax
	jl mmap_error
	movq %rax, -12(%rsp)
	
	fstat -4(%rsp), -12(%rsp)
	cmp $0, %rax
	jl fstat_error
	addq $48, -12(%rsp) /* offset struct stat pointer by 48 bytes to access st_size member */
	movq -12(%rsp), %rcx
	
	mmap (%rcx) /* allocate st_size bytes on the heap for the file contents */
	cmp $0, %rax
	jl mmap_error
	movq %rax, -20(%rsp)
	movq -12(%rsp), %rcx	
	
	read -4(%rsp), -20(%rsp), (%rcx) /* read file contents into memory */
	cmp (%rcx), %rax
	jl read_error2
	cmp $0, %rax
	jl read_error
	movq -12(%rsp), %rcx
	
	write $FD_STDOUT, -20(%rsp), (%rcx) /* write file contents to stdout */
	cmp (%rcx), %rax
	jl write_error2
	cmp $0, %rax
	jl write_error
	
	exit $EXIT_SUCCESS
