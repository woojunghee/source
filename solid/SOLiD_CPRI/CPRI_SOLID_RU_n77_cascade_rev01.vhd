-- Title      : Example top level for CPRI design
-- Project    : cpri_v8_11_13
-----------------------------------------------------------------------
-- File       : CPRI_SOLID_rev01.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: This example design for CPRI adds data generators
--              and monitors to the IQ, vendor specific, HDLC and
--              Ethernet ports. An IBUFDS is added to the reference
--              clock input to allow the design to place and route.
--              A DCM/MMCM is instantiated to generate the Ethernet
--              and hires clocks if needed.
--              In addition the recovered clock output is output
--              at a constant frequency across all line rates.
--              A simple example of a mu-law encoder and decoder
--              are also provided.
-----------------------------------------------------------------------
-- (c) Copyright 2004 - 2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library 	work;
	use work.UQDAS_PKG.all;

entity CPRI_SOLID_RU_n77_cascade_rev01 is
	port (
		i_sys_clk           								: in  std_logic :='0';	 
		i_reset                      					: in  std_logic :='0';		 
		i_10msec_ref										: in  std_logic :='0';	 
		i_ul_10msec_ref									: in  std_logic :='0';
		-- ***********************************************************************************************
		-- main path cpri 
		-- ***********************************************************************************************
		o_stat_alarm                 					: out std_logic :='0';
		o_stat_code                  					: out std_logic_vector(3 downto 0):=(others=>'0');
		o_stat_speed                 					: out std_logic_vector(14 downto 0):=(others=>'0');		
		
		o_txp                        					: out std_logic :='0';
		o_txn                        					: out std_logic :='0';
		i_rxp                        					: in  std_logic :='0';
		i_rxn                        					: in  std_logic :='0';
		i_refclk_p                   					: in  std_logic :='0';
		i_refclk_n                   					: in  std_logic :='0';	 
		
		i_gtwiz_reset_clk_freerun_in 					: in  std_logic :='0';
		i_hires_clk                  					: in  std_logic :='0';
		i_hires_clk_ok               					: in  std_logic :='0';
		i_eth_ref_clk                					: in  std_logic :='0';
		i_ext_clk_ok                 					: in  std_logic :='0';
		o_recclk_out                 					: out std_logic :='0';
				
		-- tx vss	
		i_vss_enable										: in  std_logic :='0';
		i_vss_080											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_144											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_208											: in  std_logic_vector(127 downto 0):=(others=>'0');	 
		
		-- rx vss
		o_vss_080											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_144											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_208											: out std_logic_vector(127 downto 0):=(others=>'0');
		
		-- ethernet
      i_eth_txd                 			 			: in  std_logic_vector(7 downto 0);
      i_eth_tx_er               			 			: in  std_logic;
      i_eth_tx_en               			 			: in  std_logic;
      o_eth_col                 			 			: out std_logic;
      o_eth_crs                 			 			: out std_logic;
      o_eth_rxd                 			 			: out std_logic_vector(7 downto 0);
      o_eth_rx_er               			 			: out std_logic;
      o_eth_rx_dv               			 			: out std_logic;
      o_eth_rx_avail            			 			: out std_logic;
      i_eth_rx_ready            			 			: in  std_logic;
		
		-- axi-lite interface
		s_axi_aclk                					 	: in  std_logic :='0';
		s_axi_aresetn             					 	: in  std_logic :='0';
		s_axi_awaddr              					 	: in  std_logic_vector(11 downto 0):=(others=>'0');
		s_axi_awvalid             					 	: in  std_logic :='0';
		s_axi_awready             					 	: out std_logic :='0';
		s_axi_wdata               					 	: in  std_logic_vector(31 downto 0):=(others=>'0');
		s_axi_wvalid              					 	: in  std_logic :='0';
		s_axi_wready              					 	: out std_logic :='0';
		s_axi_bresp               					 	: out std_logic_vector(1 downto 0):=(others=>'0');
		s_axi_bvalid              					 	: out std_logic :='0';
		s_axi_bready              					 	: in  std_logic :='0';
		s_axi_araddr              					 	: in  std_logic_vector(11 downto 0):=(others=>'0');
		s_axi_arvalid             					 	: in  std_logic :='0';
		s_axi_arready             					 	: out std_logic :='0';
		s_axi_rdata               					 	: out std_logic_vector(31 downto 0):=(others=>'0');
		s_axi_rresp               					 	: out std_logic_vector(1 downto 0):=(others=>'0');
		s_axi_rvalid              					 	: out std_logic :='0';
		s_axi_rready              					 	: in  std_logic :='0';	  
		
		-- ***********************************************************************************************
		-- cascade path cpri 
		-- ***********************************************************************************************
		o_stat_alarm_1               					: out std_logic :='0';
		o_stat_code_1                 				: out std_logic_vector(3 downto 0):=(others=>'0');
		o_stat_speed_1                				: out std_logic_vector(14 downto 0):=(others=>'0');		 
		
		o_txp_1                      					: out std_logic :='0';
		o_txn_1                      					: out std_logic :='0';
		i_rxp_1                      					: in  std_logic :='0';
		i_rxn_1                      					: in  std_logic :='0';
		i_refclk_p_1                 					: in  std_logic :='0';
		i_refclk_n_1                 					: in  std_logic :='0';	 
		
		i_gtwiz_reset_clk_freerun_in_1				: in  std_logic :='0';
		i_hires_clk_1                					: in  std_logic :='0';
		i_hires_clk_ok_1            					: in  std_logic :='0';
		i_eth_ref_clk_1              					: in  std_logic :='0';
		i_ext_clk_ok_1               					: in  std_logic :='0';
		o_recclk_out_1               					: out std_logic :='0';
		
		-- rx vss
		i_vss_enable_1										: in  std_logic :='0';
		o_vss_080_1											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_144_1											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_208_1											: out std_logic_vector(127 downto 0):=(others=>'0');
		
      i_eth_txd_1          			 				: in  std_logic_vector(7 downto 0);
      i_eth_tx_er_1         			 				: in  std_logic;
      i_eth_tx_en_1          			 				: in  std_logic;
      o_eth_col_1          			 				: out std_logic;
      o_eth_crs_1          			 				: out std_logic;
      o_eth_rxd_1          			 				: out std_logic_vector(7 downto 0);
      o_eth_rx_er_1          			 				: out std_logic;
      o_eth_rx_dv_1          			 				: out std_logic;
      o_eth_rx_avail_1          			 			: out std_logic;
      i_eth_rx_ready_1          			 			: in  std_logic;
	
		s_axi_aresetn_1             				 	: in  std_logic :='0';
		s_axi_awaddr_1              				 	: in  std_logic_vector(11 downto 0):=(others=>'0');
		s_axi_awvalid_1             				 	: in  std_logic :='0';
		s_axi_awready_1             				 	: out std_logic :='0';
		s_axi_wdata_1             					 	: in  std_logic_vector(31 downto 0):=(others=>'0');
		s_axi_wvalid_1             				 	: in  std_logic :='0';
		s_axi_wready_1             				 	: out std_logic :='0';
		s_axi_bresp_1             					 	: out std_logic_vector(1 downto 0):=(others=>'0');
		s_axi_bvalid_1             				 	: out std_logic :='0';
		s_axi_bready_1             				 	: in  std_logic :='0';
		s_axi_araddr_1             				 	: in  std_logic_vector(11 downto 0):=(others=>'0');
		s_axi_arvalid_1             				 	: in  std_logic :='0';
		s_axi_arready_1             				 	: out std_logic :='0';
		s_axi_rdata_1             					 	: out std_logic_vector(31 downto 0):=(others=>'0');
		s_axi_rresp_1             					 	: out std_logic_vector(1 downto 0):=(others=>'0');
		s_axi_rvalid_1             				 	: out std_logic :='0';
		s_axi_rready_1             				 	: in  std_logic :='0';
			
		-- ***********************************************************************************************
		-- iq data interface
		-- ***********************************************************************************************	
		i_loop_mode											: in  std_logic:='0';
		-- tx iq data											 
		i_sync_g0											: in  std_logic :='0';	  
		i_data_g0_1T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_2T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_3T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_4T										: in  std_logic_vector(31 downto 0):=(others=>'0');
																
		i_sync_g1											: in  std_logic :='0';	  
		i_data_g1_1T										: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_2T										: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_3T										: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_4T										: in  std_logic_vector(31 downto 0):=(others=>'0');	  
		
		-- rx iq data		
		o_dl_ref_10m										: out std_logic:='0'; -- 10msec
		o_sync_ul_10m										: out std_logic:='0';
		o_sync_ul_66u										: out std_logic:='0';

		o_sync_g0											: out std_logic:='0';	  
		o_data_g0_1T										: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_g0_2T										: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_g0_3T										: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_g0_4T										: out std_logic_vector(31 downto 0):=(others=>'0');
																  
		o_sync_g1											: out std_logic:='0';	  
		o_data_g1_1T										: out std_logic_vector(31 downto 0):=(others=>'0');		
		o_data_g1_2T										: out std_logic_vector(31 downto 0):=(others=>'0');		
		o_data_g1_3T										: out std_logic_vector(31 downto 0):=(others=>'0');		
		o_data_g1_4T										: out std_logic_vector(31 downto 0):=(others=>'0')		

	);
