# OEFENING 2

.globl main

.data

	a: .word	10
	b: .word	-1

.text
main:
	
	lw 		s1, a
	lw 		s2, b
	
	mul 	s1, s1, s1	# s1 = s1 * s1
	mul 	s2, s2, s2	# s2 = s2 * s2
	
	add 	s3, s1, s2	# s3 = a^2+b^2
	
	mv 		a0, s3		# stop de som van de kwadraten in a0, het argument-register voor een print int
	li 		a7, 1		# type 1: integer afdrukken
	ecall
	
	# exit
	li		a7, 10
	ecall
