module WB_stage(
    rd_data,
    rd_num,
    halted,
    is_LB_SB,
    cache_data_out,
    mem_block,
    mem_to_reg,
    jump,
    pc,
    alu_result,
    inst,
    reg_dst,
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
    input [31:0] inst;
    input reg_dst;
    input clk;
    input rst_b;

    output [31:0] rd_data;
    output [4:0]  rd_num;

    output halted;

    wire [31:0] cache_data_out_32_bit;

        
    wire [5:0]  opcode;
    wire [5:0]  func;
    assign cache_data_out_32_bit = (is_LB_SB == 1'b0) 
                                    ? {cache_data_out[0], cache_data_out[1], cache_data_out[2], cache_data_out[3]} 
                                    : { (cache_data_out[mem_block][7] == 1) 
                                        ? 24'hffffff 
                                        : 24'b0 , cache_data_out[mem_block] };

    assign rd_data = (mem_to_reg == 1'b1) ? cache_data_out_32_bit : (jump == 2'b10) ? pc + 8 : alu_result;
    assign rd_num = (reg_dst == 1'b1) ? inst[15:11] : (jump == 2'b10) ? 5'd31 : inst[20:16];


    assign opcode = inst[31:26];
    assign func = inst[5:0];
    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;


    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if(!rst_b)
            clk_count <= 0;
        else begin
            // $display("-----------------WB stage(%d)-------------------", clk_count);
            // $display("rd_data= %b", rd_data);
            
            clk_count <= clk_count + 1;
        end
    end
endmodule