        # Basic arithmetic instructions
        # This is a hodgepodge of arithmetic instructions to test
        # your basic functionality.
        # No overflow exceptions should occur
	.text
main:   
        addiu   $8, $zero, 10           # R8 = 1010 binary
        addiu   $9, $zero, 21           # R8 = 10101 binary
        xor     $10, $8, $9             # R10 = 11111 binary

        sll     $11, $9, 27             # R11 = 10101000000000000000000000000000 binary
        sllv    $12, $9, $8             # R12 = 101010000000000 binary
        srl     $13, $11, 3             # R13 = 00010101000000000000000000000000 binary
        
        addiu   $3, $zero, 3            # R3 = 3
        srlv    $2, $11, $3             # R2 = 11110101000000000000000000000000 binary

        addi    $14, $zero, 140         # R14 = 140
        addi    $15, $zero, 2047        # R15 = 2047
        addi    $24, $zero, -1024       # R16 = -1024
        
        sub $25, $14, $15               # R25 = 140 - 2047
        sub $4, $15, $14                # R4 = 2047 - 140
        sub $5, $15, $24                # R5 = 2047 - -1024
        sub $6, $24, $15                # R6 = -1024 - 2047

        syscall