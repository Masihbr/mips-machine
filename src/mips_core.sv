
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
    

endmodule
