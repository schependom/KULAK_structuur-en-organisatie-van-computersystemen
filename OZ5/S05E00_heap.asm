# SESSION 05 - EXCERCISE 00 - HEAP - slide 18 H2D5

.globl 	main
.data
	lst:	.space	4		
.text

# main
# GLOBALE EN LOKALE VARIABELEN: (geen leaf functie)
#   lst: geheugen
main:								# main() {
			li		a0, 8			# 	// aantal te alloceren bytes: 8
			li		a7, 9			# 	// type environment call: 9
			ecall					# 	// a0 bevat het adres van de gealloceerde ruimte
			sw		a0, lst, t0		#	lst = malloc(8);
		# 	// bovenstaande komt overeen met
		#	la		t0, lst
		#	sw		a0, 0(t0)
			lw		t0, lst			#	// t0 = lst (dit is een adres!)
			sw		zero, 0(t0)		#	lst->info = 0;
			
			li		a0, 8			# 	// aantal te alloceren bytes: 8
			li		a7, 9			# 	// type environment call: 9
			ecall					# 	// a0 bevat het adres van de gealloceerde ruimte
			sw		a0, 4(t0)		#	lst->volgend = malloc(8);
									#	4(t0) is het adres van *volgend in de struct
			li		t1, 4			#
			lw		t0, 4(t0)		#	// t0 = lst->volgend
			sw		t1, 0(t0)		#	lst->volgend->info = 4;
			
			sw		zero, 4(t0)		#	lst->volgend->volgend = NULL;
			
			sw		zero, lst, t0	#	lst = NULL;
			
			
			li		a7, 10			#
			ecall 					# }
