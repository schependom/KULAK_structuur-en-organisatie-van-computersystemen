# SESSION 02 - EXCERCISE 01

.globl 	main
.data
		a:		.align		2
				.space		80		# n is maximaal 20, 20*4=80
		b:		.align		2
				.space		80

.text

# ZONDER POINTERS

# variabelen in registers:
# 	 inpr: 	s1
# 	    i:	s2
#       n:	s3
# gebruikte constanten:
# array a:	t1
# array b:	t2

main:							# main () {
		li 		a7, 5
		ecall
		mv 		s3, a0			#	n = getint();
		li		s2, 0			#	i = 0;
		la		t1, a			#	// haal het adres van a[0] op
		la		t2, b			#	// haal het adres van b[0] op
wh1:	bge		s2, s3, endWh1	#	while (i < n) {
		slli	t0, s2, 2		#		// i * 4
		li		a7, 5
		ecall					#		a[i] = getint();
		add		t0, t0, t1		#		// adres van a[i]
		sw		a0, 0(t0)
		addi	s2, s2, 1		#		i++;
		j		wh1				#	}
endWh1:	li		s2, 0			#	i = 0;
wh2:	bge		s2, s3, endWh2	#	while (i < n) {
		slli	t0, s2, 2		#		// i * 4
		li		a7, 5
		ecall					#		b[i] = getint();
		add		t0, t0, t2		#		// adres van b[i]
		sw		a0, 0(t0)
		addi	s2, s2, 1		#		i++;
		j		wh2				#	}
endWh2:	li		s2, 0			#	i = 0;
		li		s1, 0			#	inpr = 0;
wh3:	bge		s2, s3, endWh3	#	while (i < n) {
		slli	t0, s2, 2		#		// i * 4
		add		t5, t0, t1		#		// adres van a[i]
		sw		t3, 0(t5)		#		// waarde van a[i] in t3
		add		t6, t0, t2		#		// adres van b[i]
		sw		t4, 0(t6)		#		// waarde van b[i] in t4
		mul		t0, t3, t4		#		// a[i]*b[i] in t0
		add		s1, s1, t0		#		inpr = inpr + a[i]*b[i];
		addi	s2, s2, 1		#		i++;
		j		wh3				#	}
endWh3:	li		a7, 1
		mv		a0, s1
		ecall					#	printint(inpr);
		li		a7, 10
		ecall					# }
		
		
# MET POINTERS

# pa: 	s0
# pb: 	s1
# inpr: s2
# n: 	s3

# a:	t0
# b:	t1
# for	t3
# mul	t4

main2:							# main () {
		li 		a7, 5
		ecall
		mv 		s3, a0			#	n = getint();
		la		t0, a
		la		t1, b
		mv		s0, t0			#	pa = a;
		slli	s3, s3, 2		#	// n*4
		add		t3, t0, s3		#	// a+4n
for1:	bge		s0, t3, endFor1	#	for (   ; pa<a+n;  ) {
		li		a7, 5
		ecall
		sw		a0, 0(s0)		#		*pa = getint();
		addi	s0, s0, 4		#		pa++;
		j		for1			#	}
endFor1:add		t3, t1, s3		#	// b+4n
		mv		s1, t1			#	pb = b;
for2:	bge		s1, t3, endFor2	#	for (   ; pb<b+n;  ) {
		li		a7, 5
		ecall
		sw		a0, 0(s1)		#		*pb = getint();
		addi	s1, s1, 4		#		pb++;
		j		for2			#	}
endFor2:li		s2, 0			#	inpr = 0;
		add		t3, t0, s3		#	// a+4n
		mv		s0, t0
		mv		s1, t1
for3:	bge		s0, t3, endFor3	#	for (   ; pa < a+n;  ;   ) {
		lw		t0, 0(s0)		#		// *pa
		lw		t1, 0(s1)		#		// *pb
		mul		t4, t0, t1		#		// (*pa) * (*pb)
		add		s2, s2, t4		#		inpr = inpr + (*pa) * (*pb);
		addi	s0, s0, 4		#		pa++;
		addi	s1, s1, 4		#		pb++;
		j		for3			#	}
endFor3:li		a7, 1
		mv		a0, s2			#	// inpr in a0
		ecall
		li		a7, 10
		ecall
