library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iq_slope is
	port(
        clk			: in  std_logic;
        rst_n		: in  std_logic;
		din_i		: in  std_logic_vector(15 downto 0);
        din_q		: in  std_logic_vector(15 downto 0);
        slope       : in  std_logic_vector(15 downto 0);
        curve       : in  std_logic_vector(15 downto 0);
        dout_i		: out std_logic_vector(15 downto 0);
        dout_q		: out std_logic_vector(15 downto 0)
		);
end iq_slope;

architecture Behavioral of iq_slope is

signal slope_s0                 : std_logic_vector(15 downto 0);
signal slope_s1                 : std_logic_vector(15 downto 0);
signal curve_s0                 : std_logic_vector(15 downto 0);
signal curve_s1                 : std_logic_vector(15 downto 0);

signal din_i_s0                 : std_logic_vector(15 downto 0);
signal din_q_s0                 : std_logic_vector(15 downto 0);
signal din_i_s1                 : std_logic_vector(15 downto 0);
signal din_q_s1                 : std_logic_vector(15 downto 0);
signal din_i_s2                 : std_logic_vector(15 downto 0);
signal din_q_s2                 : std_logic_vector(15 downto 0);
signal din_i_s3                 : std_logic_vector(15 downto 0);
signal din_q_s3                 : std_logic_vector(15 downto 0);
signal din_i_s4                 : std_logic_vector(15 downto 0);
signal din_q_s4                 : std_logic_vector(15 downto 0);

signal comp_in_a                : std_logic_vector(31 downto 0);
signal comp_in_b                : std_logic_vector(31 downto 0);
signal comp_out                 : std_logic_vector(79 downto 0);

signal comp_out_i               : std_logic_vector(15 downto 0);
signal comp_out_q               : std_logic_vector(15 downto 0);

attribute ASYNC_REG             : string;
attribute ASYNC_REG of slope_s0 : signal is "true";
attribute ASYNC_REG of slope_s1 : signal is "true";
attribute ASYNC_REG of curve_s0 : signal is "true";
attribute ASYNC_REG of curve_s1 : signal is "true";

begin


    process(clk)
    begin
    if rising_edge(clk) then
        slope_s0    <= slope;
        slope_s1    <= slope_s0;
        curve_s0    <= curve;
        curve_s1    <= curve_s0;
        din_i_s0	<= din_i;
        din_q_s0	<= din_q;
        din_i_s1	<= din_i_s0;
        din_q_s1	<= din_q_s0;
        din_i_s2	<= din_i_s1;
        din_q_s2	<= din_q_s1;
        din_i_s3	<= din_i_s2;
        din_q_s3	<= din_q_s2;
        din_i_s4	<= din_i_s3;
        din_q_s4	<= din_q_s3;
    end if;
    end process;

    comp_in_a   <= din_q & din_i;
    comp_in_b   <= slope_s1 & curve_s1;

    cmpy_blk : entity work.cmpy
      PORT map(
        aclk               		=> clk      			, --: IN STD_LOGIC;
        aresetn                 => rst_n                , --: IN STD_LOGIC;
        s_axis_a_tvalid    		=> '1'      			, --: IN STD_LOGIC;
        s_axis_a_tdata     		=> comp_in_a    	    , --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_b_tvalid    		=> '1'					, --: IN STD_LOGIC;
        s_axis_b_tdata     		=> comp_in_b        	, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_dout_tvalid 		=> open					, --: OUT STD_LOGIC;
        m_axis_dout_tdata  		=> comp_out				); --: OUT STD_LOGIC_VECTOR(79 DOWNTO 0)

    comp_out_i	<= comp_out(32) & comp_out(29 downto 15); -- + comp_out(14);
    comp_out_q	<= comp_out(72) & comp_out(69 downto 55); -- + comp_out(54);

    process(clk)
    begin
    if rising_edge(clk) then
        dout_i <= din_i_s4 + comp_out_i;
        dout_q <= din_q_s4 + comp_out_q;
    end if;
    end process;

end Behavioral;