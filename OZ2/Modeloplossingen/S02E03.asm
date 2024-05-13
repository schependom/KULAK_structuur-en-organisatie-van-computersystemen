# SESSION 02 - EXCERCISE 03

.globl 	main
.data
		a:		.align		2
				.space		44

.text
# variabelen in registers:
# 	    x: 	s1
# 	   ax:	s2
# 	    i:	s3
# 	    v:	s4
main:							# main(){
		li		t0, 10			#									// t0 = 10
		la		t1, a			#									// t1 = &a[0] = a
		li		s3, 0			#	i = 0;
for1:	bgt		s3, t0, endF1	#	for(    ; i<=10;    ;){
		slli	t2, s3, 2		#	  								// t2 = 4*i
		add		t2, t2, t1		#	   								// t2 = &a[i]
		li		a7, 5			#
		ecall					#
		sw		a0, 0(t2)		# 	   a[i] = getint();
		addi	s3, s3, 1		#	   i++;
		j		for1			#	}
endF1:	li		s2, 1			#	ax = 1;
for2:	bgt		s2, t0, endF2	#	for(    ; ax<10;    ;){
		li		a7, 5			#
		ecall					#
		mv		s1, a0			#	   x = getint();
		li		s4, 0			#	   v = 0;
		
		li		s3, 10			#	   i = 10;
for3:	bltz	s3, endF3		#	   for(    ; i>=0;    ;){
		mul		s4, s4, s1		#	      v = v * x
		slli	t2, s3, 2		#									// t2 = i*4
		add		t2, t2, t1		#	       					 		// t2 = &a[i]
		lw		t2, 0(t2)		#
		add		s4, s4, t2		#					+ a[i];
		addi	s3, s3, -1		#	      i--;
		j		for3			#	   }
		
endF3:	mv 		a0, s1			#
		li		a7, 1			#
		ecall					# 	   printint(x);
		li 		a0, 32			#
		li 		a7, 11 			# 
		ecall					# 	   print(" ");
		mv 		a0, s4			#
		li		a7, 1			#
		ecall					# 	   printint(v);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	   print();
		
		addi	s2, s2, 1		#	   ax++;
		j		for2			#	}

endF2:	li    	a7, 10			#
		ecall					# }
