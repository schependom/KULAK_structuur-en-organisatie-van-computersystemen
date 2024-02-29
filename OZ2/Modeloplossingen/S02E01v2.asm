# SESSION 02 - EXCERCISE 01 - version 2

.globl 	main
.data
		a:		.align		2
				.space		80
		b:		.align 		2		# .align not strictly necessary, the above is still word-aligned
				.space		80			

.text
# variabelen in registers:
# 	    n: 	s1
#    inpr:	s2
# 	   pa:	s3		# please note: we do not write *pa in s3, that would be wrong: *pa is located elsewhere!
# 	   pb:	s4		
main:							# main(){
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 	n = getint();		
		la		s3, a			#	pa = a; //or: pa = &a[0];
		slli	t0, s1, 2		#											// t0 = 4*n
		add		t0, s3, t0		#											// t0 = a+n = &a[n]
for1:	bge		s3, t0, eF1		#	for(    ; pa < a+n;    ;){
		li		a7, 5			#
		ecall					#
		sw		a0, 0(s3)		# 	   *pa = getint();
		addi	s3, s3, 4		#	   pa++;								// +4!
		j		for1			#	}
eF1:	la		s4, b			#	pb = b; //or: pb = &b[0];
		slli	t1, s1, 2		#											// t0 = 4*n
		add		t1, s4, t1		#											// t0 = b+n = &b[n]
for2:	bge		s4, t1, eF2		#	for(    ; pb < b+n;    ;){
		li		a7, 5			#
		ecall					#
		sw		a0, 0(s4)		# 	   *pb = getint();
		addi	s4, s4, 4		#	   pb++;								// +4
		j		for2			#	}
eF2:	mv		s2, zero		#	inpr = 0;
		la		s3, a			#	pa = a; //or: pa = &a[0];
		slli	t0, s1, 2		#											// t0 = 4*n
		add		t0, s3, t0		#											// t0 = a+n = &a[n]
		la		s4, b			#	pb = b; //or: pb = &b[0];
		slli	t1, s1, 2		#											// t0 = 4*n
		add		t1, s4, s1		#											// t0 = b+n = &b[n]
for3:	bge		s3, t0, eF3		#	for(    ; pa < a+n;    ;){
		lw		t2, 0(s3)		#	  										// t2 = *pa
		lw		t3, 0(s4)		#	   										// t3 = *pb
		mul		t4, t2, t3		#	   										// t4 = (*pa) * (*pb)
		add		s2, s2, t4		#	   inpr = inpr + (*pa) * (*pb);
		addi	s3, s3, 4		#	   pa++;								// +4
		addi	s4, s4, 4		#	   pb++;								// +4
		j		for3			#	}
eF3:	mv 		a0, s2			#
		li		a7, 1			#
		ecall					# 	printint(inpr);
		li    	a7, 10			#
		ecall					# }
