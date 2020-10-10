	.data
    myarray: 
		.space 400004	#space to store the array
	N:
		.word 0			#store the number of elements in array
		
	A:
		.word 1664525
	B:
		.word 22695477
	
	mid_left:
		.word 0
	mid_right:
		.word 0
	
    st1:
		.asciiz "\nEnter the number of elements that you want to sort:\n"
	st2:
		.asciiz "\nEnter each element in the array:\n"
	st3:
		.asciiz "\nInput done and now sorting...\n"
	st4:
		.asciiz "\nSorted List:\n"
	xd:
		.asciiz "\n"

	.text
	
#########################################################################
#while	(mid_right	>=	i	&&	A[mid_right]	>	pivot)	mid_right--;#
#########################################################################
loop1:
	#condition to break
	bgt $t1, $s2, exit_loop1	# if i > mid_right then break
	mul $t3, $s2, 4				# t3 = mid_right*4
	lw $t4, myarray($t3)   		# t4 = A[mid_right]
	bge $t2, $t4, exit_loop1	# if pivot >= A[mid_right] then break
	
	addi $s2, $s2, -1			# mid_right--
	j loop1
	
exit_loop1:
	jr $ra

#####################################################################
#while	(mid_right	>=	i	&&	A[i]	<=	pivot)	{               #	
#A[mid_left++]	=	A[i];	                                        #
#A[i++]	=	pivot;	                                                #
#								}                                   #
#####################################################################
loop2:
	#condition to break
	bgt $t1, $s2, exit_loop2 	# if i > mid_right then break
	mul $t3, $t1, 4				# t3 = i*4
	lw $t4, myarray($t3)   		# t4 = A[i]
	bgt $t4, $t2, exit_loop2	# if A[i] > pivot then break
	
	mul $t3, $t1, 4				# t3 = i*4
	lw $t4, myarray($t3)   		# t4 = A[i]
	mul $t3, $s1, 4				# t3 = mid_left*4
	sw $t4, myarray($t3)		# A[mid_left] = A[i]
	addi $s1, $s1, 1			# mid_left++
	
	mul $t3, $t1, 4				# t3 = i*4
	sw $t2, myarray($t3) 		# A[i] = pivot
	addi $t1, $t1, 1			# i++
	j loop2
			
exit_loop2:
	jr $ra

#####################################################################
# This part is the Big while(1) loop                                #
# Inside this part, I will call loop1 and loop2						#
#####################################################################
loop:
		
	jal loop1

	jal loop2
	
	bge $t1, $s2, exit_loop			# if i>= mid_right then break
	
	mul $t3, $s2, 4					# t3 = mid_right*4
	lw $t4, myarray($t3)   			# t4 = A[mid_right]
	mul $t3, $s1, 4					# t3 = mid_left*4
	sw $t4, myarray($t3)			# A[mid_left]=A[mid_right]
	addi $s1, $s1, 1				# mid_left++
	
	mul $t3, $t1, 4					# t3 = i*4
	lw $t4, myarray($t3)   			# t4 = A[i]
	mul $t3, $s2, 4					# t3 = mid_right*4
	sw $t4, myarray($t3)			# A[mid_right]=A[i]
	addi $s2, $s2, -1				# mid_right--
	
	mul $t3, $t1, 4					# t3 = i*4
	sw $t2, myarray($t3)			# A[i]=pivot
	addi $t1, $t1, 1				# i++
	j loop
	
exit_loop:
	sw $s1, mid_left				# update mid_left
	sw $s2, mid_right				# update mid_right
	lw $ra, 0($sp)					# load the $ra from stack in order to return to the quicksort function
	addi $sp, $sp, 4				# delete from stack
	jr $ra

