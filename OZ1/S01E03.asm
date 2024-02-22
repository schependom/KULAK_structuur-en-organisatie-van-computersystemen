# OEFENING 3

.globl main

.data

	# we hebben in deze oefening geen waarden in het geheugen

.text
main:
	
	# lees het getal a in
	li		a7, 5			# zet het ecall type in a7 - type5: int inlezen
	ecall					# het ingelezen getal zit na afloop in a0
		
	mv		t1, a0			# het grondtal
	li		t2, 1 			# het resultaat
	li		t3, 0			# de index
	li		t4, 7			# macht
	li		t5, 0			# mag ik stoppen? 0 is neen
	li		t6, 2			# ik mag pas stoppen als t6 2 is
				
	wh:
		bge		t3, t4, endW	# als index >= macht, exit while
		mul		t2, t2, t1		# vermenigvuldig het resultaat met het grondtal
		addi	t3, t3, 1		# verhoog de index met 1
		j		wh				# voer de while opnieuw uit
		
	endW:
	
	# druk het resultaat af
	mv		a0, t2		# zet het resultaat in a0
	li		a7, 1		# type1: afdrukken
	ecall
	
	# druk een end of line character
	li 		a0, 10		# put the \n character in a0
	li 		a7, 11 		# put the ecall type (11: print character) in a7
	ecall				# environment call: write the character in a0 to the standard ouput
	
	# a tot de 13e
	li		t4, 5		# verander de macht van 7 naar 5, want 7+5=13
	li		t3, 0		# zet de index terug op 0
	addi	t5, t5, 1	# verhoog "mag ik stoppen" met 1
	bne		t5, t6, wh	# voer de while opnieuw uit
	
	# end of program
	li    		a7, 10		
	ecall		
