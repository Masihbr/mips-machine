module regfile(
    rs_data,
    rt_data,
    rs_num,
    rt_num,
    rd_num,
    rd_data,
    rd_we,
    clk,
    rst_b,
    halted
);
    parameter XLEN=32, size=32;

    output [XLEN-1:0] rs_data;
    output [XLEN-1:0] rt_data;
    input       [4:0] rs_num;
    input       [4:0] rt_num;
    input       [4:0] rd_num;
    input  [XLEN-1:0] rd_data;
    input             rd_we;
    input             clk;
    input             rst_b;
    input             halted;

    reg [XLEN-1:0] data_exp;
    reg [XLEN-1:0] data_mantis;
    reg            data_sign;
    real            data_real_exp;
    real            data_real;
    integer         counter;
    real            temp;

    reg [XLEN-1:0] data[0:size-1];

    assign rs_data = data[rs_num];
    assign rt_data = data[rt_num];

    assign temp = 1 << 23;

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            int i;
            for (i = 0; i < size; i++)
                data[i] <= 0;
        end else begin
            if (rd_we && (rd_num != 0))
                data[rd_num] <= rd_data;
        end
    end

	always @(halted) begin
        integer fd = 0;
        integer i = 0;

        data_exp = 0;
        data_mantis = 0;
        data_sign = 0;
        data_real_exp = 0;
        data_real = 0;
        counter = 0;
        temp = 0;

        
		if (rst_b && (halted)) begin
			fd = $fopen("output/regdump.reg");

			$display("=== Simulation Cycle %0d ===", $time/2);
			$display("*** RegisterFile dump ***");
			$fdisplay(fd, "*** RegisterFile dump ***");
			
			for(i = 0; i < size; i = i+1) begin
                data_exp = {24'b0, data[i][30 -: 8]};
                data_mantis = {9'b0, data[i][22 -: 23]};
                data_sign = data[i][31];
                data_real_exp = 1;
                counter = 0;

                if (data_exp < 127) begin
                    for (counter = 0; counter < 127 - data_exp; counter++)
                        data_real_exp /= 2;
                end
                else begin
                    for (counter = 0; counter < data_exp - 127; counter++)
                        data_real_exp *= 2;
                end

                data_real = temp + real'(data_mantis);
                data_real = (data_real / temp) * data_real_exp;
                data_real = data_sign? data_real * (-1) : data_real;

                $display("r%2d = %f", i, data_real);
                /* verilator lint_off WIDTH */
                $fdisplay("r%2d = %f", i, data_real);

				// $display("r%2d = 0x%8x", i, data[i]);
				// $fdisplay(fd, "r%2d = 0x%8h", i, data[i]); 
			end
			
			$fclose(fd);
		end
	end
    
endmodule
