# SESSION 04 - EXCERCISE 06 - version 2

.globl 	main
.data

.text

# alternatieve functie: void fibon2(int n, int *r)
# PARAMETERS:
#	    n: a0
#	    r: a1
# LOKALE VARIABELEN: (leaf functie)
#	    i: t0
fibon:								# void fibon(int n, int *r){
			li		t1, 1			#	// t1 = 1
			sw		t1, 0(a1)		#	*r = 1;
			addi	a1, a1, 4		#	r++;
			sw		t1, 0(a1)		#	*r = 1;
			addi	a1, a1, 4		#	r++;
			li		t0, 2			#	i=2;
for2:		bge		t0, a0, endF2	#	for(    ; i<n;    ){
			lw		t3, -4(a1)		#		// t3 = *(r-1)
			lw		t4, -8(a1)		#		// t4 = *(r-2)
			add		t3, t3, t4		#		// t3 = *(r-1) + *(r-2)
			sw		t3, 0(a1)		#		*r = *(r-1) + *(r-2);
			addi	a1, a1, 4		#		r++;
			addi	t0, t0, 1		#		i++;
			j		for2			#	}
endF2:		ret						# }



# main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	  f: stack: -400(fp) -> -4(fp)
#     m: s1
#	  i: s2
main:								# main() {
			# zet eerst de frame pointer goed
			addi	sp, sp, -4		 
			sw		fp, 0(sp)		
			mv		fp, sp			 
			
			# maak plaats voor de lokale variabele op de stack
			addi	sp, sp, -400	
			
			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#	m = getint();
			
			
			# call fibon
			# zet eerst de parameters goed
			mv		a0, s1			#	// a0 = m
			mv		a1, fp			#
			addi	a1, a1, -400	#	// a1 = f = &f[0]
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	fibon			#	fibon(m,f);
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			mv		t1, fp			#
			addi	t1, t1, -400	#	// t1 = f = &f[0]
			li		s2, 0			#	i=2;
forM:		bge		s2, s1, endFM	#	for(    ; i<m;    ){
			
			slli	t0, s2, 2		#		// t0 = 4*i
			add		t0, t0, t1		#		// t0 = &f[i]
			lw		a0, 0(t0)		#		// a0 = f[i]
			li		a7, 1		
			ecall					# 		printint(f[i]);
			li 		a0, 10			# 		// put the "\n" character in a0
			li 		a7, 11 		
			ecall					#		print("\n");
			addi	s2, s2, 1		#		i++;
			j		forM			#	}
endFM:		
			# geef de plaats van f terug vrij
			addi	sp, sp, 400
			
			# herstel de frame pointer
			lw		fp,0(sp)		
			addi	sp, sp, 4		 
			
			li		a7, 10			#
			ecall 					# }