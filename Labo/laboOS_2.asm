# Exercise 2
#
# 	Write a program which reads the name of the user from the keyboard. 
# 	Afterwards, display a greeting message dialog with content “Welcome [name]”. 
# 	Make sure your program does not crash when the user presses cancel or gives long inputs. 
# 	Instead, display an appropriate error message dialog. 
# 	Hint: Take a look at system calls 54, 55 and 59.

.globl 	main
.data	
.align2
welcome: 	.string "Welcome "
name:		.string "Give your name."
lengthMsg:	.string "Max length of 10 chars was exceeded"
cancelMsg:	.string "Cancelled!"
nodataMsg:	.string "No data was entered!"
inputSpace:	.space 	44

.text	

main:

	li	a7, 54
	la	a0, name		# message
	la	a1, inputSpace	# adres of input buffer
	li	a2, 11			# maximum number of characters to read (including terminating null) -> -1!
	ecall
	
	# after this call, a1 contains status value.
	#	> 0: 	OK status. Buffer contains the input string.
	#	> -2: 	Cancel was chosen. No change to buffer.
	#	> -3: 	OK was chosen but no data had been input into field. No change to buffer.
	#	> -4: 	length of the input string exceeded the specified maximum. Buffer contains the maximum allowable input string terminated with null.
	
	li	t2, -2
	li	t3, -3
	li	t4, -4
	
	# switch
	beq	a1, t2, cancel
	beq a1, t3, noData	
	beq a1, t4, length
	
	# Status 0: succeeded -> display welcome message to user
	#	> a0 	= address of first null-terminated string
	#	> a1	= address of second null-terminated string
	li	a7, 59
	la	a0, welcome
	la	a1, inputSpace
	ecall
	
	j	eSwitch
	
cancel:

	# cancelled
	li	a7, 55
	la	a0, cancelMsg
	li	a1, 0 #error
	ecall
	
	j	main
	
noData:

	# no data was entered
	li	a7, 55
	la	a0, nodataMsg
	li	a1, 0 #error
	ecall
	
	j	main
	
length:

	# length was exceeded
	li	a7, 55
	la	a0, lengthMsg
	li	a1, 0 #error
	ecall
	
	j	main
	
eSwitch:

	li	a7, 10
	ecall


