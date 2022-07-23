module hazard_detector
(
  is_imm,
  is_src1_valid,
  is_src2_valid,
  rs_num,
  rt_num,
  dest_EXE,
  reg_write_EXE,
  dest_MEM,
  reg_write_MEM,
  mem_write_EXE,
  has_hazard
);
  input [4:0] rs_num, rt_num;
  input [4:0] dest_EXE, dest_MEM;
  input  reg_write_EXE, reg_write_MEM, is_imm, mem_write_EXE, is_src1_valid, is_src2_valid;
  output has_hazard;

  wire exe_has_hazard, mem_has_hazard, hazard;

  assign exe_has_hazard = reg_write_EXE && ((is_src1_valid && rs_num == dest_EXE) || (is_src2_valid && rt_num == dest_EXE));
  assign mem_has_hazard = reg_write_MEM && ((is_src1_valid && rs_num == dest_MEM) || (is_src2_valid && rt_num == dest_MEM));

  assign has_hazard = (exe_has_hazard || mem_has_hazard);

endmodule
