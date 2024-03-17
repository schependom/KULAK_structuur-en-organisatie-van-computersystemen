# SESSION 04 - EXCERCISE 04

.globl 	main
.data

.text

# recursieve functie: int facR(int n)
# PARAMETERS:
#	n: a0
# LOKALE VARIABELEN: (non-leaf functie)
#	-
# 
fac:
facR:								# int fac(int n){
			li		t0, 1			#	// tO = 1
			bne		a0, t0, else	#	if(n == 1)
			mv		a0, t0
			ret						#		return 1;
else:		# call fac(n-1)			#	else
			# zet eerst de eigen waarde uit a0 aan de kant!
			addi	sp, sp, -4		#
			sw		a0, 0(sp)		#
			# zet de parameters goed voor ggd
			addi	a0, a0, -1		#				// n-1 in a0
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	fac				#				// a0 = fac(n-1)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# zet het resultaat aan de kant
			mv		t0, a0			#				// t0 = fac(n-1)
			# herstel de eigen waarde uit a0!
			lw		a0, 0(sp)		#
			addi	sp, sp, 4		#
			
			mul		a0, a0, t0
			ret						#		return n*fac(n-1);
									# }


# iteratieve functie: int facI(int n)
# PARAMETERS:
#	     n: a0
# LOKALE VARIABELEN: (leaf functie)
#	     i: t0
# 	result: t1
facI:								# int facI(int n){
			li		t1, 1			#	result = 1;
			li		t0, 1			#	i=1;
for:		bgt		t0, a0, endF	#	for(   ; i<=n;   ){
			mul		t1, t1, a0		#		result *= n;
			addi	t0, t0, 1		#		i++;
			j		for				#	}
endF:		mv		a0, t1			#	return result;
			ret						# }


# EXTRA main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	x: s1
#
main:								# main() {
			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#	x = getint();
			
			# call facI
			# zet eerst de parameters goed
			mv		a0, s1			#	// a0 = x
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	facI			#	// a0 = facI(x)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			li		a7, 1		
			ecall					# 	printint(facI(x));
			
			li 		a0, 10			# 		// put the "\n" character in a0
			li 		a7, 11 		
			ecall					#		print("\n");
			
			# call fac (rec)
			# zet eerst de parameters goed
			mv		a0, s1			#	// a0 = x
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	fac				#	// a0 = fac(x)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			li		a7, 1		
			ecall					# 	printint(facI(x));
			
			li		a7, 10			#
			ecall 					# }
