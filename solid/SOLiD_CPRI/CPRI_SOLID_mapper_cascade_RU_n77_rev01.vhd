-----------------------------------------------------------------------
-- Title      : cpri_mapper
-- Project    : cpri_v8_11_13
-----------------------------------------------------------------------
-- File       : cpri_mapper.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: Generates IQ Data
-----------------------------------------------------------------------
-- (c) Copyright 2004 - 2020 Xilinx, Inc. All rights reserved.
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
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_misc.all;
	use ieee.math_real.all;
library unisim;
	use unisim.vcomponents.all;
library xpm;
	use xpm.vcomponents.all;
library 	work;
	use work.UQDAS_PKG.all;

entity CPRI_SOLID_mapper_cascade_RU_n77_rev01 is		
	generic(
		N_CTDR												: integer := 3
	);                                 			
	port (                             			
		i_sys_clk              							: in  std_logic:='0'; -- 368.64MHz
		i_rst_p												: in  std_logic:='0';	  									
		i_10msec_ref										: in  std_logic:='0';										
		i_loop_mode											: in  std_logic:='0';
		-- main cpri interface
		i_tx_clk               							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
    	i_speed             								: in  std_logic:='0';				 
		i_rx_link_up_ok									: in  std_logic:='0';			  
		
      i_nodebfn_rx_strobe       						: in  std_logic:='0';
      i_nodebfn_rx_nr           						: in  std_logic_vector(11 downto 0):=(others=>'0');
		i_hyperframe_rx_nr								: in  std_logic_vector(07 downto 0):=(others=>'0');
    	o_nodebfn_tx_strobe 								: out std_logic:='0';
    	o_nodebfn_tx_nr     								: out std_logic_vector(11 downto 0):=(others=>'0');
			
		-- iq data for main																					  
		i_iq_tx_enable										: in  std_logic:='0';	
		o_tx_iq_data										: out std_logic_vector(63 downto 0):=(others=>'0');
		i_basic_frame_first_word						: in  std_logic:='0';	                           
		i_rx_iq_data										: in  std_logic_vector(63 downto 0):=(others=>'0');
		-- vss 
		o_vendor_tx_data    								: out std_logic_vector(127 downto 0):=(others=>'0');
		i_vendor_tx_xs      								: in  std_logic_vector(1 downto 0):=(others=>'0');
		i_vendor_tx_ns      								: in  std_logic_vector(5 downto 0):=(others=>'0');	                    								
		i_vendor_rx_data    								: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vendor_rx_xs      								: in  std_logic_vector(1 downto 0):=(others=>'0');
		i_vendor_rx_ns      								: in  std_logic_vector(5 downto 0):=(others=>'0');
		
		-- mapper/demapper
		-- iq data                      			
		i_ul_10msec_ref									: in  std_logic:='0';
		i_sync_g0											: in  std_logic:='0';	  
		i_data_g0_1T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_2T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_3T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_4T										: in  std_logic_vector(31 downto 0):=(others=>'0');
                                      			
		i_sync_g1											: in  std_logic:='0';	  
		i_data_g1_1T										: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_2T										: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_3T										: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_4T										: in  std_logic_vector(31 downto 0):=(others=>'0');
		
		-- tx vss	
		i_vss_enable										: in  std_logic :='0';
--		i_vss_016											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_080											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_144											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_208											: in  std_logic_vector(127 downto 0):=(others=>'0');
		-- rx iq data		
		o_dl_ref_10m										: out std_logic:='0'; -- 10msec incase slave mode
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
		o_data_g1_4T										: out std_logic_vector(31 downto 0):=(others=>'0');	
		-- rx vss
--		o_vss_016											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_080											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_144											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_208											: out std_logic_vector(127 downto 0):=(others=>'0');

		-- cascade cpri interface
		i_tx_clk_1             							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
    	i_speed_1           								: in  std_logic:='0';				 
		i_rx_link_up_ok_1									: in  std_logic:='0';			  
		
      i_nodebfn_rx_strobe_1     						: in  std_logic:='0';
      i_nodebfn_rx_nr_1         						: in  std_logic_vector(11 downto 0):=(others=>'0');
		i_hyperframe_rx_nr_1								: in  std_logic_vector(07 downto 0):=(others=>'0');
    	o_nodebfn_tx_strobe_1							: out std_logic:='0';
    	o_nodebfn_tx_nr_1   								: out std_logic_vector(11 downto 0):=(others=>'0');
		-- iq data for cascade																					  
		i_iq_tx_enable_1									: in  std_logic:='0';	
		o_tx_iq_data_1										: out std_logic_vector(63 downto 0):=(others=>'0');
		i_basic_frame_first_word_1						: in  std_logic:='0';	                           
		i_rx_iq_data_1										: in  std_logic_vector(63 downto 0):=(others=>'0');
		-- vss 
		o_vendor_tx_data_1  								: out std_logic_vector(127 downto 0):=(others=>'0');
		i_vendor_tx_xs_1   								: in  std_logic_vector(1 downto 0):=(others=>'0');
		i_vendor_tx_ns_1    								: in  std_logic_vector(5 downto 0):=(others=>'0');	                    								
		i_vendor_rx_data_1  								: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vendor_rx_xs_1    								: in  std_logic_vector(1 downto 0):=(others=>'0');
		i_vendor_rx_ns_1    								: in  std_logic_vector(5 downto 0):=(others=>'0');

		i_vss_enable_1										: in  std_logic :='0';
		o_vss_080_1											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_144_1											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_208_1											: out std_logic_vector(127 downto 0):=(others=>'0')
	);
