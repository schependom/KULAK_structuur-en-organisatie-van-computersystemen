# SESSION 04 - EXCERCISE 03

.globl 	main
.data

.text

# iteratieve functie: int ggdI(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (leaf functie)
#	r: t0
# 
ggdI:								# int ggd(int a, int b){
			rem		t0, a0, a1		#	r = a % b;
wh:			beqz	t0, endW		#	while(r != 0){
			mv		a0, a1			#		a = b;
			mv		a1, t0			#		b = r;
			rem		t0, a0, a1		#		r = a % b;
			j		wh				#	}
endW:		mv		a0, a1			#	return b;
			ret						# }
			
# recursieve functie: int ggdR(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (non-leaf functie)
#	-
# 
ggd:
ggdR:							# int ggd(int a, int b){
			bne		a0, a1, else	#	if(a == b)
									#		// a0 = a
			ret						#		return a;
else:		bge		a0, a1, else2	#	else if(a<b)
			# zet parameters goed
			# backup is niet nodig, we hebben achteraf 
			# a0 en a1 niet meer nodig in deze functie!
			mv		t0, a0
			mv		a0, a1			#			// a0 = b
			mv		a1, t0			#			// a1 = a
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#			// a0 = ggd(b,a)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			ret						#			return ggd(b,a);
else2:								#		 else
			# zet parameters goed
			# backup is niet nodig, we hebben achteraf 
			# a0 en a1 niet meer nodig in deze functie!
			sub		a0, a0, a1		#			// a0 = a-b
									#			// a1 = b
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#			// a0 = ggd(a-b,b)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			ret						#			return ggd(a-b,b);
									# }


# functie: int kgv(int a, int b)
# PARAMETERS:
#	a: a0
#	b: a1
# LOKALE VARIABELEN: (non-leaf functie)
# 
kgv:								# int kgv(int a, int b){
			# call ggd(a,b)
			# zet eerst de eigen waarden uit a0 en a1 aan de kant!
			addi	sp, sp, -8		#
			sw		a0, 0(sp)		#
			sw		a1, 4(sp) 		#
			# zet de parameters goed voor ggd
									#				// a zit al in a0!
									#				// b zit al in a1!
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	ggd				#				// a0 = ggd(a,b)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#
			# zet het resultaat aan de kant
			mv		t0, a0			#				// t0 = ggd(a,b)
			# herstel de eigen waarden uit a0 en a1!
			lw		a0, 0(sp)		#
			lw		a1, 4(sp) 		#
			addi	sp, sp, 8		#
			
			mul		a0, a0, a1		#				// a0 = a*b
			div		a0, a0, t0		#		return a*b/ggd(a,b);
			ret						# }
			
			

# main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	x: s1
#	y: s2
#
main:								# main() {
			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#	x = getint();
			li		t0, -1			#	// t0 = -1
wh2:		beq		s1, t0, endW2	#	while(x != -1){
			li		a7, 5			#
			ecall					# 
			mv		s2, a0			#		y = getint();
			
			# print x en y
			mv		a0, s1	
			li		a7, 1		
			ecall					# 		print(x);
			li 		a0, 32			# 		// put the " " character in a0
			li 		a7, 11 		
			ecall					#		print(" ");
			mv		a0, s2	
			li		a7, 1		
			ecall					# 		print(y);
			li 		a0, 32			# 		// put the " " character in a0
			li 		a7, 11 		
			ecall					#		print(" ");
			
			# call kgv
			# zet eerst de parameters goed
			mv		a0, s1			#		// a0 = x
			mv		a1, s2			#		// a1 = y
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	kgv				#		// a0 = kgv(x,y)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			li		a7, 1		
			ecall					# 		print(kgv(x,y);
			li 		a0, 10			# 		// put the "\n" character in a0
			li 		a7, 11 		
			ecall					#		print("\n");

			li		a7, 5			#
			ecall					# 
			mv		s1, a0			#		x = getint();
			
			j		wh2				#	}
endW2:
			li		a7, 10			#
			ecall 					# }
