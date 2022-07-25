module mips_core(
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
    output  [31:0] inst_addr;
    input   [31:0] inst;
    output  [31:0] mem_addr;
    input   [7:0]  mem_data_out[0:3];
    output  [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;
    input          clk;
    input          rst_b;

    parameter XLEN=32;

    wire [XLEN-1:0]  rs_data;
    wire [XLEN-1:0]  rt_data;
    wire [4:0]       rs_num;
    wire [4:0]       rt_num;
    wire [4:0]       rd_num;
    wire [XLEN-1:0]  rd_data;
    wire             clk;
    wire             rst_b;
    
    wire [31:0] pc_IF;
    wire [1:0]  jump_ID;
    wire [2:0]  branch_ID;
    wire        jr_ID;
    wire        do_extend_ID;
    wire        zero_ID;
    wire [31:0] rs_data_ID;
    wire        cache_en_ID;
    wire [31:0] sign_extend_immediate_ID;

    wire [31:0] pc_ID;
    wire [31:0] inst_ID;

    wire        flush_IF;

    wire        is_LB_SB_ID;
    wire        reg_dst_ID;
    wire [1:0]  alu_src_ID;
    wire        mem_to_reg_ID;
    wire        reg_write_ID;
    wire        mem_read_ID;
    wire        mem_write_ID;
    wire [2:0]  branch_ID;
    wire [3:0]  alu_op_ID;
    wire        do_extend_ID;
    wire        jr_ID;
    wire [31:0] sign_extend_immediate_ID;
    wire [3:0]  control_ID;
    wire [31:0] a_ID;
    wire [31:0] b_ID;
    wire        halted_ID;

    wire alu_select_ID;
    wire alu_select_EXE;


    wire [31:0] a_EXE;
    wire [31:0] b_EXE;
    wire [3:0]  control_EXE;
    wire        mem_write_EXE;
    wire        is_LB_SB_EXE;
    wire [31:0] rt_data_EXE;
    wire        cache_en_EXE;
    wire        mem_to_reg_EXE;
    wire [1:0]  jump_EXE;
    wire [31:0] pc_EXE;
    wire [31:0] inst_EXE;
    wire        reg_dst_EXE;
    wire        reg_write_EXE;
    wire [4:0]  dest_EXE;
    wire [4:0]  dest_MEM;

    wire [31:0] alu_result_EXE;
    wire        zero_EXE;


    wire        mem_write_MEM;
    wire [31:0] alu_result_MEM;
    wire        is_LB_SB_MEM;
    wire [31:0] rt_data_MEM;
    wire        cache_en_MEM;
    wire        mem_to_reg_MEM;
    wire [1:0]  jump_MEM;
    wire [31:0] pc_MEM;
    wire [31:0] inst_MEM;
    wire        reg_dst_MEM;
    wire        reg_write_MEM;

    wire        hit_MEM;
    wire [7:0]  cache_data_out_MEM[0:3];
    wire [7:0]  mem_data_in_MEM[0:3];
    wire        mem_write_en_MEM;
    wire [31:0] mem_addr_MEM;
    assign mem_addr = mem_addr_MEM;
    wire [1:0]  mem_block_MEM;

    wire        is_LB_SB_WB;
    wire [7:0]  cache_data_out_WB[0:3];
    wire [1:0]  mem_block_WB;
    wire        mem_to_reg_WB;
    wire [1:0]  jump_WB;
    wire [31:0] pc_WB;
    wire [31:0] alu_result_WB;
    wire [31:0] inst_WB;
    wire        reg_dst_WB;
    wire        reg_write_WB;
    wire        is_imm;
    /* verilator lint_off UNOPTFLAT */
    wire        has_hazard;
    wire        is_src1_valid;
    wire        is_src2_valid;
    wire [4:0]  src1_forw_EXE, src2_ID, src2_forw_EXE;

    wire [31:0] rd_data_WB;  

    assign inst_addr = pc_IF;

	hazard_detector hazard (
		// INPUTS
		.is_imm(is_imm),
		.is_src1_valid(is_src1_valid),
		.is_src2_valid(is_src2_valid),
		.rs_num(rs_num),
		.rt_num(rt_num),
		.dest_EXE(dest_EXE),
		.dest_MEM(dest_MEM),
		.reg_write_EXE(reg_write_EXE),
		.reg_write_MEM(reg_write_MEM),
		.mem_write_EXE(mem_write_EXE),
		// OUTPUTS
		.has_hazard(has_hazard)
	);

	// forwarding forwrding (
	// 	.src1_EXE(src1_forw_EXE),
	// 	.src2_EXE(src2_forw_EXE),
	// 	.ST_src_EXE(dest_EXE),
	// 	.dest_MEM(dest_MEM),
	// 	.dest_WB(rd_num),
	// 	.reg_write_MEM(reg_write_MEM),
	// 	.WB_EN_WB(reg_write_WB),
	// 	.val1_sel(a_EXE),
	// 	.val2_sel(b_EXE),
	// 	.ST_val_sel(ST_val_sel)
	// );

    regfile regfile_unit(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(rs_num),
        .rt_num(rt_num),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(reg_write_WB),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );

    IF_stage IF_stage (
        // outputs
        .pc(pc_IF),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .jump(jump_ID),
        .branch(branch_ID),
        .jr(jr_ID),
        .do_extend(do_extend_ID),
        .zero(zero_ID),
        .rs_data(rs_data_ID),
        .inst(inst),
        .cache_en(cache_en_ID),
        .hit(hit_MEM),
        .sign_extend_immediate(sign_extend_immediate_ID),
        .freeze(has_hazard)
    ); 

    IF_to_ID IF_to_ID (
        // outputs
        .pc(pc_ID),
        .inst(inst_ID),
        // inputs
        .pc_in(pc_IF),
        .inst_in(inst),
        .clk(clk),
        .rst_b(rst_b),
        .flush(flush_IF),
        .freeze(has_hazard)
    );
    
    assign rs_num = inst_ID[25:21];
    assign rt_num = inst_ID[20:16];

    ID_stage ID_stage(
        // outputs
        .is_LB_SB(is_LB_SB_ID),
        .reg_dst(reg_dst_ID),
        .alu_src(alu_src_ID),
        .mem_to_reg(mem_to_reg_ID),
        .reg_write(reg_write_ID),
        .mem_read(mem_read_ID),
        .mem_write(mem_write_ID),
        .branch(branch_ID),
        .alu_op(alu_op_ID),
        .do_extend(do_extend_ID),
        .jr(jr_ID),
        .jump(jump_ID),
        .cache_en(cache_en_ID),
        .sign_extend_immediate(sign_extend_immediate_ID),
        .control(control_ID),
        .a(a_ID),
        .b(b_ID),
        .halted(halted_ID),
        .is_imm(is_imm),
        .is_src1_valid(is_src1_valid),    
        .is_src2_valid(is_src2_valid),
        .src2(src2_ID),          
        .alu_select(alu_select_ID), 
        //inputs
        .inst(inst_ID),
        .rs_data(rs_data),
        .rt_data(rt_data),
        .has_hazard(has_hazard),
        .clk(clk),
        .rst_b(rst_b)
    ); 

    ID_to_EXE ID_to_EXE(
        // outputs
        .a(a_EXE),
        .b(b_EXE),
        .control(control_EXE),
        .is_LB_SB(is_LB_SB_EXE),
        .mem_to_reg(mem_to_reg_EXE),
        .jump(jump_EXE),
        .mem_write(mem_write_EXE),
        .rt_data(rt_data_EXE),
        .cache_en(cache_en_EXE),
        .pc(pc_EXE),
        .inst(inst_EXE),
        .reg_dst(reg_dst_EXE),
        .reg_write(reg_write_EXE),
        .dest(dest_EXE),
        .src1_in(rs_num),
        .src2_in(src2_ID),
        .alu_select(alu_select_EXE),
        // inputs
        .a_in(a_ID),
        .b_in(b_ID),
        .control_in(control_ID),
        .is_LB_SB_in(is_LB_SB_ID),
        .mem_to_reg_in(mem_to_reg_ID),
        .jump_in(jump_ID),
        .mem_write_in(mem_write_ID),
        .rt_data_in(rt_data),
        .cache_en_in(cache_en_ID),
        .pc_in(pc_ID),
        .inst_in(inst_ID),
        .reg_dst_in(reg_dst_ID),
        .reg_write_in(reg_write_ID),
        .src1(src1_forw_EXE),
        .src2(src2_forw_EXE),
        .alu_select_in(alu_select_ID),
        .clk(clk),
        .rst_b(rst_b),
        .freeze(1'b0)
    ); 

    EXE_stage EXE_stage (
        // outputs
        .alu_result(alu_result_EXE),
        .zero(zero_EXE),
        // inputs
        .a(a_EXE),
        .b(b_EXE),
        .alu_select(alu_select_EXE),
        // .ST_val_sel(ST_val_sel),
        .control(control_EXE),
        .clk(clk),
        .rst_b(rst_b)
    ); 

    EXE_to_MEM EXE_to_MEM(
        // outputs
        .mem_write(mem_write_MEM),
        .alu_result(alu_result_MEM),
        .is_LB_SB(is_LB_SB_MEM),
        .rt_data(rt_data_MEM),
        .cache_en(cache_en_MEM),
        .mem_to_reg(mem_to_reg_MEM),
        .jump(jump_MEM),
        .pc(pc_MEM),
        .inst(inst_MEM),
        .reg_dst(reg_dst_MEM),
        .reg_write(reg_write_MEM),
        // inputs
        .mem_write_in(mem_write_EXE),
        .alu_result_in(alu_result_EXE),
        .is_LB_SB_in(is_LB_SB_EXE),
        .rt_data_in(rt_data_EXE),
        .cache_en_in(cache_en_EXE),
        .mem_to_reg_in(mem_to_reg_EXE),
        .jump_in(jump_EXE),
        .pc_in(pc_EXE),
        .inst_in(inst_EXE),
        .reg_dst_in(reg_dst_EXE),
        .reg_write_in(reg_write_EXE),
        .clk(clk),
        .rst_b(rst_b),
        .freeze(1'b0)
    ); 

    MEM_stage MEM_stage(
        // outputs
        .hit(hit_MEM),
        .cache_data_out(cache_data_out_MEM),
        .mem_data_in(mem_data_in_MEM),
        .mem_write_en(mem_write_en_MEM),
        .mem_addr(mem_addr_MEM),
        .mem_block(mem_block_MEM),
        // inputs
        .mem_write(mem_write_MEM),
        .alu_result(alu_result_MEM),
        .is_LB_SB(is_LB_SB_MEM),
        .rt_data(rt_data_MEM),
        .mem_data_out(mem_data_out),
        .cache_en(cache_en_MEM),
        .clk(clk),
        .rst_b(rst_b)
    ); 

    MEM_to_WB MEM_to_WB(
        // outputs
        .is_LB_SB(is_LB_SB_WB),
        .cache_data_out(cache_data_out_WB),
        .mem_block(mem_block_WB),
        .mem_to_reg(mem_to_reg_WB),
        .jump(jump_WB),
        .pc(pc_WB),
        .alu_result(alu_result_WB),
        .inst(inst_WB),
        .reg_dst(reg_dst_WB),
        .reg_write(reg_write_WB),
        // inputs
        .is_LB_SB_in(is_LB_SB_MEM),
        .cache_data_out_in(cache_data_out_MEM),
        .mem_block_in(mem_block_MEM),
        .mem_to_reg_in(mem_to_reg_MEM),
        .jump_in(jump_MEM),
        .pc_in(pc_MEM),
        .alu_result_in(alu_result_MEM),
        .inst_in(inst_MEM),
        .reg_dst_in(reg_dst_MEM),
        .reg_write_in(reg_write_MEM),
        .clk(clk),
        .rst_b(rst_b),
        .freeze(1'b0)
    );

    assign rd_data = rd_data_WB;

    WB_stage WB_stage (
        // outputs
        .rd_data(rd_data_WB),
        .rd_num(rd_num),
        .halted(halted),
        // inputs
        .is_LB_SB(is_LB_SB_WB),
        .cache_data_out(cache_data_out_WB),
        .mem_block(mem_block_WB),
        .mem_to_reg(mem_to_reg_WB),
        .jump(jump_WB),
        .pc(pc_WB),
        .alu_result(alu_result_WB),
        .inst(inst_WB),
        .reg_dst(reg_dst_WB),
        .clk(clk),
        .rst_b(rst_b)
    );

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if (!rst_b)
            clk_count <= 0;
        else begin
            $display("---------------------MIPS CORE(%d)*****************", clk_count);
            $display("inst= %b", inst);
            $display("inst_addr= %b", inst_addr);
            $display("has_hazard= %b", has_hazard);
            $display("is_imm= %b",is_imm);
            $display("is_src1_valid= %b",is_src1_valid);
            $display("is_src2_valid= %b",is_src2_valid);
            $display("rs_num= %b",rs_num);
            $display("rt_num= %b",rt_num);
            $display("dest_EXE= %b",dest_EXE);
            $display("dest_MEM= %b",dest_MEM);
            $display("reg_write_EXE= %b",reg_write_EXE);
            $display("reg_write_MEM= %b",reg_write_MEM);
            $display("mem_write_EXE= %b",mem_write_EXE);

            clk_count <= clk_count + 1;
        end
    end


endmodule