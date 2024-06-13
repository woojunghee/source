component cpri_sync_gen_25G is												 
	port (
		i_tx_clk               							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz
		i_sys_clk              							: in  std_logic:='0'; -- 368.64MHz
		i_rst_p												: in  std_logic:='0';	  
		i_10msec_ref										: in  std_logic:='0';
    	i_speed             								: in  std_logic:='0';		  
		 
		i_core_is_master             					: in  std_logic:='0';                
		i_iq_tx_enable										: in  std_logic:='0';
      i_nodebfn_rx_strobe       						: in  std_logic:='0';                              
      i_nodebfn_rx_nr           						: in  std_logic_vector(11 downto 0):=(others=>'0'); 
		 														                                                   
--		o_sync_basic_frame_sys							: out std_logic:='0'; -- to mapper
    	o_nodebfn_tx_strobe 								: out std_logic:='0';
    	o_nodebfn_tx_nr     								: out std_logic_vector(11 downto 0):=(others=>'0');
    	o_hyperframe_nr 	 								: out std_logic_vector(07 downto 0):=(others=>'0')	
	);
end component;

component cpri_mapper_25G is		
	port (
		i_sys_clk              				: in  std_logic:='0'; -- 368.64MHz
		i_rst_p									: in  std_logic:='0';	  
		i_10msec_ref							: in  std_logic:='0';
    	i_speed             					: in  std_logic:='0';				 
		i_ul_10msec_ref						: in  std_logic:='0';
		-- iq data
		i_sync_g0								: in  std_logic:='0';	  
		i_data_g0_1T							: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_2T							: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_3T							: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_g0_4T							: in  std_logic_vector(31 downto 0):=(others=>'0');

		i_sync_g1								: in  std_logic:='0';	  
		i_data_g1_1T							: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_2T							: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_3T							: in  std_logic_vector(31 downto 0):=(others=>'0');		
		i_data_g1_4T							: in  std_logic_vector(31 downto 0):=(others=>'0');
		
		-- tx clock domain 
		i_vendor_tx_xs      					: in  std_logic_vector(01 downto 0):=(others=>'0');
		i_vendor_tx_ns      					: in  std_logic_vector(05 downto 0):=(others=>'0');
    	i_hyperframe_nr 	 					: in  std_logic_vector(07 downto 0):=(others=>'0');	
		o_ul_ref_pointer						: out std_logic_vector(31 downto 0):=(others=>'0');
		o_dl_ref_pointer						: out std_logic_vector(31 downto 0):=(others=>'0');

		i_link_up_ok							: in  std_logic:='0';
		i_iq_tx_enable							: in  std_logic:='0';		
		o_iq_data								: out std_logic_vector(63 downto 0):=(others=>'0');	
		-- to demapper
		o_first_word_loop						: out std_logic:='0';	
		o_iq_data_loop							: out std_logic_vector(63 downto 0):=(others=>'0');	
		
		i_test_mode                      : in  std_logic;	
		i_tx_clk               				: in  std_logic:='0' -- 10G:153.6MJz or 25G:368.64MHz			
		
	);
end component;

component cpri_demapper_25G is		
	port (
		i_rst_p									: in  std_logic:='0';	  
		i_rx_clk               				: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
		i_link_up_ok							: in  std_logic:='0';		 
		i_loop_mode								: in  std_logic:='0';
 		o_iqdata_comp_loop               : out ARRAY_8x22bit;
   	i_speed             					: in  std_logic:='0'; 
		 
		i_basic_frame_first_word			: in  std_logic:='0';		
		i_nodebfn_rx_strobe					: in  std_logic:='0';
		i_iq_data								: in  std_logic_vector(63 downto 0):=(others=>'0');	  	
		
		i_iq_txenable_mapper					: in  std_logic:='0';
		i_iq_data_mapper						: in  std_logic_vector(63 downto 0):=(others=>'0');	  	
		
		i_vendor_rx_xs      					: in  std_logic_vector(01 downto 0):=(others=>'0');
		i_vendor_rx_ns      					: in  std_logic_vector(05 downto 0):=(others=>'0');
      i_hyperframe_rx_nr        			: in  std_logic_vector(07 downto 0):=(others=>'0');

		-- sys clock domain 
		i_sys_clk              				: in  std_logic:='0'; -- 368.64MHz
		i_ul_ref_pointer	 					: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_dl_ref_pointer	 					: in  std_logic_vector(31 downto 0):=(others=>'0');
		-- iq data
		o_dl_ref_10m							: out std_logic:='0'; -- in case only cpri slave mode 
		o_sync_ul_10m							: out std_logic:='0'; -- ul sync  
		o_sync_ul_66u							: out std_logic:='0'; -- ul hyper period  
		o_sync_g0								: out std_logic:='0';	  
		o_data_g0_1T							: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_g0_2T							: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_g0_3T							: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_g0_4T							: out std_logic_vector(31 downto 0):=(others=>'0');
													  
		o_sync_g1								: out std_logic:='0';	  
		o_data_g1_1T							: out std_logic_vector(31 downto 0):=(others=>'0');		
		o_data_g1_2T							: out std_logic_vector(31 downto 0):=(others=>'0');		
		o_data_g1_3T							: out std_logic_vector(31 downto 0):=(others=>'0');		
		o_data_g1_4T							: out std_logic_vector(31 downto 0):=(others=>'0')	
	);
