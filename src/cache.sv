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

    output [7:0]   cache_data_out[0:3];
    output [7:0]   mem_data_in[0:3];
    output         mem_write_en;
    output         hit;

    input  [7:0]   mem_data_out[0:3];
    input  [7:0]   cache_data_in[0:3];
    input          cache_write_en;
    input          rst_b;
    input          clk;
    input  [31:0]  address;

    parameter blocks_number = 11;
    parameter word_size = 32; 
    parameter tag_size = 16 - blocks_number - 2;
    parameter start = 0, top = (1 << blocks_number) - 1;

    reg  [word_size-1:0]        data[start:top];
    reg                         valid[start:top];
    reg                         dirty[start:top];
    reg  [tag_size-1:0]         tag[start:top];
    wire [blocks_number-1:0]    ea;
    wire [tag_size-1:0]         input_tag;

    assign ea = address[blocks_number + 2 :- blocks_number];
    assign input_tag = address[16 :- tag_size];

    assign {cache_data_out[3], cache_data_out[2], cache_data_out[1], cache_data_out[0]} = data[ea]; 

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            integer i;
            for (i = start; i <= top; i++) begin
                data[i] <= 0;
                valid[i] <= 0;
                tag[i] <= 0;
            end
        end
        else begin
            if (cache_write_en) begin
                if (valid[ea]) begin
                    if (tag[ea] == input_tag) begin
                        // write zart
                        dirty[ea] <= 1;
                    end else begin
                    // write back (check dirty) 4 clk
                    // 4 clk read mem
                    // write zart
                        dirty[ea] <= 1;
                    end 
                end else begin
                    // 4 clk read mem
                    // write zart
                    dirty[ea] <= 0;
                end
            end else if (valid[ea] && tag[ea] == input_tag) begin
                hit <= 1;
            end else begin
                // 4 clk read mem
            end
        end
    end
endmodule