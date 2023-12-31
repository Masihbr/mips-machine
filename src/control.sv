module control(
    reg_dst,
    alu_src,
    is_LB_SB,
    mem_to_reg,
    reg_write,
    mem_read,
    mem_write,
    cache_en,
    branch,
    alu_op,
    jr,
    jump,
    do_extend,
    is_imm,
    is_src1_valid,
    is_src2_valid,
    opcode,
    func,
    has_hazard
);
    parameter OPCODE_LENGTH = 6, FUNCT_LENGTH = 6;
    input [OPCODE_LENGTH-1:0] opcode;
    input [FUNCT_LENGTH-1:0]  func;
    input                     has_hazard;
    
    output     cache_en;
    output reg reg_dst;
    output reg [1:0] alu_src; // alu_src[0] => a, alu_src[1] => b
    output reg mem_to_reg;
    output reg reg_write;
    output reg mem_read;
    output reg mem_write;
    output reg [2:0] branch;
    output reg [3:0] alu_op;
    output reg jr;
    output reg [1:0]jump;
    output reg do_extend;
    output reg is_LB_SB;
    output reg is_imm;
    output reg is_src1_valid;
    output reg is_src2_valid;

    assign cache_en = (mem_write || mem_read);
    
    always_comb begin
        reg_dst = 1'b0;
        alu_src = 2'b00;
        mem_to_reg = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 3'b000;
        alu_op = 4'b0000;
        do_extend = 1'b1;
        jr = 1'b0;
        jump = 2'b00;
        is_LB_SB = 1'b0;
        is_imm = 1'b0;
        is_src1_valid = 1'b1;
        is_src2_valid = 1'b1;
        /* verilator lint_off CASEX */
        if (!has_hazard) begin
            casex (opcode)
                6'b000000: begin // I-type
                    alu_src = 2'b00;
                    reg_write = 1'b1;
                    reg_dst = 1'b1;
                    case (func)
                        6'b000000, 6'b000010, 6'b000011: begin // shifts
                        alu_src[0] = 1'b1; // use sh_amount
                        alu_op = 4'b0000;
                        is_src1_valid = 1'b0;
                        end
                        6'b001000: begin // jr
                            jr = 1'b1;
                            is_src2_valid = 1'b0;
                        end
                        default: begin
                        end
                    endcase
                end
                // R-type - J-type
                6'b001000: begin // ADDi
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0001;
                    is_imm = 1'b1;
                    is_src2_valid = 1'b0;
                end
                6'b001001: begin // ADDiu
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0010;
                    do_extend = 1'b0;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end
                6'b001100: begin // ANDi
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0011;
                    do_extend = 1'b0;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end

                6'b001110: begin // XORi
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0100;
                    do_extend = 1'b0;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end
                
                6'b001101: begin // ORi
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    do_extend = 1'b0;
                    alu_op = 4'b0101;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end

                6'b000100, 6'b000101: begin // BEQ, BNE
                    alu_src = 2'b00;
                    branch = opcode[2:0];
                    alu_op = 4'b1000;
                    is_imm = 1'b1;
                end

                6'b000110, 6'b000111: begin // BLEZ, BGTZ
                    alu_src = 2'b00;
                    branch = opcode[2:0];
                    alu_op = 4'b1000;
                    is_imm = 1'b1;
                    is_src2_valid = 1'b0;
                end

                6'b000001: begin // BGEZ
                    alu_src = 2'b00;
                    branch = 3'b001;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end
                
                6'b001111: begin // Lui
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0111;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end

                6'b000010: begin // j
                    is_src1_valid = 1'b0;
                    is_src2_valid = 1'b0;
                    jump = 2'b01;
                end

                6'b000011: begin // jal
                    jump = 2'b10;
                    is_src1_valid = 1'b0;
                    is_src2_valid = 1'b0;
                    reg_write = 1'b1;
                end

                6'b100011: begin // LW 
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0001;
                    mem_read = 1'b1; // has no effect
                    mem_to_reg = 1;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end

                6'b101011: begin // SW
                    alu_src = 2'b10;
                    alu_op = 4'b0001;
                    mem_write = 1'b1;
                    is_imm = 1'b1;
                end

                6'b100000: begin // LB
                    alu_src = 2'b10;
                    reg_write = 1'b1;
                    alu_op = 4'b0001;
                    mem_read = 1'b1; // has no effect
                    mem_to_reg = 1;
                    is_LB_SB = 1'b1;
                    is_imm = 1'b1;
                end

                6'b101000: begin // SB
                    alu_src = 2'b10;
                    alu_op = 4'b0001;
                    mem_write = 1'b1;
                    is_LB_SB = 1'b1;
                    is_imm = 1'b1;
                end
                
                
                6'b001010: begin // SLTi
                    alu_src = 2'b10;
                    alu_op = 4'b0110;
                    reg_write = 1'b1;
                    is_src2_valid = 1'b0;
                    is_imm = 1'b1;
                end

                default: begin
                    alu_src = 2'b00;
                end
            endcase
        end
        else begin
            {reg_write, mem_write, alu_op} = 0;
        end
    end
endmodule