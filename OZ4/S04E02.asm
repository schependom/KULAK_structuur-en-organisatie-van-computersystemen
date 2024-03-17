# SESSION 04 - EXCERCISE 02

.globl 	main

.text

# De functie ggd is een leaf function
#	PARAMETERS		LOCAL VARIABLES
#	a0: a			t0: r
#	a1: b			
ggd:							# int ggd(int a, int b) {
		rem		t0, a0, a1		#	int r = a % b;
wh:		beqz	t0, eWh			#	while (r!=0) {
		mv		a0, a1			#		a = b;
		mv		a1, t0			#		b = r;
		rem		t0, a0, a1		#		r = a % b;
		j		wh				#	}
eWh:	mv		a0, a1			#	return b;
		ret						# }
		
# De recursieve versie van de functie ggd is GEEN leaf functie, wat ze roep zichzelf op
#	PARAMETERS
#	a0: a
#	a1: b
ggdRec:							# int ggdRec(int a, int b) {
		bne		a0, a1, else	#	if (a == b) {
		ret						#		return a; 		// a zit al in a0!
else:	bge		a0, a1, else2	#	else if (a < b) {
		mv		t0, a0			#		// tmp = a;
		mv		a0, a1			#		// a = b;
		mv		a1, t0			#		// b = tmp;
		addi	sp, sp, -4		#		// pas sp aan
		sw		ra, 0(sp)		#		// zet ra weg op stack
		call	ggdRec			#		c = ggd(b,a);
		lw		ra, 0(sp)		#		// haal ra van stack
		addi	sp, sp, 4		#		// restore sp
		ret						#		return c;		// a0 bevat de return waarde van de functie
else2:	sub		a0, a0, a1		#	} else {
		addi	sp, sp, -4		#		// pas sp aan
		sw		ra, 0(sp)		#		// zet ra weg op stack
		call	ggdRec			#		c = ggd(b,a);
		lw		ra, 0(sp)		#		// haal ra van stack
		addi	sp, sp, 4		#		// restore sp
		ret						#		return c;		// a0 bevat de return waarde van de functie
		
main:							# main() {
		li		a0, 45			#	u = 45;
		li		a1, 10			#	v = 10;
		addi	sp, sp, -4		#	// pas de stack pointer aan
		sw		ra, 0(sp)		#	// plaats het return adres op de stack
		call	ggdRec			#	w = ggd(u,v);
		lw		ra, 0(sp)		#	// haal het return adres terug van de stack
		addi	sp, sp, 4		#	// pas de stack pointer terug aan
		li		a7, 1			#	// zet a7 op 1 voor printint, in a0 zit de return waarde van ggd al
		ecall					#	printint(w);
		li		a7, 10			# }
		ecall					# // exit code 0 (hopelijk)