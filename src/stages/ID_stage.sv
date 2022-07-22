module ID_stage(
    // outputs
    is_LB_SB,
    reg_dst,
    alu_src,
    mem_to_reg,
    reg_write,
    mem_read,
    mem_write,
    branch,
    alu_op,
    do_extend,
    jr,
    jump,
    cache_en,
    sign_extend_immediate,
    control,
    a,
    b,
    halted,
    // inputs
    inst,
    rs_data,
    rt_data,
    clk,
    rst_b
);

    output        is_LB_SB;
    output        reg_dst;
    output [1:0]  alu_src;
    output        mem_to_reg;
    output        reg_write;
    output        mem_read;
    output        mem_write;
    output [2:0]  branch;
    output [3:0]  alu_op;
    output        do_extend;
    output        jr;
    output [1:0]  jump;
    output        cache_en;
    output [31:0] sign_extend_immediate;
    output [3:0]  control;
    output [31:0] a;
    output [31:0] b;
    output        halted;


    input [31:0] inst;
    input [31:0] rs_data;
    input [31:0] rt_data;
    input        clk;
    input        rst_b;
     

    wire [5:0]  opcode;
    wire [5:0]  func;
    wire [15:0] immediate_data;
    wire [4:0]  sh_amount;


    assign opcode = inst[31:26];
    assign func = inst[5:0];
    assign immediate_data = inst[15:0];
    assign sign_extend_immediate = (do_extend) ? {{16{immediate_data[15]}}, immediate_data} : {16'd0, immediate_data};

    assign sh_amount = inst[10:6]; 

    assign a = (alu_src[0] == 1'b1) ? {{27{1'b0}}, sh_amount} : rs_data;
    assign b = (alu_src[1] == 1'b1) ? sign_extend_immediate : rt_data;
    assign halted = (opcode == 0 && func == 6'b001100) ? 1'b1 : 1'b0;

    control control_unit(
        // outputs
        .is_LB_SB(is_LB_SB),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .alu_op(alu_op),
        .do_extend(do_extend),
        .jr(jr),
        .jump(jump),
        .cache_en(cache_en),
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

            $display("-----------------Id stage(%d)-------------------", clk_count);
            $display("is_LB_SB=%b", is_LB_SB);
            $display("reg_dst=%b", reg_dst);
            $display("alu_src=%b", alu_src);
            $display("mem_to_reg=%b", mem_to_reg);
            $display("reg_write=%b", reg_write);
            $display("mem_read=%b", mem_read);
            $display("mem_write=%b", mem_write);
            $display("branch=%b", branch);
            $display("alu_op=%b", alu_op);
            $display("do_extend=%b", do_extend);
            $display("jr=%b", jr);
            $display("jump=%b", jump);
            $display("cache_en=%b", cache_en);
            $display("sign_extend_immediate=%b", sign_extend_immediate);
            $display("control=%b", control);
            $display("a=%b", a);
            $display("b=%b", b);
            $display("halted=%b", halted);
        end
    end
    
endmodule
