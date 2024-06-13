//----------------------------------------------------------------------------
// Title : Command Generator for the Example Design
// Project : JESD204
//----------------------------------------------------------------------------
// File : jesd204c_cmd_gen.v
//----------------------------------------------------------------------------
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//----------------------------------------------------------------------------

`timescale 1ns / 1ps

module jesd204c_cmd_gen (
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_RESET rst_n" *)
  input          clk,
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *)
  (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
  input          rst_n,
  input          tx_clear,
  input          tx_tready,
  input          tx_cmd_tready,
  input    [1:0] meta_mode,

  output  [255:0] tx_cmd_tdata,
  output         tx_cmd_tvalid
);

localparam   CRC12_mode = 2'h0;
localparam    CRC3_mode = 2'h1;
localparam     CMD_mode = 2'h2;
localparam     FEC_mode = 2'h3;

//Command width extended to 32 to comply with the axi standard. Commands will still be at most 19 bits wide, however
reg  [31:0] tx_cmd_tdata0_reg;
reg  [31:0] tx_cmd_tdata1_reg;
reg  [31:0] tx_cmd_tdata2_reg;
reg  [31:0] tx_cmd_tdata3_reg;
reg  [31:0] tx_cmd_tdata4_reg;
reg  [31:0] tx_cmd_tdata5_reg;
reg  [31:0] tx_cmd_tdata6_reg;
reg  [31:0] tx_cmd_tdata7_reg;
reg  [31:0] command;

wire        cmd_update;

always @(posedge clk)
begin
  if(!rst_n | tx_clear)
  begin
    tx_cmd_tdata0_reg <= 32'b0;
    tx_cmd_tdata1_reg <= 32'b0;
    tx_cmd_tdata2_reg <= 32'b0;
    tx_cmd_tdata3_reg <= 32'b0;
    tx_cmd_tdata4_reg <= 32'b0;
    tx_cmd_tdata5_reg <= 32'b0;
    tx_cmd_tdata6_reg <= 32'b0;
    tx_cmd_tdata7_reg <= 32'b0;
  end
  else
  begin
    tx_cmd_tdata0_reg <= command;
    tx_cmd_tdata1_reg <= command + 1;
    tx_cmd_tdata2_reg <= command + 2;
    tx_cmd_tdata3_reg <= command + 3;
    tx_cmd_tdata4_reg <= command + 4;
    tx_cmd_tdata5_reg <= command + 5;
    tx_cmd_tdata6_reg <= command + 6;
    tx_cmd_tdata7_reg <= command + 7;
  end
end//always

//Commands are generated from a counter. Each lane is assigned a different command
//by adding its lane number.
always @(posedge clk)
begin
  if(!rst_n | tx_clear)
  begin
    command <= 32'b0;
  end
  else
  begin
    //Commands are generated differently for each meta mode (7-bit commands for CRC, 19-bit commands for CMD, no commands for FEC). When the
	//maximum value for command on each mode is reached, the count restarts.
	if (cmd_update)
	begin
	  case(meta_mode)
	    CRC12_mode, CRC3_mode : command <= (command == 32'h0000007f) ? 32'b0 : command + 1;
	    CMD_mode : command <= (command == 32'h0007ffff) ? 32'b0 : command + 1;
	    FEC_mode : command <= 32'b0;
	  endcase
	end
  end
end//always

//Commands are updated on the cycle after the previous one is captured (tx_cmd_tready pulse) while data is being transmitted (tx_tready asserted)
assign cmd_update = tx_cmd_tready & tx_tready;
assign tx_cmd_tdata = { tx_cmd_tdata7_reg, tx_cmd_tdata6_reg, tx_cmd_tdata5_reg, tx_cmd_tdata4_reg, tx_cmd_tdata3_reg, tx_cmd_tdata2_reg, tx_cmd_tdata1_reg, tx_cmd_tdata0_reg };
assign tx_cmd_tvalid = tx_tready;

endmodule