end entity;

architecture K2Code of CPRI_SOLID_mapper_cascade_RU_n77_rev01 is
  		
	constant willardcode_96								: std_logic_vector(95 downto 0):=x"4c70_f07c_0fc0_7f00_ff00_7fc0";	
	signal nodebfn_tx_strobe     						: std_logic :='0';
	signal nodebfn_tx_nr         						: std_logic_vector(11 downto 0):=(others =>'0');
	signal nodebfn_rx_strobe     						: std_logic :='0';
	signal nodebfn_rx_nr         						: std_logic_vector(11 downto 0):=(others =>'0');	
	signal hyperframe_nr									: std_logic_vector(07 downto 0):=(others =>'0');	 
	signal ul_ref_pointer								: std_logic_vector(31 downto 0):=(others =>'0');	
	signal vss_016_in										: std_logic_vector(127 downto 0):=(others =>'0');
	signal vss_016_in_1									: std_logic_vector(127 downto 0):=(others =>'0');
	signal vss_080_in										: std_logic_vector(127 downto 0):=(others =>'0');
	signal vss_016_out									: std_logic_vector(127 downto 0):=(others =>'0');	 
	signal vss_016_out_1									: std_logic_vector(127 downto 0):=(others =>'0');	 
	signal vss_080_out									: std_logic_vector(127 downto 0):=(others =>'0');	 
	signal vss_144_out									: std_logic_vector(127 downto 0):=(others =>'0');	 
	signal vss_208_out									: std_logic_vector(127 downto 0):=(others =>'0');	 
	signal dl_ref_10m										: std_logic:='0';																		
	signal sync_g0_ul										: std_logic:='0';	  
	signal data_g0_1T_ul									: std_logic_vector(31 downto 0):=(others=>'0');
	signal data_g0_2T_ul									: std_logic_vector(31 downto 0):=(others=>'0');
	signal data_g0_3T_ul									: std_logic_vector(31 downto 0):=(others=>'0');
	signal data_g0_4T_ul									: std_logic_vector(31 downto 0):=(others=>'0');	
	signal sync_g1_ul										: std_logic:='0';	  
	signal data_g1_1T_ul									: std_logic_vector(31 downto 0):=(others=>'0');		
	signal data_g1_2T_ul									: std_logic_vector(31 downto 0):=(others=>'0');		
	signal data_g1_3T_ul									: std_logic_vector(31 downto 0):=(others=>'0');		
	signal data_g1_4T_ul									: std_logic_vector(31 downto 0):=(others=>'0');
	signal sync_g0_cas									: std_logic:='0';	  
	signal data_g0_1T_cas								: std_logic_vector(31 downto 0):=(others=>'0');
	signal data_g0_2T_cas								: std_logic_vector(31 downto 0):=(others=>'0');
	signal data_g0_3T_cas								: std_logic_vector(31 downto 0):=(others=>'0');
	signal data_g0_4T_cas								: std_logic_vector(31 downto 0):=(others=>'0');	
	signal sync_g1_cas									: std_logic:='0';	  
	signal data_g1_1T_cas								: std_logic_vector(31 downto 0):=(others=>'0');		
	signal data_g1_2T_cas								: std_logic_vector(31 downto 0):=(others=>'0');		
	signal data_g1_3T_cas								: std_logic_vector(31 downto 0):=(others=>'0');		
	signal data_g1_4T_cas								: std_logic_vector(31 downto 0):=(others=>'0');	  
	signal sync_ul_10m									: std_logic:='0';
	signal sync_ul_66u									: std_logic:='0';			
	signal speed_bit										: std_logic:='0';		 
	signal ul_10msec_ref_combine						: std_logic:='0';		  
	signal sync_ul											: std_logic:='0';
	signal tx_iq_data										: std_logic_vector(63 downto 0):=(others =>'0');

	attribute	mark_debug 								: string;
	attribute	keep 										: string;
	attribute	mark_debug of hyperframe_nr		: signal is "true";
	attribute	mark_debug of ul_ref_pointer		: signal is "true";
	attribute	mark_debug of vss_016_in			: signal is "true";
	attribute	mark_debug of vss_016_in_1			: signal is "true";
	attribute	mark_debug of vss_016_out			: signal is "true";
	attribute	mark_debug of vss_016_out_1		: signal is "true";
	attribute	mark_debug of vss_080_out			: signal is "true";
	attribute	mark_debug of vss_144_out			: signal is "true";
	attribute	mark_debug of vss_208_out			: signal is "true";
	attribute	mark_debug of data_g0_1T_ul		: signal is "true";
	attribute	mark_debug of data_g0_2T_ul		: signal is "true";
	attribute	mark_debug of data_g0_3T_ul		: signal is "true";
	attribute	mark_debug of data_g0_4T_ul		: signal is "true";
	attribute	mark_debug of data_g1_1T_ul		: signal is "true";
	attribute	mark_debug of data_g1_2T_ul		: signal is "true";
	attribute	mark_debug of data_g1_3T_ul		: signal is "true";
	attribute	mark_debug of data_g1_4T_ul		: signal is "true";
	attribute	mark_debug of sync_g0_cas			: signal is "true";
	attribute	mark_debug of data_g0_1T_cas		: signal is "true";
	attribute	mark_debug of data_g0_2T_cas		: signal is "true";
	attribute	mark_debug of data_g0_3T_cas		: signal is "true";
	attribute	mark_debug of data_g0_4T_cas		: signal is "true";
	attribute	mark_debug of sync_g1_cas			: signal is "true";
	attribute	mark_debug of data_g1_1T_cas		: signal is "true";
	attribute	mark_debug of data_g1_2T_cas		: signal is "true";
	attribute	mark_debug of data_g1_3T_cas		: signal is "true";
	attribute	mark_debug of data_g1_4T_cas		: signal is "true";
	attribute	mark_debug of sync_ul_10m			: signal is "true";
	attribute	mark_debug of sync_ul_66u			: signal is "true";
	attribute	mark_debug of ul_10msec_ref_combine	: signal is "true";
	attribute	mark_debug of sync_ul				: signal is "true";
	attribute	mark_debug of tx_iq_data			: signal is "true";
	
	
