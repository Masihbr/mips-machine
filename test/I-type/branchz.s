        # Basic branch test
	.text
        .set noreorder

main:
        addiu $v0, $zero, 0xa
l_0:    
        addiu $5, $zero, 1
        j l_1
        addiu $10, $10, 0xf00
        ori $0, $0, 0
        ori $0, $0, 0
        addiu $5, $zero, 100
        syscall        
l_1:
        bgtz $zero, l_3
        ori $0, $0, 0
        ori $0, $0, 0
        addiu $6, $zero, 0x1337
l_2:
        blez $zero, l_4
        ori $0, $0, 0
        ori $0, $0, 0
        # Should not reach here
        addiu $7, $zero, 0x347
        syscall
l_3:
        # Should not reach here
        addiu $8, $zero, 0x347
        syscall
l_4:    
        addi $10, $zero, -10
        blez $10, l_6
l_5:
        addiu $7, $zero, 0xd00d
        syscall
l_6:    
        bgtz $10, l_4   # shouldn't jump
        bgtz $zero, l_4 # shouldn't jump
        addi $10, $10, 11
        bgez $10, l_5   # should jump back
        syscall