end CPRI_SOLID_RU_n77_cascade_rev01;

library unisim;
use unisim.vcomponents.all;

Library xpm;
use xpm.vcomponents.all;

--library cpri_v8_11_13;
--use cpri_v8_11_13.all;

architecture K2Code of CPRI_SOLID_RU_n77_cascade_rev01 is

	signal refclk                						: std_logic :='0';
	signal recclk                						: std_logic :='0';
	signal hires_clk_i           						: std_logic :='0';
	signal hires_clk_ok_qual     						: std_logic :='0';
	signal clk_i                 						: std_logic :='0';	
	
	signal refclk_1              						: std_logic :='0';
	signal recclk_1              						: std_logic :='0';
	signal hires_clk_i_1         						: std_logic :='0';
	signal hires_clk_ok_qual_1   						: std_logic :='0';
	signal clk_i_1               						: std_logic :='0';	 
	
	signal aux_clk_i             						: std_logic :='0';
	signal gtwiz_reset_clk_freerun_in_i 			: std_logic :='0';
	signal eth_ref_clk_i         						: std_logic :='0';
	signal stat_speed_i          						: std_logic_vector(14 downto 0):=(others =>'0');
	signal stat_speed_i_clk      						: std_logic_vector(14 downto 0):=(others =>'0');
	signal stat_speed_i_rec      						: std_logic_vector(14 downto 0):=(others =>'0');
	signal count                 						: unsigned (4 downto 0) := "00000";
	signal clk_ok_i              						: std_logic :='0';
	signal recclkout_i           						: std_logic :='0' ;
	
	signal gtwiz_reset_clk_freerun_in_i_1 			: std_logic :='0';
	signal eth_ref_clk_i_1       						: std_logic :='0';
	signal stat_speed_i_1        						: std_logic_vector(14 downto 0):=(others =>'0');
	signal stat_speed_i_clk_1   						: std_logic_vector(14 downto 0):=(others =>'0');
	signal stat_speed_i_rec_1    						: std_logic_vector(14 downto 0):=(others =>'0');
	signal count_1               						: unsigned (4 downto 0) := "00000";
	signal clk_ok_i_1            						: std_logic :='0';
	signal recclkout_i_1         						: std_logic :='0' ;
	
	-- IQ Data generation and checking
	signal iq_tx_enable          						: std_logic :='0';
	signal iq_tx                 						: std_logic_vector(63 downto 0):=(others =>'0');
	signal iq_tx_i               						: std_logic_vector(63 downto 0):=(others =>'0');
	signal iq_tx_encoded         						: std_logic_vector(63 downto 0):=(others =>'0');
	signal basic_frame_first_word 					: std_logic :='0';
	signal rx_iq_data            						: std_logic_vector(63 downto 0):=(others =>'0');
	signal iq_rx_decoded         						: std_logic_vector(13 downto 0):=(others =>'0');
	signal nodebfn_tx_strobe     						: std_logic :='0';
	signal nodebfn_tx_nr         						: std_logic_vector(11 downto 0):=(others =>'0');
	signal hyperframe_nr         						: std_logic_vector(7 downto 0):=(others =>'0');
	signal nodebfn_rx_strobe     						: std_logic :='0';
	signal nodebfn_rx_nr         						: std_logic_vector(11 downto 0):=(others =>'0');
	signal nodebfn_rx_nr_store   						: std_logic:='0';
	signal iq_rx_chk_enable      						: std_logic :='0';
	signal frame_count           						: std_logic_vector(31 downto 0):=(others =>'0');
	signal error_count           						: std_logic_vector(31 downto 0):=(others =>'0');
	signal stat_code_i           						: std_logic_vector(3 downto 0):=(others =>'0');
	signal operate_state         						: std_logic :='0';
	signal operate_state_clk     						: std_logic_vector(4 downto 0):=(others =>'0');
	
	signal iq_tx_enable_1        						: std_logic :='0';
	signal iq_tx_1                 					: std_logic_vector(63 downto 0):=(others =>'0');
	signal iq_tx_i_1               					: std_logic_vector(63 downto 0):=(others =>'0');
	signal iq_tx_encoded_1         					: std_logic_vector(63 downto 0):=(others =>'0');
	signal basic_frame_first_word_1 					: std_logic :='0';
	signal rx_iq_data_1            					: std_logic_vector(63 downto 0):=(others =>'0');
	signal iq_rx_decoded_1         					: std_logic_vector(13 downto 0):=(others =>'0');
	signal nodebfn_tx_strobe_1     					: std_logic :='0';
	signal nodebfn_tx_nr_1         					: std_logic_vector(11 downto 0):=(others =>'0');
	signal hyperframe_nr_1         					: std_logic_vector(7 downto 0):=(others =>'0');
	signal nodebfn_rx_strobe_1     					: std_logic :='0';
	signal nodebfn_rx_nr_1         					: std_logic_vector(11 downto 0):=(others =>'0');
	signal nodebfn_rx_nr_store_1   					: std_logic:='0';
	signal iq_rx_chk_enable_1      					: std_logic :='0';
	signal frame_count_1           					: std_logic_vector(31 downto 0):=(others =>'0');
	signal error_count_1           					: std_logic_vector(31 downto 0):=(others =>'0');
	signal stat_code_i_1           					: std_logic_vector(3 downto 0):=(others =>'0');
	signal operate_state_1         					: std_logic :='0';
	signal operate_state_clk_1     					: std_logic_vector(4 downto 0):=(others =>'0');
	
	-- HDLC Data generation and checking
	signal hdlc_rx_data         						: std_logic :='0';
	signal hdlc_tx_data         						: std_logic :='0';
	signal hdlc_rx_data_valid   						: std_logic :='0';
	signal hdlc_tx_enable       						: std_logic :='0';
	signal hdlc_bit_count       						: std_logic_vector(31 downto 0):=(others =>'0');
	signal hdlc_error_count     						: std_logic_vector(31 downto 0):=(others =>'0');
	
	signal hdlc_rx_data_1        						: std_logic :='0';
	signal hdlc_tx_data_1        						: std_logic :='0';
	signal hdlc_rx_data_valid_1  						: std_logic :='0';
	signal hdlc_tx_enable_1      						: std_logic :='0';
	signal hdlc_bit_count_1      						: std_logic_vector(31 downto 0):=(others =>'0');
	signal hdlc_error_count_1    						: std_logic_vector(31 downto 0):=(others =>'0');
	
	-- Ethernet data generation and checking
	signal rx_fifo_almost_full   						: std_logic :='0';
	signal rx_fifo_full          						: std_logic :='0';
	
	signal rx_fifo_almost_full_1						: std_logic :='0';
	signal rx_fifo_full_1        						: std_logic :='0';
	
	-- Vendor specific data generation and checking
	signal vendor_tx_data        						: std_logic_vector(127 downto 0):=(others =>'0');
	signal vendor_tx_xs          						: std_logic_vector(1 downto 0):=(others =>'0');
	signal vendor_tx_ns          						: std_logic_vector(5 downto 0):=(others =>'0');
	signal vendor_rx_data        						: std_logic_vector(127 downto 0):=(others =>'0');
	signal vendor_rx_xs          						: std_logic_vector(1 downto 0):=(others =>'0');
	signal vendor_rx_ns          						: std_logic_vector(5 downto 0):=(others =>'0');
	signal vs_word_count         						: std_logic_vector(31 downto 0):=(others =>'0');
	signal vs_error_count        						: std_logic_vector(31 downto 0):=(others =>'0');
	
	signal vendor_tx_data_1      						: std_logic_vector(127 downto 0):=(others =>'0');
	signal vendor_tx_xs_1        						: std_logic_vector(1 downto 0):=(others =>'0');
	signal vendor_tx_ns_1        						: std_logic_vector(5 downto 0):=(others =>'0');
	signal vendor_rx_data_1       					: std_logic_vector(127 downto 0):=(others =>'0');
	signal vendor_rx_xs_1          					: std_logic_vector(1 downto 0):=(others =>'0');
	signal vendor_rx_ns_1          					: std_logic_vector(5 downto 0):=(others =>'0');
	signal vs_word_count_1         					: std_logic_vector(31 downto 0):=(others =>'0');
	signal vs_error_count_1        					: std_logic_vector(31 downto 0):=(others =>'0');
	
	                            						
	signal txphalign_vec         						: std_logic_vector(2 downto 0):=(others =>'0');
	signal txdlysreset_vec       						: std_logic_vector(2 downto 0):=(others =>'0');
	signal txphinit_vec          						: std_logic_vector(2 downto 0):=(others =>'0');
	                            						
	signal txphalign_vec_1       						: std_logic_vector(2 downto 0):=(others =>'0');
	signal txdlysreset_vec_1     						: std_logic_vector(2 downto 0):=(others =>'0');
	signal txphinit_vec_1        						: std_logic_vector(2 downto 0):=(others =>'0');
	                            							
	signal tx_iq_data										: std_logic_vector(63 downto 0) := (others =>'0');		
	signal rx_link_up_ok									: std_logic;			 
	signal tx_iq_data_1									: std_logic_vector(63 downto 0) := (others =>'0');		
	signal rx_link_up_ok_1								: std_logic;			 
	
	signal local_los 										: std_logic:= '1';
	signal local_lof 										: std_logic:= '1';
	signal local_rai 										: std_logic:= '1';      	
	signal speed_bit										: std_logic:='1';	
	
	signal local_los_1 									: std_logic:= '1';
	signal local_lof_1 									: std_logic:= '1';
	signal local_rai_1 									: std_logic:= '1';      
	signal speed_bit_1									: std_logic:='1';
	