--	b"0100_1100_0111_0000_1111_0000_0111_1100_0000_1111_1100_0000_0111_1111_0000_0000_1111_1111_0000_0000_0111_1111_1100_0000"
--	x"4c70_f07c_0fc0_7f00_ff00_7fc0";  
begin	
-- ************************************************************************
-- sync genertor
-- ************************************************************************
cpri_sync_gen00:entity work.cpri_sync_gen_25G 												 
	port map(
		i_tx_clk            								=> i_tx_clk,
		i_sys_clk              							=> i_sys_clk, -- 368.64MHz
		i_rst_p												=> i_rst_p,
		i_10msec_ref										=> i_10msec_ref,
    	i_speed             								=> i_speed,	  
		i_core_is_master             					=> '0',
		i_iq_tx_enable										=> i_iq_tx_enable,		

		i_nodebfn_rx_strobe       						=> i_nodebfn_rx_strobe,
		i_nodebfn_rx_nr           						=> i_nodebfn_rx_nr,
    	o_nodebfn_tx_strobe 								=> o_nodebfn_tx_strobe,  -- @tx clock 
    	o_nodebfn_tx_nr     								=> o_nodebfn_tx_nr,		  -- @tx clock 
    	o_hyperframe_nr   								=> hyperframe_nr  		  -- @tx clock 
	);
