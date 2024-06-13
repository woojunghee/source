Library IEEE;
use 	ieee.std_logic_1164.all;
use 	ieee.std_logic_unsigned.all;
 
ENTITY delay_blk_dpram IS
PORT(			 
	rst_n			: In std_logic;
	clk_i			: In std_logic;
	clk_i_en        : In std_logic;
	clk_o			: In std_logic;
	clk_o_en		: In std_logic;
	din_i_m0		: In std_logic_vector(15 downto 0);
	din_q_m0		: in std_logic_vector(15 downto 0);
	din_i_m1		: in std_logic_vector(15 downto 0);
	din_q_m1		: in std_logic_vector(15 downto 0);
	sig_in			: In std_logic;
	dly_sel			: In std_logic_vector(14 downto 0); 
	dout_i_m0		: out std_logic_vector(15 downto 0);
	dout_q_m0		: out std_logic_vector(15 downto 0);
	dout_i_m1		: out std_logic_vector(15 downto 0);
	dout_q_m1		: out std_logic_vector(15 downto 0);
	sig_out			: out std_logic
	);					  												 
END delay_blk_dpram;

Architecture Behave OF delay_blk_dpram IS

COMPONENT dpram_32768by65
  PORT (
    clka : IN std_logic;
    ena : IN std_logic;
    wea : IN std_logic_vector(0 DOWNTO 0);
    addra : IN std_logic_vector(14 DOWNTO 0);
    dina : IN std_logic_vector(64 DOWNTO 0);
    clkb : IN std_logic;
    enb : IN std_logic;
    addrb : IN std_logic_vector(14 DOWNTO 0);
    doutb : OUT std_logic_vector(64 DOWNTO 0)
  );
END COMPONENT;

	Signal w_addr1		: std_logic_vector(14 downto 0);
	Signal r_addr		: std_logic_vector(14 downto 0);	
	Signal rd_data		: std_logic_vector(64 downto 0);
	
	Signal data_outi	: std_logic_vector(32 downto 0);
	signal high			: std_logic_vector(0 downto 0);
	
	signal add_value1	: std_logic_vector(14 downto 0);
	signal add_value11	: std_logic_vector(14 downto 0);
	signal dly_sel_1	: std_logic_vector(14 downto 0);
	signal dly_sel_2	: std_logic_vector(14 downto 0);
	signal wr_data		: std_logic_vector(64 downto 0);
 
Begin

high	 <= "1" ;
   
Process(clk_i)
Begin
	if rising_edge(clk_i) then
	  dly_sel_1 <= dly_sel;
	  dly_sel_2 <= dly_sel_1;
	end if;
end process;
	
Process(clk_i)
Begin
	if rising_edge(clk_i) then
		if clk_i_en = '1' then
			if    dly_sel_2 = x"00" then   	add_value11 <= "000000000000001";
			elsif dly_sel_2 > x"00" then	add_value11 <= dly_sel_2(14 downto 0);
			end if;
		end if;
	end if;
end process;

add_value1 <= add_value11(14 downto 0)+"000000000000001" ;
	
Process(clk_i)
Begin
	If rst_n='1' then
		w_addr1 <= (others=>'0');					 
	elsif rising_edge(clk_i) then
		if clk_i_en = '1' then								 		  			 
			w_addr1 <= r_addr + 1 + add_value1(14 downto 0) ;
		end if;			 		  
	End if;
End process ;				

Process(clk_o)
Begin
	If rst_n='1' then
		r_addr  <= (others=>'0');				 
	elsif rising_edge(clk_o) then
		if clk_o_en = '1' then								 		  
			r_addr	<= r_addr + 1 	;				 
		end if;			 		  
	End if;
End process ;	
	
-------------------------------------------------------------------------	
wr_data <= sig_in & din_q_m1 & din_i_m1 & din_q_m0 & din_i_m0;

inst_dpram : dpram_32768by65
PORT map(
      clka  	=> clk_i, --: IN std_logic;
      ena   	=> clk_i_en, --: IN std_logic;
      wea   	=> high, --: IN std_logic_vector(0 DOWNTO 0);
      addra 	=> w_addr1, --: IN std_logic_vector(9 DOWNTO 0);
      dina  	=> wr_data, --: IN std_logic_vector(23 DOWNTO 0);
      clkb  	=> clk_o, --: IN std_logic;
      enb 		=> clk_o_en, --: IN std_logic;
      addrb 	=> r_addr, --: IN std_logic_vector(9 DOWNTO 0);
      doutb 	=> rd_data --: OUT std_logic_vector(23 DOWNTO 0)
 );

Process(clk_o)
Begin
	if rising_edge(clk_o) then	
		if clk_o_en = '1' then
			dout_i_m0 <= rd_data(15 downto 0);
			dout_q_m0 <= rd_data(31 downto 16);
			dout_i_m1 <= rd_data(47 downto 32);
			dout_q_m1 <= rd_data(63 downto 48);
			sig_out <= rd_data(64);
		end if;
    end if;
end process;
	
END Behave;


