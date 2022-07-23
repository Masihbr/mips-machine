module MEM_to_WB(
        // outputs
        is_LB_SB,
        cache_data_out,
        mem_block,
        mem_to_reg,
        jump,
        pc,
        alu_result,
        inst,
        reg_dst,
        reg_write,
        // inputs
        is_LB_SB_in,
        cache_data_out_in,
        mem_block_in,
        mem_to_reg_in,
        jump_in,
        pc_in,
        alu_result_in,
        inst_in,
        reg_dst_in,
        reg_write_in,
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
    input [31:0] inst_in;   
    input        reg_dst_in;
    input        reg_write_in;
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
    output reg [31:0] inst;  
    output reg        reg_dst;
    output reg        reg_write;  

integer clk_count;
always @ (posedge clk, negedge rst_b) begin

    if (!rst_b || inst_in == 0) begin
        clk_count <= 0;
        is_LB_SB <= 0;  
        {cache_data_out[0], cache_data_out[1], cache_data_out[2], cache_data_out[3]} <= 0;
        mem_block <= 0;
        mem_to_reg <= 0;
        jump <= 0;
        pc <= 0;
        alu_result <= 0;
        inst <= 0;
        reg_dst <= 0;
        reg_write <= 0;
    end
    else begin
        // $display("------------------MEM TO WB(%d)--------------", clk_count);
        // $display("is_LB_SB_in= %b", is_LB_SB_in);
        // $display("cache_data_out_in= %b", cache_data_out_in);
        // $display("mem_block_in= %b", mem_block_in);
        // $display("mem_to_reg_in= %b", mem_to_reg_in);
        // $display("jump_in= %b", jump_in);
        // $display("pc_in= %b", pc_in);
        // $display("alu_result_in= %b", alu_result_in);
        // $display("inst_in= %b", inst_in);
        // $display("reg_dst_in= %b", reg_dst_in);
        // $display("reg_write_in= %b", reg_write_in);
        // $display("clk= %b", clk);
        // $display("rst_b= %b", rst_b);
        // $display("freeze= %b", freeze);
        
        clk_count <= clk_count + 1;
        if (~freeze) begin
                is_LB_SB <= is_LB_SB_in;
                cache_data_out <= cache_data_out_in;
                mem_block <= mem_block_in;
                mem_to_reg <= mem_to_reg_in;
                jump <= jump_in;
                pc <= pc_in;
                alu_result <= alu_result_in;
                inst <= inst_in;
                reg_dst <= reg_dst_in;
                reg_write <= reg_write_in;
        end
    end
  end

endmodule