-- cascade
cpri_sync_gen01:entity work.cpri_sync_gen_25G 												 
	port map(
		i_tx_clk            								=> i_tx_clk_1,
		i_sys_clk              							=> i_sys_clk, -- 368.64MHz
		i_rst_p												=> i_rst_p,
		i_10msec_ref										=> i_nodebfn_rx_strobe,
    	i_speed             								=> i_speed_1,	  
		i_core_is_master             					=> '1',
		i_iq_tx_enable										=> i_iq_tx_enable_1,		

		i_nodebfn_rx_strobe       						=> i_nodebfn_rx_strobe,
		i_nodebfn_rx_nr           						=> i_nodebfn_rx_nr,
    	o_nodebfn_tx_strobe 								=> o_nodebfn_tx_strobe_1,  -- @tx clock 
    	o_nodebfn_tx_nr     								=> o_nodebfn_tx_nr_1,		  -- @tx clock 
    	o_hyperframe_nr   								=> open  		  -- @tx clock 
	);

-- ************************************************************************
-- iq mapper
-- ************************************************************************
cpri_mapper00:entity work.cpri_mapper_25G 		
	generic map(
		N_CTDR												=> 3
	)
	port map(
		i_sys_clk              								=> i_sys_clk, -- 368.64MHz
		i_rst_p												=> i_rst_p,	  
		i_10msec_ref										=> i_10msec_ref,
		i_ul_10msec_ref										=> ul_10msec_ref_combine,-- from combine
    	i_speed             								=> i_speed,--				 
--		i_sync_basic_frame_sys							=> sync_basic_frame_sys, -- from sync gen	 
		i_link_up_ok										=> i_rx_link_up_ok,		  
		o_ul_ref_pointer	 								=> ul_ref_pointer,
		-- iq data											 
		i_sync_g0											=> sync_ul,			-- from combine
		i_data_g0_1T										=> data_g0_1T_ul,
		i_data_g0_2T										=> data_g0_2T_ul,
		i_data_g0_3T										=> data_g0_3T_ul,
		i_data_g0_4T										=> data_g0_4T_ul,
																 					
		i_sync_g1											=> sync_ul,
		i_data_g1_1T										=> data_g1_1T_ul,		
		i_data_g1_2T										=> data_g1_2T_ul,		
		i_data_g1_3T										=> data_g1_3T_ul,		
		i_data_g1_4T										=> data_g1_4T_ul,
																
		-- tx clock domain 								 
    	i_hyperframe_nr   									=> hyperframe_nr,  		  -- @tx clock 
		i_vendor_tx_xs      								=> i_vendor_tx_xs, 
		i_vendor_tx_ns      								=> i_vendor_tx_ns,    

		i_iq_tx_enable										=> i_iq_tx_enable,		
		o_iq_data											=> tx_iq_data,
		i_tx_clk               								=> i_tx_clk -- 10G:153.6MJz or 25G:368.64MHz			
	);
	o_tx_iq_data <= tx_iq_data;
  
-- ************************************************************************
-- iq demapper-main path
-- ************************************************************************
cpri_demapper00:entity work.cpri_demapper_25G 		
	generic map(
		N_CTDR												=> 3
	)
	port map(
		i_rst_p												=> i_rst_p,
		i_rx_clk               								=> i_tx_clk,		
    	i_speed             								=> i_speed,	
		i_link_up_ok										=> i_rx_link_up_ok,
		-- mapper to demapper loop mode		
		i_loop_mode				           					=> i_loop_mode,
		i_iq_txenable_mapper								=> i_iq_tx_enable,	
		i_iq_data_mapper									=> tx_iq_data,		
		-- normal path
		i_nodebfn_rx_strobe       							=> i_nodebfn_rx_strobe,
		i_basic_frame_first_word							=> i_basic_frame_first_word,
		i_iq_data											=> i_rx_iq_data,
																
		i_vendor_rx_xs      								=> i_vendor_rx_xs,
		i_vendor_rx_ns      								=> i_vendor_rx_ns,
		i_hyperframe_rx_nr        							=> i_hyperframe_rx_nr,
		-- sys clock domain 								
		i_sys_clk              								=> i_sys_clk,
		i_ul_ref_pointer	 								=> x"0000_0000",
		-- iq data											 						 
		o_dl_ref_10m										=> o_dl_ref_10m,	
		o_sync_ul_10m										=> open,
		o_sync_ul_66u										=> open,
		o_sync_g0											=> o_sync_g0,		
		o_data_g0_1T										=> o_data_g0_1T,	
		o_data_g0_2T										=> o_data_g0_2T,	
		o_data_g0_3T										=> o_data_g0_3T,	
		o_data_g0_4T										=> o_data_g0_4T,	
																						
		o_sync_g1											=> o_sync_g1,		
		o_data_g1_1T										=> o_data_g1_1T,	
		o_data_g1_2T										=> o_data_g1_2T,	
		o_data_g1_3T										=> o_data_g1_3T,	
		o_data_g1_4T										=> o_data_g1_4T	
	);

