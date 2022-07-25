module ID_stage(
    // outputs
    halted,
    sign_extend_immediate,
    reg1_num,
    reg2_num,
    dest_reg_num,
    val1,
    val2,
    zero,
    is_reg1_valid,
    is_reg2_valid,
    control,
    jump,
    branch,
    jr,
    cache_en,
    is_LB_SB,
    mem_to_reg,
    mem_write,
    reg_write,
    // reg_dst,
    // mem_read,
    // alu_op,
    // is_sign_extended,
    // control,
    // a,
    // b,
    // halted,
    // is_imm,
  
    // src2,
    // inputs
    inst,
    reg1_data,
    reg2_data,
    has_reg1_hazard,
    has_reg2_hazard,
    clk,
    rst_b
);
    output        halted;
    output [31:0] sign_extend_immediate;
    output [4:0]  reg1_num;
    output [4:0]  reg2_num;
    output [4:0]  dest_reg_num;
    output [31:0] val1;
    output [31:0] val2;
    output        zero;
    output        is_reg1_valid;
    output        is_reg2_valid;
    output [3:0]  control;
    output [1:0]  jump;
    output [2:0]  branch;
    output        jr;
    output        cache_en;
    output        is_LB_SB;
    output        mem_write;
    output        reg_write;
    output        mem_to_reg;





    // output        reg_dst;
    // output        mem_read;
    // // output [3:0]  alu_op;
    // output        is_sign_extended;
    
    // output [4:0]  src2;
    // output        is_imm;



    input [31:0] inst;
    input [31:0] reg1_data;
    input [31:0] reg2_data;
    input        has_reg1_hazard;
    input        has_reg2_hazard;
    input        clk;
    input        rst_b;
     

    wire [5:0]  opcode;
    wire [4:0]  rs_num, rt_num, rd_num;
    wire [4:0]  sh_amount;
    wire [5:0]  func;
    wire [15:0] immediate_data;
    wire        dest_reg_sel;
    wire        is_sign_extended;
    wire [3:0]  alu_op;

    assign opcode = inst[31:26];
    assign rs_num = inst[25:21];
    assign rt_num = inst[20:16];
    assign rd_num = inst[15:11];
    assign sh_amount = inst[10:6]; 
    assign func = inst[5:0];
    assign immediate_data = inst[15:0];

    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;
    
    assign sign_extend_immediate = (is_sign_extended) ? {{16{immediate_data[15]}}, immediate_data} : {16'd0, immediate_data};

    assign reg1_num = rs_num;
    assign reg2_num = rt_num;
    assign dest_reg_num = dest_reg_sel ? rd_num : (jump == 2'b10) ? 5'd31 : rt_num;

    assign val1 = is_reg1_valid ? reg1_data : {{27{1'b0}}, sh_amount};
    assign val2 = is_reg2_valid ? reg2_data : sign_extend_immediate;
    assign zero = (val1 == val2) ? 1'b1 : 1'b0;


    control control_unit (
        // outputs
        .is_reg1_valid(is_reg1_valid),
        .is_reg2_valid(is_reg2_valid),
        .dest_reg_sel(dest_reg_sel),
        .is_sign_extended(is_sign_extended),
        .alu_op(alu_op),
        .jump(jump),
        .branch(branch),
        .jr(jr),
        .cache_en(cache_en),
        .is_LB_SB(is_LB_SB),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        // .is_imm(is_imm),
        // .reg_dst(reg_dst),
        .dest_reg_write(reg_write),
        // .mem_read(mem_read),
        // .has_hazard(has_hazard),

        // inputs
        .func(func),
        .opcode(opcode)
    );

    alu_control alu_control_unit(
        // outputs
        .control(control),
        // inputs
        .alu_op(alu_op),
        .func(func)
    );

    integer clk_count;
    always_ff @(posedge clk, negedge rst_b) begin
        if (!rst_b)
            clk_count <= 0;
        else begin
            clk_count <= clk_count + 1;
            // // $display("-----------------Id stage(%d)-------------------", clk_count);
            // // $display("is_imm= %b", is_imm);
            // // $display("is_reg1_valid= %b", is_reg1_valid);
            // // $display("is_reg2_valid= %b", is_reg2_valid);
            // // $display("has_hazard= %b", has_hazard);
            // // $display("is_LB_SB=%b", is_LB_SB);
            // // $display("reg_dst=%b", reg_dst);
            // // $display("mem_to_reg=%b", mem_to_reg);
            // // $display("reg_write=%b", reg_write);
            // // $display("mem_read=%b", mem_read);
            // // $display("mem_write=%b", mem_write);
            // // $display("branch=%b", branch);
            // // $display("alu_op=%b", alu_op);
            // // $display("is_sign_extended=%b", is_sign_extended);
            // // $display("jr=%b", jr);
            // // $display("jump=%b", jump);
            // // $display("cache_en=%b", cache_en);
            // // $display("sign_extend_immediate=%b", sign_extend_immediate);
            // // $display("control=%b", control);
            // // $display("a=%b", a);
            // // $display("b=%b", b);
            // // $display("halted=%b", halted);
        end
    end
    
endmodule
