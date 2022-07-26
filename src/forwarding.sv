module forwarding 
(
  // outputs
  reg1_selected_data,
  reg2_selected_data,
  saved_val_selected_data,
  // inputs
  reg1_data,
  reg2_data,
  has_reg1_hazard,
  has_reg2_hazard,
  has_saved_val_hazard,
  is_reg1_EXE_hazard,
  is_reg1_MEM_hazard,
  is_reg1_WB_hazard,
  is_reg2_EXE_hazard,
  is_reg2_MEM_hazard,
  is_reg2_WB_hazard,
  EXE_data,
  MEM_data,
  WB_data
);

  input [31:0] reg1_data, reg2_data, EXE_data, MEM_data, WB_data;
  input has_reg1_hazard, has_reg2_hazard, has_saved_val_hazard;
  input is_reg1_EXE_hazard, is_reg1_MEM_hazard, is_reg1_WB_hazard, is_reg2_EXE_hazard, is_reg2_MEM_hazard, is_reg2_WB_hazard;
  output reg [31:0] reg1_selected_data, reg2_selected_data, saved_val_selected_data;

  always_comb begin
    reg1_selected_data = reg1_data;
    reg2_selected_data = reg2_data;
    saved_val_selected_data = reg2_data;
    // reg1
    if (has_reg1_hazard) begin
      if (is_reg1_EXE_hazard) reg1_selected_data = EXE_data;
      else if (is_reg1_MEM_hazard) reg1_selected_data = MEM_data;
      else if (is_reg1_WB_hazard) reg1_selected_data = WB_data;
    end else reg1_selected_data = reg1_data;
    // reg2
    if (has_reg2_hazard) begin
      if (is_reg2_EXE_hazard) reg2_selected_data = EXE_data;
      else if (is_reg2_MEM_hazard) reg2_selected_data = MEM_data;
      else if (is_reg2_WB_hazard) reg2_selected_data = WB_data;
    end else reg2_selected_data = reg2_data;
    // saved_val
    if (has_saved_val_hazard) begin
      if (is_reg2_EXE_hazard) saved_val_selected_data = EXE_data;
      else if (is_reg2_MEM_hazard) saved_val_selected_data = MEM_data;
      else if (is_reg2_WB_hazard) saved_val_selected_data = WB_data;
    end else saved_val_selected_data = reg2_data;
  end
endmodule
