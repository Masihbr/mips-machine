module EXE_stage(
    alu_result,
    zero,
    a,
    b,
    control
);

    input [31:0] a;
    input [31:0] b;
    input [3:0]  control;

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
endmodule