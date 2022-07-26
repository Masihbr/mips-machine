module cache(
    hit,
    cache_data_out,
    mem_data_in,
    mem_write_en,
    cache_addr,
    mem_addr,
    cache_data_in,
    mem_data_out,
    cache_write_en,
    cache_en,
    clk,
    rst_b
);

    output      [7:0]   cache_data_out[0:3];
    output reg  [7:0]   mem_data_in[0:3];
    output reg          mem_write_en;
    output              hit;
    output reg  [31:0]  mem_addr;

    input          cache_en;
    input  [7:0]   mem_data_out[0:3];
    input  [7:0]   cache_data_in[0:3];
    input          cache_write_en;
    input          rst_b;
    input          clk;
    input  [31:0]  cache_addr;

    parameter blocks_number = 11;
    parameter word_size = 32; 
    parameter tag_size = 32 - blocks_number - 2;
    parameter start = 0, top = (1 << blocks_number) - 1;
    integer counter, next_counter;

    reg  [word_size-1:0]        data[start:top];
    reg                         valid[start:top];
    reg                         dirty[start:top];
    reg  [tag_size-1:0]         tag[start:top];
    wire [blocks_number-1:0]    ea;
    wire [tag_size-1:0]         input_tag;

    assign ea = cache_addr[blocks_number + 1 -: blocks_number];
    assign input_tag = cache_addr[31 -: tag_size];

    assign {cache_data_out[3], cache_data_out[2], cache_data_out[1], cache_data_out[0]} = data[ea]; 

    integer i;

    // assign hit = 
    // (valid[ea] && tag[ea] == input_tag) || (tag[ea]!= input_tag && ((dirty[ea] && counter == 1) || (!dirty[ea] && counter == 0))) || (!valid[ea] && counter == 0);

    assign hit = 1;
    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        // integer i;
        // // $display("---------------CACHE(%d)------------", clk_count);
        // for(i = start; i<= top ; i++) begin
        //     if(data[i] != 0)
        //     // $display("data[%d] = %b", i, data[i]);
        // end
        if (rst_b == 0) begin
            clk_count <= 0;
            counter <= 0;
            for (i = start; i <= top; i++) begin
                data[i] <= 0;
                valid[i] <= 0;
                tag[i] <= 0;
            end
        end
        else if (cache_en) begin
            clk_count <= clk_count + 1; 
            if (valid[ea]) begin
                if (tag[ea] == input_tag) begin
                    counter <= 0;
                end
                else begin
                    if (dirty[ea] && counter == 0) begin
                        mem_addr <= {tag[ea], ea, 2'b00};
                        mem_write_en <= 1;
                        {mem_data_in[3], mem_data_in[2], mem_data_in[1], mem_data_in[0]} <= data[ea]; 

                        counter <= counter + 1;
                    end else begin
                        mem_addr <= cache_addr;
                        mem_write_en <= 0;

                        if ((dirty[ea] && counter == 1) || (!dirty[ea] && counter == 0)) begin
                            data[ea] <= {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]}; 
                            valid[ea] <= 1;
                            dirty[ea] <= 0;
                            tag[ea] <= input_tag;
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end
                    end
                end
            end else begin
                mem_addr <= cache_addr;
                if (counter == 0) begin
                    data[ea] <= {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]}; 
                    valid[ea] <= 1;
                    dirty[ea] <= 0;
                    tag[ea] <= input_tag;
                    counter <= 0;   
                end else begin
                    counter <= counter + 1;
                end
            end

            if (cache_write_en) begin
                data[ea] <= {cache_data_in[3], cache_data_in[2], cache_data_in[1], cache_data_in[0]}; 
                dirty[ea] <= 1;
            end
        end
    end
endmodule