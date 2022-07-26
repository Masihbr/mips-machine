module IF_stage(
    // outputs
    pc,
    flush,
    // inputs
    clk,
    rst_b,
    jump,
    branch,
    jr,
    zero,
    rs_data,
    inst,
    cache_en,
    hit,
    sign_extend_immediate, 
    freeze
);
    
    input            clk;
    input            rst_b;
    input [1:0]      jump;
    input [2:0]      branch;
    input            jr;
    input            zero;
    input [31:0]     rs_data;
    input [31:0]     inst;
    input            cache_en;
    input            hit;
    input [31:0]     sign_extend_immediate;
    input            freeze;
    
    output reg [31:0] pc;
    output            flush;

    wire [31:0] next_pc;
    wire [25:0] address;

    assign address = inst[25:0];

    pc_control pc_control(
        .next_pc(next_pc),
        .flush(flush),
        .pc(pc),
        .address(address),
        .jump(jump),
        .branch(branch),
        .jr(jr),
        .zero(zero),
        .sign_extend_immediate(sign_extend_immediate),
        .rs_data(rs_data)
    );

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            clk_count <= 0;
            pc <= 0;
        end
        else begin
            // $display("-------------------------- IF STAGE(%d) ---------------------", clk_count);
            // $display("pc= %b", pc);
            // $display("inst= %b",inst);
            clk_count <= clk_count + 1;
            if (!freeze) begin
                pc <= next_pc;           
            end
        end
    end

endmodule