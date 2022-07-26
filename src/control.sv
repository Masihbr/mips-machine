module control(
    // output
    mem_write,
    // is_imm,
    is_reg1_valid,
    is_reg2_valid,
    dest_reg_write,
    dest_reg_sel,
    is_sign_extended,
    alu_op,
    jump,
    branch,
    jr,
    cache_en,
    is_LB_SB,
    is_SW_SB,
    mem_to_reg,
    // inputs
    opcode,
    func
    // has_hazard
);
    parameter OPCODE_LENGTH = 6, FUNCT_LENGTH = 6;
    input [OPCODE_LENGTH-1:0] opcode;
    input [FUNCT_LENGTH-1:0]  func;
    // input                     has_hazard;
    
    output     cache_en;
    output reg dest_reg_sel; // 0 is for rt reg and 1 is for rd reg 
    output reg mem_to_reg;
    output reg dest_reg_write;
    output reg mem_write;
    output reg [2:0] branch;
    output reg [3:0] alu_op;
    output reg jr;
    output reg [1:0] jump;
    output reg is_sign_extended;
    output reg is_LB_SB;
    output reg is_SW_SB;
    output reg is_reg1_valid;
    output reg is_reg2_valid;

    reg mem_read;
    
    assign cache_en = (mem_write || mem_read);
    
    always_comb begin
        is_reg1_valid = 1'b1;
        is_reg2_valid = 1'b1;
        dest_reg_write = 1'b0;
        dest_reg_sel = 1'b0;
        is_sign_extended = 1'b1;
        alu_op = 4'b0000;
        jump = 2'b00;
        mem_to_reg = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 3'b000;
        jr = 1'b0;
        is_LB_SB = 1'b0;
        is_SW_SB = 1'b0;

        /* verilator lint_off CASEX */
        casex (opcode)
            // R-type
            6'b000000: begin 
                dest_reg_write = 1'b1;
                dest_reg_sel = 1'b1;
                case (func)
                    6'b000000, 6'b000010, 6'b000011: begin // SLL, SRL, SRA
                    is_reg1_valid = 1'b0;
                    alu_op = 4'b0000;
                    end
                    6'b001000: begin // jr
                        is_reg2_valid = 1'b0;
                        jr = 1'b1;
                    end
                    default: begin
                    end
                endcase
            end
            // I type
            6'b001000: begin // ADDi
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                alu_op = 4'b0001;
                // is_imm = 1'b1;
            end
            6'b001001: begin // ADDiu
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                is_sign_extended = 1'b0;
                alu_op = 4'b0010;
                // is_imm = 1'b1;
            end
            6'b001100: begin // ANDi
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                is_sign_extended = 1'b0;
                alu_op = 4'b0011;
                // is_imm = 1'b1;
            end

            6'b001110: begin // XORi
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                is_sign_extended = 1'b0;
                alu_op = 4'b0100;
                // is_imm = 1'b1;
            end
            
            6'b001101: begin // ORi
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                is_sign_extended = 1'b0;
                alu_op = 4'b0101;
                // is_imm = 1'b1;
            end

            6'b000100, 6'b000101: begin // BEQ, BNE
                branch = opcode[2:0];
                alu_op = 4'b1000;
                // is_imm = 1'b1;
            end

            6'b000110, 6'b000111: begin // BLEZ, BGTZ
                is_reg2_valid = 1'b0;
                branch = opcode[2:0];
                alu_op = 4'b1000;
                // is_imm = 1'b1;
            end

            6'b000001: begin // BGEZ
                is_reg2_valid = 1'b0;
                branch = 3'b001;
                // is_imm = 1'b1;
            end

                6'b100011: begin // LW 
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;

                alu_op = 4'b0001;
                mem_read = 1'b1; // has no effect
                mem_to_reg = 1;
                // is_imm = 1'b1;
            end

            6'b101011: begin // SW
                alu_op = 4'b0001;
                mem_write = 1'b1;
                is_SW_SB = 1'b1;
            end

            6'b100000: begin // LB
                dest_reg_write = 1'b1;
                alu_op = 4'b0001;
                is_LB_SB = 1'b1;
                mem_read = 1'b1; // has no effect
                mem_to_reg = 1;
                is_reg2_valid = 1'b0;
                // is_imm = 1'b1;
            end

            6'b101000: begin // SB
                alu_op = 4'b0001;
                is_LB_SB = 1'b1;
                mem_write = 1'b1;
                is_SW_SB = 1'b1;
            end
            
            
            6'b001010: begin // SLTi
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                alu_op = 4'b0110;
                // is_imm = 1'b1;
            end
            
            6'b001111: begin // Lui
                is_reg1_valid = 1'b0;
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                alu_op = 4'b0111;
                // is_imm = 1'b1;
            end

            // J type
            6'b000010: begin // J
                is_reg1_valid = 1'b0;
                is_reg2_valid = 1'b0;
                jump = 2'b01;
            end

            6'b000011: begin // JAL
                is_reg1_valid = 1'b0;
                is_reg2_valid = 1'b0;
                dest_reg_write = 1'b1;
                jump = 2'b10;
            end

            default: begin
            end
        endcase
    end
endmodule