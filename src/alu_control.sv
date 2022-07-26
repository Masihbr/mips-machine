module alu_control(
    control,
    alu_select,
    alu_op,
    func
);
    parameter FUNCT_LENGTH = 6, ALU_OP_LENTH = 4, CONTROL_LENGTH = 4;

    input [FUNCT_LENGTH-1:0]    func;
    input [ALU_OP_LENTH-1:0]    alu_op;
    output reg [CONTROL_LENGTH-1:0] control;
    output reg alu_select;

    always@(*) begin
        alu_select = 0;
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
                6'b111111: begin // addf
                    control = 0;
                    alu_select = 1;
                end
                6'b111110: begin // subf
                    control = 1;
                    alu_select = 1;
                end
                6'b111101: begin // multf
                    control = 2;
                    alu_select = 1;
                end
                6'b111011: begin // gf
                    control = 3;
                    alu_select = 1;
                end
                6'b110111: begin // divf
                    control = 4;
                    alu_select = 1;
                end
                6'b101111: begin // invf
                    control = 5;
                    alu_select = 1;
                end
                6'b011111: begin // roundf
                    control = 6;
                    alu_select = 1;
                end
                6'b001111: begin // lf
                    control = 7;
                    alu_select = 1;
                end
                
                default: control = 0;
            endcase
        end else begin
        case (alu_op)
            4'b0001: control = 0; // addi, b*, lw, sw, lb, sb,
            4'b0010: control = 2; // addiu
            4'b0011: control = 4; // andi
            4'b0100: control = 5; // xori
            4'b0101: control = 13; // ori
            4'b0110: control = 9; // slti
            4'b0111: control = 14; // lui
            4'b1000: control = 3; // (sub)beq
            default: control = 0; 
        endcase
        end
    end
endmodule