# Exercise 3
#
# 	Write a custom user-mode exception handler. 
# 	The exception handler should do nothing but jump over the faulting instruction. 
# 	Make sure the handler does not modify any regular registers (Hint: use uscratch). 
# 	Do not forget to enable custom trap handling in user mode (csrrsi zero, ustatus, 1 ) 
# 	before triggering the trap.

.globl 	main

.text	

handler:

	# eerst backup maken van t0
	# daarna kunnen we t0 gebruiken om de uepc op te slaan
	# vervolgens kunnen we arithmetics doen op t0
	# en dan terug het omgekeerde!
	
	csrrw	zero, uscratch, t0		# backup t0 in uscratch
	csrrw 	t0, uepc, zero			# move the uepc to t0 and zero uepc
	addi	t0, t0, 4				# add 4 to exception program counter to jump over instruction
	csrrw	zero, uepc, t0			# move UEPC+4 to uepc
	csrrw	t0, uscratch, zero		# restore t0
	
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
	
	
	
	
	
