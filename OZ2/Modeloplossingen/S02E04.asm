# SESSION 02 - EXCERCISE 04

.globl 	main
.data
		r:		.align		2
				.space		400
	   br:		.align		2
				.space		400

.text
# variabelen in registers:
# 	getal: 	s1
# 	   ar:	s2
# 	  abr:	s3
# 	    i:	s4
# 	    j:	s5
main:							# main(){
		la		t1, r			#								// t1 = &r[0] = r
		la		t2, br			#								// t2 = &br[0] = br
		li		t3, -1			#								// t3 = -1		
		li		s2, 0			#	ar = 0;
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 	getal = getint();
wh1:	beq		s1, t3, eW1		#	while (getal != -1){
		slli	t0, s2, 2		#	    						// t0 = ar*4
		add		t0, t0, t1		#	    						// t0 = &r[ar]
		sw		s1, 0(t0)		#	    r[ar] = getal;
		addi	s2, s2, 1		#	    ar++;
		li		a7, 5			#
		ecall					#
		mv		s1, a0			# 	    getal = getint();
		j		wh1				#	}
eW1:	lw		t0, 0(t1)		#
		sw		t0, 0(t2)		#	br[0] = r[0];
		li		s3, 1			#	abr = 1;
		li		s4, 1			#	i=1;
for1:	bge		s4, s2, endF1	#	for(    ; i<ar;    ;){
		slli	t4, s4, 2		#								// t4 = 4*i
		add		t4, t4, t1		#								// t4 = &r[i]
		lw		t4, 0(t4)		#								// t4 = r[i]
		slli	t5, s3, 2		#								// t5 = 4*abr
		add		t5, t5, t2		#								// t5 = &br[abr]
		sw		t4, 0(t5)		#		br[abr] = r[i];
		li		s5, 0			#		j=0;
wh2:	slli	t4, s5, 2		#								// t4 = 4*j
		add		t4, t4, t2		#								// t4 = &br[j]
		addi	s5, s5, 1		#								// j++
		lw		t4, 0(t4)		#								// t4 = br[j++]	
		slli	t5, s4, 2		#								// t5 = 4*i
		add		t5, t5, t1		#								// t5 = &r[i]
		lw		t5, 0(t5)		#		
		beq		t4, t5, endW2	#		while(br[j++] != r[i])
		j		wh2				#							  ;
endW2:	addi	t0, s3, 1		#
		bne		s5, t0, else	#		if(j==abr+1)
		addi	s3, s3, 1		#			abr++;
else:	addi	s4, s4, 1		#		i++;					// NIET VERGETEN!
		j		for1			#	}				
endF1:	li		s5, 0			#	j=0;
for2:	bge		s5, s3, endF2	#	for(    ; j<abr;    ;){
		slli	t0, s5, 2		#								// t0 = j*4
		add		t0, t0, t2		#								// t0 = &br[j]
		lw		a0, 0(t0)		#								// a0 = br[j]
		li		a7, 1			#
		ecall					# 	   	printint(br[j]);
		li 		a0, 10			#
		li 		a7, 11 			# 
		ecall					# 	   	print();
		addi	s5, s5, 1		#		j++;
		j		for2			#	}
endF2:	li    	a7, 10			#
		ecall					# }
