
component sync_recover is		
	generic(
		N_CHANNEL											: integer := 2;
		N_TIME_SET											: integer := 1228800 -- fixed
	);
	port (
		i_rst_p												: in  std_logic;	  
		i_clk 	              							: in  std_logic; 
		i_clk_en												: in  std_logic;
		i_sync_ch	      								: in  std_logic_vector(N_CHANNEL-1 downto 0); -- sync in
		o_sync_alarm	    								: out std_logic_vector(N_CHANNEL-1 downto 0); -- '1' recovery sync valid 
		o_sync_rec											: out std_logic_vector(N_CHANNEL-1 downto 0)  -- 50% duty cycle gen
	);
end component;

component cpri_mapper_25G is		
	generic( 
		N_CTDR												: integer := 3;			-- fix
		TEST_MODE											: std_logic := '0'
	);			
	port (			
		i_sys_clk              							: in  std_logic:='0'; 	-- 368.64MHz
		i_rst_p												: in  std_logic:='0';	  
		i_tx_10msec_ref									: in  std_logic:='0';
    	i_loop_mode                      			: in  std_logic; 			-- far end loop 
    	i_iqdata_comp_loop               			: in  ARRAY_8x22bit;
		-- iq data			
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
					
		-- tx clock domain 			
      i_bfn_cnt                        			: in  std_logic_vector(15 downto 0); -- basic frame counter from demapper
		o_tx_ref_pointer									: out std_logic_vector(31 downto 0):=(others=>'0'); 
			
		i_link_up_ok										: in  std_logic:='0';
		i_iq_tx_enable										: in  std_logic:='0';		
		o_iq_data											: out std_logic_vector(63 downto 0):=(others=>'0');	
		-- to demapper			
		o_first_word_loop									: out std_logic:='0';	
		o_iq_data_loop										: out std_logic_vector(63 downto 0):=(others=>'0');	
					
		-- data mode			
		i_test_mode                      			: in  std_logic;	-- ramp function gen , connect '0'
		i_tx_clk               							: in  std_logic:='0' -- 24G:368.64MHz			
		
	);
end component;

component cpri_demapper_25G is		
	generic(
		N_CTDR												: integer := 3;
		TEST_MODE											: std_logic := '0'
			
	);			
	port (			
		i_rst_p												: in  std_logic:='0';	  
		i_rx_clk               							: in  std_logic:='0'; -- 25G:368.64MHz			
		i_link_up_ok										: in  std_logic:='0';		 
		i_loop_mode											: in  std_logic:='0';
		o_iqdata_comp_loop               			: out ARRAY_8x22bit;
					
		i_basic_frame_first_word						: in  std_logic:='0';		
		i_nodebfn_rx_strobe								: in  std_logic:='0';
		i_iq_data											: in  std_logic_vector(63 downto 0):=(others=>'0');	  	
		o_bfn_cnt                        			: out std_logic_vector(15 downto 0); -- basic frame number to mapper 
		i_iq_txenable_mapper								: in  std_logic:='0';
		i_iq_data_mapper									: in  std_logic_vector(63 downto 0):=(others=>'0');	  	
					
		-- sys clock domain 			
		i_sys_clk              							: in  std_logic:='0'; -- 368.64MHz
		i_rx_ref_pointer	 								: in  std_logic_vector(31 downto 0):=(others=>'0');
		-- iq data			
		o_rx_10m_ref					   				: out std_logic:='0'; 
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
end component;

component dl_data_copy is		
	port (
		i_rst_p												: in  std_logic:='0';	  
		i_clk_rx	              							: in  std_logic:='0'; -- 24G:368.64MHz			
		i_basic_frame_first_word						: in  std_logic:='0';
		i_iq_data											: in  std_logic_vector(63 downto 0):=(others=>'0');	  
		
		i_clk_tx	              							: in  std_logic:='0'; -- 24G:368.64MHz			
		i_iq_tx_enable      								: in  std_logic:='0';
		o_iq_data											: out std_logic_vector(63 downto 0):=(others=>'0')	  
	);
end component;

component ul_data_cobine is		
	port (
		i_rst_p												: in  std_logic:='0';	  
		i_clk_sys              							: in  std_logic:='0'; -- 24G:368.64MHz			
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

component solid_compression is
	generic (
		g_Exp													: integer		:= 4;			--	Exponent bit /i and q sample
		g_ManIQ												: integer		:= 18;		--	Mantissa +sign bit /i and q sample
		g_DataIn_EFF										: integer		:= 17;			
		g_DataIn												: integer		:= 17;		--	round{(2**g_Exp -1 +g_ManIQ)/2, 0}
		g_DataOut											: integer		:= 22			--	g_ManIQ +g_Exp
	);	
	port (				
		-- INPUT				
		i_data_sync											: in  std_logic												:= '0';
		i_data_i												: in	std_logic_vector(g_DataIn -1 downto  0)		:= (others => '0');
		i_data_q												: in	std_logic_vector(g_DataIn -1 downto  0)		:= (others => '0');
		--	OUTPUT				
		o_data_sync											: out	std_logic	:=	'0';
		o_data												: out	std_logic_vector(g_DataOut -1 downto  0)		:=	(others => '0');
		--				
		i_test_mode											: in	std_logic												:=	'0';	-- '1'
		i_round_en											: in	std_logic												:=	'0';	-- '1'
		-- CLOCK &RESET				
		i_clk_sys											: in	std_logic												:= '0';
		i_rst_p												: in	std_logic												:= '0'	
	);
end component ;


























