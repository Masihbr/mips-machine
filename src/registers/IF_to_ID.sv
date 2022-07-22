module IF_to_ID (
    // outputs
    pc,
    inst,
    // outputs
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

    output [31:0] pc;
    output [31:0] inst;
    
    always @ (posedge clk, negedge rst_b) begin
        if (rst_b) begin
            PC <= 0;
            inst <= 0;
        end
        else begin
            if (~freeze) begin
                if (flush) begin
                    inst <= 0;
                    PC <= 0;
                end
                else begin
                    inst <= inst_in;
                    pc <= pc_in;
                end
            end
      end
    end
endmodule