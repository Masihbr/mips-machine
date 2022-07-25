module pc_control(
    next_pc,
    pc,
    address,
    jump,
    branch,
    jr,
    zero,
    sign_extend_immediate,
    rs_data
);
    parameter N = 32;
    output reg  [N-1:0]      next_pc;
    input [N-1:0]            pc;
    input [25:0]             address;
    input [1:0]              jump;
    input [2:0]              branch;
    input                    jr;
    input                    zero;  
    input [N-1:0]            sign_extend_immediate;
    input [N-1:0]            rs_data;

    wire [N-1:0] pc4;
    assign pc4 = pc + 32'd4;

    always_comb begin   
        next_pc = pc4;
        if (jump != 2'b00) begin
            next_pc = {pc4[31:28] ,address, 2'b00}; 
        end 
        else if (jr == 1'b1) begin
            next_pc = rs_data;
        end
        else begin
            case(branch)
                3'b100: begin
                    if (zero == 1'b1) begin
                        next_pc = pc + {sign_extend_immediate[29:0],2'b00};
                    end
                end

                3'b101: begin
                    if (zero == 1'b0) begin
                        next_pc = pc4 + {sign_extend_immediate[29:0],2'b00};
                    end
                end 

                3'b110: begin
                    if ($signed(rs_data) <= 0) begin
                        next_pc = pc4 + {sign_extend_immediate[29:0],2'b00};
                    end
                end

                3'b111: begin
                    if ($signed(rs_data) > 0) begin
                        next_pc = pc4 + {sign_extend_immediate[29:0],2'b00};
                    end
                end

                3'b001: begin
                    if ($signed(rs_data) >= 0) begin
                        next_pc = pc4 + {sign_extend_immediate[29:0],2'b00};
                    end
                end
                default: next_pc = pc4;
            endcase
        end
    end

endmodule