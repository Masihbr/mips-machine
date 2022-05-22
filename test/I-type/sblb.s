
	    .text
        .set noreorder

main:
        li $2, 0xfafbfcfd
        li $3, 0x01020304
        sw $2, 0($zero)
        sw $3, 4($zero)
        lb $8, 0($zero)
        lb $9, 1($zero)
        lb $10, 2($zero)
        lb $11, 3($zero)
        lb $12, 4($zero)
        lb $13, 5($zero)
        lb $14, 6($zero)
        lb $15, 7($zero)
        syscall