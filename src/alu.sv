module alu(
    alu_result,
	a, 
    b,
    control
);
    parameter LENGTH = 32, CONTROL_LENGTH = 4;


    input [LENGTH-1:0]          a;
    input [LENGTH-1:0]          b;
    input [CONTROL_LENGTH-1:0]  control;
    output reg [LENGTH-1:0]     alu_result;

    always_comb begin
        case (control)
            0: alu_result = $signed(a) + $signed(b); // add
            1: alu_result = $signed(a) - $signed(b); //signed sub
            2: alu_result = a + b; // unsigned add
            3: alu_result = a - b; // unsigned sub
            4: alu_result = a & b; // and
            5: alu_result = a ^ b; // xor
            6: alu_result = a ~| b; // nor
            7: alu_result = b << a; // shift left
            8: alu_result = b >> a; // unsigned shift right
            9: alu_result = {{31{1'b0}}, ($signed(a) < $signed(b))}; // compare
            10: alu_result = $signed(a) * $signed(b); // mult
            11: alu_result = $signed(a) / $signed(b); // div
            12: alu_result = $signed(b) >>> a; // signed shift right  
            13: alu_result = a | b; // or
            14: alu_result = b << 16; // lui
            default: alu_result = 0;
        endcase
    end
endmodule