begin

  process(aux_clk_i)
  begin
    if rising_edge(aux_clk_i) then
       hires_clk_ok_qual   <= i_hires_clk_ok and i_ext_clk_ok;
       hires_clk_ok_qual_1 <= i_hires_clk_ok_1;
    end if;
  end process;

-- ************************************************************************
-- main path cpri 
-- ************************************************************************
cpri_block_main:entity work.xCORE_CPRI_RUn77_RE
    port map (
      reset                   						=> i_reset,
      -- I/Q interface       						
      iq_tx_enable            						=> iq_tx_enable,
      basic_frame_first_word  						=> basic_frame_first_word,
      iq_tx                   						=> tx_iq_data,
      iq_rx                   						=> rx_iq_data,
      -- GT Common Ports     						
      qpll0clk_out            						=> open,
      qpll0refclk_out         						=> open,
      qpll1clk_out            						=> open,
      qpll1refclk_out         						=> open,
      qpll0lock_out           						=> open,
      qpll1lock_out           						=> open,
      -- Vendor interface
      vendor_tx_data          						=> vendor_tx_data,
      vendor_tx_xs            						=> vendor_tx_xs,
      vendor_tx_ns            						=> vendor_tx_ns,
      vendor_rx_data          						=> vendor_rx_data,
      vendor_rx_xs            						=> vendor_rx_xs,
      vendor_rx_ns            						=> vendor_rx_ns,
      vs_negotiation_complete 						=> '1',		
		reset_acknowledge_in								=> '0',
      -- Synchronization     						
      nodebfn_tx_strobe       						=> nodebfn_tx_strobe,
      nodebfn_tx_nr           						=> nodebfn_tx_nr,
      nodebfn_rx_strobe       						=> nodebfn_rx_strobe,
      nodebfn_rx_nr           						=> nodebfn_rx_nr,
      -- Ethernet interface  						
      eth_txd                 						=> i_eth_txd,							
      eth_tx_er               						=> i_eth_tx_er,						
      eth_tx_en               						=> i_eth_tx_en,						
      eth_col                 						=> o_eth_col,							
		eth_crs                 						=> o_eth_crs,							
      eth_rxd                 						=> o_eth_rxd,							
      eth_rx_er               						=> o_eth_rx_er,						
      eth_rx_dv               						=> o_eth_rx_dv,						
      eth_rx_avail            						=> o_eth_rx_avail,					
      eth_rx_ready            						=> i_eth_rx_ready,					
      rx_fifo_almost_full     						=> rx_fifo_almost_full,				 
      rx_fifo_full            						=> rx_fifo_full,						 
      eth_tx_clk              						=> eth_ref_clk_i,
      eth_rx_clk              						=> eth_ref_clk_i,
      -- HDLC interface
      hdlc_rx_data           							=> hdlc_rx_data,
      hdlc_tx_data           							=> hdlc_tx_data,
      hdlc_rx_data_valid     							=> hdlc_rx_data_valid,
      hdlc_tx_enable         							=> hdlc_tx_enable,
      -- Status interface    							
      stat_alarm             							=> o_stat_alarm,
      stat_code              							=> stat_code_i,
      stat_speed             							=> stat_speed_i,
      sdi_request_in         							=> '0',
     	reset_request_out 								=>	open,
     	sdi_request_out        							=> open,
      local_los              							=> local_los  ,
      local_lof              							=> local_lof  ,
      local_rai              							=> local_rai  ,
      remote_los             							=> open,
      remote_lof             							=> open,
      remote_rai             							=> open,
      fifo_transit_time      							=> open,
      coarse_timer_value     							=> open,
      barrel_shift_value     							=> open,
      tx_gb_latency_value    							=> open,
      rx_gb_latency_value    							=> open,
      hyperframe_number      							=> hyperframe_nr,
      -- AXI management interface
      s_axi_aclk              						=> aux_clk_i,
      s_axi_aresetn           						=> s_axi_aresetn,
      s_axi_awaddr            						=> s_axi_awaddr,
      s_axi_awvalid           						=> s_axi_awvalid,
      s_axi_awready           						=> s_axi_awready,
      s_axi_wdata             						=> s_axi_wdata,
      s_axi_wvalid            						=> s_axi_wvalid,
      s_axi_wready            						=> s_axi_wready,
      s_axi_bresp             						=> s_axi_bresp,
      s_axi_bvalid            						=> s_axi_bvalid,
      s_axi_bready            						=> s_axi_bready,
      s_axi_araddr            						=> s_axi_araddr,
      s_axi_arvalid           						=> s_axi_arvalid,
      s_axi_arready           						=> s_axi_arready,
      s_axi_rdata             						=> s_axi_rdata,
      s_axi_rresp             						=> s_axi_rresp,
      s_axi_rvalid            						=> s_axi_rvalid,
      s_axi_rready            						=> s_axi_rready,
      l1_timer_expired        						=> '0',
      -- SFP interface
      txp                     						=> o_txp,
      txn                     						=> o_txn,
      rxp                     						=> i_rxp,
      rxn                     						=> i_rxn,
      lossoflight             						=> '0',
      txinhibit               						=> open,
      -- Clocks               						
      refclk                  						=> refclk,
      gtwiz_reset_clk_freerun_in 					=> gtwiz_reset_clk_freerun_in_i,
      hires_clk               						=> hires_clk_i,
      hires_clk_ok            						=> hires_clk_ok_qual,
      qpll_select             						=> '0',
      recclk_ok               						=> open,
      recclk                  						=> o_recclk_out,
      clk_out                 						=> clk_i,
      clk_ok_out              						=> clk_ok_i,
      rxrecclkout             						=> open,
      -- Tx Phase alignment   						
      txphaligndone_in        						=> txphalign_vec,
      txdlysresetdone_in      						=> txdlysreset_vec,
      txphinitdone_in         						=> txphinit_vec,
      txphinit_out            						=> txphinit_vec,
      phase_alignment_done_out						=> open,
      txdlysreset_out         						=> txdlysreset_vec,
      txphalign_out           						=> txphalign_vec,
      txdlyen_out             						=> open
	);	
	
