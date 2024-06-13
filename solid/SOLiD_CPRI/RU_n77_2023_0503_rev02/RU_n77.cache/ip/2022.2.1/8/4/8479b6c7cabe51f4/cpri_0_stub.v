// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2.1 (win64) Build 3719031 Thu Dec  8 18:35:04 MST 2022
// Date        : Mon Jan  2 16:15:18 2023
// Host        : SUPERK2-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ cpri_0_stub.v
// Design      : cpri_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu11eg-ffvc1760-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cpri_v8_11_14,Vivado 2022.2.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(reset, iq_tx_enable, basic_frame_first_word, 
  iq_tx, iq_rx, qpll0clk_in, qpll0refclk_in, qpll1clk_in, qpll1refclk_in, qpll0lock_in, qpll0_pd, 
  qpll1lock_in, qpll1_pd, recclk_in, txusrclk, gtreset_sm_done, userclk_tx_reset, 
  userclk_rx_reset, rxoutclk, vendor_tx_data, vendor_tx_xs, vendor_tx_ns, vendor_rx_data, 
  vendor_rx_xs, vendor_rx_ns, vs_negotiation_complete, nodebfn_tx_strobe, nodebfn_tx_nr, 
  nodebfn_rx_strobe, nodebfn_rx_nr, eth_txd, eth_tx_er, eth_tx_en, eth_col, eth_crs, eth_rxd, 
  eth_rx_er, eth_rx_dv, eth_rx_avail, eth_rx_ready, rx_fifo_almost_full, rx_fifo_full, 
  eth_tx_clk, eth_rx_clk, hdlc_rx_data, hdlc_tx_data, hdlc_rx_data_valid, hdlc_tx_enable, 
  stat_alarm, stat_code, stat_speed, reset_request_in, sdi_request_in, reset_acknowledge_out, 
  sdi_request_out, local_los, local_lof, local_rai, remote_los, remote_lof, remote_rai, 
  fifo_transit_time, coarse_timer_value, barrel_shift_value, tx_gb_latency_value, 
  rx_gb_latency_value, stat_rx_delay_value, hyperframe_number, s_axi_aclk, s_axi_aresetn, 
  s_axi_awaddr, s_axi_awvalid, s_axi_awready, s_axi_wdata, s_axi_wvalid, s_axi_wready, 
  s_axi_bresp, s_axi_bvalid, s_axi_bready, s_axi_araddr, s_axi_arvalid, s_axi_arready, 
  s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready, l1_timer_expired, txp, txn, rxp, rxn, 
  lossoflight, txinhibit, refclk, aux_clk_out, gtwiz_reset_clk_freerun_in, hires_clk, 
  hires_clk_ok, qpll_select, core_is_master, recclk_ok, txoutclk, mmcm_rst, txresetdone_out, 
  clk_in, clk_ok_in, rxrecclkout, txdlyen_in, txphinit_in, phase_alignment_done_in, 
  txdlysreset_in, txphalign_in, txphaligndone_out, txdlysresetdone_out, txsyncdone_out, 
  txphinitdone_out)
