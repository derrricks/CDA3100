#################################################################
# CDA3100 - Assignment 1			       		#
#						       		#
# The following code is provided by the professor.     		#
# DO NOT MODIFY any code above the STUDENT_CODE label. 		#
#						       		#
# The professor will not troubleshoot any changes to this code. #
#################################################################

	.data
	.align 0

	# Define strings used in each of the printf statements
msg1:	.asciiz "Welcome to Prime Tester\n\n"
msg2:	.asciiz "Enter a number between 0 and 100: "
msg3:	.asciiz "Error: Invalid input for Prime Tester\n"
msg4:	.asciiz "The entered number is prime\n"
msg5:	.asciiz "The entered number is not prime\n"
ec_msg:	.asciiz " is prime\n" 		# Reserved for use in extra credit

	.align 2	
	.text
	.globl main

	# The following macros are provided to simplify the program code
	# A macro can be thought of as a cross between a function and a constant
	# The assembler will copy the macro's code to each use in the program code
	
	# Display the %integer to the user
	# Reserved for extra credit
	.macro display_integer (%integer)
		li $v0, 1			# Prepare the system for output
		add $a0, $zero, %integer	# Set the integer to display
		syscall				# System displays the specified integer
	.end_macro
	
	# Display the %string to the user
	.macro display_string (%string)
		li $v0, 4		# Prepare the system for output
		la $a0, %string		# Set the string to display
		syscall			# System displays the specified string
	.end_macro
	
	# Compute the square root of the %value
	# Result stored in the floating-point register $f2
	.macro calc_sqrt (%value)
		mtc1.d %value, $f2	# Copy integer %value to floating-point processor
		cvt.d.w $f2, $f2	# Convert integer %value to double
		sqrt.d $f2, $f2		# Calculate the square root of the %value
	.end_macro 
	
	# Determine if the %value is less-than or equal-to the current square root value in register $f2
	# Result stored in the register $v1
	.macro slt_sqrt (%value)
		mtc1.d %value, $f4	# Copy integer %value to floating-point processor
		cvt.d.w $f4, $f4	# Convert integer %value to double
		c.lt.d $f4, $f2		# Test if %value is less-than square root
		bc1t less_than_or_equal	# If less-than, go to less_than_or_equal label
		c.eq.d $f4, $f2		# Test if %value is equal-to square root
		bc1t less_than_or_equal	# If equal-to, go to less_than_or_equal label
		li $v1, 0		# Store a 0 in register $v1 to indicate greater-than condition
		j end_macro		# Go to the end_macro label
less_than_or_equal: 	
		li $v1, 1		# Store a 1 in register $v1 to indicate less-than or equal-to condition
end_macro: 
	.end_macro

main:
	# This series of instructions
	# 1. Displays the welcome message
	# 2. Displays the input prompt
	# 3. Reads input from the user
	display_string msg1	# Display welcome message
	display_string msg2	# Display input prompt
	li $v0, 5		# Prepare the system for keyboard input
	syscall			# System reads user input from keyboard
	move $a1, $v0		# Store the user input in register $a0
	j student_code 		# Go to the student_code label

error:	
	display_string msg3	# Display error message
	j exit
isprime:
	display_string msg4	# Display is prime message
	j exit
notprime:
	display_string msg5	# Display not prime message
exit:
	li $v0, 10	# Prepare to terminate the program
	syscall		# Terminate the program
	
#################################################################
# The code above is provided by the professor.     		#
# DO NOT MODIFY any code above the STUDENT_CODE label. 		#
#						       		#
# The professor will not troubleshoot any changes to this code. #
#################################################################

# Place all your code below the student_code label
student_code:

# test users input

	addi $t0, $zero, 0 # holds value 0 -> (0 + 0 = 0)
	addi $t1, $zero, 100 # holds value 100 -> (0 + 100 = 100)
	
	slt $t2, $a1, $t0 # $t2 = (1 or 0) if userInput < 0, print error message
	beq $t2, 1, error # $t2 = 1? then userInput < 0
	
	sgt $t3, $a1, $t1 # $t3 = (1 or 0) if userInput > 100, print error message
	beq $t3, 1, error # $t2 = 1? then userInput > 100
	
# preform prime test
	
	addi $t4, $zero, 2 # holds value of 2 -> (0 + 2 = 2)
	
	slt $t5, $a1, $t4 # $t5 = (1 or 0) if userInput < 2, print not prime message
	beq $t5, 1, notprime # $t5 = 1? number not prime

	beq $a1, $t4, keep_going # if userInput == 2, jump to keep_going
		
	div $a1, $t4 # checks if userInput % 2 == 0
	mfhi $t6 # moves remainder from above to $t6
	beq $t6, $t0, notprime # if userInput == 0, number not prime 
	
keep_going:

	addi $a2, $zero, 3 # acts as x-value for loop, value = 3
	calc_sqrt $a1 # calculates the square root of userInput
	
Loop: # sets up a for loop

	slt_sqrt $a2 # compares x with value in $f2 (which was calculated from calc_sqrt $a1)
	beq $v1, $t0, done # if $v1 0= 0, comparison is done, number is prime, jump to done
	
	div $a1, $a2 # input % x 
	mfhi $a3 # move remainder to $a3
	beq $a3, $t0, notprime  # remainder == 0? number not prime
		
	addi $a2, $a2, 2 # x = x + 2
	
	j Loop # loop again
	
done: 
	j isprime # loop is done (print is prime)
