# OEFENING 4

.globl main

.data

	# we hebben in deze oefening geen waarden in het geheugen

.text
main:
	
	# lees het getal x in
	li		a7, 5			# type5: int inlezen
	ecall					# het ingelezen getal zit na afloop in a0
	mv		s1, a0			# s1 = x
	
	# lees het getal y in
	li		a7, 5
	ecall
	mv		s2, a0			# s2 = y
	
	#li		t0, 4			# t0 = 4 (nodig voor de vermenigvuldiging)
	li		t1, 9			# t1 = 9 (nodig voor de vermenigvuldiging)
	
	mul		s3, s1, s1		# s3 = x^2
	mul		s4, s2, s2		# s4 = y^2
	#mul	s4, s4, t0		# s4 = 4*y^2
	slli	s4, s4, 2		# deze shift left immediate komt overeen met maal 2^2, hetzelfde als bovenstaande
	add		s3, s3, s4		# s3 = x^2+4y^2
	
	mul		s4, t1, s1		# s4 = 9*x
	mul		s4, s4, s2		# s4 = s4*y = 9*x*y
	
	div		s0, s3, s4		# s5 bevat het resultaat
	
	# druk het resultaat af
	li		a7, 1			# type 1: int printen
	mv		a0, s0			# het af te printen getal zit in s0, kopieer naar a0
	ecall
	
	# end of program
	li    		a7, 10		
	ecall		
