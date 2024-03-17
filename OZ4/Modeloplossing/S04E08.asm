# SESSION 04 - EXCERCISE 08

.globl 	main
.data
		a:		.align 		2
				.space		400		

.text


# functie: void lees(int[] r, int n)
# PARAMETERS:
#	    r: a0
#		n: a1
# LOKALE VARIABELEN: (leaf functie)
#	    i: t0
lees:								# void lees(int[] r, int n){
			li		t0, 0			#	i = 0;
forL1:		bge		t0, a1, endFL1	#	for(   ; i<n;   ){
			
			# zet even a0 aan de kant
			addi	sp, sp, -4
			sw		a0, 0(sp)		
			
			li		a7, 5			#
			ecall					# 
			mv		t1, a0			#		// t1 = getint()
			
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4
			
			slli	t2, t0, 2		#		// t2 = 4*i
			add		t2, t2, a0		#		// t2 = &r[i]
			sw		t1, 0(t2)		#		r[i] = getint();
			
			addi	t0, t0, 1		#		i++;
			j		forL1			#	}
endFL1:		ret						# }
	
					
# functie: void schrijf(int[] r, int n)
# PARAMETERS:
#	    r: a0
#		n: a1
# LOKALE VARIABELEN: (leaf functie)
#	    i: t0
schrijf:							# void schrijf(int[] r, int n){
			li		t0, 0			#	i = 0;
forS1:		bge		t0, a1, endFS1	#	for(   ; i<n;   ){
			
			# zet even a0 aan de kant
			addi	sp, sp, -4
			sw		a0, 0(sp)		
			
			slli	t1, t0, 2		#		// t1 = 4*i
			add		t1, t1, a0		#		// t1 = &r[i]
			lw		a0, 0(t1)		#		// a0 = r[i]
			li		a7, 1			#
			ecall					# 		print(r[i]);
			li 		a0, 32			# 		
			li 		a7, 11 			#
			ecall					#		print(" ");
			
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4			
			
			addi	t0, t0, 1		#		i++;
			j		forS1			#	}
endFS1:		li 		a0, 10			# 	
			li 		a7, 11 			#
			ecall					#	print("\n");
			ret						# }


# functie: void schrijfOmgekeerd(int[] r, int n)
# PARAMETERS:
#	    r: a0
#		n: a1
# LOKALE VARIABELEN: (leaf functie)
#	    i: t0
schrijfO:							# void schrijfO(int[] r, int n){
			mv		t0, a1
			addi	t0, t0, -1		#	i = n-1;
forS2:		bltz	t0, endFS2		#	for(   ; i>=0;   ){
			
			# zet even a0 aan de kant
			addi	sp, sp, -4
			sw		a0, 0(sp)		
			
			slli	t1, t0, 2		#		// t1 = 4*i
			add		t1, t1, a0		#		// t1 = &r[i]
			lw		a0, 0(t1)		#		// a0 = r[i]
			li		a7, 1			#
			ecall					# 		print(r[i]);
			li 		a0, 32			# 		
			li 		a7, 11 			#
			ecall					#		print(" ");
			
			# herstel a0
			lw		a0, 0(sp)
			addi	sp, sp, 4			
			
			addi	t0, t0, -1		#		i--;
			j		forS2			#	}
endFS2:		li 		a0, 10			# 	
			li 		a7, 11 			#
			ecall					#	print("\n");
			ret						# }



# main functie
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#	      a: geheugen (GLOBAAL)
#		  n: s1
main:								# main() {
			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#	n = getint();
			
			
			# call lees(a,n)
			# zet eerst de parameters goed
			la		a0, a			#	// a0 = a = &a[0]
			mv		a1, s1			#	// a1 = n
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	lees			#	lees(a, n);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			# call schrijf(a,n)
			# zet eerst de parameters goed
			la		a0, a			#	// a0 = a = &a[0]
			mv		a1, s1			#	// a1 = n
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	schrijf			#	schrijf(a, n);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			# call schrijfO(a,n)
			# zet eerst de parameters goed
			la		a0, a			#	// a0 = a = &a[0]
			mv		a1, s1			#	// a1 = n
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	schrijfO		#	schrijfO(a, n);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			
			li		a7, 10			#
			ecall 					# }