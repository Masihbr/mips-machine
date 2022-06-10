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
    output reg          hit;
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

    always_ff @(posedge clk, negedge rst_b) begin
        $display("ea=%d\ndirty=%b\nvalid=%b\ntag=%h\ninput_tag=%h\ndata=%h", ea,dirty[ea],valid[ea],tag[ea],input_tag,data[ea]);
        if (rst_b == 0) begin
            counter <= 0;
            for (i = start; i <= top; i++) begin
                data[i] <= 0;
                valid[i] <= 0;
                tag[i] <= 0;
            end
        end
        else if (cache_en) begin   
            hit <= 0;
            if (valid[ea]) begin
                $display("valid");
                if (tag[ea] == input_tag) begin
                    $display("tag");
                    hit <= 1;
                    counter <= 0;
                end
                else begin
                    $display("not tag");
                    if (dirty[ea] && counter == 0) begin
                        $display("dirty and counter=0");
                        mem_addr <= {tag[ea], ea, 2'b00};
                        mem_write_en <= 1;
                        {mem_data_in[3], mem_data_in[2], mem_data_in[1], mem_data_in[0]} <= data[ea]; 

                        counter <= counter + 1;
                    end else begin
                        mem_addr <= cache_addr;
                        mem_write_en <= 0;

                        if ((dirty[ea] && counter == 5) || (!dirty[ea] && counter == 4)) begin
                            data[ea] <= {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]}; 
                            valid[ea] <= 1;
                            dirty[ea] <= 0;
                            tag[ea] <= input_tag;
                            hit <= 1;
                            counter <= 0;
                        end else begin
                            counter <= counter + 1;
                        end
                    end
                end
            end else begin
                mem_addr <= cache_addr;
                hit <= 0;
                if (counter == 4) begin

                    data[ea] <= {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]}; 
                    valid[ea] <= 1;
                    dirty[ea] <= 0;
                    tag[ea] <= input_tag;
                    hit <= 1;
                    counter <= 0;   
                end else begin
                    counter <= counter + 1;
                    hit <= 0;
                end
            end

            if (cache_write_en) begin
                $display("cache_write_en");
                data[ea] <= {cache_data_in[3], cache_data_in[2], cache_data_in[1], cache_data_in[0]}; 
                dirty[ea] <= 1;
            end
        end


        // else begin
        //     counter <= next_counter;
        //     if (cache_write_en) begin
        //         if (valid[ea]) begin
        //             if (tag[ea] == input_tag) begin
        //                 data[ea + 0] <= cache_data_in[0];
        //                 data[ea + 1] <= cache_data_in[1];
        //                 data[ea + 2] <= cache_data_in[2];
        //                 data[ea + 3] <= cache_data_in[3];
        //                 dirty[ea] <= 1;
        //             end else begin
        //             // write back (check dirty) 4 clk
        //             // 4 clk read mem
        //             // write zart
        //                 dirty[ea] <= 1;
        //             end 
        //         end else begin
        //             // 4 clk read mem
        //             // write zart
        //             dirty[ea] <= 0;
        //         end
        //     end else if (valid[ea] && tag[ea] == input_tag) begin
        //         hit <= 1;
        //     end else begin
        //         if (counter == 4) begin
        //             if (valid[ea] && dirty[ea]) begin
        //                 mem_data_in[ea + 0] <= data[ea + 0];
        //                 mem_data_in[ea + 1] <= data[ea + 1];
        //                 mem_data_in[ea + 2] <= data[ea + 2];
        //                 mem_data_in[ea + 3] <= data[ea + 3];
        //                 mem_write_en <= 1;
        //                 dirty[ea] <= 0;
        //             end
        //             data[ea + 0] <= mem_data_out[0];
        //             data[ea + 1] <= mem_data_out[1];
        //             data[ea + 2] <= mem_data_out[2];
        //             data[ea + 3] <= mem_data_out[3];
        //             dirty[ea] <= 0;
        //             valid[ea] <= 1;
        //             tag[ea] <= input_tag;

        //         end
        //     end
        // end
    end
endmodule