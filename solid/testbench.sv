/* ------------------------------------------------------------------------------------------------
---- Description:  VVDN O-RAN testbench file 
--   Target Device     : XCZU28DR-FFVG1517  
--   Device Family     : Zynq UltraScale+ RFSoC  
--   Synthesis Tool    : Vivado System  Edition 19.1
---------------------------------------------------------------------------------
---- $Revision: 0.1 $ $Date: 21/09/2020 : init.
---------------------------------------------------------------------------------
*/

`default_nettype none
`timescale 1ns / 1ns

// `define DU_CPRI_SIMULATION

module testbench
#(
	parameter   pTEST_NUMBER    = 0,            // test number
	parameter   pADDR_WIDTH    = 32,
	parameter   pDATA_WIDTH    = 32
);
	
logic rst_h;
logic clk_100m;
logic clk_122p88m;
logic clk_245p76m;
logic clk_491p52m;


// ------------------------------------------------------------------------------------------------------------
//                                              test inclusion
// ------------------------------------------------------------------------------------------------------------
// `include "D:/Projects/LGU/RAU/Project/source/simulation/headers/vm_aru_cpri_tester.svh"

initial begin
	rst_h = 1'b1;
end

always begin
    #(4000) 		rst_h <= 1'b0;	// 4 us
end	

	
always begin : MasterControl
    // ---------------------------------------------
    //  initialization
    // ---------------------------------------------
	$display("simulation start");	// ?�� ?��것을 ?��?��?��?�� ?��?��거�????
	
	// vm_axi_inst.axi_wait(17);
    
    // set the default clocks        
    vm_clkgen_inst.set_freq(0, 100000);      
    vm_clkgen_inst.set_freq(1, 122880);      
    vm_clkgen_inst.set_freq(2, 245760);      
    vm_clkgen_inst.set_freq(3, 491520);      

	@(rst_h == 1'b0);

	// case (pTEST_NUMBER)
        // 0:  vm_oran_tsu_tester;	
		// 1:  vm_oran_ecpri_tester;
        // default:  $display("Invalid test number");
    // endcase

	// end the simulation
    // vm_axi_inst.axi_wait(22);
    $display("Simulation Complete");
    //$stop;
end // MasterControl
	
vm_clkgen vm_clkgen_inst
(
    .clk_0  (clk_100m),
    .clk_1  (clk_122p88m),
    .clk_2  (clk_245p76m),
    .clk_3  (clk_491p52m)
);

logic [20:0] cnt_10ms;
logic tick_10ms;

always@(posedge clk_122p88m) begin
	if (rst_h) begin
		tick_10ms <= 0;
		cnt_10ms <= 0;
	end else begin
		cnt_10ms <= (cnt_10ms==1228800-1)? 0 : cnt_10ms+1;
		tick_10ms <= (cnt_10ms==1228800-1)? 1 : 0;
	end
end

uq_tdd_gen tdd_gen
(
	.i_rst				(rst_h), 
	.clk				(clk_122p88m), 
	.clk_100m			(clk_100m),
	.tdd_valid			(1),
	.tdd_mode			(0),
	.tick_10ms			(tick_10ms),
	.dl_slt_num1		(3),
	.dl_sym_num1		(6),
	.ul_slt_num1		(0),//(5),
	.ul_sym_num1		(0),//(6),
	.trx_periodicity1	(30),
	.patt2_onoff		(0),
	.dl_slt_num2		(4),
	.dl_sym_num2		(0),
	.ul_slt_num2		(0),//(2),
	.ul_sym_num2		(0),//(5),
	.trx_periodicity2	(20),
	.tdd_out			()
);

endmodule
