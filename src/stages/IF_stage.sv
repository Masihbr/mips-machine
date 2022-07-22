module IF_stage(
    // outputs
    PC,
    // inputs
    clk,
    rst_b,
    jump,
    branch,
    jr,
    do_extend,
    zero,
    rs_data,
    instruction,
    cache_en,
    hit,
    sign_extend_immediate,
);
    
    input            clk;
    input            rst_b;
    input [1:0]      jump;
    input [2:0]      branch;
    input            jr;
    input            do_extend;
    input            zero;
    input [31:0]     rs_data;
    input [31:0]     instruction;
    input            cache_en;
    input            hit;
    input [31:0]     sign_extend_immediate;
    
    output reg [31:0] pc;

    wire [31:0] next_pc;
    wire [25:0] address;

    assign address = instruction[25:0];

    pc_control pc_control(
        .next_pc(next_pc),
        .pc(pc),
        .address(address),
        .jump(jump),
        .branch(branch),
        .jr(jr),
        .zero(zero),
        .sign_extend_immediate(sign_extend_immediate),
        .rs_data(rs_data)
    );

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            pc <= 0;
        end
        else begin
            if (!cache_en || hit)
                pc <= next_pc;
        end
    end

endmodule