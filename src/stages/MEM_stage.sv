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
    is_SW_SB,
    rt_data,
    saved_val,
    mem_data_out,
    cache_en,
    clk,
    rst_b
);

    input        mem_write;
    input [31:0] alu_result;
    input        is_LB_SB;
    input        is_SW_SB;
    input [31:0] rt_data;
    input [31:0] saved_val;
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
    reg [7:0]  cache_data_in[0:3];
    wire is_SB;

    assign cache_write_en = mem_write;
    assign cache_addr = alu_result;

    wire [31:0] temp = (cache_addr % 4);
    assign mem_block = temp[1:0];

    assign is_SB = is_SW_SB && is_LB_SB;

    always_comb begin
        if (is_SW_SB) begin
            if (is_SB) begin
                cache_data_in[0] = (mem_block == 0) ? saved_val[31-24 -: 8]: cache_data_out[0];
                cache_data_in[1] = (mem_block == 1) ? saved_val[31-24 -: 8]: cache_data_out[1];
                cache_data_in[2] = (mem_block == 2) ? saved_val[31-24 -: 8]: cache_data_out[2];
                cache_data_in[3] = (mem_block == 3) ? saved_val[31-24 -: 8]: cache_data_out[3]; 
            end else begin
                cache_data_in[0] = saved_val[31   -: 8];
                cache_data_in[1] = saved_val[31-8 -: 8];
                cache_data_in[2] = saved_val[31-16 -: 8];
                cache_data_in[3] = saved_val[31-24 -: 8];
            end
        end else begin
            cache_data_in[0] = (is_LB_SB == 1'b0) ? rt_data[31 -: 8] : (mem_block == 0) ?   rt_data[31-24 -: 8]: cache_data_out[0];
            cache_data_in[1] = (is_LB_SB == 1'b0) ? rt_data[31-8 -: 8]: (mem_block == 1) ?  rt_data[31-24 -: 8]: cache_data_out[1];
            cache_data_in[2] = (is_LB_SB == 1'b0) ? rt_data[31-16 -: 8]: (mem_block == 2) ? rt_data[31-24 -: 8]: cache_data_out[2];
            cache_data_in[3] = (is_LB_SB == 1'b0) ? rt_data[31-24 -: 8]: (mem_block == 3) ? rt_data[31-24 -: 8]: cache_data_out[3];
        end
        
    end

  

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
            // // $display("-----------------MEM stage(%d)-------------------", clk_count);
            // // $display("mem_write= %b", mem_write);
            // // $display("alu_result= %b", alu_result);
            // // $display("is_= %b", is_LB_SB);
            // // $display("is_SW_SB= %b", is_SW_SB);
            // // $display("saved_val= %b",saved_val);
            // // $display("cache_data_in= %b",{cache_data_in[0],cache_data_in[1],cache_data_in[2],cache_data_in[3]});
            // // $display("rt_data= %b", rt_data);
            // // $display("mem_data_out= %b", {mem_data_out[0], mem_data_out[1], mem_data_out[2], mem_data_out[3]});
            // // $display("cache_en= %b", cache_en);
            // // $display("clk= %b", clk);
            // // $display("rst_b= %b", rst_b);
            // // $display("hit= %b", hit);
            // // $display("cache_data_out= %b", {cache_data_out[0], cache_data_out[1], cache_data_out[2], cache_data_out[3]});
            // // $display("mem_data_in= %b", mem_data_in);
            // // $display("mem_write_en= %b", mem_write_en);
            // // $display("mem_addr= %b", mem_addr);
            // // $display("mem_block= %b", mem_block);

            clk_count <= clk_count + 1;
        end
    end
endmodule