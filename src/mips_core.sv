
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
    wire             rd_we;
    wire             clk;
    wire             rst_b;
    wire             halted;
    wire             reg_dst;
    wire             alu_src;
    wire             mem_to_reg;
    wire             reg_write;
    wire             mem_read;
    wire             mem_write;
    wire             branch;
    wire             alu_op;
    wire             jump;
    wire [5:0]       opcode;
    wire             control;
    wire [5:0]       func;
    wire [31:0]      alu_result;
    wire             zero;
    wire [31:0]      a;
    wire [31:0]      b;

    reg [31:0] pc;

    regfile regfile(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(rs_num),
        .rt_num(rt_num),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(rd_we),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );
    control control(
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

    alu_control alu_control(
        .control(control),
        .alu_op(alu_op),
        .func(func)
    );
    
    alu alu(
        .alu_result(alu_result),
	    .zero(zero),
	    .a(a), 
        .b(b),
        .control(control)
    );

    assign immediate_data = inst[15:0];
    assign sh_amount = inst[11:6]; 
    assign opcode = inst[31:26];
    assign func = inst[5:0];
    assign sign_extend_immediate = {16{immediate_data[15]}, immediate_data};
    assign a = (alu_src[0] == 1'b1) ? sh_amount : rs_data;
    assign b = (alu_src[1] == 1'b1) ? sign_extend_immediate : rt_data;

    assign next_pc = pc + 4;
    assign inst_addr = pc;
    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;

    always_ff @(posedge clock) begin
        pc <= next_pc;
    end
endmodule
