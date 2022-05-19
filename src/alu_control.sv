module alu_control(
    control,
    alu_op,
    func
);
    parameter FUNCT_LENGTH = 6, ALU_OP_LENTH = 3, CONTROL_LENGTH = 4;

    input [FUNCT_LENGTH-1:0]    func;
    input [ALU_OP_LENTH-1:0]    alu_op;
    output reg [CONTROL_LENGTH-1:0] control;

    always@(*) begin
        if (alu_op == 0) begin // R-type
            case (func)
                6'b100110: control = 5;
                6'b000000: control = 7;  
                6'b000100: control = 7;  
                6'b000010: control = 8;  
                6'b100010: control = 1;  
                6'b000110: control = 12;  
                6'b101010: control = 9;  
                6'b100011: control = 3;  
                6'b100101: control = 13;  
                6'b100111: control = 6;  
                6'b100001: control = 2;  
                6'b011000: control = 10;  
                6'b011010: control = 11;
                6'b100100: control = 4;
                6'b100000: control = 0;
                6'b000011: control = 12;
                default: control = 0;
            endcase
        end else begin
        case (alu_op)
            3'b001: control = 0; // addi, b*, lw, sw, lb, sb,
            3'b010: control = 2; // addiu
            3'b011: control = 4; // andi
            3'b100: control = 5; // xori
            3'b101: control = 13; // ori
            3'b110: control = 9; // slti
            3'b111: control = 14; // lui
            default: control = 0; 
        endcase
        end
    end
endmodule