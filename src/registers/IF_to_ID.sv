module IF_to_ID (
    // outputs
    pc,
    inst,
    // inputs
    pc_in,
    inst_in,
    clk,
    rst_b,
    flush,
    freeze
);

    input [31:0] pc_in;
    input [31:0] inst_in;
    input        clk;
    input        rst_b;
    input        flush;
    input        freeze;

    output reg [31:0] pc;
    output reg [31:0] inst;

    integer clk_count;
    always @ (posedge clk, negedge rst_b) begin
        if (!rst_b) begin
            pc <= 0;
            inst <= 0;
            clk_count <= 0;
        end
        else begin
            // // $display("-------------IF TO ID(%d)-------------", clk_count);
            // // $display("inst_in= %b", inst_in);
            // // $display("pc_in= %b", pc_in);
            // // $display("freeze= %b", freeze);
            // // $display("flush= %b", flush);
            clk_count <= clk_count + 1;
            if (!freeze) begin
                if (flush) begin
                    inst <= 0;
                    pc <= 0;
                end
                else begin
                    inst <= inst_in;
                    pc <= pc_in;
                end
            end
      end
    end
endmodule