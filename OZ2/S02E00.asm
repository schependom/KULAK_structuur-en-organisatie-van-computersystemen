# SESSION 02 - EXCERCISE 00 - INTRODUCTION

.globl 	main
.data
		a:		.align		2
				.word		1,2,3,4,5,6,7,8,9,10			

.text
# variabelen in registers:
# 	  som: 	s1
# 	    i:	s2
# gebruikte constanten:
#	   10:	t0
#   array:	t1
main:							# main(){
		li		t0, 10			#										// constante 10 in t0
		la		t1, a			#										// adres van a[0] in t1
		li		s1, 0			#	som = 0;
		li		s2, 0			#	i = 0;
for:	bge		s2, t0, endF	#	for(  ; i<10;   ;){
		slli	t2, s2, 2		#										// t2 = i*4
		add		t2, t2, t1		#										// t2 = adres van a[i]
		lw		t3, 0(t2)		#										// waarde van a[i] in t3
		add		s1, s1, t3		#		som += a[i]
		addi	s2, s2, 1		#		i++;
		j		for				#	}
endF:	mv 		a0, s1			#
		li		a7, 1			#
		ecall					# 	printint(som);
		li    	a7, 10			#
		ecall					# }



# with pointers:
#
# variabelen in registers:
# 	  som: 	s1
# 	    i:	s2
# gebruikte constanten:
#	   10:	t0
#   array:	t1
									# main(){
		li		s1, 0				#    som = 0;
		la		s2, a				#    p = a;
		addi	t0, s2, 40			#    									// t0 = a+10 (constante)
for2:	bge		s2, t0, endF2		#    for(  ; p<a+10;   ;){
		lw		t3, 0(s2)			#        								// t3 = *p
		add		s1, s1, t3			#        som += *p
		addi	s2, s2, 4			#        p++;
		j		for2				#    }
endF2:	mv 		a0, s1				#
		li		a7, 1				#
		ecall						#    printint(som);
		li    	a7, 10				#
		ecall						# }
