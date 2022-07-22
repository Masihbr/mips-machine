module mips_core_old(
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
    wire             halted;
    wire             reg_dst;
    wire [1:0]       alu_src;
    wire             mem_to_reg;
    wire             reg_write;
    wire             mem_read;
    wire             mem_write;
    wire             is_LB_SB;
    wire [2:0]       branch;
    wire [3:0]       alu_op;
    wire             jr;
    wire [1:0]       jump;
    wire             do_extend;
    wire [3:0]       control;
    wire [31:0]      alu_result;
    wire             zero;
    wire [31:0]      a;
    wire [31:0]      b;
    reg  [31:0]      pc;

    wire [31:0] cache_data_out_32_bit;
    wire [1:0] mem_block;
    wire hit;
    wire [7:0]  cache_data_out[0:3];
    wire [31:0] cache_addr;
    wire [7:0]  cache_data_in[0:3];
    wire        cache_en;

    regfile regfile_unit(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(rs_num),
        .rt_num(rt_num),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(reg_write),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );
    
    IF_stage IF_stage(
        // outputs
        .PC(pc_IF),
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
    );

    IF_to_ID IF_to_ID (
        // outputs
        .pc(pc_ID),
        .inst(inst_ID),
        // outputs
        .pc_in(pc_IF),
        .inst_in(inst_IF),
        .clk(clk),
        .rst_b(rst_b),
        .flush(flush_IF),
        .freeze(~hit_MEM)
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
        //inputs
        .inst(inst_ID),
        .rs_data(rs_data),
        .rt_data(rt_data),
        .clk(clk),
        .rst_b(rst_b)
    );

    ID_to_EXE ID_to_EXE(
        // outputs
        .a(a_EXE),
        .b(b_EXE),
        .control(control_EXE),
        .mem_write(mem_write_EXE),
        .alu_result(alu_result_EXE),
        .is_LB_SB(is_LB_SB_EXE),
        .rt_data(rt_data_EXE),
        .mem_data_out(mem_data_out_EXE),
        .cache_en(cache_en_EXE),
        .mem_to_reg(mem_to_reg_EXE),
        .jump(jump_EXE),
        .pc(pc_EXE),
        // inputs
        .a_in(a_ID),
        .b_in(b_ID),
        .control_in(control_ID),
        .mem_write_in(mem_write_ID),
        .alu_result_in(alu_result_ID),
        .is_LB_SB_in(is_LB_SB_ID),
        .rt_data_in(rt_data_ID),
        .mem_data_out_in(mem_data_out_ID),
        .cache_en_in(cache_en_ID),
        .mem_to_reg_in(mem_to_reg_ID),
        .jump_in(jump_ID),
        .pc_in(pc_ID),
        .clk(clk),
        .rst_b(rst_b),
        .freeze(~hit_MEM)
    );

    EXE_stage EXE_stage (
        // outputs
        .alu_result(alu_result_EXE),
        .zero(zero_EXE),
        // inputs
        .a(a_EXE),
        .b(b_EXE),
        .control(control_EXE)
    );
    EXE_to_MEM EXE_to_MEM();

    MEM_stage MEM_stage(
        // outputs
        .hit(hit_MEM),
        .cache_data_out(cache_data_out_MEM),
        .mem_data_in(mem_data_in_MEM),
        .mem_write_en(mem_write_en_MEM),
        .mem_addr(mem_addr_MEM),
        // inputs
        .mem_write(mem_write_MEM),
        .alu_result(alu_result_MEM),
        .is_LB_SB(is_LB_SB_MEM),
        .rt_data(rt_data_MEM),
        .mem_data_out(mem_data_out_MEM),
        .cache_en(cache_en_MEM),
        .clk(clk),
        .rst_b(rst_b)
    );

    WB_stage WB_stage(
        // outputs
        .rd_data(rd_data_WB),
        // inputs
        .is_LB_SB(is_LB_SB_WB),
        .cache_data_out(cache_data_out_WB),
        .mem_block(mem_block_WB),
        .mem_to_reg(mem_to_reg_WB),
        .jump(jump_WB),
        .pc(pc_WB),
        .alu_result(alu_result_WB)
    );

    assign rd_num = (reg_dst == 1'b1) ? inst[15:11] : (jump == 2'b10) ? 5'd31 : rt_num;

    wire [31:0] temp = (cache_addr % 4);
    assign mem_block = temp[1:0];

    assign inst_addr = pc;

    assign cache_addr = alu_result;
    assign cache_data_in[0] = (is_LB_SB == 1'b0) ? rt_data[31 -: 8] : (mem_block == 0) ? rt_data[31-24 -: 8]: cache_data_out[0];
    assign cache_data_in[1] = (is_LB_SB == 1'b0) ? rt_data[31-8 -: 8]: (mem_block == 1) ? rt_data[31-24 -: 8]: cache_data_out[1];
    assign cache_data_in[2] = (is_LB_SB == 1'b0) ? rt_data[31-16 -: 8]: (mem_block == 2) ? rt_data[31-24 -: 8]: cache_data_out[2];
    assign cache_data_in[3] = (is_LB_SB == 1'b0) ? rt_data[31-24 -: 8]: (mem_block == 3) ? rt_data[31-24 -: 8]: cache_data_out[3];

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            pc <= 0;
            clk_count <=0;
        end else begin
            clk_count <= clk_count+1;
        end  
    end

endmodule