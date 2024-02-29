# SESSION 02 - EXCERCISE 04 - version 2

.globl 	main
.data
		r:		.align		2
				.space		400

.text
# variabelen in registers:
# 	   ar:	s1
# 	    i:	s2
# 	getal:	s3
main:							# main(){
		la		t1, r			#								// t1 = &r[0] = r
		
		li		s1, 0			#	ar = 0;
		li		a7, 5			#
		ecall					#
		mv		s3, a0			# 	getal = getint();
wh1:	bltz	s3, eW1			#	while (getal >= 0){
		slli	t0, s1, 2		#	    						// t0 = ar*4
		add		t0, t0, t1		#	    						// t0 = &r[ar]
		sw		s3, 0(t0)		#	    r[ar] = getal;
		li		s2, 0			#		i=0;
wh2:	slli	t0, s2, 2		#								// t0 = i*4
		add		t0, t0, t1		#								// t0 = &r[i]
		lw		t0, 0(t0)		#								// t0 = r[i]
		beq		t0, s3, endW2	#		while(r[i] != getal){
		addi	s2, s2, 1		#			i++;
		j		wh2				#		}
endW2:	bne		s2, s1, endif	#		if(i==ar)
		addi	s1, s1, 1		#			ar++;
endif:	li		a7, 5			#
		ecall					#
		mv		s3, a0			# 		getal = getint();
		j		wh1				#	}
eW1: 
		li		s2, 0			#	i=0;
for:	bge		s2, s1, endF	#	for(    ; i<ar;    ;){
		slli	t0, s2, 2		#								// t0 = i*4
		add		t0, t0, t1		#								// t0 = &r[i]
		lw		a0, 0(t0)		#								// a0 = r[i]
		li		a7, 1			#
		ecall					# 	   	printint(r[i]);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	   	print();
		addi	s2, s2, 1		#		i++;
		j		for				#	}
endF:	
		li    	a7, 10			#
		ecall					# }
