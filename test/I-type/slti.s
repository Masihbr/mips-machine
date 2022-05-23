        # Basic branch test
	.text
    .set noreorder

main:
    addi $1, $0, -27
    slti $2, $1, 28
    slti $3, $1, 26
    slti $4, $1, -26
    slti $5, $1, -27
    slti $6, $1, -28
    addi $7, $0, 170
    slti $8, $7, 180
    slti $9, $7, 169
    syscall