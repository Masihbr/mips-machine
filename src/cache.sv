


module cache(
    hit,
    cache_data_out,
    mem_data_in,
    mem_write_en,
    address,
    cache_data_in,
    mem_data_out,
    cache_write_en,
    clk,
    rst_b
);

    output [31:0]  cache_data_out;
    output [31:0]  mem_data_in;
    output         mem_write_en;
    output         hit;

    input  [31:0]  mem_data_out;
    input  [31:0]  cache_data_in;
    input          cache_write_en;
    input          rst_b;
    input          clk;
    input  [31:0]  address;

    parameter blocks_number = 12;
    parameter word_size = 32; 
    parameter tag_size = 16 - blocks_number - 2;
    parameter start = 0, top = (1 << blocks_number) - 1;

    reg  [word_size-1:0]        data[start:top];
    reg                         valid[start:top];
    reg  [tag_size-1:0]         tag_array[start:top];
    wire [blocks_number-1:0]    ea;

    assign ea = address[blocks_number + 2 : -blocks_number];

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            integer i;
            for (i = start; i <= top; i++) begin
                data[i] <= 32'b0;
                valid[i] <= 0;
                tag_array[i] <= 2'b0;
            end
        end
    end
endmodule