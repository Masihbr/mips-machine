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
    wire [5:0]       opcode;
    wire [3:0]       control;
    wire [5:0]       func;
    wire [31:0]      alu_result;
    wire             zero;
    wire [31:0]      a;
    wire [31:0]      b;
    wire [15:0]      immediate_data;
    wire [4:0]       sh_amount;
    wire [31:0]      sign_extend_immediate;
    wire [25:0]      address;
    wire [31:0]      next_pc;
    reg  [31:0]      pc;
    reg  [31:0]      pc4;
    reg  [3:0]       stall;
    reg  [3:0]       next_stall;

    wire [31:0] cache_data_out_32_bit;
    wire [1:0] mem_block;
    wire hit;
    wire [7:0]  cache_data_out[0:3];
    wire [31:0] cache_addr;
    wire cache_write_en;
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

    control control_unit(
        .is_LB_SB(is_LB_SB),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .alu_op(alu_op),
        .do_extend(do_extend),
        .jr(jr),
        .jump(jump),
        .cache_en(cache_en),
        .func(func),
        .opcode(opcode)
    );

    alu_control alu_control_unit(
        .control(control),
        .alu_op(alu_op),
        .func(func)
    );
    
    alu alu_unit(
        .alu_result(alu_result),
        .zero(zero),
        .a(a), 
        .b(b),
        .control(control)
    );

    pc_control pc_control(
        .next_pc(next_pc),
        .pc(pc),
        .address(address),
        .jump(jump),
        .branch(branch),
        .jr(jr),
        .zero(zero),
        .sign_extend_immediate(sign_extend_immediate),
        .rs_data(rs_data)
    );

    cache cache_unit(
        .hit(hit),
        .cache_data_out(cache_data_out),
        .mem_data_in(mem_data_in),
        .mem_write_en(mem_write_en),
        .cache_addr(cache_addr),
        .mem_addr(mem_addr),
        .cache_data_in(cache_data_in),
        .mem_data_out(mem_data_out),
        .cache_write_en(cache_write_en),
        .cache_en(cache_en),
        .clk(clk),
        .rst_b(rst_b)
    );

    assign rs_num = inst[25:21];
    assign rt_num = inst[20:16];
    assign rd_num = (reg_dst == 1'b1) ? inst[15:11] : (jump == 2'b10) ? 5'd31 : rt_num;

    wire [31:0] temp = (cache_addr % 4);
    assign mem_block = temp[1:0];
    assign cache_data_out_32_bit = (is_LB_SB == 1'b0) ? {cache_data_out[0], cache_data_out[1], cache_data_out[2], cache_data_out[3]} : { (cache_data_out[mem_block][7] == 1) ? 24'hffffff : 24'b0 , cache_data_out[mem_block]};

    assign rd_data = (mem_to_reg == 1'b1) ? cache_data_out_32_bit : (jump == 2'b10) ? pc + 8 : alu_result;

    assign immediate_data = inst[15:0];
    assign sh_amount = inst[10:6]; 
    assign opcode = inst[31:26];
    assign func = inst[5:0];
    assign sign_extend_immediate = (do_extend) ? {{16{immediate_data[15]}}, immediate_data} : {16'd0, immediate_data};
    assign a = (alu_src[0] == 1'b1) ? {{27{1'b0}},sh_amount} : rs_data;
    assign b = (alu_src[1] == 1'b1) ? sign_extend_immediate : rt_data;

    assign address = inst[25:0];

    assign inst_addr = pc;
    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;

    assign cache_write_en = mem_write && ((is_LB_SB && stall == 5) || (!is_LB_SB && stall == 0));
    assign cache_addr = alu_result;
    assign cache_data_in[0] = (is_LB_SB == 1'b0) ? rt_data[31 -: 8] : (mem_block == 0) ? rt_data[31-24 -: 8]: cache_data_out[0];
    assign cache_data_in[1] = (is_LB_SB == 1'b0) ? rt_data[31-8 -: 8]: (mem_block == 1) ? rt_data[31-24 -: 8]: cache_data_out[1];
    assign cache_data_in[2] = (is_LB_SB == 1'b0) ? rt_data[31-16 -: 8]: (mem_block == 2) ? rt_data[31-24 -: 8]: cache_data_out[2];
    assign cache_data_in[3] = (is_LB_SB == 1'b0) ? rt_data[31-24 -: 8]: (mem_block == 3) ? rt_data[31-24 -: 8]: cache_data_out[3];

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        $display("------------------INSTR------------------");
        $display("inst=%b\nopcode=%b\npc=%d\na=%h\nb=%h\nalu_res=%h\nrd_data=%h\nalu_src=%b\nimm=%h\nrd_num=%d\ncontrol=%d\nalu_op=%b\nfunc=%b\nnext_pc=%d\n",
        inst, opcode, pc, a, b, alu_result, rd_data,alu_src, sign_extend_immediate, rd_num, control, alu_op, func, next_pc);
        
        $display("------------------CACHE------------------");
        // $display("mem_read=%b\nmem_write=%b\nmem_write_en=%b\nmem_write_ctrl=%b\nmem_data_out=%h\nstall=%d", 
        // mem_read, mem_write, mem_write_en, mem_write, {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]}, stall);
        $display("hit=%b\ncache_data_out=%h\nmem_data_in=%h\nmem_write_en=%b\ncache_addr=%d\nmem_addr=%d\ncache_data_in=%h\nmem_data_out=%h\ncache_write_en=%b\nclkcount=%d", hit,cache_data_out,mem_data_in,mem_write_en,cache_addr,mem_addr,cache_data_in,mem_data_out,cache_write_en,clk_count);        
        $display("-----------------------------------------");
        if (rst_b == 0) begin
            pc <= 0;
            stall <= 0;
            clk_count <=0;
        end else begin
            clk_count <= clk_count+1;
            // stall <= next_stall;
            // $display("YO CHECK: stall:%d, next_stall:%d", stall, next_stall);
            // if ((stall == 0 && next_stall != 4 && next_stall != 8) || stall == 1) begin
            //     pc <= next_pc;
            // end
            if (!cache_en || hit)
                pc <= next_pc;
        end  
    end

    always_comb begin
        // next_stall = stall;
        // if ((mem_read || mem_write) && stall == 0) begin
        //     if (mem_write && is_LB_SB && stall == 0)
        //         next_stall = 8;
        //     else
        //         next_stall = 4;
        // end  
        // else if (stall > 0) begin 
        //     next_stall = stall - 1;
        // end 
    end

endmodule