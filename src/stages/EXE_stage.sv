module EXE_stage(
    alu_result,
    zero,
    a,
    b,
    control,
    alu_select,
    clk, 
    rst_b
);

    input [31:0] a;
    input [31:0] b;
    input [3:0]  control;
    input clk, rst_b;
    input alu_select;

    output [31:0] alu_result;
    output        zero;

    wire [31:0] int_alu_result;
    wire        int_alu_zero;

    wire [31:0] flaot_alu_result;
    wire        float_alu_zero;

    wire DBZ, QNAN, SNAN, Inexact, Underflow, Overflow;

    

    alu alu_unit(
        // outputs
        .alu_result(int_alu_result),
        .zero(int_alu_zero),
        // inputs
        .a(a), 
        .b(b),
        .control(control)
    );

    floating_point_alu falu(
        //outputs
        .falu_result(flaot_alu_result),
        .zero(float_alu_zero),
        .DBZ(DBZ),
        .QNAN(QNAN),
        .SNAN(SNAN),
        .Inexact(Inexact),
        .Underflow(Underflow),
        .Overflow(Overflow),
        //inputs
        .a(a),
        .b(b),
        .opcode(control)

    );

    assign alu_result = alu_select? flaot_alu_result : int_alu_result;
    assign zero = alu_select? float_alu_zero : int_alu_zero;

    integer clk_count;

    always_ff @(posedge clk, negedge rst_b) begin
        if(!rst_b )
            clk_count <= 0;
        else begin
            // $display("-----------------EXE stage(%d)-------------------", clk_count);
            // $display("alu_result=%b",alu_result);
            // $display("zero=%b",zero);
            
            clk_count <= clk_count + 1;
        end
    end
    
endmodule