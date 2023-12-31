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
    inst,
    reg_dst,
    reg_write,
    dest,
    src1,
    src2,
    alu_select,
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
    inst_in,
    reg_dst_in,
    reg_write_in,
    src1_in,
    src2_in,
    alu_select_in,
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
    input [31:0] inst_in;
    input        reg_dst_in;
    input        reg_write_in;
    input [4:0]  src1_in;
    input [4:0]  src2_in;
    input        clk;
    input        rst_b;
    input        freeze;
    input        alu_select_in;


    output reg [31:0] a;
    output reg [31:0] b;
    output reg [3:0]  control;
    output reg        mem_write;
    output reg        is_LB_SB;
    output reg [31:0] rt_data;
    output reg        cache_en;
    output reg        mem_to_reg;
    output reg [1:0]  jump;
    output reg [31:0] pc;
    output reg [31:0] inst;
    output reg        reg_dst;
    output reg        reg_write;
    output reg [4:0]  dest;
    output reg [4:0]  src1;
    output reg [4:0]  src2;
    output reg        alu_select;

    

  integer clk_count;

  always @ (posedge clk, negedge rst_b) begin
    if (!rst_b || inst_in == 0) begin
      clk_count <= 0;
      {a, b, control, is_LB_SB, mem_to_reg, jump, mem_write, rt_data, cache_en, pc, inst, reg_dst, reg_write, src1, src2, alu_select} <= 0;
    end
    else begin
      // $display("------------------ID TO EXE(%d)--------------", clk_count);
      // $display("a_in= %b", a_in);
      // $display("b_in= %b", b_in);
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
            inst <= inst_in;
            reg_dst <= reg_dst_in;
            reg_write <= reg_write_in;
            src1 <= src1_in;
            src2 <= src2_in;
            alu_select <= alu_select_in;
            dest <= (reg_dst_in == 1'b1) ? inst_in[15:11] : (jump_in == 2'b10) ? 5'd31 : inst_in[20:16];
        end
    end
  end
endmodule