// (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
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
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:ip:cpri:8.11
// IP Revision: 14

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
xCORE_CPRI_RUn77_RE your_instance_name (
  .iq_tx_enable(iq_tx_enable),                              // output wire iq_tx_enable
  .iq_tx(iq_tx),                                            // input wire [63 : 0] iq_tx
  .iq_rx(iq_rx),                                            // output wire [63 : 0] iq_rx
  .basic_frame_first_word(basic_frame_first_word),          // output wire basic_frame_first_word
  .vendor_tx_data(vendor_tx_data),                          // input wire [127 : 0] vendor_tx_data
  .vendor_tx_xs(vendor_tx_xs),                              // output wire [1 : 0] vendor_tx_xs
  .vendor_tx_ns(vendor_tx_ns),                              // output wire [5 : 0] vendor_tx_ns
  .vendor_rx_data(vendor_rx_data),                          // output wire [127 : 0] vendor_rx_data
  .vendor_rx_xs(vendor_rx_xs),                              // output wire [1 : 0] vendor_rx_xs
  .vendor_rx_ns(vendor_rx_ns),                              // output wire [5 : 0] vendor_rx_ns
  .nodebfn_tx_strobe(nodebfn_tx_strobe),                    // input wire nodebfn_tx_strobe
  .nodebfn_tx_nr(nodebfn_tx_nr),                            // input wire [11 : 0] nodebfn_tx_nr
  .nodebfn_rx_strobe(nodebfn_rx_strobe),                    // output wire nodebfn_rx_strobe
  .nodebfn_rx_nr(nodebfn_rx_nr),                            // output wire [11 : 0] nodebfn_rx_nr
  .eth_tx_clk(eth_tx_clk),                                  // input wire eth_tx_clk
  .eth_txd(eth_txd),                                        // input wire [7 : 0] eth_txd
  .eth_tx_er(eth_tx_er),                                    // input wire eth_tx_er
  .eth_tx_en(eth_tx_en),                                    // input wire eth_tx_en
  .eth_col(eth_col),                                        // output wire eth_col
  .eth_crs(eth_crs),                                        // output wire eth_crs
  .eth_rx_clk(eth_rx_clk),                                  // input wire eth_rx_clk
  .eth_rxd(eth_rxd),                                        // output wire [7 : 0] eth_rxd
  .eth_rx_er(eth_rx_er),                                    // output wire eth_rx_er
  .eth_rx_dv(eth_rx_dv),                                    // output wire eth_rx_dv
  .eth_rx_avail(eth_rx_avail),                              // output wire eth_rx_avail
  .eth_rx_ready(eth_rx_ready),                              // input wire eth_rx_ready
  .rx_fifo_almost_full(rx_fifo_almost_full),                // output wire rx_fifo_almost_full
  .rx_fifo_full(rx_fifo_full),                              // output wire rx_fifo_full
  .hdlc_rx_data(hdlc_rx_data),                              // output wire hdlc_rx_data
  .hdlc_tx_data(hdlc_tx_data),                              // input wire hdlc_tx_data
  .hdlc_rx_data_valid(hdlc_rx_data_valid),                  // output wire hdlc_rx_data_valid
  .hdlc_tx_enable(hdlc_tx_enable),                          // output wire hdlc_tx_enable
  .stat_alarm(stat_alarm),                                  // output wire stat_alarm
  .stat_code(stat_code),                                    // output wire [3 : 0] stat_code
  .txp(txp),                                                // output wire txp
  .txn(txn),                                                // output wire txn
  .rxp(rxp),                                                // input wire rxp
  .rxn(rxn),                                                // input wire rxn
  .lossoflight(lossoflight),                                // input wire lossoflight
  .txinhibit(txinhibit),                                    // output wire txinhibit
  .s_axi_aclk(s_axi_aclk),                                  // input wire s_axi_aclk
  .s_axi_aresetn(s_axi_aresetn),                            // input wire s_axi_aresetn
  .s_axi_awaddr(s_axi_awaddr),                              // input wire [11 : 0] s_axi_awaddr
  .s_axi_awvalid(s_axi_awvalid),                            // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),                            // output wire s_axi_awready
  .s_axi_wdata(s_axi_wdata),                                // input wire [31 : 0] s_axi_wdata
  .s_axi_wvalid(s_axi_wvalid),                              // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),                              // output wire s_axi_wready
  .s_axi_bresp(s_axi_bresp),                                // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),                              // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),                              // input wire s_axi_bready
  .s_axi_araddr(s_axi_araddr),                              // input wire [11 : 0] s_axi_araddr
  .s_axi_arvalid(s_axi_arvalid),                            // input wire s_axi_arvalid
  .s_axi_arready(s_axi_arready),                            // output wire s_axi_arready
  .s_axi_rdata(s_axi_rdata),                                // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(s_axi_rresp),                                // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(s_axi_rvalid),                              // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready),                              // input wire s_axi_rready
  .l1_timer_expired(l1_timer_expired),                      // input wire l1_timer_expired
  .vs_negotiation_complete(vs_negotiation_complete),        // input wire vs_negotiation_complete
  .reset_acknowledge_in(reset_acknowledge_in),              // input wire reset_acknowledge_in
  .sdi_request_in(sdi_request_in),                          // input wire sdi_request_in
  .reset_request_out(reset_request_out),                    // output wire reset_request_out
  .sdi_request_out(sdi_request_out),                        // output wire sdi_request_out
  .local_los(local_los),                                    // output wire local_los
  .local_lof(local_lof),                                    // output wire local_lof
  .local_rai(local_rai),                                    // output wire local_rai
  .remote_los(remote_los),                                  // output wire remote_los
  .remote_lof(remote_lof),                                  // output wire remote_lof
  .remote_rai(remote_rai),                                  // output wire remote_rai
  .fifo_transit_time(fifo_transit_time),                    // output wire [13 : 0] fifo_transit_time
  .coarse_timer_value(coarse_timer_value),                  // output wire [17 : 0] coarse_timer_value
  .barrel_shift_value(barrel_shift_value),                  // output wire [6 : 0] barrel_shift_value
  .tx_gb_latency_value(tx_gb_latency_value),                // output wire [15 : 0] tx_gb_latency_value
  .rx_gb_latency_value(rx_gb_latency_value),                // output wire [15 : 0] rx_gb_latency_value
  .stat_rx_delay_value(stat_rx_delay_value),                // output wire [6 : 0] stat_rx_delay_value
  .hyperframe_number(hyperframe_number),                    // output wire [7 : 0] hyperframe_number
  .txusrclk_out(txusrclk_out),                              // output wire txusrclk_out
  .stat_speed(stat_speed),                                  // output wire [14 : 0] stat_speed
  .qpll_select(qpll_select),                                // input wire qpll_select
  .recclk(recclk),                                          // output wire recclk
  .recclk_ok(recclk_ok),                                    // output wire recclk_ok
  .clk_out(clk_out),                                        // output wire clk_out
  .clk_ok_out(clk_ok_out),                                  // output wire clk_ok_out
  .hires_clk(hires_clk),                                    // input wire hires_clk
  .hires_clk_ok(hires_clk_ok),                              // input wire hires_clk_ok
  .gtwiz_reset_clk_freerun_in(gtwiz_reset_clk_freerun_in),  // input wire gtwiz_reset_clk_freerun_in
  .refclk(refclk),                                          // input wire refclk
  .qpll0clk_out(qpll0clk_out),                              // output wire qpll0clk_out
  .qpll0refclk_out(qpll0refclk_out),                        // output wire qpll0refclk_out
  .qpll0lock_out(qpll0lock_out),                            // output wire qpll0lock_out
  .qpll1clk_out(qpll1clk_out),                              // output wire qpll1clk_out
  .qpll1refclk_out(qpll1refclk_out),                        // output wire qpll1refclk_out
  .qpll1lock_out(qpll1lock_out),                            // output wire qpll1lock_out
  .rxrecclkout(rxrecclkout),                                // output wire rxrecclkout
  .txphinit_out(txphinit_out),                              // output wire [2 : 0] txphinit_out
  .phase_alignment_done_out(phase_alignment_done_out),      // output wire phase_alignment_done_out
  .txdlysreset_out(txdlysreset_out),                        // output wire [2 : 0] txdlysreset_out
  .txphalign_out(txphalign_out),                            // output wire [2 : 0] txphalign_out
  .txdlyen_out(txdlyen_out),                                // output wire [2 : 0] txdlyen_out
  .txphaligndone_in(txphaligndone_in),                      // input wire [2 : 0] txphaligndone_in
  .txdlysresetdone_in(txdlysresetdone_in),                  // input wire [2 : 0] txdlysresetdone_in
  .txphinitdone_in(txphinitdone_in),                        // input wire [2 : 0] txphinitdone_in
  .reset(reset)                                            // input wire reset
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file xCORE_CPRI_RUn77_RE.v when simulating
// the core, xCORE_CPRI_RUn77_RE. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

