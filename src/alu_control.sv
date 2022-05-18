module alu_control(
    control,
    alu_op,
    func
);
    parameter FUNCT_LENGTH = 6, ALU_OP_LENTH = 3, CONTROL_LENGTH = 4;

    input [FUNCT_LENGTH-1:0]    func;
    input [ALU_OP_LENTH-1:0]    alu_op;
    output [CONTROL_LENGTH-1:0] control;
    
    wire [FUNCT_LENGTH+ALU_OP_LENTH-1:0] _alu_control_in;
    assign _alu_control_in = {alu_op, func};

    always@(_alu_control_in) begin
        casex (_alu_control_in)
            : 
            default: 
        endcase
    end
endmodule