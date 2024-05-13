# Exercise 4
#
# 	Previous exercise:
# 		Write a custom user-mode exception handler. 
# 		The exception handler should do nothing but jump over the faulting instruction. 
# 		Make sure the handler does not modify any regular registers (Hint: use uscratch). 
# 		Do not forget to enable custom trap handling in user mode (csrrsi zero, ustatus, 1 ) 
# 		before triggering the trap.
#
# --> Extend the handler from previous exercise so that it prints:
#		1. The cause of the exception
#		2. The address of the instruction that caused the exception

.globl 	main

# 	Make sure to restore all register values before returning from the trap handler. 
# 	In theory, you could use the call stack for this purpose. 
# 	However, the stack pointer itself might be misaligned. 
# 	Using the stack pointer would then cause an additional exception within the handler. 
#
# -->	A better alternative is to reserve space in the data section to back-up registers. 
# 		You will still need to load the initial address of this space into a register, so 
# 		you will still need to use the uscratch register to back-up that specific register.

.data 	buffer .space 10 			# buffer space for backup-registers

.text	

handler:

	# dit keer willen we meerdere registers gebruiken
	#	--> t0 voor arithmetics
	#	--> a0 voor ecall voor print
	#	--> buffer nodig
	
	# backup t0 and load buffer address
	csrrw	zero, uscratch, t0		# backup t0 in uscratch
	la		t0, buffer				# load the address of the buffer space
	
	# backup t1, 
	sw		t1, 0(t0)
	
	
	
	
	
	
	# restore t1,
	lw		t1, 0(t0)
	
	# restore t0
	csrrw	t0, uscratch, zero
	
	uret
	
main:

	la 		t0, handler
	csrrw 	zero, utvec, t0 		# set utvec so it points to our custom trap handle
	csrrsi 	zero, ustatus, 1 		# set interrupt enable in use mode
	
	lw 		t0, 1					# trigger trap
	
	#continued code
	li		a7, 1
	li		a0, 69420
	ecall
	
	li		a7, 10
	ecall
	
	
	
	
	