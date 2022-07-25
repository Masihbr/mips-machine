module EXE_stage (
    // outputs
    alu_result,
    // inputs
    val1,
    val2,
    control,
    clk,
    rst_b
);

    input [31:0] val1;
    input [31:0] val2;
    input [3:0]  control;
    input clk, rst_b;

    output [31:0] alu_result;

    alu alu_unit(
        // outputs
        .alu_result(alu_result),
        // inputs
        .a(val1), 
        .b(val2),
        .control(control)
    );
    
    integer clk_count;

    always_ff @(posedge clk, negedge rst_b) begin
        if(!rst_b )
            clk_count <= 0;
        else begin
            // // $display("-----------------EXE stage(%d)-------------------", clk_count);
            // // $display("alu_result=%b",alu_result);
            // // $display("zero=%b",zero);
            
            clk_count <= clk_count + 1;
        end
    end
    
endmodule