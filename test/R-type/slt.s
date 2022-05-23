        # Basic addition tests
	.text
main:   
        addi $3, $zero, 2
        addi $4, $zero, 1
        addi  $5, $zero, -1
        addi $6, $zero, -2
        slt $7, $5, $6 # -1 < -2
        slt $8, $6, $5 # -2 < -1
        slt $9, $6, $4 # -2 < 1
        slt $10, $4, $6 # 1 < -2
        slt $11, $3, $4 # 2 < 1
        slt $12, $4, $3 # 1 < 2
        slt $13, $zero, $zero # 0 < 0
        syscall
