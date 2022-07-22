module ID_to_EXE (
    // outputs
    a,
    b,
    control,
    is_LB_SB,
    mem_to_reg,
    jump,
    mem_write,
    rt_data,
    cache_en,
    pc,
    // inputs
    a_in,
    b_in,
    control_in,
    is_LB_SB_in,
    mem_to_reg_in,
    jump_in,
    mem_write_in,
    rt_data_in,
    cache_en_in,
    pc_in,
    clk,
    rst_b,
    freeze
);

    input [31:0] a_in;
    input [31:0] b_in;
    input [3:0]  control_in;
    input        mem_write_in;
    input        is_LB_SB_in;
    input [31:0] rt_data_in;
    input        cache_en_in;
    input        mem_to_reg_in;
    input [1:0]  jump_in;
    input [31:0] pc_in;
    input        clk;
    input        rst_b;
    input        freeze;

    output [31:0] a;
    output [31:0] b;
    output [3:0]  control;
    output        mem_write;
    output        is_LB_SB;
    output [31:0] rt_data;
    output        cache_en;
    output        mem_to_reg;
    output [1:0]  jump;
    output [31:0] pc;

  always @ (posedge clk, negedge rst_b) begin
    if (!rst_b) begin
      {a, b, control, is_LB_SB, mem_to_reg, jump, mem_write, rt_data, cache_en, pc} <= 0;
    end
    else begin
        if (~freeze) begin
            a <= a_in;
            b <= b_in;
            control <= control_in;
            is_LB_SB <= is_LB_SB_in;
            mem_to_reg <= mem_to_reg_in;
            jump <= jump_in;
            mem_write <= mem_write_in;
            rt_data <= rt_data_in;
            cache_en <= cache_en_in;
            pc <= pc_in;
        end
    end
  end
endmodule
// ID_to_EXE:
//     - a
//     - b
//     - control
//     - is_LB_SB
//     - mem_to_reg
//     - jump
//     - mem_write
//     - rt_data
//     - cache_en
//     - pc