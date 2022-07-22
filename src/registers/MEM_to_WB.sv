module MEM_to_WB(
        // outputs
        is_LB_SB,
        cache_data_out,
        mem_block,
        mem_to_reg,
        jump,
        pc,
        alu_result,
        // inputs
        is_LB_SB_in,
        cache_data_out_in,
        mem_block_in,
        mem_to_reg_in,
        jump_in,
        pc_in,
        alu_result_in,
        clk,
        rst_b,
        freeze
);

    input        is_LB_SB_in;
    input [7:0]  cache_data_out_in[0:3];
    input [1:0]  mem_block_in;
    input        mem_to_reg_in;
    input [1:0]  jump_in;
    input [31:0] pc_in;
    input [31:0] alu_result_in;   
    input        clk;
    input        rst_b;
    input        freeze;

    output reg        is_LB_SB;
    output reg [7:0]  cache_data_out[0:3];
    output reg [1:0]  mem_block;
    output reg        mem_to_reg;
    output reg [1:0]  jump;
    output reg [31:0] pc;
    output reg [31:0] alu_result;  

always @ (posedge clk, negedge rst_b) begin
    if (!rst_b) begin
        is_LB_SB <= 0;  
        {cache_data_out[0], cache_data_out[1], cache_data_out[2], cache_data_out[3]} <= 0;
        mem_block <= 0;
        mem_to_reg <= 0;
        jump <= 0;
        pc <= 0;
        alu_result <= 0;
    end
    else begin
        if (~freeze) begin
                is_LB_SB <= is_LB_SB_in;
                cache_data_out <= cache_data_out_in;
                mem_block <= mem_block_in;
                mem_to_reg <= mem_to_reg_in;
                jump <= jump_in;
                pc <= pc_in;
                alu_result <= alu_result_in;
        end
    end
  end

endmodule

// EXE_to_MEM:
//     - mem_write
//     - alu_result
//     - is_LB_SB
//     - rt_data
//     - cache_en
//     - mem_to_reg
//     - jump
//     - pc