#####################################################################
# This part is the partition function                               #
# Inside this part, I will call loop, and after the loop completed, #
# loop will return directly to quicksort function  					#
#####################################################################
partition: 	
	add $s1, $a1, $zero				#s1 = mid_left = low
	add $s2, $a2, $zero 			#s2 = mid_right = high
	
	sub $t1, $s2, $s1 		
	addi $t1, $t1, 1				#t1=high-low+1
	lw $t2, A
	lw $t3, B
	
	rem $t2, $t2, $t1				#t2 = 1664525 % t1
	rem $t8, $s2, $t1				#t8 = high % t1
	mul $t2, $t2, $t8				#t2 = t2 * t8 = (1664525 % t1)*(high % t1)
	rem $t2, $t2, $t1				#t2 = t2 % t1 = ((1664525 % t1)*(high % t1))%t1
	
	rem $t3, $t3, $t1				#t3 = 22695477 % t1
	rem $t8, $s1, $t1				#t8 = low % t1
	mul $t3, $t3, $t8				#t3 = t3 * t8 = (22695477 % t1)*(low % t1)
	rem $t3, $t3, $t1				#t3 = t3 % t1 = ((22695477 % t1)*(low % t1)) % t1

	add $t2, $t2, $t3				#(1664525*(unsigned)high	+	22695477*(unsigned)low)%(high-low+1)
	rem $t2, $t2, $t1
	
	add $t1, $s1, $t2 				#t1 = i = low + (1664525*(unsigned)high	+	22695477*(unsigned)low)%(high-low+1), now t1 is i
	
	mul $t3, $t1, 4					#t3= t1 * 4 = i * 4
	mul $t4, $s1, 4					#t4= s1 * 4 = low * 4
	
	lw $t2, myarray($t3)  			# t2 = pivot = A[i], now t2 is pivot
	lw $t5, myarray($t4)			# t5 = A[low]
	sw $t5, myarray($t3)			# A[i] = A[low]
	sw $t2, myarray($t4)			# A[low] = pivot

	addi $t1, $s1, 1 				# i = low + 1
	
	addi $sp, $sp, -4				# prepare stack for 1 values
	sw $ra, 0($sp)
	
	jal loop

#####################################################################
# This part is the quicksort function                               #
# Inside this part, I will call partition. 		 					#
#####################################################################
quicksort:
	
	addi $sp, $sp, -12				# prepare stack for 3 values

	sw $a1, 0($sp)					# store low to stack
	sw $a2, 4($sp)					# store high to stack
	sw $ra, 8($sp)					# store $ra to stack

	bge $a1, $a2, exit_quicksort 	#if low>=high then exit_quicksort

	jal partition					# call partition 
	lw $s0, mid_left				# mid_left
	lw $s1, mid_right				# mid_right

	lw $a1, 0($sp)					#a1 = low
	addi $a2, $s0, -1				#a2 = mid_left -1
	jal quicksort					#call quicksort
	
	addi $a1, $s1, 1				#a1 = mid_right + 1
	lw $a2, 4($sp)					#a2 = high
	jal quicksort					#call quicksort

exit_quicksort:
	lw $a1, 0($sp)					# load low from stack
	lw $a2, 4($sp)					# load high from stack
	lw $ra, 8($sp)					# load $ra to return correctly
	addi $sp, $sp, 12				# delete the value from the stack
	jr $ra

#####################################################################
# This part is the function to read the array of N elements         #
#####################################################################
readarr:
	beq $t1,$t0,exit_readarr	#if t1 == t0 then exit
	li $v0,5					#read integer
	syscall				
	sw $v0,myarray($t1)			#store a new integer into array[t1/4]
	add $t1,$t1,4				#increase the pointer of array
	j readarr					#loop

exit_readarr:
	jr $ra

#####################################################################
# This part is the function to print the array after sorted         #
#####################################################################
print_result:
	beq $t1,$t0,exit_print_result	#if t1 == t0 then exit
	li $v0,1						#print integer
	lw $a0, myarray($t1)			#a0 = A[t1/4]
	syscall
	
	li $v0,4						#new line
	la $a0, xd
	syscall
	
	add $t1,$t1,4					#increase the pointer of array
	j print_result					#loop

exit_print_result:
	jr $ra


#####################################################################
# Main function												        #
#####################################################################
main:
	#Print the request to input N
	li $v0,4
    la $a0,st1
    syscall
	
	#Read N
	li $v0, 5  			#Read n which is the number of elements in array
	syscall
	sw $v0, N			#store the number of elements in N
	
	# create the top boundary of the space in order to loop and read N elements
	mul $t0, $v0, 4		# t0 = N*4+4
	addi $t0, $t0, 4

	# start to read N elements
	li $t1,4 			#initialize t1 = 4
	li $v0,4
    la $a0,st2
    syscall
	jal readarr
	
	#Read done
	li $v0,4
    la $a0,st3
    syscall
	
	#Sorting
	li $a1, 1
	lw $a2, N
	jal quicksort
	
	#Sorted
	li $v0,4
    la $a0,st4
    syscall
	
	#print_result
	li $t1,4 			#initialize t1 = 4
	jal print_result
	
	#exit the program
	li $v0,10
	syscall