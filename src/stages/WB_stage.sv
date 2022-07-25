module WB_stage (
    // outputs
    dest_reg_data,
    // inputs
    is_LB_SB,
    cache_data_out,
    mem_block,
    mem_to_reg,
    jump,
    pc,
    alu_result,
    clk,
    rst_b
);
    input        is_LB_SB;
    input [7:0]  cache_data_out[0:3];
    input [1:0]  mem_block;
    input        mem_to_reg;
    input [1:0]  jump;
    input [31:0] pc;
    input [31:0] alu_result;
    input clk;
    input rst_b;

    output [31:0] dest_reg_data;


    wire [31:0] cache_data_out_32_bit;

        
    wire [5:0]  opcode;
    wire [5:0]  func;
    assign cache_data_out_32_bit = (is_LB_SB == 1'b0) 
                                    ? {cache_data_out[0], cache_data_out[1], cache_data_out[2], cache_data_out[3]} 
                                    : { (cache_data_out[mem_block][7] == 1) 
                                        ? 24'hffffff 
                                        : 24'b0 , cache_data_out[mem_block] };

    assign dest_reg_data = (mem_to_reg == 1'b1) ? cache_data_out_32_bit : (jump == 2'b10) ? pc + 8 : alu_result;

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if(!rst_b)
            clk_count <= 0;
        else begin
            // // $display("-----------------WB stage(%d)-------------------", clk_count);
            // // // $display("dest_reg_data= %b", dest_reg_data);
            // // $display("is_LB_SB= %b", is_LB_SB);
            // // $display("cache_data_out= %b", cache_data_out);
            // // $display("mem_block= %b", mem_block);
            // // $display("mem_to_reg= %b", mem_to_reg);
            // // $display("jump= %b", jump);
            // // $display("pc= %b", pc);
            // // $display("alu_result= %b", alu_result);
            clk_count <= clk_count + 1;
        end
    end
endmodule