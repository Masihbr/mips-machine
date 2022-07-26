module mips_core (
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);
    input   [31:0] inst;
    input   [7:0]  mem_data_out [0:3];
    input          clk;
    input          rst_b;

    output  [31:0] inst_addr;
    output  [31:0] mem_addr;
    output  [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output         halted;

    wire [31:0] reg1_data_ID, reg2_data_ID, dest_reg_data_WB, val1_ID, val2_ID, inst_ID, sign_extend_immediate_ID, pc_ID;
    wire [4:0]  reg1_num_ID, reg2_num_ID, dest_reg_num_ID, dest_reg_num_WB, dest_reg_num_EXE, dest_reg_num_MEM;  
    wire reg_write_WB, halted_WB;
    wire [1:0]  jump_ID, jump_EXE, jump_MEM, jump_WB;
    wire [2:0]  branch_ID;
    wire jr_ID, zero_ID, cache_en_ID, halted_ID, is_reg1_valid_ID, is_reg2_valid_ID;
    wire mem_to_reg_ID, is_LB_SB_ID, reg_write_ID, mem_write_ID;
    wire [3:0]  control_ID, control_EXE;
    wire [31:0] val1_EXE, val2_EXE, pc_EXE;
    wire mem_write_EXE, is_LB_SB_EXE, cache_en_EXE, mem_to_reg_EXE, reg_write_EXE, halted_EXE;
    
    wire [31:0] alu_result_EXE, alu_result_MEM, alu_result_WB;
    wire mem_write_MEM, is_LB_SB_MEM, cache_en_MEM, mem_to_reg_MEM, reg_write_MEM, halted_MEM;
    wire [31:0] val2_MEM, pc_MEM, pc_WB ;
    wire hit_MEM;
    wire [7:0] cache_data_out_MEM[0:3];
    wire [7:0] cache_data_out_WB[0:3];
    wire [1:0] mem_block_MEM, mem_block_WB;
    wire is_LB_SB_WB, mem_to_reg_WB;
    wire [31:0] saved_val_ID, saved_val_EXE, saved_val_MEM;
    wire is_SW_SB_ID, is_SW_SB_EXE, is_SW_SB_MEM;
    wire has_reg1_hazard_ID, has_reg2_hazard_ID, has_saved_val_hazard_ID;
    wire [31:0] reg1_selected_data, reg2_selected_data, saved_val_selected_data;
    wire is_reg1_EXE_hazard, is_reg2_EXE_hazard, is_reg1_MEM_hazard, is_reg2_MEM_hazard, is_reg1_WB_hazard, is_reg2_WB_hazard;
    wire flush_IF;
    
    assign halted = halted_WB;

    hazard_detector hazard_detector (
        // outputs
        .has_reg1_hazard_ID(has_reg1_hazard_ID),
        .has_reg2_hazard_ID(has_reg2_hazard_ID),
        .has_saved_val_hazard_ID(has_saved_val_hazard_ID),
        .is_reg1_EXE_hazard(is_reg1_EXE_hazard),
        .is_reg1_MEM_hazard(is_reg1_MEM_hazard),
        .is_reg1_WB_hazard(is_reg1_WB_hazard),
        .is_reg2_EXE_hazard(is_reg2_EXE_hazard),
        .is_reg2_MEM_hazard(is_reg2_MEM_hazard),
        .is_reg2_WB_hazard(is_reg2_WB_hazard),
        // inputs
        .dest_reg_num_EXE(dest_reg_num_EXE),
        .reg_write_EXE(reg_write_EXE),
        .dest_reg_num_MEM(dest_reg_num_MEM),
        .reg_write_MEM(reg_write_MEM),
        .dest_reg_num_WB(dest_reg_num_WB),
        .reg_write_WB(reg_write_WB),
        .reg1_num_ID(reg1_num_ID),
        .reg2_num_ID(reg2_num_ID),
        .is_reg1_valid_ID(is_reg1_valid_ID),
        .is_reg2_valid_ID(is_reg2_valid_ID),
        .is_SW_SB_ID(is_SW_SB_ID)
    );

    forwarding forwarding (
        // outputs
        .reg1_selected_data(reg1_selected_data),
        .reg2_selected_data(reg2_selected_data),
        .saved_val_selected_data(saved_val_selected_data),
        // inputs
        .reg1_data(reg1_data_ID),
        .reg2_data(reg2_data_ID),
        .has_reg1_hazard(has_reg1_hazard_ID),
        .has_reg2_hazard(has_reg2_hazard_ID),
        .has_saved_val_hazard(has_saved_val_hazard_ID),
        .is_reg1_EXE_hazard(is_reg1_EXE_hazard),
        .is_reg1_MEM_hazard(is_reg1_MEM_hazard),
        .is_reg1_WB_hazard(is_reg1_WB_hazard),
        .is_reg2_EXE_hazard(is_reg2_EXE_hazard),
        .is_reg2_MEM_hazard(is_reg2_MEM_hazard),
        .is_reg2_WB_hazard(is_reg2_WB_hazard),
        .EXE_data(alu_result_EXE),
        .MEM_data(alu_result_MEM),
        .WB_data(alu_result_WB)
    );



    regfile regfile_unit (
        // outputs
        .rs_data(reg1_data_ID),
        .rt_data(reg2_data_ID),
        // inputs
        .rs_num(reg1_num_ID),
        .rt_num(reg2_num_ID),
        .rd_num(dest_reg_num_WB),
        .rd_data(dest_reg_data_WB),
        .rd_we(reg_write_WB),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted_WB)
    );

    IF_stage IF_stage (
        // outputs
        .pc(inst_addr),
        .flush(flush_IF),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .jump(jump_ID),
        .branch(branch_ID),
        .jr(jr_ID),
        .zero(zero_ID),
        .rs_data(val1_ID),
        .inst(inst_ID),
        .cache_en(cache_en_ID),
        .sign_extend_immediate(sign_extend_immediate_ID ),
        .freeze(1'b0),
        .hit(1'b1)
    );

    IF_to_ID IF_to_ID (
        // outputs
        .pc(pc_ID),
        .inst(inst_ID),
        // inputs
        .pc_in(inst_addr),
        .inst_in(inst),
        .clk(clk),
        .rst_b(rst_b),
        .flush(flush_IF),
        .freeze(1'b0)
    );

    ID_stage ID_stage (
        // outputs
        .halted(halted_ID),
        .sign_extend_immediate(sign_extend_immediate_ID),
        .reg1_num(reg1_num_ID),
        .reg2_num(reg2_num_ID),
        .dest_reg_num(dest_reg_num_ID),
        .val1(val1_ID),
        .val2(val2_ID),
        .saved_val(saved_val_ID),
        .zero(zero_ID),
        .is_reg1_valid(is_reg1_valid_ID),
        .is_reg2_valid(is_reg2_valid_ID),
        .control(control_ID),
        .jump(jump_ID),
        .branch(branch_ID),
        .jr(jr_ID),
        .cache_en(cache_en_ID),
        .mem_to_reg(mem_to_reg_ID),
        .is_LB_SB(is_LB_SB_ID),
        .is_SW_SB(is_SW_SB_ID),
        .reg_write(reg_write_ID),
        .mem_write(mem_write_ID),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .inst(inst_ID),
        .reg1_data(reg1_selected_data),
        .reg2_data(reg2_selected_data),
        .saved_val_data(saved_val_selected_data),
        .has_reg1_hazard(has_reg1_hazard_ID),
        .has_reg2_hazard(has_reg2_hazard_ID),
        .has_saved_val_hazard(has_saved_val_hazard_ID)
    );


    ID_to_EXE ID_to_EXE (
        // outputs
        // ----- EXE -----
        .val1(val1_EXE),
        .val2(val2_EXE),
        .control(control_EXE),
        // ----- MEM -----
        .mem_write(mem_write_EXE),
        .is_LB_SB( is_LB_SB_EXE),
        .cache_en(cache_en_EXE),
        .saved_val(saved_val_EXE),
        .is_SW_SB(is_SW_SB_EXE),
        // ----- WB ------
        .mem_to_reg(mem_to_reg_EXE),
        .jump(jump_EXE),
        .pc(pc_EXE),
        .dest_reg_num(dest_reg_num_EXE),
        .reg_write(reg_write_EXE),
        .halted(halted_EXE),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        // ----- EXE -----
        .val1_in(val1_ID),
        .val2_in(val2_ID),
        .control_in(control_ID),
        // ----- MEM -----
        .mem_write_in(mem_write_ID),
        .is_LB_SB_in(is_LB_SB_ID),
        .cache_en_in(cache_en_ID),
        .saved_val_in(saved_val_ID),
        .is_SW_SB_in(is_SW_SB_ID),
        // ----- WB ------
        .mem_to_reg_in(mem_to_reg_ID),
        .jump_in(jump_ID),
        .pc_in(pc_ID),
        .dest_reg_num_in(dest_reg_num_ID),
        .reg_write_in(reg_write_ID),
        .halted_in(halted_ID),
        .freeze(1'b0)
    );

    EXE_stage EXE_stage (
        // outputs
        .alu_result(alu_result_EXE),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .val1(val1_EXE),
        .val2(val2_EXE),
        .control(control_EXE)
    );

    EXE_to_MEM EXE_to_MEM (
        // outputs
        // ----- MEM -----
        .mem_write(mem_write_MEM),
        .alu_result(alu_result_MEM),
        .is_LB_SB(is_LB_SB_MEM),
        .is_SW_SB(is_SW_SB_MEM),
        .val2(val2_MEM),
        .saved_val(saved_val_MEM),
        .cache_en(cache_en_MEM),
        // ----- WB ------
        .mem_to_reg(mem_to_reg_MEM),
        .jump(jump_MEM),
        .pc(pc_MEM),
        .dest_reg_num(dest_reg_num_MEM),
        .reg_write(reg_write_MEM),
        .halted(halted_MEM),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        // ----- MEM -----
        .mem_write_in(mem_write_EXE),
        .alu_result_in(alu_result_EXE),
        .is_LB_SB_in(is_LB_SB_EXE),
        .is_SW_SB_in(is_SW_SB_EXE),
        .val2_in(val2_EXE),
        .saved_val_in(saved_val_EXE),
        .cache_en_in(cache_en_EXE),
        // ----- WB ------
        .mem_to_reg_in(mem_to_reg_EXE),
        .jump_in(jump_EXE),
        .pc_in(pc_EXE),
        .dest_reg_num_in(dest_reg_num_EXE),
        .reg_write_in(reg_write_EXE),
        .halted_in(halted_EXE),
        .freeze(1'b0)
    );

    MEM_stage MEM_stage (
        // outputs
        .hit(hit_MEM),
        .cache_data_out(cache_data_out_MEM),
        .mem_data_in(mem_data_in),
        .mem_write_en(mem_write_en),
        .mem_addr(mem_addr),
        .mem_block(mem_block_MEM),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .mem_write(mem_write_MEM),
        .alu_result(alu_result_MEM),
        .is_LB_SB(is_LB_SB_MEM),
        .is_SW_SB(is_SW_SB_MEM),
        .rt_data(val2_MEM),
        .saved_val(saved_val_MEM),
        .mem_data_out(mem_data_out),
        .cache_en(cache_en_MEM)
    );

    MEM_to_WB MEM_to_WB (
        // outputs
        .is_LB_SB(is_LB_SB_WB),
        .cache_data_out(cache_data_out_WB),
        .mem_block(mem_block_WB),
        .mem_to_reg(mem_to_reg_WB),
        .jump(jump_WB),
        .pc(pc_WB),
        .alu_result(alu_result_WB),
        .dest_reg_num(dest_reg_num_WB),
        .reg_write(reg_write_WB),
        .halted(halted_WB),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .is_LB_SB_in(is_LB_SB_MEM),
        .cache_data_out_in(cache_data_out_MEM),
        .mem_block_in(mem_block_MEM),
        .mem_to_reg_in(mem_to_reg_MEM),
        .jump_in(jump_MEM),
        .pc_in(pc_MEM),
        .alu_result_in(alu_result_MEM),
        .dest_reg_num_in(dest_reg_num_MEM),
        .reg_write_in(reg_write_MEM),
        .halted_in(halted_MEM),
        .freeze(1'b0)
    );

    WB_stage WB_stage (
        // outputs
        .dest_reg_data(dest_reg_data_WB),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .is_LB_SB(is_LB_SB_WB),
        .cache_data_out(cache_data_out_WB),
        .mem_block(mem_block_WB),
        .mem_to_reg(mem_to_reg_WB),
        .jump(jump_WB),
        .pc(pc_WB),
        .alu_result(alu_result_WB)
    );

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if (!rst_b)
            clk_count <= 0;
        else begin
            // // $display("-----------------CORE(%d)---------------", clk_count);
             // // $display("inst= %b", inst);      
            // // $display("inst_addr= %b", inst_addr);
            // // $display("reg1_selected_data= %b", reg1_selected_data);
            // // $display("reg2_selected_data= %b", reg2_selected_data);
            // // $display("saved_val_selected_data= %b", saved_val_selected_data);
            // // $display("reg1_data_ID= %b", reg1_data_ID);
            // // $display("reg2_data_ID= %b", reg2_data_ID);
            // // $display("has_reg1_hazard_ID= %b", has_reg1_hazard_ID);
            // // $display("has_reg2_hazard_ID= %b", has_reg2_hazard_ID);
            // // $display("has_saved_val_hazard_ID= %b", has_saved_val_hazard_ID);
            // // $display("is_reg1_EXE_hazard= %b", is_reg1_EXE_hazard);
            // // $display("is_reg1_MEM_hazard= %b", is_reg1_MEM_hazard);
            // // $display("is_reg2_EXE_hazard= %b", is_reg2_EXE_hazard);
            // // $display("is_reg2_MEM_hazard= %b", is_reg2_MEM_hazard);
            // // $display("alu_result_EXE= %b", alu_result_EXE);
            // // $display("alu_result_MEM= %b", alu_result_MEM );     
            clk_count <= clk_count + 1;
        end
    end


endmodule