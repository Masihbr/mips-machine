module ID_to_EXE (
    // outputs
    val1,
    val2,
    saved_val,
    control,
    mem_write,
    is_LB_SB,
    is_SW_SB,
    cache_en,
    mem_to_reg,
    jump,
    pc,
    dest_reg_num,
    reg_write,
    halted,
    // inputs
    val1_in,
    val2_in,
    saved_val_in,
    control_in,
    mem_write_in,
    is_LB_SB_in,
    is_SW_SB_in,
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

    input [31:0] val1_in;
    input [31:0] val2_in;
    input [3:0]  control_in;
    input        mem_write_in;
    input        is_LB_SB_in;
    input        is_SW_SB_in;
    input        cache_en_in;
    input        mem_to_reg_in;
    input [1:0]  jump_in;
    input [31:0] pc_in;
    input [4:0]  dest_reg_num_in;
    input        reg_write_in;
    input        halted_in;
    input [31:0] saved_val_in;

    input        clk;
    input        rst_b;
    input        freeze;


    output reg [31:0] val1;
    output reg [31:0] val2;
    output reg [31:0] saved_val;
    output reg [3:0]  control;
    output reg        mem_write;
    output reg        is_LB_SB;
    output reg        is_SW_SB;
    output reg        cache_en;
    output reg        mem_to_reg;
    output reg [1:0]  jump;
    output reg [31:0] pc;
    output reg [4:0]  dest_reg_num;
    output reg        reg_write;
    output reg        halted;

    

  integer clk_count;

  always @ (posedge clk, negedge rst_b) begin
    if (!rst_b) begin
      clk_count <= 0;
      {val1, val2, control, is_LB_SB, mem_to_reg, jump, mem_write, cache_en, pc, reg_write, dest_reg_num, halted, saved_val, is_SW_SB} <= 0;
    end
    else begin
      // $display("------------------ID TO EXE(%d)--------------", clk_count);
      // $display("val1_in= %b", val1_in);
      // $display("val2_in= %b", val2_in);
      // $display("control_in= %b", control_in);
      // $display("mem_write_in= %b", mem_write_in);
      // $display("is_LB_SB_in= %b", is_LB_SB_in);
      // $display("rt_data_in= %b", rt_data_in);
      // $display("cache_en_in= %b", cache_en_in);
      // $display("mem_to_reg_in= %b", mem_to_reg_in);
      // $display("jump_in= %b", jump_in);
      // $display("pc_in= %b", pc_in);
      // $display("inst_in= %b", inst_in);
      // $display("dest= %b", (reg_dst_in == 1'b1) ? inst_in[15:11] : (jump_in == 2'b10) ? 5'd31 : inst_in[20:16]);
      // $display("reg_dst_in= %b", reg_dst_in);
      // $display("reg_write_in= %b", reg_write_in);
      // $display("clk= %b", clk);
      // $display("rst_b= %b", rst_b);
      // $display("freeze= %b", freeze);

      clk_count <= clk_count + 1;
        if (~freeze) begin
            val1 <= val1_in;
            val2 <= val2_in;
            control <= control_in;
            is_LB_SB <= is_LB_SB_in;
            mem_to_reg <= mem_to_reg_in;
            jump <= jump_in;
            mem_write <= mem_write_in;
            // rt_data <= rt_data_in;
            cache_en <= cache_en_in;
            pc <= pc_in;
            // inst <= inst_in;
            // reg_dst <= reg_dst_in;
            reg_write <= reg_write_in;
            // src1 <= src1_in;
            // src2 <= src2_in;
            // dest <= (reg_dst_in == 1'b1) ? inst_in[15:11] : (jump_in == 2'b10) ? 5'd31 : inst_in[20:16];
            dest_reg_num <= dest_reg_num_in;
            halted <= halted_in;
            saved_val <= saved_val_in;
            is_SW_SB <= is_SW_SB_in;
        end
    end
  end
endmodule