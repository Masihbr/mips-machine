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
        .PC(PC),
        // inputs
        .clk(clk),
        .rst_b(rst_b),
        .jump(jump),
        .branch(branch),
        .jr(jr),
        .do_extend(do_extend),
        .zero(zero),
        .rs_data(rs_data),
        .instruction(instruction),
        .cache_en(cache_en),
        .hit(hit),
        .sign_extend_immediate(sign_extend_immediate),
    );

    assign rs_num = inst[25:21];
    assign rt_num = inst[20:16];
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