/* synthesis syn_black_box black_box_pad_pin="reset,iq_tx_enable,basic_frame_first_word,iq_tx[63:0],iq_rx[63:0],qpll0clk_in,qpll0refclk_in,qpll1clk_in,qpll1refclk_in,qpll0lock_in,qpll0_pd,qpll1lock_in,qpll1_pd,recclk_in,txusrclk,gtreset_sm_done,userclk_tx_reset,userclk_rx_reset,rxoutclk,vendor_tx_data[127:0],vendor_tx_xs[1:0],vendor_tx_ns[5:0],vendor_rx_data[127:0],vendor_rx_xs[1:0],vendor_rx_ns[5:0],vs_negotiation_complete,nodebfn_tx_strobe,nodebfn_tx_nr[11:0],nodebfn_rx_strobe,nodebfn_rx_nr[11:0],eth_txd[7:0],eth_tx_er,eth_tx_en,eth_col,eth_crs,eth_rxd[7:0],eth_rx_er,eth_rx_dv,eth_rx_avail,eth_rx_ready,rx_fifo_almost_full,rx_fifo_full,eth_tx_clk,eth_rx_clk,hdlc_rx_data,hdlc_tx_data,hdlc_rx_data_valid,hdlc_tx_enable,stat_alarm,stat_code[3:0],stat_speed[14:0],reset_request_in,sdi_request_in,reset_acknowledge_out,sdi_request_out,local_los,local_lof,local_rai,remote_los,remote_lof,remote_rai,fifo_transit_time[13:0],coarse_timer_value[17:0],barrel_shift_value[6:0],tx_gb_latency_value[15:0],rx_gb_latency_value[15:0],stat_rx_delay_value[6:0],hyperframe_number[7:0],s_axi_aclk,s_axi_aresetn,s_axi_awaddr[11:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[31:0],s_axi_wvalid,s_axi_wready,s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_araddr[11:0],s_axi_arvalid,s_axi_arready,s_axi_rdata[31:0],s_axi_rresp[1:0],s_axi_rvalid,s_axi_rready,l1_timer_expired,txp,txn,rxp,rxn,lossoflight,txinhibit,refclk,aux_clk_out,gtwiz_reset_clk_freerun_in,hires_clk,hires_clk_ok,qpll_select,core_is_master,recclk_ok,txoutclk,mmcm_rst,txresetdone_out,clk_in,clk_ok_in,rxrecclkout,txdlyen_in,txphinit_in,phase_alignment_done_in,txdlysreset_in,txphalign_in,txphaligndone_out,txdlysresetdone_out,txsyncdone_out,txphinitdone_out" */;
  input reset;
  output iq_tx_enable;
  output basic_frame_first_word;
  input [63:0]iq_tx;
  output [63:0]iq_rx;
  input qpll0clk_in;
  input qpll0refclk_in;
  input qpll1clk_in;
  input qpll1refclk_in;
  input qpll0lock_in;
  output qpll0_pd;
  input qpll1lock_in;
  output qpll1_pd;
  input recclk_in;
  input txusrclk;
  output gtreset_sm_done;
  output userclk_tx_reset;
  output userclk_rx_reset;
  output rxoutclk;
  input [127:0]vendor_tx_data;
  output [1:0]vendor_tx_xs;
  output [5:0]vendor_tx_ns;
  output [127:0]vendor_rx_data;
  output [1:0]vendor_rx_xs;
  output [5:0]vendor_rx_ns;
  input vs_negotiation_complete;
  input nodebfn_tx_strobe;
  input [11:0]nodebfn_tx_nr;
  output nodebfn_rx_strobe;
  output [11:0]nodebfn_rx_nr;
  input [7:0]eth_txd;
  input eth_tx_er;
  input eth_tx_en;
  output eth_col;
  output eth_crs;
  output [7:0]eth_rxd;
  output eth_rx_er;
  output eth_rx_dv;
  output eth_rx_avail;
  input eth_rx_ready;
  output rx_fifo_almost_full;
  output rx_fifo_full;
  input eth_tx_clk;
  input eth_rx_clk;
  output hdlc_rx_data;
  input hdlc_tx_data;
  output hdlc_rx_data_valid;
  output hdlc_tx_enable;
  output stat_alarm;
  output [3:0]stat_code;
  output [14:0]stat_speed;
  input reset_request_in;
  input sdi_request_in;
  output reset_acknowledge_out;
  output sdi_request_out;
  output local_los;
  output local_lof;
  output local_rai;
  output remote_los;
  output remote_lof;
  output remote_rai;
  output [13:0]fifo_transit_time;
  output [17:0]coarse_timer_value;
  output [6:0]barrel_shift_value;
  output [15:0]tx_gb_latency_value;
  output [15:0]rx_gb_latency_value;
  output [6:0]stat_rx_delay_value;
  output [7:0]hyperframe_number;
  input s_axi_aclk;
  input s_axi_aresetn;
  input [11:0]s_axi_awaddr;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input s_axi_wvalid;
  output s_axi_wready;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [11:0]s_axi_araddr;
  input s_axi_arvalid;
  output s_axi_arready;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rvalid;
  input s_axi_rready;
  input l1_timer_expired;
  output txp;
  output txn;
  input rxp;
  input rxn;
  input lossoflight;
  output txinhibit;
  input refclk;
  output aux_clk_out;
  input gtwiz_reset_clk_freerun_in;
  input hires_clk;
  input hires_clk_ok;
  input qpll_select;
  input core_is_master;
  output recclk_ok;
  output txoutclk;
  output mmcm_rst;
  output txresetdone_out;
  input clk_in;
  input clk_ok_in;
  output rxrecclkout;
  input txdlyen_in;
  input txphinit_in;
  input phase_alignment_done_in;
  input txdlysreset_in;
  input txphalign_in;
  output txphaligndone_out;
  output txdlysresetdone_out;
  output txsyncdone_out;
  output txphinitdone_out;
endmodule