end component;


component cpri_vss_ch_25G is		
	port (
		i_rst_p												: in  std_logic:='0';	  
		i_vss_enable      								: in  std_logic:='0';
		i_clk 	              							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
		
		i_iq_tx_enable      								: in  std_logic:='0';
		o_vendor_tx_data    								: out std_logic_vector(127 downto 0):=(others=>'0');
		i_vendor_tx_xs      								: in  std_logic_vector(1 downto 0):=(others=>'0');
		i_vendor_tx_ns      								: in  std_logic_vector(5 downto 0):=(others=>'0');
		                    								
		i_basic_frame_first_word						: in  std_logic:='0';
		i_vendor_rx_data    								: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vendor_rx_xs      								: in  std_logic_vector(1 downto 0):=(others=>'0');
		i_vendor_rx_ns      								: in  std_logic_vector(5 downto 0):=(others=>'0');
 		-- tx vss register 
		i_vss_016											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_080											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_144											: in  std_logic_vector(127 downto 0):=(others=>'0');
		i_vss_208											: in  std_logic_vector(127 downto 0):=(others=>'0');
		-- rx vss register
		o_vss_016											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_080											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_144											: out std_logic_vector(127 downto 0):=(others=>'0');
		o_vss_208											: out std_logic_vector(127 downto 0):=(others=>'0')	
	);
end component;


component dl_data_copy is		
	port (
		i_rst_p												: in  std_logic:='0';	  
		i_speed	              							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
		i_clk_rx	              							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
		i_basic_frame_first_word						: in  std_logic:='0';
		i_iq_data											: in  std_logic_vector(63 downto 0):=(others=>'0');	  
		
		i_clk_tx	              							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
		i_iq_tx_enable      								: in  std_logic:='0';
		o_iq_data											: out std_logic_vector(63 downto 0):=(others=>'0')	  
	);
end component;

component ul_data_cobine is		
	port (
		i_rst_p												: in  std_logic:='0';	  
		i_clk_sys              							: in  std_logic:='0'; -- 10G:153.6MJz or 25G:368.64MHz			
		i_sync_ref_main        							: in  std_logic:='0';  
		i_sync_main_g0										: in  std_logic:='0';
		i_data_main_1T_g0									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_main_2T_g0									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_main_3T_g0									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_main_4T_g0									: in  std_logic_vector(31 downto 0):=(others=>'0');	
		
		i_sync_main_g1									  	: in  std_logic:='0';
		i_data_main_1T_g1									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_main_2T_g1									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_main_3T_g1									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_main_4T_g1									: in  std_logic_vector(31 downto 0):=(others=>'0');
		
		i_sync_ref_cas        							: in  std_logic:='0';  
		i_sync_cas_g0										: in  std_logic:='0';
		i_data_cas_1T_g0 									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_cas_2T_g0 									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_cas_3T_g0 									: in  std_logic_vector(31 downto 0):=(others=>'0');
		i_data_cas_4T_g0 									: in  std_logic_vector(31 downto 0):=(others=>'0');	
		
		i_sync_cas_g1									  	: in  std_logic:='0';
		i_data_cas_1T_g1 									: in  std_logic_vector(31 downto 0):=(others=>'0');	
		i_data_cas_2T_g1 									: in  std_logic_vector(31 downto 0):=(others=>'0');	
		i_data_cas_3T_g1 									: in  std_logic_vector(31 downto 0):=(others=>'0');	
		i_data_cas_4T_g1 									: in  std_logic_vector(31 downto 0):=(others=>'0');	
		
		o_sync_ref_combine								: out std_logic:='0';
		o_sync_combine										: out std_logic:='0';
		o_data_combine_1T_g0								: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_combine_2T_g0								: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_combine_3T_g0								: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_combine_4T_g0								: out std_logic_vector(31 downto 0):=(others=>'0');  
	
		o_data_combine_1T_g1								: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_combine_2T_g1								: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_combine_3T_g1								: out std_logic_vector(31 downto 0):=(others=>'0');
		o_data_combine_4T_g1								: out std_logic_vector(31 downto 0):=(others=>'0')		
	);
end component;



















