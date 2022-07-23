module MEM_stage(
    // outputs
    hit,
    cache_data_out,
    mem_data_in,
    mem_write_en,
    mem_addr,
    mem_block,
    // inputs
    mem_write,
    alu_result,
    is_LB_SB,
    rt_data,
    mem_data_out,
    cache_en,
    clk,
    rst_b
);

    input        mem_write;
    input [31:0] alu_result;
    input        is_LB_SB;
    input [31:0] rt_data;
    input [7:0]  mem_data_out[0:3];
    input        cache_en;
    input        clk;
    input        rst_b;

    output        hit;
    output [7:0]  cache_data_out[0:3];
    output [7:0]  mem_data_in[0:3];
    output        mem_write_en;
    output [31:0] mem_addr;
    output [1:0]  mem_block;

    wire        cache_write_en;
    wire [31:0] cache_addr;
    wire [7:0]  cache_data_in[0:3];

    assign cache_write_en = mem_write;
    assign cache_addr = alu_result;

    wire [31:0] temp = (cache_addr % 4);
    assign mem_block = temp[1:0];

    assign cache_data_in[0] = (is_LB_SB == 1'b0) ? rt_data[31 -: 8] : (mem_block == 0) ? rt_data[31-24 -: 8]: cache_data_out[0];
    assign cache_data_in[1] = (is_LB_SB == 1'b0) ? rt_data[31-8 -: 8]: (mem_block == 1) ? rt_data[31-24 -: 8]: cache_data_out[1];
    assign cache_data_in[2] = (is_LB_SB == 1'b0) ? rt_data[31-16 -: 8]: (mem_block == 2) ? rt_data[31-24 -: 8]: cache_data_out[2];
    assign cache_data_in[3] = (is_LB_SB == 1'b0) ? rt_data[31-24 -: 8]: (mem_block == 3) ? rt_data[31-24 -: 8]: cache_data_out[3];


    cache cache_unit(
        // outputs
        .hit(hit),
        .cache_data_out(cache_data_out),
        .mem_data_in(mem_data_in),
        .mem_write_en(mem_write_en),
        .mem_addr(mem_addr),
        // inputs
        .cache_addr(cache_addr),
        .cache_data_in(cache_data_in),
        .mem_data_out(mem_data_out),
        .cache_write_en(cache_write_en),
        .cache_en(cache_en),
        .clk(clk),
        .rst_b(rst_b)
    );

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if (!rst_b)
            clk_count <= 0;
        else begin
            // $display("-----------------MEM stage(%d)-------------------", clk_count);
            // $display("hit= %b",hit);
            // $display("cache_data_out= %b",cache_data_out);
            // $display("mem_data_in= %b",mem_data_in);
            // $display("mem_write_en= %b",mem_write_en);
            // $display("mem_addr= %b",mem_addr);
            // $display("mem_block= %b",mem_block);

            clk_count <= clk_count + 1;
        end
    end
endmodule