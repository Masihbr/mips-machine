module EXE_to_MEM(
  // outputs
  mem_write,
  alu_result,
  is_LB_SB,
  is_SW_SB,
  val2,
  saved_val,
  cache_en,
  mem_to_reg,
  jump,
  pc,
  dest_reg_num,
  reg_write,
  halted,
  // inputs
  mem_write_in,
  alu_result_in,
  is_LB_SB_in,
  is_SW_SB_in,
  val2_in,
  saved_val_in,
  cache_en_in,
  mem_to_reg_in,
  jump_in,
  pc_in,
  dest_reg_num_in,
  reg_write_in,
  halted_in,
  clk,
  rst_b,
  freeze
);

  input        mem_write_in;
  input [31:0] alu_result_in;
  input        is_LB_SB_in;
  input        is_SW_SB_in;
  input [31:0] val2_in;
  input [31:0] saved_val_in;
  input        cache_en_in;
  input        mem_to_reg_in;
  input [1:0]  jump_in;
  input [31:0] pc_in;
  input        reg_write_in;
  input [4:0]  dest_reg_num_in;
  input        halted_in;
  input        clk;
  input        rst_b;
  input        freeze;

  output reg        mem_write;
  output reg [31:0] alu_result;
  output reg        is_LB_SB;
  output reg        is_SW_SB;
  output reg [31:0] val2;
  output reg [31:0] saved_val;
  output reg        cache_en;
  output reg        mem_to_reg;
  output reg [1:0]  jump;
  output reg [31:0] pc;
  output reg        reg_write;
  output reg [4:0]  dest_reg_num;
  output reg        halted;


  always @ (posedge clk, negedge rst_b) begin
    if (!rst_b) begin
      {mem_write, alu_result, is_LB_SB, val2, cache_en, mem_to_reg, jump, pc, reg_write, dest_reg_num, halted, saved_val, is_SW_SB} <= 0;
    end
    else begin
      if (~freeze) begin
          mem_write <= mem_write_in;
          alu_result <= alu_result_in;
          is_LB_SB <= is_LB_SB_in;
          val2 <= val2_in;
          cache_en <= cache_en_in;
          mem_to_reg <= mem_to_reg_in;
          jump <= jump_in;
          pc <= pc_in;
          reg_write <= reg_write_in;
          dest_reg_num <= dest_reg_num_in;
          halted <= halted_in;
          saved_val <= saved_val_in;
          is_SW_SB <= is_SW_SB_in;
      end
    end
  end

endmodule
