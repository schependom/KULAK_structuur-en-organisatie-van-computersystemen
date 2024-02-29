# SESSION 02 - EXCERCISE 02 v2

.globl 	main
.data
		f:		.align		2
				.space		400		# n is maximaal 100, 100*4bytes = 100 * 1 woord = 400 bytes

.text

# s1: p
# s2: n

main:							# main () {
		li 		a7, 5
		ecall
		mv 		s2, a0			#	n = getint();
		la		s1, f			#	p = f;
		li		t0, 1			#	// 1 in t0
		sw		t0, 0(s1)		#	*p = 1;
		addi	s1, s1, 4		#	p++;
		sw		t0, 0(s1)		#	*p = 1;
		addi	s1, s1, 4		#	p++;
		li		a7, 1
		li		a0, 1			#	printint(1);
		ecall
		li 		a7, 11
		li 		a0, 32			#	printstr(" ");				
		ecall
		li		a7, 1
		li		a0, 1			#	printint(1);
		ecall
		li 		a7, 11
		li 		a0, 32			#	printstr(" ");				
		ecall
		slli	t1, s2, 2		#	// 4*n
		la		t4, f
		add		t2, t1, t4		#	// f+4n
for:	bge		s1, t2, eFor	#	for (; p < f + n;) {
		lw		t0, -8(s1)		#		// *(p-2)
		lw		t1, -4(s1)		#		// *(p-1)
		add		t1, t0, t1		#		// *(p-2) + *(p-1)
		sw		t1, 0(s1)		#		*p = *(p-2) + *(p-1);
		li		a7, 1
		mv		a0, t1			#		printint(*p);
		ecall
		li 		a7, 11
		li 		a0, 32			#		printstr(" ");
		ecall		
		addi	s1, s1, 4		#		p++;
		j		for				#	}
eFor:	li		a7, 10			# }
		ecall
