
`timescale 1ns / 1ps

module uq_tdd_gen
(    
	input wire              i_rst, 
	input wire              clk, // 122.88m
	input wire 				clk_100m,
//	input wire 				tdd_valid,
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
	output reg				tdd_out,
	input wire				i_tsync_chk_clr,
	output wire 			tsync_valid
);

reg sm;
wire [1:0] tdd_mode_s;
reg [8:0] sym_cnt;
reg [12:0] smp_cnt;
reg tick_10ms_d;
reg trig;
reg trig_d;
reg tsync_valid_s;
wire tsync_chk_clr;

wire [6:0] sym_value_1s = (trx_periodicity1==10)? 28  :
						  (trx_periodicity1==20)? 56  :
						  (trx_periodicity1==30)? 84  :
						  (trx_periodicity1==40)? 112 : 84;
wire [6:0] sym_value_2s = (trx_periodicity2==10)? 28  :
						  (trx_periodicity2==20)? 56  :
						  (trx_periodicity2==30)? 84  :
						  (trx_periodicity2==40)? 112 : 56;
wire [6:0] sym_value_s = (~trig)? sym_value_1s : sym_value_2s;
wire [6:0] sym_value;

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
	.bits	(7)
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
	.bits	(1)
) 
inst_tsync_chk_clr
(
	.in_clk		(clk_100m),
	.out_clk	(clk),            
	.d_in		(i_tsync_chk_clr), 
	.d_out		(tsync_chk_clr) 
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
	.bits	(1)
) 
inst_ul_sym_num
(
	.in_clk		(clk),
	.out_clk	(clk_100m),            
	.d_in		(tsync_valid_s), 
	.d_out		(tsync_valid) 
);

wire [8:0] dl_slt_sym_num = dl_slt_num*14;
wire [8:0] ul_slt_sym_num = ul_slt_num*14;
// wire [8:0] flex_num_s = sym_value - dl_slt_sym_num - ul_slt_sym_num - dl_sym_num - ul_sym_num;
// wire [8:0] flex_num = (flex_num_s < 2)? 0 : flex_num_s;

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
	 end else if(tick_10ms_sync) begin
		 sm <= 1'b0;
		 smp_cnt <= 0;
		 sym_cnt <= 0;
		 trig <= 0;
	end else begin	
		case(sm)
			1'b0 : begin	
//			 if (tick_10ms_sync) begin
				smp_cnt <= smp_cnt+1;//0;
				sym_cnt <= 0;
				sm <= 1'b1;	
//			 end
			end
			1'b1 : begin
				if(sym_cnt%14==0) begin
					if(smp_cnt<4447)
						smp_cnt <= smp_cnt+1;
					else begin
						smp_cnt <= 0;
						sym_cnt <= sym_cnt+1;
					end
				end else begin
					if(smp_cnt<4383)
						smp_cnt <= smp_cnt+1;
					else begin
						smp_cnt <= 0;
						if(sym_cnt<sym_value-1) begin
							sym_cnt <= sym_cnt+1;
							sm <= 1'b1;
						end else begin
							sym_cnt <= 0;
							trig <= (patt2_onoff_s)? 0 : ~trig;
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
	if(rst) begin
		tdd_out <= 0;
		trig_d <= 0;
	end else if(dl_slt_sym_num==0)
		tdd_out <= 1;
	else begin
		if(sym_cnt < (dl_slt_sym_num+{5'b0,dl_sym_num}))
			tdd_out <= 1;
		else 
			tdd_out <= 0;

		trig_d <= trig;
	end
end

always@(posedge clk) begin 
	if(rst)
		tsync_valid_s <= 1;
	else if(tsync_chk_clr)
		tsync_valid_s <= 1;
	else if(tdd_mode_s==1 || tdd_mode_s==2)
		tsync_valid_s <= 1;
	else begin
		if(trig_d==1 && tdd_out==0)
			tsync_valid_s <= 0;
		else if(trig==0 && sym_cnt < (dl_slt_sym_num+{5'b0,dl_sym_num}-1) && tdd_out==0)
			tsync_valid_s <= 0;
		else if(trig_d==0 && sym_cnt > (dl_slt_sym_num+{5'b0,dl_sym_num}) && tdd_out==1)
			tsync_valid_s <= 0;
		else
			tsync_valid_s <= tsync_valid_s;
	end
end

// ila_tdd_gen inst_ila
// (
	// .clk (clk),
	// .probe0     (sm),				//1
	// .probe1     (tick_10ms_sync), 	//1
	// .probe2     (trig), 				//1
	// .probe3        (smp_cnt),				// 13
	// .probe4        (sym_cnt),				// 9
	// .probe5        (dl_slt_sym_num),		// 9
	// .probe6        (dl_sym_num),			// 4
	// .probe7     (tdd_out), 	//1
	// .probe8     (tick_10ms) 	//1
// );

endmodule 

