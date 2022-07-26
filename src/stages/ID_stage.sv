module ID_stage (
    // outputs
    halted,
    sign_extend_immediate,
    reg1_num,
    reg2_num,
    dest_reg_num,
    val1,
    val2,
    saved_val,
    zero,
    is_reg1_valid,
    is_reg2_valid,
    control,
    jump,
    branch,
    jr,
    cache_en,
    is_LB_SB,
    is_SW_SB,
    mem_to_reg,
    mem_write,
    reg_write,
    // inputs
    inst,
    reg1_data,
    reg2_data,
    saved_val_data,
    has_reg1_hazard,
    has_reg2_hazard,
    has_saved_val_hazard,
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
    output [31:0] saved_val;
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
    output        is_SW_SB;

    input [31:0] inst;
    input [31:0] reg1_data;
    input [31:0] reg2_data;
    input [31:0] saved_val_data;
    input        has_reg1_hazard;
    input        has_reg2_hazard;
    input        has_saved_val_hazard;
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

    // assign correct_reg1_data = has_reg1_hazard
    assign val1 = is_reg1_valid ? reg1_data : {{27{1'b0}}, sh_amount};
    assign val2 = (is_reg2_valid && !is_SW_SB) ? reg2_data : sign_extend_immediate;
    assign saved_val = is_SW_SB ? saved_val_data : 32'd0;
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
        .is_SW_SB(is_SW_SB),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .dest_reg_write(reg_write),
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
            // $display("------------------- ID STAGE(%d) ---------------", clk_count);
            // $display("reg1_num= %b", reg1_num);
            // $display("has_reg1_hazard= %b", has_reg1_hazard);
            // $display("reg1_data= %b", reg1_data);
            // $display("reg2_num= %b", reg2_num);
            // $display("has_reg2_hazard= %b", has_reg2_hazard);
            // $display("reg2_data= %b", reg2_data);
            // $display("saved_val= %b", saved_val);
            // $display("has_saved_val_hazard= %b", has_saved_val_hazard);
            // $display("saved_val_data= %b", saved_val_data);
            // $display("dest_reg_num= %b", dest_reg_num);
            // $display("halted= %b", halted);
            // $display("sign_extend_immediate= %b", sign_extend_immediate);
            // $display("val1= %b", val1);
            // $display("val2= %b", val2);
            // $display("zero= %b", zero);
            // $display("is_reg1_valid= %b", is_reg1_valid);
            // $display("is_reg2_valid= %b", is_reg2_valid);
            // $display("control= %b", control);
            // $display("jump= %b", jump);
            // $display("branch= %b", branch);
            // $display("jr= %b", jr);
            // $display("cache_en= %b", cache_en);
            // $display("is_LB_SB= %b", is_LB_SB);
            // $display("mem_write= %b", mem_write);
            // $display("reg_write= %b", reg_write);
            // $display("mem_to_reg= %b", mem_to_reg);
        end
    end
    
endmodule
