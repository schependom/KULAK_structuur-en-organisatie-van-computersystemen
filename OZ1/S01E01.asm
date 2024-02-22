# OEFENING 1

.globl main

.data

	# we slaan a en b op in het geheugen
	a: .word	10
	b: .word	-1

.text
main:
	
	lw 	s1, a	# haal a op
	lw 	s2, b	# haal b op
	
	# MET PSEUDO
	#sw s2, a, t0	# sw heeft een extra argument (hulpregister) nodig -> load upper t.o.v. program counter
	#sw s1, b, t0	# sw heeft een extra argument (hulpregister) nodig
	
	# MET ECHTE INSTRUCTIES
	la 	s3, a
	la 	s4, b
	sw 	s2, 0(s3)
	sw 	s1, 0(s4)

	# exit 
	li    	a7, 10
	ecall		