-- ************************************************************************
-- cascade path cpri 
-- ************************************************************************
cpri_block_cascade:entity work.xCORE_CPRI_RUn77_REC
    port map (
      reset                   						=> i_reset,
      -- I/Q interface       						
      iq_tx_enable            						=> iq_tx_enable_1,
      basic_frame_first_word  						=> basic_frame_first_word_1,
      iq_tx                   						=> tx_iq_data_1,
      iq_rx                   						=> rx_iq_data_1,
      -- GT Common Ports     						
      qpll0clk_out            						=> open,
      qpll0refclk_out         						=> open,
      qpll1clk_out            						=> open,
      qpll1refclk_out         						=> open,
      qpll0lock_out           						=> open,
      qpll1lock_out           						=> open,
      -- Vendor interface
      vendor_tx_data          						=> vendor_tx_data_1,
      vendor_tx_xs            						=> vendor_tx_xs_1,
      vendor_tx_ns            						=> vendor_tx_ns_1,
      vendor_rx_data          						=> vendor_rx_data_1,
      vendor_rx_xs            						=> vendor_rx_xs_1,
      vendor_rx_ns            						=> vendor_rx_ns_1,
      vs_negotiation_complete 						=> '1',
      -- Synchronization     						
      nodebfn_tx_strobe       						=> nodebfn_tx_strobe_1,
      nodebfn_tx_nr           						=> nodebfn_tx_nr_1,
      nodebfn_rx_strobe       						=> nodebfn_rx_strobe_1,
      nodebfn_rx_nr           						=> nodebfn_rx_nr_1,
      -- Ethernet interface  						
      eth_txd                 						=> i_eth_txd_1,							
      eth_tx_er               						=> i_eth_tx_er_1,						
      eth_tx_en               						=> i_eth_tx_en_1,						
      eth_col                 						=> o_eth_col_1,							
		eth_crs                 						=> o_eth_crs_1,							
      eth_rxd                 						=> o_eth_rxd_1,							
      eth_rx_er               						=> o_eth_rx_er_1,						
      eth_rx_dv               						=> o_eth_rx_dv_1,						
      eth_rx_avail            						=> o_eth_rx_avail_1,					
      eth_rx_ready            						=> i_eth_rx_ready_1,					
      rx_fifo_almost_full     						=> rx_fifo_almost_full_1,				 
      rx_fifo_full            						=> rx_fifo_full_1,						 
      eth_tx_clk              						=> eth_ref_clk_i,
      eth_rx_clk              						=> eth_ref_clk_i,
      -- HDLC interface
      hdlc_rx_data           							=> hdlc_rx_data_1,
      hdlc_tx_data           							=> hdlc_tx_data_1,
      hdlc_rx_data_valid     							=> hdlc_rx_data_valid_1,
      hdlc_tx_enable         							=> hdlc_tx_enable_1,
      -- Status interface    							
      stat_alarm             							=> o_stat_alarm_1,
      stat_code              							=> stat_code_i_1,
      stat_speed             							=> stat_speed_i_1,
      reset_request_in       							=> '0',
      sdi_request_in         							=> '0',
      reset_acknowledge_out  							=> open,
      sdi_request_out        							=> open,
      local_los              							=> local_los_1  ,
      local_lof              							=> local_lof_1  ,
      local_rai              							=> local_rai_1  ,
      remote_los             							=> open,
      remote_lof             							=> open,
      remote_rai             							=> open,
      fifo_transit_time      							=> open,
      coarse_timer_value     							=> open,
      barrel_shift_value     							=> open,
      tx_gb_latency_value    							=> open,
      rx_gb_latency_value    							=> open,
      stat_rx_delay_value    							=> open,
      hyperframe_number      							=> hyperframe_nr_1,
      -- AXI management interface
      s_axi_aclk              						=> aux_clk_i,
      s_axi_aresetn           						=> s_axi_aresetn_1,
      s_axi_awaddr            						=> s_axi_awaddr_1,
      s_axi_awvalid           						=> s_axi_awvalid_1,
      s_axi_awready           						=> s_axi_awready_1,
      s_axi_wdata             						=> s_axi_wdata_1,
      s_axi_wvalid            						=> s_axi_wvalid_1,
      s_axi_wready            						=> s_axi_wready_1,
      s_axi_bresp             						=> s_axi_bresp_1,
      s_axi_bvalid            						=> s_axi_bvalid_1,
      s_axi_bready            						=> s_axi_bready_1,
      s_axi_araddr            						=> s_axi_araddr_1,
      s_axi_arvalid           						=> s_axi_arvalid_1,
      s_axi_arready           						=> s_axi_arready_1,
      s_axi_rdata             						=> s_axi_rdata_1,
      s_axi_rresp             						=> s_axi_rresp_1,
      s_axi_rvalid            						=> s_axi_rvalid_1,
      s_axi_rready            						=> s_axi_rready_1,
      l1_timer_expired        						=> '0',
      -- SFP interface
      txp                     						=> o_txp_1,
      txn                     						=> o_txn_1,
      rxp                     						=> i_rxp_1,
      rxn                     						=> i_rxn_1,
      lossoflight             						=> '0',
      txinhibit               						=> open,
      -- Clocks               						
      core_is_master          						=> '1',
      refclk                  						=> refclk_1,
      gtwiz_reset_clk_freerun_in 					=> gtwiz_reset_clk_freerun_in_i_1,
      hires_clk               						=> hires_clk_i_1,
      hires_clk_ok            						=> hires_clk_ok_qual_1,
      qpll_select             						=> '0',
      recclk_ok               						=> open,
      recclk                  						=> o_recclk_out_1,
      clk_out                 						=> clk_i_1,
      clk_ok_out              						=> clk_ok_i_1,
      rxrecclkout             						=> open,
      txusrclk_out            						=> open,
      -- Tx Phase alignment   						
      txphaligndone_in        						=> txphalign_vec_1,
      txdlysresetdone_in      						=> txdlysreset_vec_1,
      txphinitdone_in         						=> txphinit_vec_1,
      txphinit_out            						=> txphinit_vec_1,
      phase_alignment_done_out						=> open,
      txdlysreset_out         						=> txdlysreset_vec_1,
      txphalign_out           						=> txphalign_vec_1,
      txdlyen_out             						=> open
	);	 
	rx_link_up_ok   <= not (local_los   or local_lof   or local_rai);	  	
	rx_link_up_ok_1 <= not (local_los_1 or local_lof_1 or local_rai_1);	  	
	speed_bit   <= '1' when stat_speed_i   = "000010000000000" or stat_speed_i   = "100000000000000" else '0'; 
	speed_bit_1 <= '1' when stat_speed_i_1 = "000010000000000" or stat_speed_i_1 = "100000000000000" else '0'; 
	
