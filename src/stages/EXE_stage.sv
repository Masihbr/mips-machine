module EXE_stage (
    // outputs
    alu_result,
    // inputs
    val1,
    val2,
    control
);

    input [31:0] val1;
    input [31:0] val2;
    input [3:0]  control;

    output [31:0] alu_result;

    alu alu_unit(
        // outputs
        .alu_result(alu_result),
        // inputs
        .a(val1), 
        .b(val2),
        .control(control)
    );
    
endmodule