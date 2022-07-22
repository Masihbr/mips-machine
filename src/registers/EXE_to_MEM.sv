module EXE_to_MEM(
        // outputs
        mem_write,
        alu_result,
        is_LB_SB,
        rt_data,
        cache_en,
        mem_to_reg,
        jump,
        pc,
        // inputs
        mem_write_in,
        alu_result_in,
        is_LB_SB_in,
        rt_data_in,
        cache_en_in,
        mem_to_reg_in,
        jump_in,
        pc_in,
        clk,
        rst_b,
        freeze
);

    input        mem_write_in;
    input [31:0] alu_result_in;
    input        is_LB_SB_in;
    input [31:0] rt_data_in;
    input        cache_en_in;
    input        mem_to_reg_in;
    input [1:0]  jump_in;
    input [31:0] pc_in;
    input        clk;
    input        rst_b;
    input        freeze;

    output        mem_write;
    output [31:0] alu_result;
    output        is_LB_SB;
    output [31:0] rt_data;
    output        cache_en;
    output        mem_to_reg;
    output [1:0]  jump;
    output [31:0] pc;

always @ (posedge clk, negedge rst_b) begin
    if (!rst_b) begin
      {mem_write, alu_result, is_LB_SB, rt_data, cache_en, mem_to_reg, jump, pc} <= 0;
    end
    else begin
        if (~freeze) begin
                mem_write <= mem_write_in;
                alu_result <= alu_result_in;
                is_LB_SB <= is_LB_SB_in;
                rt_data <= rt_data_in;
                cache_en <= cache_en_in;
                mem_to_reg <= mem_to_reg_in;
                jump <= jump_in;
                pc <= pc_in;
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