# SESSION 05 - EXCERCISE 10

.globl 	main
.data
	root: .word	0
.text

# void voegtoe(struct knooptype **b, int g)
#	argumenten:
#		a0: b (pointer naar pointer naar struct knooptype)
#		a1: g (int)
# non-leaf, dus lokale variabelen in saved regs (backup nodig!)
# 		s1: *b
#		s2: a0 = b
#		s3: a1 = g

voegtoe:							# void voegtoe(struct knooptype **b, int g) {

		# backup saved registers
		addi	sp, sp, -12
		sw		s1, 0(sp)
		sw		s2, 4(sp)
		sw		s3, 8(sp)

		lw		s1, 0(a0)			#	// *b
		mv		s2, a0
		mv		s3, a1
		bnez	s1, elseV			#	if (*b == NULL) {
		li		a7, 9
		li		a0, 12
		ecall						#		// malloc van 12 bytes
		sw		a0, 0(s2)			#		*b = malloc(12);
		mv		s1, a0				#		// *b
		sw		s3, 0(s1)			#		*b->waarde = g; 	// eerste positie van **b
		sw		x0, 4(s1)			#		*b->links = NULL;
		sw		x0, 8(s1)			#		*b->rechts = NULL;
		j		endIfV				#	} else {
elseV:	lw		t0, 0(s1)			#		// *b->waarde
		ble		t0, s3, else2		#		if (*b->waarde > g) {
		# zet parameters goed
		addi	a0, s1, 4			#			//&(*b->links) in a0
		mv		a1, s3				
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	voegtoe				#			voegtoe(&(*b->links),g);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		j		endIf2				#		} else {
else2:	# zet parameters goed
		addi	a0, s1, 8			#			//&(*b->rechts) in a0
		mv		a1, s3				
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	voegtoe				#			voegtoe(&(*b->links),g);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
endIf2:								#		}
endIfV:								#	}
		# restore saved registers
		lw		s1, 0(sp)
		lw		s2, 4(sp)
		lw		s3, 8(sp)
		addi	sp, sp, 12
		
		ret							# }
		
# void drukboom(struct knooptype *b)
# non-leaf
# argument a0: b (pointer naar struct knooptype)

drukboom:							# void drukboom(struct knooptype *b) {
		beqz	a0, endif			#	if(b != NULL){
		
		# zet a0 op stack
		addi	sp, sp, -4
		sw		a0, 0(sp)
		
		# zet param a0 goed
		lw		a0, 4(a0)			#		//b->links in a0
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	drukboom			#		drukboom(b->links);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		
		# laad a0 van de stack
		lw		a0, 0(sp)
		
		# print b->waarde
		li		a7, 1
		lw		a0, 0(a0)
		ecall						#		printint(b->waarde);
		
		# laad a0 van de stack
		lw		a0, 0(sp)
		
		# zet param a0 goed
		lw		a0, 8(a0)			#		//b->rechts in a0
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	drukboom			#		drukboom(b->rechts);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		
		# laad a0 van de stack
		# en pas de sp terug aan!
		lw		a0, 0(sp)
		addi	sp, sp, 4
		
endif:								#	}
		ret							# }

# main
# non-leaf
#	s1: getal
#	s2: &root

main:								# main() {
		# inlezen					# 	int getal;
		li		a7, 5
		ecall
		mv		s1, a0				#	getal = getint();
whM:	blez	s1, eWhM			#	while(getal > 0) {
		# zet parameters goed voor function call
		la		a0, root			#		&root
		mv		a1, s1
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	voegtoe				#		voegtoe(&root,getal);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		# end call
		# inlezen
		li		a7, 5
		ecall
		mv		s1, a0				#		getal = getint();
		j		whM					#	}
eWhM:	# zet argument goed
		lw		a0, root
		# call
		addi	sp, sp, -4
		sw		ra, 0(sp)
		call	drukboom			#	drukboom(p);
		lw		ra, 0(sp)
		addi	sp, sp, 4
		
		# end call
		li		a7, 10
		ecall						# }





		
