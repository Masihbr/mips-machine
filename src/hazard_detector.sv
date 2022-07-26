module hazard_detector
(
  // outputs
  has_reg1_hazard_ID,
  has_reg2_hazard_ID,
  has_saved_val_hazard_ID,
  is_reg1_EXE_hazard,
  is_reg1_MEM_hazard,
  is_reg1_WB_hazard,
  is_reg2_EXE_hazard,
  is_reg2_MEM_hazard,
  is_reg2_WB_hazard,
  // inputs
  dest_reg_num_EXE,
  reg_write_EXE,
  dest_reg_num_MEM,
  reg_write_MEM,
  dest_reg_num_WB,
  reg_write_WB,
  reg1_num_ID,
  reg2_num_ID,
  is_reg1_valid_ID,
  is_reg2_valid_ID,
  is_SW_SB_ID
);
  input [4:0] dest_reg_num_EXE, dest_reg_num_MEM, dest_reg_num_WB, reg1_num_ID, reg2_num_ID;
  input       reg_write_EXE, reg_write_MEM, reg_write_WB, is_reg1_valid_ID, is_reg2_valid_ID, is_SW_SB_ID;
  output      has_reg1_hazard_ID, has_reg2_hazard_ID, has_saved_val_hazard_ID, is_reg1_WB_hazard, is_reg2_WB_hazard;
  
  output is_reg1_EXE_hazard, is_reg2_EXE_hazard, is_reg1_MEM_hazard, is_reg2_MEM_hazard;

  assign is_reg1_EXE_hazard = (reg_write_EXE && dest_reg_num_EXE == reg1_num_ID && reg1_num_ID != 0);
  assign is_reg2_EXE_hazard = (reg_write_EXE && dest_reg_num_EXE == reg2_num_ID && reg2_num_ID != 0);
  // assign is_EXE_hazard = is_reg1_EXE_hazard || is_reg2_EXE_hazard;

  assign is_reg1_MEM_hazard = (reg_write_MEM && dest_reg_num_MEM == reg1_num_ID && reg1_num_ID != 0);
  assign is_reg2_MEM_hazard = (reg_write_MEM && dest_reg_num_MEM == reg2_num_ID && reg2_num_ID != 0);
  // assign is_MEM_hazard = is_reg1_MEM_hazard || is_reg2_MEM_hazard;

  assign is_reg1_WB_hazard = (reg_write_WB && dest_reg_num_WB == reg1_num_ID && reg1_num_ID != 0);
  assign is_reg2_WB_hazard = (reg_write_WB && dest_reg_num_WB == reg2_num_ID && reg2_num_ID != 0);
  
  assign has_reg1_hazard_ID = is_reg1_valid_ID ? (is_reg1_EXE_hazard || is_reg1_MEM_hazard || is_reg1_WB_hazard) : 1'b0;
  assign has_reg2_hazard_ID = (is_reg2_valid_ID && !is_SW_SB_ID) ?  (is_reg2_EXE_hazard || is_reg2_MEM_hazard || is_reg2_WB_hazard) : 1'b0;
  assign has_saved_val_hazard_ID = is_SW_SB_ID ? (is_reg2_EXE_hazard || is_reg2_MEM_hazard || is_reg2_WB_hazard) : 1'b0;
endmodule