-- ************************************************************************
-- iq demapper-cascade path
-- ************************************************************************
cpri_demapper01:entity work.cpri_demapper_25G 		
	generic map(
		N_CTDR												=> 3
	)
	port map(
		i_rst_p												=> i_rst_p,
		i_rx_clk               							=> i_tx_clk_1,		
    	i_speed             								=> i_speed_1,	
		i_link_up_ok										=> i_rx_link_up_ok_1,
		-- mapper to demapper loop mode		
		i_loop_mode				           				=> '0',
		i_iq_txenable_mapper								=> '0',	
		i_iq_data_mapper									=> (others=>'0'),		
		-- normal path
		i_nodebfn_rx_strobe       						=> i_nodebfn_rx_strobe_1,
		i_basic_frame_first_word						=> i_basic_frame_first_word_1,
		i_iq_data											=> i_rx_iq_data_1,
																
		i_vendor_rx_xs      								=> i_vendor_rx_xs_1,
		i_vendor_rx_ns      								=> i_vendor_rx_ns_1,
		i_hyperframe_rx_nr        						=> i_hyperframe_rx_nr_1,
		-- sys clock domain 								
		i_sys_clk              							=> i_sys_clk,
		i_ul_ref_pointer	 								=> vss_016_out_1(127 downto 96),--ul_ref_pointer,
		-- iq data											 						 
		o_dl_ref_10m										=> open,	
		o_sync_ul_10m										=> sync_ul_10m,	-- simulation monitor
		o_sync_ul_66u										=> sync_ul_66u,	-- to combine
		o_sync_g0											=> sync_g0_cas,		
		o_data_g0_1T										=> data_g0_1T_cas,-- to combine
		o_data_g0_2T										=> data_g0_2T_cas,	
		o_data_g0_3T										=> data_g0_3T_cas,	
		o_data_g0_4T										=> data_g0_4T_cas,	
																						
		o_sync_g1											=> sync_g1_cas,		
		o_data_g1_1T										=> data_g1_1T_cas,	
		o_data_g1_2T										=> data_g1_2T_cas,	
		o_data_g1_3T										=> data_g1_3T_cas,	
		o_data_g1_4T										=> data_g1_4T_cas	
	);	 

-- ************************************************************************
-- vss channel 
-- ************************************************************************
	vss_016_in <= ul_ref_pointer & willardcode_96;
cpri_vss_ch00:entity work.cpri_vss_ch_25G 		
	port map(
		i_rst_p												=> i_rst_p,
		i_vss_enable      								=> i_vss_enable,
		i_clk 	              							=> i_tx_clk,		
																 
		i_iq_tx_enable      								=> i_iq_tx_enable,   
		o_vendor_tx_data    								=> o_vendor_tx_data, 
		i_vendor_tx_xs      								=> i_vendor_tx_xs,   
		i_vendor_tx_ns      								=> i_vendor_tx_ns,   
		                    								
		i_basic_frame_first_word						=> i_basic_frame_first_word,	
		i_vendor_rx_data    								=> i_vendor_rx_data,    			
		i_vendor_rx_xs      								=> i_vendor_rx_xs,      			
		i_vendor_rx_ns      								=> i_vendor_rx_ns,      			
 		-- tx vss register 								
		i_vss_016											=> vss_016_in,				
		i_vss_080											=> i_vss_080,				
		i_vss_144											=> i_vss_144,				
		i_vss_208											=> i_vss_208,				
		-- rx vss register												
		o_vss_016											=> vss_016_out,				
		o_vss_080											=> vss_080_out,				
		o_vss_144											=> vss_144_out,				
		o_vss_208											=> vss_208_out			
	);		
	o_vss_080 <= vss_080_out;
	o_vss_144 <= vss_144_out;
	o_vss_208 <= vss_208_out;	 
	
	-- cascade 
	vss_016_in_1 <= ul_ref_pointer & willardcode_96;
