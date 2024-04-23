# Exercise 1
#
# 	Write a user program that uses system calls to read two numbers 
# 	from the user’s keyboard. Afterwards, print the sum of these two numbers. 


.globl main
.text

main:
	li	a7, 5
	ecall
	mv	t0, a0
	
	li	a7, 5
	ecall
	mv	t1, a0
	
	li	a7, 1
	add a0, t0, t1
	ecall
	
	li	a7, 10
	ecall
