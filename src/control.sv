module control(
    reg_dst,
    alu_src,
    mem_to_reg,
    reg_write,
    mem_read,
    mem_write,
    branch,
    alu_op,
    jump,
    do_extend,
    opcode,
    func
);
    parameter OPCODE_LENGTH = 6, FUNCT_LENGTH = 6;
    input [OPCODE_LENGTH-1:0] opcode;
    input [FUNCT_LENGTH-1:0] func;
    output reg reg_dst;
    output reg [1:0] alu_src; // alu_src[0] => a, alu_src[1] => b
    output reg mem_to_reg;
    output reg reg_write;
    output reg mem_read;
    output reg mem_write;
    output reg branch;
    output reg [2:0] alu_op;
    output reg jump;
    output reg do_extend;
    always_comb begin
        reg_dst = 1'b0;
        alu_src = 2'b00;
        mem_to_reg = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 1'b0;
        alu_op = 3'b000;
        do_extend = 1'b1;
        jump = 1'b0;
        case (opcode)
            6'b000000: begin
                alu_src = 2'b00;
                reg_write = 1'b1;
                reg_dst = 1'b1;
                case (func)
                    6'b000000, 6'b000010, 6'b000011: begin
                    alu_src[0] = 1'b1; // use sh_amount
                    alu_op = 3'b000;
                    end
                    default: begin
                    end
                endcase
            end
            6'b001000: begin
                alu_src = 2'b10;
                reg_write = 1'b1;
                alu_op = 3'b001;
            end
            6'b001001: begin
                alu_src = 2'b10;
                reg_write = 1'b1;
                alu_op = 3'b010;
            end
            6'b001110: begin
                alu_src = 2'b10;
                reg_write = 1'b1;
                alu_op = 3'b100;
            end
            6'b001111: begin
                alu_src = 2'b10;
                reg_write = 1'b1;
                alu_op = 3'b111;
            end
            6'b001101: begin
                alu_src = 2'b10;
                reg_write = 1'b1;
                do_extend = 1'b0;
                alu_op = 3'b101;
            end
            default: begin
                alu_src = 2'b00;
            end
        endcase
    end
endmodule