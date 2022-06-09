


module cache(
    
    cache_data_out,
    rst_b,
    clk,
    cache_addr,
    cache_hit

);

    output [31:0] cache_data_out;
    output cache_hit;
    input rst_b;
    input clk;
    input [31:0] cache_addr;

    parameter start = 0, top = (1 << 12) - 1;

    reg [31:0] data[start:top];
    reg valid[start:top];
    reg [1:0] tag_array[start:top];



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