-- ************************************************************************
-- cpri mapper/demapper	cascade type
-- ************************************************************************

	CPRI_SOLID_mapper00:entity work.CPRI_SOLID_mapper_cascade_RU_n77_rev01 		
	generic map(
		N_CTDR												=> 3
	)                                				
	port map(                             			 
		i_sys_clk              								=> i_sys_clk,
		i_rst_p												=> i_reset,
		i_10msec_ref										=> i_10msec_ref,
		-- main cpri interface
		i_tx_clk               								=> clk_i,		
    	i_speed             								=> speed_bit,		 
		i_rx_link_up_ok										=> rx_link_up_ok,	 	
		i_loop_mode											=> i_loop_mode,
		
		i_nodebfn_rx_strobe       							=> nodebfn_rx_strobe, 
		i_nodebfn_rx_nr           							=> nodebfn_rx_nr,  
		i_hyperframe_rx_nr									=> hyperframe_nr,
    	o_nodebfn_tx_strobe 								=> nodebfn_tx_strobe, 
    	o_nodebfn_tx_nr     								=> nodebfn_tx_nr,     

		-- iq data											
		i_iq_tx_enable										=> iq_tx_enable,						
		o_tx_iq_data										=> tx_iq_data,						
		i_basic_frame_first_word							=> basic_frame_first_word,		
		i_rx_iq_data										=> rx_iq_data,						
		-- vss 												
		o_vendor_tx_data    								=> vendor_tx_data,  
		i_vendor_tx_xs      								=> vendor_tx_xs,    
		i_vendor_tx_ns      								=> vendor_tx_ns,               								
		i_vendor_rx_data    								=> vendor_rx_data,
		i_vendor_rx_xs      								=> vendor_rx_xs,    
		i_vendor_rx_ns      								=> vendor_rx_ns,    
																 
		-- mapper/demapper								
		i_ul_10msec_ref										=> i_ul_10msec_ref,		

		-- iq data                      				
		i_sync_g0											=> i_sync_g0,			
		i_data_g0_1T										=> i_data_g0_1T,		
		i_data_g0_2T										=> i_data_g0_2T,		
		i_data_g0_3T										=> i_data_g0_3T,		
		i_data_g0_4T										=> i_data_g0_4T,		
                                      				                  
		i_sync_g1											=> i_sync_g1,			
		i_data_g1_1T										=> i_data_g1_1T,		
		i_data_g1_2T										=> i_data_g1_2T,		
		i_data_g1_3T										=> i_data_g1_3T,		
		i_data_g1_4T										=> i_data_g1_4T,		
																 
		-- tx vss											
		i_vss_enable										=> i_vss_enable,
		i_vss_080											=> i_vss_080,	
		i_vss_144											=> i_vss_144,	
		i_vss_208											=> i_vss_208,				 
		-- rx iq data										
		o_dl_ref_10m										=> o_dl_ref_10m,	
		o_sync_ul_10m										=> o_sync_ul_10m,
		o_sync_ul_66u										=> o_sync_ul_66u,

		o_sync_g0											=> o_sync_g0,				
		o_data_g0_1T										=> o_data_g0_1T,			
		o_data_g0_2T										=> o_data_g0_2T,			
		o_data_g0_3T										=> o_data_g0_3T,			
		o_data_g0_4T										=> o_data_g0_4T,			
																						
		o_sync_g1											=> o_sync_g1,				
		o_data_g1_1T										=> o_data_g1_1T,			
		o_data_g1_2T										=> o_data_g1_2T,			
		o_data_g1_3T										=> o_data_g1_3T,			
		o_data_g1_4T										=> o_data_g1_4T,			
		-- rx vss											=> -- rx vss				
--		o_vss_016											=> o_vss_016,				
		o_vss_080											=> o_vss_080,				
		o_vss_144											=> o_vss_144,				
		o_vss_208											=> o_vss_208,						
		-- cascade cpri interface
		i_tx_clk_1             								=> clk_i_1,		       	
    	i_speed_1           								=> speed_bit_1,		    
		i_rx_link_up_ok_1									=> rx_link_up_ok_1,	    
																	                   
		i_nodebfn_rx_strobe_1     							=> nodebfn_rx_strobe_1, 
		i_nodebfn_rx_nr_1         							=> nodebfn_rx_nr_1,     
		i_hyperframe_rx_nr_1								=> hyperframe_nr_1,     
    	o_nodebfn_tx_strobe_1								=> nodebfn_tx_strobe_1, 
    	o_nodebfn_tx_nr_1   								=> nodebfn_tx_nr_1,     
		-- iq data											
		i_iq_tx_enable_1									=> iq_tx_enable_1,						
		o_tx_iq_data_1										=> tx_iq_data_1,						   
		i_basic_frame_first_word_1							=> basic_frame_first_word_1,		   
		i_rx_iq_data_1										=> rx_iq_data_1,						   
		-- vss 													                              
		o_vendor_tx_data_1  								=> vendor_tx_data_1,               
		i_vendor_tx_xs_1   									=> vendor_tx_xs_1,                 
		i_vendor_tx_ns_1    								=> vendor_tx_ns_1,               	           								
		i_vendor_rx_data_1  								=> vendor_rx_data_1,               
		i_vendor_rx_xs_1    								=> vendor_rx_xs_1,                 
		i_vendor_rx_ns_1    								=> vendor_rx_ns_1,                 
																
		i_vss_enable_1										=> i_vss_enable_1,	
		o_vss_080_1											=> o_vss_080_1,		
		o_vss_144_1											=> o_vss_144_1,		
		o_vss_208_1											=> o_vss_208_1		
	);
	

  -- Assign outputs
  o_stat_speed <= stat_speed_i;
  o_stat_code  <= stat_code_i;
	refclk_ibufds0:IBUFDS_GTE4
   port map (
   	I     												=> i_refclk_p,
      IB    												=> i_refclk_n,
      O     												=> refclk,
      CEB   												=> '0',
      ODIV2 												=> open)
	;

	hires_bufg0 : BUFG
   port map (
   	O 														=> hires_clk_i,
      I 														=> i_hires_clk
	);

  	aux_bufg0 : BUFG
  	port map (
		O 														=> aux_clk_i,
      I 														=> s_axi_aclk
	);

  	reset_block_clk_bufg0 : BUFG
   port map (
   	O 														=> gtwiz_reset_clk_freerun_in_i,
      I 														=> i_gtwiz_reset_clk_freerun_in
	);

  	eth_ref_clk_bufg0 : BUFG
   port map (
   	O 														=> eth_ref_clk_i,
      I 														=> i_eth_ref_clk
	);	  
		
	o_stat_speed_1 <= stat_speed_i_1;
	o_stat_code_1  <= stat_code_i_1;

  	refclk_ibufds1 : IBUFDS_GTE4
   port map (
      I     												=> i_refclk_p_1,
      IB    												=> i_refclk_n_1,
      O     												=> refclk_1,
      CEB   												=> '0',
      ODIV2 												=> open
	);

  	hires_bufg1 : BUFG
   port map (
      O 														=> hires_clk_i_1,
      I 														=> i_hires_clk_1
	);

  	rset_block_clk_bufg1 : BUFG
   port map (
      O 														=> gtwiz_reset_clk_freerun_in_i_1,
      I 														=> i_gtwiz_reset_clk_freerun_in_1
	);
		

end K2Code;
