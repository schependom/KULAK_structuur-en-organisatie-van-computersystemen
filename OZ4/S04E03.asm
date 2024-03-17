# SESSION 04 - EXCERCISE 03

.globl 	main

.text

# De functie ggd is een leaf function
#	PARAMETERS		LOCAL VARIABLES
#	a0: a			t0: r
#	a1: b			
ggd:							# int ggd(int a, int b) {
		rem		t0, a0, a1		#	int r = a % b;
wh:		beqz	t0, eWh			#	while (r!=0) {
		mv		a0, a1			#		a = b;
		mv		a1, t0			#		b = r;
		rem		t0, a0, a1		#		r = a % b;
		j		wh				#	}
eWh:	mv		a0, a1			#	return b;
		ret						# }
		
# De functie kgv is een NON-LEAF functie!
#	PARAMETERS		LOCAL VARIABLES
#	a0: a			# s1 bevat een kopie van a
#	a1: b			# s2 bevat een kopie van b
kgv:
		addi	sp, sp, -8
		sw		a0, 4(sp)		# a op de stack
		sw		a1, 0(sp)		# b op de stack
		# functie-oproep
		addi	sp, sp, -4		
		sw		ra, 0(sp)		# bewaar return address op stack	
		call	ggd				# roep ggd aan
		lw		ra, 0(sp)		# haal ra terug op van stack
		addi	sp, sp, 4
		# einde functie-oproep
		mv		t0, a0			# zet de return waarde effetjes weg
		lw		a1, 0(sp)		# haal b terug van de stack
		lw		a0, 4(sp)		# haal a terug van de stack
		addi	sp, sp, 8
		mul		t1, a0, a1		# t1 = a * b
		div		a0, t1, t0		# a0 = (a*b)/ggd(a,b)
		ret


# VARIABELEN in register
#	s1: x
#	s2: -1
#	s3: y
#	s4: return value
main:							# main() {
		li		a7, 5
		ecall					
		mv		s1, a0			#	x = getint();
		li		s2, -1
wh2:	beq		s1, s2, eWh2	#	while (x != -1) {
		li		a7, 5
		ecall
		mv		s3, a0			#		y = getint();
		# zet waarden goed voor call
		mv		a0, s1
		mv		a1, s3
		# call de functie
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	kgv
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# einde call, zet return value in s4
		mv		s4, a0
		li		a7, 1
		mv		a0, s1
		ecall					#		printint(x);
		li		a7, 11
		li		a0, 32
		ecall					#		// print space
		li		a7, 1
		mv		a0, s3
		ecall					#		printint(y);
		li		a7, 11
		li		a0, 32
		ecall					#		// print space
		li		a7, 1
		mv		a0, s4			#		// zet de return waarde van kgv in a0
		ecall					#		printint( kgv(x,y) );
		li		a7, 11
		li		a0, 10
		ecall					#		// print enter
		li		a7, 5
		ecall
		mv		s1, a0			#		x = getint();
		j		wh2				#	}
eWh2:	li		a7, 10			# }
		ecall					# // exit code 0 (hopelijk)