# SESSION 04 - EXCERCISE 00 - SPILLING - 1

.globl 	main
.data
		a:		.word	

.text

# functie: void druk()
# PARAMETERS:
#	-
# LOKALE VARIABELEN: (geen leaf functie wegens '...')
#	r: stack: -40(fp) -> -4(fp)
# 
druk:								# void druk(){
			# zet eerst de frame pointer goed
			addi	sp, sp, -4		# 
			sw		fp, 0(sp)		#
			mv		fp, sp			# 
			
			# maak plaats voor de lokale variabele op de stack
			addi	sp, sp, -40	
			
			li		t0, 1			#									
			sw		t0, 0(sp)		#	r[0] = 1;
									#   // ...
			lw		a0, 0(sp)		#
			li		a7, 1			#
			ecall					#   printint(a[0]);
									#   // ...
			# geef de plaats van r terug vrij
			addi	sp, sp, 40
			
			# herstel de frame pointer
			lw		fp,0(sp)		#
			addi	sp, sp, 4		# 
			
			ret						# }


# main functie
# LOKALE VARIABELEN: (geen leaf functie)
#	-
#
main:								# main() {
									#	// ...
	
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	druk			#	druk();
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			li		a7, 10			#
			ecall 					# }
