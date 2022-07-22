module ID_to_EXE (
    a,
    b,
    control,
    mem_write,
    alu_result,
    is_LB_SB,
    rt_data,
    mem_data_out,
    cache_en,
    mem_to_reg,
    jump,
    pc,
    a_in,
    b_in,
    control_in,
    mem_write_in,
    alu_result_in,
    is_LB_SB_in,
    rt_data_in,
    mem_data_out_in,
    cache_en_in,
    mem_to_reg_in,
    jump_in,
    pc_in,
    clk,
    rst_b,
    freeze
);
    input clk;
    input rst_b;
    input freeze;

    input [31:0]      a_in;
    input [31:0]      b_in;
    input [3:0]       control_in;

    
    output [31:0]      a;
    output [31:0]      b;
    output [3:0]       control;

  always @ (posedge clk, negedge rst_b) begin
    if (!rst_b) begin
      {a, b, control} <= 0;
    end
    else begin
        if (~freeze) begin
            a <= a_in;
            b <= b_in;
            control <= control_in;
        end
    end
  end
endmodule