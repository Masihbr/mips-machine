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
    alu_result
);
    input        is_LB_SB;
    input [7:0]  cache_data_out[0:3];
    input [1:0]  mem_block;
    input        mem_to_reg;
    input [1:0]  jump;
    input [31:0] pc;
    input [31:0] alu_result;

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

endmodule