cpri_vss_ch01:entity work.cpri_vss_ch_25G 		
	port map(
		i_rst_p												=> i_rst_p,
		i_vss_enable      								=> i_vss_enable_1,
		i_clk 	              							=> i_tx_clk_1,		
																 
		i_iq_tx_enable      								=> i_iq_tx_enable_1,   
		o_vendor_tx_data    								=> o_vendor_tx_data_1, 
		i_vendor_tx_xs      								=> i_vendor_tx_xs_1,   
		i_vendor_tx_ns      								=> i_vendor_tx_ns_1,   
		                    								
		i_basic_frame_first_word						=> i_basic_frame_first_word_1,	
		i_vendor_rx_data    								=> i_vendor_rx_data_1,    			
		i_vendor_rx_xs      								=> i_vendor_rx_xs_1,      			
		i_vendor_rx_ns      								=> i_vendor_rx_ns_1,      			
 		-- tx vss register 								
		i_vss_016											=> vss_016_in_1,				
		i_vss_080											=> vss_080_out,				
		i_vss_144											=> vss_144_out,				
		i_vss_208											=> vss_208_out,				
		-- rx vss register												
		o_vss_016											=> vss_016_out_1,				
		o_vss_080											=> o_vss_080_1,				
		o_vss_144											=> o_vss_144_1,				
		o_vss_208											=> o_vss_208_1			
	);

-- ************************************************************************
-- dl forward copy , main -> cacade 
-- ************************************************************************
dl_data_copy00:entity work.dl_data_copy 		
	port map(
		i_rst_p												=> i_rst_p, 
		i_speed	              							=> i_speed,		
		i_clk_rx	              							=> i_tx_clk,		
		i_basic_frame_first_word						=> i_basic_frame_first_word,
		i_iq_data											=> i_rx_iq_data,
															
		i_clk_tx	              							=> i_tx_clk_1,		
		i_iq_tx_enable      								=> i_iq_tx_enable_1,
		o_iq_data											=> o_tx_iq_data_1
	);		
			
-- ************************************************************************
-- combine main and cascade 
-- ************************************************************************
ul_data_cobine00:entity work.ul_data_cobine 		
	port map(
		i_rst_p												=> i_rst_p,
		i_clk_sys              							=> i_sys_clk,			
		i_sync_ref_main        							=> i_ul_10msec_ref,
		i_sync_main_g0										=> i_sync_g0,
		i_data_main_1T_g0									=> i_data_g0_1T,
		i_data_main_2T_g0									=> i_data_g0_2T,
		i_data_main_3T_g0									=> i_data_g0_3T,
		i_data_main_4T_g0									=> i_data_g0_4T,
																
		i_sync_main_g1									  	=> i_sync_g1,
		i_data_main_1T_g1									=> i_data_g1_1T,
		i_data_main_2T_g1									=> i_data_g1_2T,
		i_data_main_3T_g1									=> i_data_g1_3T,
		i_data_main_4T_g1									=> i_data_g1_4T,
																
		i_sync_ref_cas        							=> sync_ul_66u,
		i_sync_cas_g0										=> sync_g0_cas,
		i_data_cas_1T_g0 									=> data_g0_1T_cas,
		i_data_cas_2T_g0 									=> data_g0_2T_cas,
		i_data_cas_3T_g0 									=> data_g0_3T_cas,
		i_data_cas_4T_g0 									=> data_g0_4T_cas,
																
		i_sync_cas_g1									  	=> sync_g1_cas,
		i_data_cas_1T_g1 									=> data_g1_1T_cas,
		i_data_cas_2T_g1 									=> data_g1_2T_cas,
		i_data_cas_3T_g1 									=> data_g1_3T_cas,
		i_data_cas_4T_g1 									=> data_g1_4T_cas,
																
		o_sync_ref_combine								=> ul_10msec_ref_combine,
		o_sync_combine										=> sync_ul,		
		o_data_combine_1T_g0								=> data_g0_1T_ul, 
		o_data_combine_2T_g0								=> data_g0_2T_ul, 
		o_data_combine_3T_g0								=> data_g0_3T_ul, 
		o_data_combine_4T_g0								=> data_g0_4T_ul, 
																					   
		o_data_combine_1T_g1								=> data_g1_1T_ul,    
		o_data_combine_2T_g1								=> data_g1_2T_ul,	
		o_data_combine_3T_g1								=> data_g1_3T_ul,	
		o_data_combine_4T_g1								=> data_g1_4T_ul
	);																
						
end architecture K2Code;
