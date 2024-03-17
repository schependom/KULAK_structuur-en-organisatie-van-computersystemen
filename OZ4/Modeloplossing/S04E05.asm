# SESSION 04 - EXCERCISE 05

.globl 	main
.data
	res:	.space		4
	n:		.word		5
	
.text

# functie: void max(int n, int *m)
# PARAMETERS:
#	    n: a0
#	   *m: a1
# LOKALE VARIABELEN: (leaf functie)
#	    i: t0
# 	getal: t1
max:								# void max(int n, int *m){
			li		t2, 0			#	// t2 = 0
			sw		t2, 0(a1)		#	*m = 0;
			li		t0, 0			#	i=0;
for:		bge		t0, a0, endF	#	for(    ; i<n;    ){
			# zet even a0 op de stack want we moeten het overschrijven
			# wanneer we een nieuw getal zullen inlezen
			# alternatief: gebruik een s-variabele hiervoor
			addi	sp, sp, -4		#
			sw		a0, 0(sp)		#
			li		a7, 5			#
			ecall					# 
			mv		t1, a0			#		getal = getint();
			# herstel a0
			lw		a0, 0(sp)		#
			addi	sp, sp, 4		#		
			
			lw		t3, 0(a1)		#		// t3 = *m
			ble		t1, t3, endIf	#		if(getal > *m)
			sw		t1, 0(a1)		#			*m = getal;
endIf:		addi	t0, t0, 1		#		i++;
			j		for				#	}
endF:		ret						# }
			

# EXTRA main functie
# GLOBALE VARIABELEN: (geen leaf functie)
#	res: geheugen
#     n: geheugen
main:								# main() {
			# call max
			# zet eerst de parameters goed
			lw		a0, n			#	// a0 = n
			la		a1, res			#	// a1 = &res
			# roep de functie op (dus zet het vorige return adres aan de kant)
			addi	sp, sp, -4		#
			sw		ra, 0(sp)		#
			call  	max				#	// a0 = max(n,&res)
			lw		ra, 0(sp)		#
			addi	sp, sp, 4		#		
			
			lw		a0, res	
			li		a7, 1		
			ecall					# 	printint(res);
			
			li		a7, 10			#
			ecall 					# }
