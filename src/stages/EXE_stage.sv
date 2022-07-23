module EXE_stage(
    alu_result,
    zero,
    a,
    b,
    control,
    clk, 
    rst_b
);

    input [31:0] a;
    input [31:0] b;
    input [3:0]  control;
    input clk, rst_b;

    output [31:0] alu_result;
    output        zero;

    alu alu_unit(
        // outputs
        .alu_result(alu_result),
        .zero(zero),
        // inputs
        .a(a), 
        .b(b),
        .control(control)
    );
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