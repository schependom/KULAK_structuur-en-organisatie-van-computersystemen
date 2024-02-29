# SESSION 02 - EXCERCISE 06

.globl 	main
.data
	ftab:		.align		2
				.space		144

.text
# variabelen in registers:
# 	    t:	s1
# 	    i:	s2
main:							# main(){
		la		t1, ftab		#								// t1 = &ftab[0] = ftab
		li		t2, 20			#								// t2 = 20
		li		t3, 31			#								// t2 = 31

		li		s1, -15			#	t = -15;
for1:	bgt		s1, t2, endF1	#	for(    ; t<=20;    ;){
		slli	t0, s1, 2		#								// t0 = t*4
		add		t0, t0, t1		#								// t0 = &ftab[t]
		sw		zero, 60(t0)	#		ftab[t+15] = 0;
		addi	s1, s1, 1		#		t++;
		j		for1			#	}
endF1:
		li		s2, 0			#	i=0;
for2:	bge		s2, t3, endF2	#	for(    ; i<31;    ;){
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 		t = getint();
		slli	t0, s1, 2		#								// t0 = t*4
		add		t0, t0, t1		#								// t0 = &ftab[t]
		lw		t4, 60(t0)		#								// t4 = ftab[t+15]
		addi	t4, t4, 1		#
		sw		t4, 60(t0)		#		ftab[t+15]++;
		addi	s2, s2, 1		#		i++;
		j		for2			#	}
endF2:	
		li		s1, -15			#	t = -15;
for3:	bgt		s1, t2, endF3	#	for(    ; t<=20;    ;){
		slli	t0, s1, 2		#								// t0 = t*4
		add		t0, t0, t1		#								// t0 = &ftab[t]
		lw		t0, 60(t0)		#								// t0 = ftab[t+15]
		beqz	t0, endif		#		if(ftab[t+15] != 0){
		
		mv 		a0, s1			#
		li		a7, 1			#
		ecall					# 	   		printint(t);
		li 		a0, 32			#
		li 		a7, 11 			# 
		ecall					# 	   		print(" ");
		mv		a0, t0			#
		li		a7, 1			#
		ecall					# 	   		printint(ftab[t+15]);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	  		print();
		
endif:	addi	s1, s1, 1		#		t++;
		j		for3			#	}
endF3:														
		li    	a7, 10			#
		ecall					# }
