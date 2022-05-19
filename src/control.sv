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
    opcode
);
    parameter OPCODE_LENGTH = 6;
    input [OPCODE_LENGTH-1:0] opcode;
    output reg reg_dst,
    output reg  [1:0] alu_src, // alu_src[0] => a, alu_src[1] => b
    output reg mem_to_reg,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg alu_op,
    output reg jump,
    always_comb @(*) begin
        reg_dst = 1'b0;
        alu_src = 2'b00;
        mem_to_reg = 1'b0;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 1'b0;
        alu_op = 1'b0;
        jump = 1'b0;
        case (opcode)
            6'b001001: begin
                alu_src = 1'b01;
                reg_write = 1'b1;
                alu_op = 1'b0;
            end
        endcase
    end
endmodule