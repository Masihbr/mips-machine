        # Basic branch test
	.text
        .set noreorder

main:
        addiu $v0, $zero, 0xa
l_0:    
        j l_1
l_1:
        bne $zero, $zero, l_3
l_2:
        beq $zero, $zero, l_4
        addiu $7, $zero, 0x347
        syscall
l_3:
	addiu $7, $zero, 0x1337
        # Should not reach here
l_4:    
        addi $10, $zero, 10
        addi $11, $zero, 1 
        j l_5
l_6:        
        addiu $7, $zero, 0xd00d
        syscall
l_5:    
        sub $10, $10, $11
        beq $10, $zero, l_6
        jal l_5
        syscall

        
