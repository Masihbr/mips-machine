
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

    wire [XLEN-1:0] rs_data;
    wire [XLEN-1:0] rt_data;
    wire       [4:0] rs_num;
    wire       [4:0] rt_num;
    wire       [4:0] rd_num;
    wire  [XLEN-1:0] rd_data;
    wire             clk;
    wire             rst_b;
    wire             halted;
    wire             reg_dst;
    wire [1:0]       alu_src;
    wire             mem_to_reg;
    wire             reg_write;
    wire             mem_read;
    wire             mem_write;
    wire             branch;
    wire [2:0]       alu_op;
    wire             jump;
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
    wire [31:0]      next_pc;
    reg [31:0] pc;


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
        .jump(jump),
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

    assign rs_num = inst[25:21];
    assign rt_num = inst[20:16];
    assign rd_num = (reg_dst == 1'b1) ? inst[15:11] : rt_num;

    assign rd_data = (mem_to_reg == 1'b1) ? 32'b0 : alu_result;

    assign immediate_data = inst[15:0];
    assign sh_amount = inst[10:6]; 
    assign opcode = inst[31:26];
    assign func = inst[5:0];
    assign sign_extend_immediate = {{16{immediate_data[15]}}, immediate_data};
    assign a = (alu_src[0] == 1'b1) ? {{27{1'b0}},sh_amount} : rs_data;
    assign b = (alu_src[1] == 1'b1) ? sign_extend_immediate : rt_data;

    assign next_pc = pc + 4;
    assign inst_addr = pc;
    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;

    always_ff @(posedge clk) begin
        // $display("inst=%b,\npc=%b,\na=%b,\nb=%b\nalu_res=%b,\nrd_data=%b,\nalu_src=%b,im=%b\n rd_num=%b\n-------------------------------------",
        //  inst,pc, a, b, alu_result, rd_data,alu_src, sign_extend_immediate, rd_num);
        if (rst_b == 0) begin
            pc <= 0;
        end else begin
            pc <= next_pc;
        end
    end
endmodule
