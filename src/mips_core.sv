
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

    wire [31:0] mem_data_out_32_bit;




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

    assign rs_num = inst[25:21];
    assign rt_num = inst[20:16];
    assign rd_num = (reg_dst == 1'b1) ? inst[15:11] : (jump == 2'b10) ? 5'd31 : rt_num;

    assign mem_data_out_32_bit = {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]};

    assign rd_data = (mem_to_reg == 1'b1) ? mem_data_out_32_bit : (jump == 2'b10) ? pc + 8 : alu_result;

    

    assign immediate_data = inst[15:0];
    assign sh_amount = inst[10:6]; 
    assign opcode = inst[31:26];
    assign func = inst[5:0];
    assign sign_extend_immediate = (do_extend) ? {{16{immediate_data[15]}}, immediate_data} : {16'b0, immediate_data};
    assign a = (alu_src[0] == 1'b1) ? {{27{1'b0}},sh_amount} : rs_data;
    assign b = (alu_src[1] == 1'b1) ? sign_extend_immediate : rt_data;

    assign address = inst[25:0];

    assign inst_addr = pc;
    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;

    assign mem_write_en = mem_write;
    assign mem_addr = alu_result;

    assign mem_data_in[0] = rt_data[31 -: 8]; // should be changed for LB and SB commands
    assign mem_data_in[1] = rt_data[31-8 -: 8];
    assign mem_data_in[2] = rt_data[31-16 -: 8];
    assign mem_data_in[3] = rt_data[31-24 -: 8];

    always_ff @(posedge clk) begin
        $display("inst=%b\npc=%d\na=%b\nb=%b\nalu_res=%b\nrd_data=%b\nalu_src=%b\nim=%b\nrd_num=%b\ncontrol=%d\nalu_op=%b\nfunc=%b\nnext_pc=%d\n-------------------------------------",
        inst,pc, a, b, alu_result, rd_data,alu_src, sign_extend_immediate, rd_num, control, alu_op, func, next_pc);
        if (rst_b == 0) begin
            pc <= 0;
        end else begin
            pc <= next_pc;
        end
    end
endmodule