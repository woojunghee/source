
`timescale 1ns / 1ps

module uq_tdd_gen
(    
	input wire              i_rst, 
	input wire              clk, // 122.88m
	input wire 				clk_100m,
	input wire 				tdd_valid,
	input wire [1:0]		tdd_mode,
	input wire 				tick_10ms,
	input wire [5:0]		dl_slt_num1,
	input wire [3:0]		dl_sym_num1,
	input wire [5:0]		ul_slt_num1,
	input wire [3:0]		ul_sym_num1,
	input wire [6:0]		trx_periodicity1,	// 0~10ms 0.1ms step // 50 is 5ms
	input wire				patt2_onoff,		// '0' : On, '1' : Off
	input wire [5:0]		dl_slt_num2,
	input wire [3:0]		dl_sym_num2,
	input wire [5:0]		ul_slt_num2,
	input wire [3:0]		ul_sym_num2,
	input wire [6:0]		trx_periodicity2,	// 0~10ms 0.1ms step
	output reg				tdd_out
);

localparam [13:0] sym_0 	= 17'd4448;
localparam [13:0] sym_1_13 	= 17'd4384;
localparam [7:0] ms5_sym 	= 8'd140;

reg [13:0] sym_0_value;
reg [13:0] sym_1_13_value;
reg sm;
wire [1:0] tdd_mode_s;
reg [8:0] sym_cnt;
reg [16:0] smp_cnt;
reg tick_10ms_d;

wire [8:0] sym_value_s = (trx_periodicity1== 25)? {1'b0, ms5_sym[7:1]} :
					     (trx_periodicity1== 50)? ms5_sym :
					     (trx_periodicity1==100)? {ms5_sym, 1'b0} : ms5_sym;
wire [8:0] sym_value;
reg trig;

wire [5:0] dl_slt_num_s = (~trig)? dl_slt_num1 : dl_slt_num2;
wire [5:0] ul_slt_num_s = (~trig)? ul_slt_num1 : ul_slt_num2;
wire [3:0] dl_sym_num_s = (~trig)? dl_sym_num1 : dl_sym_num2;
wire [3:0] ul_sym_num_s = (~trig)? ul_sym_num1 : ul_sym_num2;
wire [5:0] dl_slt_num;
wire [5:0] ul_slt_num;
wire [3:0] dl_sym_num;
wire [3:0] ul_sym_num;
wire rst;

xpm_cdc_async_rst #(
	.DEST_SYNC_FF	(2),
	.RST_ACTIVE_HIGH	(1)
) 
rst_blk 
(
	.src_arst	(i_rst),
	.dest_clk	(clk),            
	.dest_arst	(rst) 
);
// assign rst = i_rst;

d_sync #(
	.bits	(2)
) 
inst_tdd_mode 
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(tdd_mode), 
	.d_out		(tdd_mode_s) 
);
d_sync #(
	.bits	(9)
) 
total_sym_value  
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(sym_value_s), 
	.d_out		(sym_value) 
);
d_sync #(
	.bits	(1)
) 
inst_patt2_onoff
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(patt2_onoff), 
	.d_out		(patt2_onoff_s) 
);
d_sync #(
	.bits	(6)
) 
inst_dl_slt_num
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(dl_slt_num_s), 
	.d_out		(dl_slt_num) 
);
d_sync #(
	.bits	(6)
) 
inst_ul_slt_num
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(ul_slt_num_s), 
	.d_out		(ul_slt_num) 
);
d_sync #(
	.bits	(4)
) 
inst_dl_sym_num
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(dl_sym_num_s), 
	.d_out		(dl_sym_num) 
);
d_sync #(
	.bits	(4)
) 
inst_ul_sym_num
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(ul_sym_num_s), 
	.d_out		(ul_sym_num) 
);
// assign tdd_mode_s = tdd_mode;
// assign sym_value = sym_value_s;
// assign patt2_onoff_s = patt2_onoff;
// assign dl_slt_num = dl_slt_num_s;
// assign ul_slt_num = ul_slt_num_s;
// assign dl_sym_num = dl_sym_num_s;
// assign ul_sym_num = ul_sym_num_s;

wire [8:0] dl_slt_sym_num = dl_slt_num*14;
wire [8:0] ul_slt_sym_num = ul_slt_num*14;
wire [8:0] flex_num_s = sym_value - dl_slt_sym_num - ul_slt_sym_num - dl_sym_num - ul_sym_num;
wire [8:0] flex_num = (flex_num_s < 2)? 0 : flex_num_s;

always@(posedge clk) begin 
    tick_10ms_d <= tick_10ms;
end

wire tick_10ms_sync = tick_10ms & (~tick_10ms_d);

always@(posedge clk) begin 
	if(rst) begin
		sm <= 1'b0;
		smp_cnt <= 0;
		sym_cnt <= 0;
		trig <= 0;
	end else if(~tdd_valid | tick_10ms_sync) begin
		sm <= 1'b0;
		smp_cnt <= 0;
		sym_cnt <= 0;
		trig <= 0;
	end else begin	
		case(sm)
			1'b0 : begin	
				if(sym_value == {1'b0, ms5_sym[7:1]}) begin
					sym_0_value <= {1'b0, sym_0[13:1]};
					sym_1_13_value <= {1'b0, sym_1_13[13:1]};
					sm <= 1'b1;		
				end else if(sym_value == ms5_sym) begin
					sym_0_value <= sym_0;
					sym_1_13_value <= sym_1_13;
					sm <= 1'b1;	
				end else if(sym_value == {ms5_sym, 1'b0}) begin
					sym_0_value <= {sym_0, 1'b0};
					sym_1_13_value <= {sym_1_13, 1'b0};
					sm <= 1'b1;	
				end
				smp_cnt <= 0;
				sym_cnt <= 0;
			end
			1'b1 : begin
				if(sym_cnt%14==0) begin
					if(smp_cnt!=(sym_0_value-1))
						smp_cnt <= smp_cnt+1;
					else begin
						smp_cnt <= 0;
						sym_cnt <= sym_cnt+1;
					end
				end else begin
					if(smp_cnt!=sym_1_13_value-1)
						smp_cnt <= smp_cnt+1;
					else begin
						smp_cnt <= 0;
						if(sym_cnt!=sym_value-1) begin
							sym_cnt <= sym_cnt+1;
							sm <= 1'b1;
						end else begin
							sym_cnt <= 0;
							trig <= (~patt2_onoff_s)? 0 : ~trig;
							sm <= 1'b0;
						end
					end
				end				
			end	
			default : begin
				sm <= 1'b0;
				smp_cnt <= 0;
				sym_cnt <= 0;
			end
		endcase
	end	
end

always@(posedge clk) begin 
	if(rst)
		tdd_out <= 0;
	else if (~tdd_valid)
		tdd_out <= 0;
	else if(tdd_mode_s==2'b01)
		tdd_out <= 1;
	else if(tdd_mode_s==2'b10)
		tdd_out <= 0;
	else begin
		if(sym_cnt < (dl_slt_sym_num+dl_sym_num+flex_num[8:1]))
			tdd_out <= 1;
		else 
			tdd_out <= 0;
	end
end

endmodule 

