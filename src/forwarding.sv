module forwarding 
(
  src1_EXE,
  src2_EXE,
  ST_src_EXE,
  dest_MEM,
  dest_WB,
  reg_write_MEM,
  WB_EN_WB,
  val1_sel,
  val2_sel,
  ST_val_sel
);

  input [31:0] src1_EXE, src2_EXE, ST_src_EXE;
  input [31:0] dest_MEM, dest_WB;
  input reg_write_MEM, WB_EN_WB;
  output reg [31:0] val1_sel, val2_sel, ST_val_sel;

  always_comb begin
    // initializing sel signals to 0
    // they will change to enable forwrding if needed.
    {val1_sel, val2_sel, ST_val_sel} = 0;

    // determining forwarding control signal for store value (ST_val)
    if (reg_write_MEM && ST_src_EXE == dest_MEM) ST_val_sel = 2'd1;
    else if (WB_EN_WB && ST_src_EXE == dest_WB) ST_val_sel = 2'd2;

    // determining forwarding control signal for ALU val1
    if (reg_write_MEM && src1_EXE == dest_MEM) val1_sel = 2'd1;
    else if (WB_EN_WB && src1_EXE == dest_WB) val1_sel = 2'd2;

    // determining forwarding control signal for ALU val2
    if (reg_write_MEM && src2_EXE == dest_MEM) val2_sel = 2'd1;
    else if (WB_EN_WB && src2_EXE == dest_WB) val2_sel = 2'd2;
  end
endmodule // forwarding
