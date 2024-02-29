# SESSION 02 - EXCERCISE 02 v1

.globl 	main
.data
		f:		.align		2
				.space		400		# n is maximaal 100, 100*4bytes = 100 * 1 woord = 400 bytes

.text

# s0: f
# s1: i
# s2: n

main:							# main () {
		li 		a7, 5
		ecall
		mv 		s2, a0			#	n = getint();
		la		s0, f
		li		t0, 1			#	// 1 in t0
		sw		t0, 0(s0)		#	f[0] = 1;
		sw		t0, 4(s0)		#	f[1] = 1;
		li		a7, 1
		li		a0, 1			#	printint(f[0]);
		ecall
		li 		a7, 11
		li 		a0, 32			#	printstr(" ");				
		ecall
		li		a7, 1
		li		a0, 1			#	printint(f[1]);
		li 		a7, 11
		li 		a0, 32			#	printstr(" ");				
		ecall
		li		s1, 1			#	i = 2;
wh:		bge		s1, s2, eWh		#	while (i < n) {
		slli	t3, s1, 2
		add		t3, t3, s0
		lw		t0, -8(t3)		#		// f[i-2]
		lw		t1, -4(t3)		#		// f[i-1]
		add		t2, t0, t1		#		// f[i-2] + f[i-1]
		sw		t2, 0(t3)		#		f[i] = f[i-2] + f[i-1]
		li		a7, 1
		mv		a0, t2			#		printint(f[i]);
		ecall
		li 		a7, 11
		li 		a0, 32			#	printstr(" ");				
		ecall
		addi	s1, s1, 1		#		i++;
		j		wh				#	}
eWh:	li		a7, 10			# }
		ecall