module EXE_to_MEM(
  // outputs
  mem_write,
  alu_result,
  is_LB_SB,
  rt_data,
  cache_en,
  mem_to_reg,
  jump,
  pc,
  inst,
  reg_dst,
  reg_write,
  // inputs
  mem_write_in,
  alu_result_in,
  is_LB_SB_in,
  rt_data_in,
  cache_en_in,
  mem_to_reg_in,
  jump_in,
  pc_in,
  inst_in,
  reg_dst_in,
  reg_write_in,
  clk,
  rst_b,
  freeze
);

  input        mem_write_in;
  input [31:0] alu_result_in;
  input        is_LB_SB_in;
  input [31:0] rt_data_in;
  input        cache_en_in;
  input        mem_to_reg_in;
  input [1:0]  jump_in;
  input [31:0] pc_in;
  input [31:0] inst_in;
  input        reg_dst_in;
  input        reg_write_in;
  input        clk;
  input        rst_b;
  input        freeze;

  output reg        mem_write;
  output reg [31:0] alu_result;
  output reg        is_LB_SB;
  output reg [31:0] rt_data;
  output reg        cache_en;
  output reg        mem_to_reg;
  output reg [1:0]  jump;
  output reg [31:0] pc;
  output reg [31:0] inst;
  output reg        reg_dst;
  output reg        reg_write;

  integer clk_count;

  always @ (posedge clk, negedge rst_b) begin

    if (!rst_b || inst_in == 0) begin
      clk_count <= 0;
      {mem_write, alu_result, is_LB_SB, rt_data, cache_en, mem_to_reg, jump, pc, inst, reg_dst, reg_write} <= 0;
    end
    else begin
      // $display("------------------EXE TO MEM(%d)--------------", clk_count);
      // $display("mem_write_in= %b",mem_write_in);
      // $display("alu_result_in= %b",alu_result_in);
      // $display("is_LB_SB_in= %b",is_LB_SB_in);
      // $display("rt_data_in= %b",rt_data_in);
      // $display("cache_en_in= %b",cache_en_in);
      // $display("mem_to_reg_in= %b",mem_to_reg_in);
      // $display("jump_in= %b",jump_in);
      // $display("pc_in= %b",pc_in);
      // $display("inst_in= %b",inst_in);
      // $display("reg_dst_in= %b",reg_dst_in);
      // $display("reg_write_in= %b",reg_write_in);
      // $display("clk= %b",clk);
      // $display("rst_b= %b",rst_b);
      // $display("freeze= %b",freeze);

      clk_count <= clk_count + 1;
      if (~freeze) begin
          mem_write <= mem_write_in;
          alu_result <= alu_result_in;
          is_LB_SB <= is_LB_SB_in;
          rt_data <= rt_data_in;
          cache_en <= cache_en_in;
          mem_to_reg <= mem_to_reg_in;
          jump <= jump_in;
          pc <= pc_in;
          inst <= inst_in;
          reg_dst <= reg_dst_in;
          reg_write <= reg_write_in;
      end
    end
  end

endmodule
