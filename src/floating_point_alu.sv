module floating_point_alu(
    falu_result,
    zero,
    DBZ,
    QNAN,
    SNAN,
    Inexact,
    Underflow,
    Overflow,
    opcode,
    a,
    b
);

    input [31:0] a, b;
    input [3:0] opcode;

    output reg [31:0] falu_result;
    output reg zero, DBZ, QNAN, SNAN, Inexact, Underflow, Overflow;

    reg [31:0] a_exponent, b_exponent, a_mantis, b_mantis;
    reg a_sign, b_sign, result_sign;

    reg [7:0] result_exponent;
    reg [22:0] result_mantis;

    reg [31:0] result_no_sign;

    real a_real_exp, a_real, b_real_exp, b_real, result_real;
    real alt;

    integer i;
    real trash;
    real temp;
    integer rounded;
    reg flag;

    reg [63:0] result_real_double;
    reg [51:0] result_real_mantis;

    always @(*) begin

        falu_result = 0;
        zero = 0;
        DBZ = 0;
        QNAN = 0;
        SNAN = 0;
        Inexact = 0;
        Underflow = 0;
        Overflow = 0;
        result_no_sign = 0;

        result_real = 0;
        result_sign = 0;
        alt = 0;
        result_mantis = 0;
        result_exponent = 0;

        a_exponent = {24'b0, a[30 -: 8]};
        b_exponent = {24'b0, b[30 -: 8]};

        a_mantis = {9'b0, a[22 -: 22]};
        b_mantis = {9'b0, b[22 -: 22]};

        a_sign = a[31];
        b_sign = b[31];

        a_real_exp = 1;        
        if (a_exponent < 127) begin
            for (i = 0; i < 127 - a_exponent; i++)
                a_real_exp /= 2;
        end
        else begin
            for (i = 0; i < a_exponent - 127; i++)
                a_real_exp *= 2;
        end

        temp = 4194304;

        a_real = temp + real'(a_mantis);
        a_real = (a_real / temp) * a_real_exp;
        a_real = a_sign? a_real * (-1) : a_real;
        
        b_real_exp = 1;
        if (b_exponent < 127) begin
            for (i = 0; i < 127 - b_exponent; i++)
                b_real_exp /= 2;
        end
        else begin
            for (i = 0; i < b_exponent - 127; i++)
                b_real_exp *= 2;
        end

        b_real = temp + real'(b_mantis);
        b_real = (b_real / temp) * b_real_exp;
        b_real = b_sign? b_real * (-1) : b_real;

        case (opcode)
                4'b0000: result_real = a_real + b_real;
                4'b0001: result_real = a_real - b_real;
                4'b0010: result_real = a_real * b_real;
                4'b0011: begin
                    if (a_real > b_real) begin
                        result_real = a_real;
                    end
                    else if (a_real == b_real) begin
                        result_real = 0;
                    end
                    else begin
                        result_real = b_real;
                    end
                end
                4'b0100: begin
                    if (b_real == 0)
                        DBZ = 1;
                    else
                        result_real = a_real / b_real;
                end
                4'b0101: begin
                    if (b_real == 0)
                        DBZ = 1;
                    else
                        result_real = 1 / a_real;
                end
                4'b0110: begin
                    rounded = int'(a_real);
                    result_real = real'(rounded);
                end

                default: result_real = 0;
        endcase

        result_sign = result_real > 0? 0 : 1;
        result_real = result_real < 0? -result_real: result_real;

        result_exponent = 127;

        if (result_real == 0)
            zero = 1;

        alt = result_real;
        if (alt < 1) begin
            while(alt < 1) begin
                if (result_exponent == 8'b00000000) begin
                    Underflow = 1;
                    break;
                end
                result_exponent--;
                alt *= 2;
            end
        end

        else begin
            while (alt > 2) begin
                if (result_exponent == 8'b11111111) begin
                    Overflow = 1;
                    break;
                end
                result_exponent++;
                alt /= 2;
            end
        end

        result_mantis = 0;
        result_real_double = $realtobits(result_real);
        result_mantis = result_real_double[51 -: 23];

        falu_result = {result_sign, result_exponent, result_mantis};

        result_no_sign = {1'b0, falu_result[30:0]};
        if (result_no_sign[30 -: 8] == 8'b11111111) begin
            trash = {9'b000000000, result_no_sign[22:0]};
            if ((trash > 1) && (trash < 4194303))
                SNAN = 1;
            if ((trash > 0) && (trash < 8388607))
                QNAN = 1;
        end

    end

endmodule