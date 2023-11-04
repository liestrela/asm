no_args:
	movq $ERR0, %rdi
	call die

open_error:
	movq $ERR1, %rdi
	call die

mmap_error:
	movq $ERR2, %rdi
	call die

fstat_error:
	movq $ERR3, %rdi
	call die

read_error:
	movq $ERR4, %rdi
	call die

read_error2:
	movq $ERR5, %rdi
	call die

write_error:
	movq $ERR6, %rdi
	call die

write_error2:
	movq $ERR7, %rdi
	call die

