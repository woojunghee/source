library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
Library UNISIM;
use UNISIM.vCOMPONENTs.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity dout_iq_sw is
port(
    clk_368p64  : in  std_logic;
    data_sync  : in  std_logic;
    clk_122p88  : in  std_logic;
    clk_100     : in  std_logic;
    axi_clk     : in  std_logic;
    rst         : in  std_logic;

    cpri_linkup : in  std_logic_vector(1 downto 0);

    dcm_din_i   : in  arr_4_16_stdlogic;
    dcm_din_q   : in  arr_4_16_stdlogic;
    kddi_din_i  : in  arr_4_16_stdlogic;
    kddi_din_q  : in  arr_4_16_stdlogic;
    rm_din_i    : in  arr_4_16_stdlogic;
    rm_din_q    : in  arr_4_16_stdlogic;
    sb_din_i    : in  arr_4_16_stdlogic;
    sb_din_q    : in  arr_4_16_stdlogic;

    op_id0       : in  arr_2_6_stdlogic;
    op_id1       : in  arr_2_6_stdlogic;

    dout_i0     : out arr_4_16_stdlogic;
    dout_q0     : out arr_4_16_stdlogic;
    dout_i1     : out arr_4_16_stdlogic;
    dout_q1     : out arr_4_16_stdlogic;
    dout_i2     : out arr_4_16_stdlogic;
    dout_q2     : out arr_4_16_stdlogic;
    dout_i3     : out arr_4_16_stdlogic;
    dout_q3     : out arr_4_16_stdlogic
);

end dout_iq_sw;

architecture beh of dout_iq_sw is

  signal rst_122p88  : std_logic;
  signal rst_368p64  : std_logic;
  signal vendor_info : arr_4_6_stdlogic;
  signal link_up     : std_logic_vector(1 downto 0);
signal dout_i0_s     : arr_4_16_stdlogic;
signal dout_q0_s     : arr_4_16_stdlogic;
signal dout_i1_s     : arr_4_16_stdlogic;
signal dout_q1_s     : arr_4_16_stdlogic;
signal dout_i2_s     : arr_4_16_stdlogic;
signal dout_q2_s     : arr_4_16_stdlogic;
signal dout_i3_s     : arr_4_16_stdlogic;
signal dout_q3_s     : arr_4_16_stdlogic;
signal fifo_wr_en    : std_logic;
signal fifo_in_0  : arr_4_32_stdlogic;
signal fifo_out_0  : arr_4_32_stdlogic;
signal fifo_in_1  : arr_4_32_stdlogic;
signal fifo_out_1  : arr_4_32_stdlogic;
signal fifo_in_2  : arr_4_32_stdlogic;
signal fifo_out_2  : arr_4_32_stdlogic;
signal fifo_in_3  : arr_4_32_stdlogic;
signal fifo_out_3  : arr_4_32_stdlogic;

begin

rst_blk_122p88: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => rst,
     dest_clk  => clk_122p88,
     dest_arst => rst_122p88
  );
rst_blk_368p64: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => rst,
     dest_clk  => clk_368p64,
     dest_arst => rst_368p64
  );

cpri_linkup_sync : xpm_cdc_array_single
generic map (
   DEST_SYNC_FF   => 4               ,
   INIT_SYNC_FF   => 0               ,
   SIM_ASSERT_CHK => 0               ,
   SRC_INPUT_REG  => 1               ,
   WIDTH          => 2               )
port map (
   dest_out       => link_up         ,
   dest_clk       => clk_122p88      ,
   src_clk        => axi_clk         ,
   src_in         => cpri_linkup     );

vendor_info_sync0 : xpm_cdc_array_single
generic map (
   DEST_SYNC_FF   => 4               ,
   INIT_SYNC_FF   => 0               ,
   SIM_ASSERT_CHK => 0               ,
   SRC_INPUT_REG  => 1               ,
   WIDTH          => 6               )
port map (
   dest_out       => vendor_info(0)  ,
   dest_clk       => clk_122p88      ,
   src_clk        => clk_100         ,
   src_in         => op_id0(0)       );

vendor_info_sync1 : xpm_cdc_array_single
generic map (
   DEST_SYNC_FF   => 4               ,
   INIT_SYNC_FF   => 0               ,
   SIM_ASSERT_CHK => 0               ,
   SRC_INPUT_REG  => 1               ,
   WIDTH          => 6               )
port map (
   dest_out       => vendor_info(1)  ,
   dest_clk       => clk_122p88      ,
   src_clk        => clk_100         ,
   src_in         => op_id1(0)       );

vendor_info_sync2 : xpm_cdc_array_single
generic map (
   DEST_SYNC_FF   => 4               ,
   INIT_SYNC_FF   => 0               ,
   SIM_ASSERT_CHK => 0               ,
   SRC_INPUT_REG  => 1               ,
   WIDTH          => 6               )
port map (
   dest_out       => vendor_info(2)  ,
   dest_clk       => clk_122p88      ,
   src_clk        => clk_100         ,
   src_in         => op_id0(1)       );


vendor_info_sync3 : xpm_cdc_array_single
generic map (
   DEST_SYNC_FF   => 4               ,
   INIT_SYNC_FF   => 0               ,
   SIM_ASSERT_CHK => 0               ,
   SRC_INPUT_REG  => 1               ,
   WIDTH          => 6               )
port map (
   dest_out       => vendor_info(3)  ,
   dest_clk       => clk_122p88      ,
   src_clk        => clk_100         ,
   src_in         => op_id1(1)       );


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        dout_i0_s  <= (others => ( others=>'0' ));
        dout_q0_s  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000001" and vendor_info(1) /= "000001" and vendor_info(2) /= "000001" and vendor_info(3) /= "000001") then
                dout_i0_s  <= dcm_din_i;
                dout_q0_s  <= dcm_din_q;
            elsif (vendor_info(0) = "000010" and vendor_info(1) /= "000010" and vendor_info(2) /= "000010" and vendor_info(3) /= "000010") then
                dout_i0_s  <= kddi_din_i;
                dout_q0_s  <= kddi_din_q;
            elsif (vendor_info(0) = "000100" and vendor_info(1) /= "000100" and vendor_info(2) /= "000100" and vendor_info(3) /= "000100") then
                dout_i0_s  <= rm_din_i;
                dout_q0_s  <= rm_din_q;
            elsif (vendor_info(0) = "001000" and vendor_info(1) /= "001000" and vendor_info(2) /= "001000" and vendor_info(3) /= "001000") then
                dout_i0_s  <= sb_din_i;
                dout_q0_s  <= sb_din_q;
            else
                dout_i0_s  <= (others => ( others=>'0' ));
                dout_q0_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000001" and vendor_info(1) /= "000001") then
                dout_i0_s  <= dcm_din_i;
                dout_q0_s  <= dcm_din_q;
            elsif (vendor_info(0) = "000010" and vendor_info(1) /= "000010") then
                dout_i0_s  <= kddi_din_i;
                dout_q0_s  <= kddi_din_q;
            elsif (vendor_info(0) = "000100" and vendor_info(1) /= "000100") then
                dout_i0_s  <= rm_din_i;
                dout_q0_s  <= rm_din_q;
            elsif (vendor_info(0) = "001000" and vendor_info(1) /= "001000") then
                dout_i0_s  <= sb_din_i;
                dout_q0_s  <= sb_din_q;
            else
                dout_i0_s  <= (others => ( others=>'0' ));
                dout_q0_s  <= (others => ( others=>'0' ));
            end if;
        else
            dout_i0_s  <= (others => ( others=>'0' ));
            dout_q0_s  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        dout_i1_s  <= (others => ( others=>'0' ));
        dout_q1_s  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) /= "000001" and vendor_info(1) = "000001" and vendor_info(2) /= "000001" and vendor_info(3) /= "000001") then
                dout_i1_s  <= dcm_din_i;
                dout_q1_s  <= dcm_din_q;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) = "000010" and vendor_info(2) /= "000010" and vendor_info(3) /= "000010") then
                dout_i1_s  <= kddi_din_i;
                dout_q1_s  <= kddi_din_q;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) = "000100" and vendor_info(2) /= "000100" and vendor_info(3) /= "000100") then
                dout_i1_s  <= rm_din_i;
                dout_q1_s  <= rm_din_q;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) = "001000" and vendor_info(2) /= "001000" and vendor_info(3) /= "001000") then
                dout_i1_s  <= sb_din_i;
                dout_q1_s  <= sb_din_q;
            else
                dout_i1_s  <= (others => ( others=>'0' ));
                dout_q1_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) /= "000001" and vendor_info(1) = "000001") then
                dout_i1_s  <= dcm_din_i;
                dout_q1_s  <= dcm_din_q;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) = "000010") then
                dout_i1_s  <= kddi_din_i;
                dout_q1_s  <= kddi_din_q;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) = "000100") then
                dout_i1_s  <= rm_din_i;
                dout_q1_s  <= rm_din_q;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) = "001000") then
                dout_i1_s  <= sb_din_i;
                dout_q1_s  <= sb_din_q;
            else
                dout_i1_s  <= (others => ( others=>'0' ));
                dout_q1_s  <= (others => ( others=>'0' ));
            end if;
        else
            dout_i1_s  <= (others => ( others=>'0' ));
            dout_q1_s  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        dout_i2_s  <= (others => ( others=>'0' ));
        dout_q2_s  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) /= "000001" and vendor_info(1) /= "000001" and vendor_info(2) = "000001" and vendor_info(3) /= "000001") then
                dout_i2_s  <= dcm_din_i;
                dout_q2_s  <= dcm_din_q;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) /= "000010" and vendor_info(2) = "000010" and vendor_info(3) /= "000010") then
                dout_i2_s  <= kddi_din_i;
                dout_q2_s  <= kddi_din_q;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) /= "000100" and vendor_info(2) = "000100" and vendor_info(3) /= "000100") then
                dout_i2_s  <= rm_din_i;
                dout_q2_s  <= rm_din_q;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) /= "001000" and vendor_info(2) = "001000" and vendor_info(3) /= "001000") then
                dout_i2_s  <= sb_din_i;
                dout_q2_s  <= sb_din_q;
            else
                dout_i2_s  <= (others => ( others=>'0' ));
                dout_q2_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000001" and vendor_info(3) /= "000001") then
                dout_i2_s  <= dcm_din_i;
                dout_q2_s  <= dcm_din_q;
            elsif (vendor_info(2) = "000010" and vendor_info(3) /= "000010") then
                dout_i2_s  <= kddi_din_i;
                dout_q2_s  <= kddi_din_q;
            elsif (vendor_info(2) = "000100" and vendor_info(3) /= "000100") then
                dout_i2_s  <= rm_din_i;
                dout_q2_s  <= rm_din_q;
            elsif (vendor_info(2) = "001000" and vendor_info(3) /= "001000") then
                dout_i2_s  <= sb_din_i;
                dout_q2_s  <= sb_din_q;
            else
                dout_i2_s  <= (others => ( others=>'0' ));
                dout_q2_s  <= (others => ( others=>'0' ));
            end if;
        else
            dout_i2_s  <= (others => ( others=>'0' ));
            dout_q2_s  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        dout_i3_s  <= (others => ( others=>'0' ));
        dout_q3_s  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) /= "000001" and vendor_info(1) /= "000001" and vendor_info(2) /= "000001" and vendor_info(3) = "000001") then
                dout_i3_s  <= dcm_din_i;
                dout_q3_s  <= dcm_din_q;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) /= "000010" and vendor_info(2) /= "000010" and vendor_info(3) = "000010") then
                dout_i3_s  <= kddi_din_i;
                dout_q3_s  <= kddi_din_q;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) /= "000100" and vendor_info(2) /= "000100" and vendor_info(3) = "000100") then
                dout_i3_s  <= rm_din_i;
                dout_q3_s  <= rm_din_q;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) /= "001000" and vendor_info(2) /= "001000" and vendor_info(3) = "001000") then
                dout_i3_s  <= sb_din_i;
                dout_q3_s  <= sb_din_q;
            else
                dout_i3_s  <= (others => ( others=>'0' ));
                dout_q3_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) /= "000001" and vendor_info(3) = "000001") then
                dout_i3_s  <= dcm_din_i;
                dout_q3_s  <= dcm_din_q;
            elsif (vendor_info(2) /= "000010" and vendor_info(3) = "000010") then
                dout_i3_s  <= kddi_din_i;
                dout_q3_s  <= kddi_din_q;
            elsif (vendor_info(2) /= "000100" and vendor_info(3) = "000100") then
                dout_i3_s  <= rm_din_i;
                dout_q3_s  <= rm_din_q;
            elsif (vendor_info(2) /= "001000" and vendor_info(3) = "001000") then
                dout_i3_s  <= sb_din_i;
                dout_q3_s  <= sb_din_q;
            else
                dout_i3_s  <= (others => ( others=>'0' ));
                dout_q3_s  <= (others => ( others=>'0' ));
            end if;
        else
            dout_i3_s  <= (others => ( others=>'0' ));
            dout_q3_s  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;

------------------------------------------------------
process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        fifo_wr_en  <= '0';
    else
        fifo_wr_en  <= '1';
    end if;
end if;
end process;

dout_0_cdc : for n in 0 to 3 generate
fifo_in_0(n) <= dout_q0_s(n) & dout_i0_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    wr_clk 					=> clk_122p88				, --: IN STD_LOGIC;
	rd_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    rd_clk 					=> clk_368p64				, --: IN STD_LOGIC;
    din    					=> fifo_in_0(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> fifo_wr_en			, --: IN STD_LOGIC;
    rd_en  					=> data_sync				, --: IN STD_LOGIC;
    dout   					=> fifo_out_0(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

dout_q0(n) <= fifo_out_0(n)(31 downto 16);
dout_i0(n) <= fifo_out_0(n)(15 downto  0);
end generate;

dout_1_cdc : for n in 0 to 3 generate
fifo_in_1(n) <= dout_q1_s(n) & dout_i1_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    wr_clk 					=> clk_122p88				, --: IN STD_LOGIC;
	rd_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    rd_clk 					=> clk_368p64				, --: IN STD_LOGIC;
    din    					=> fifo_in_1(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> fifo_wr_en			, --: IN STD_LOGIC;
    rd_en  					=> data_sync				, --: IN STD_LOGIC;
    dout   					=> fifo_out_1(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

dout_q1(n) <= fifo_out_1(n)(31 downto 16);
dout_i1(n) <= fifo_out_1(n)(15 downto  0);
end generate;

dout_2_cdc : for n in 0 to 3 generate
fifo_in_2(n) <= dout_q2_s(n) & dout_i2_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    wr_clk 					=> clk_122p88				, --: IN STD_LOGIC;
	rd_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    rd_clk 					=> clk_368p64				, --: IN STD_LOGIC;
    din    					=> fifo_in_2(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> fifo_wr_en			, --: IN STD_LOGIC;
    rd_en  					=> data_sync				, --: IN STD_LOGIC;
    dout   					=> fifo_out_2(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

dout_q2(n) <= fifo_out_2(n)(31 downto 16);
dout_i2(n) <= fifo_out_2(n)(15 downto  0);
end generate;

dout_3_cdc : for n in 0 to 3 generate
fifo_in_3(n) <= dout_q3_s(n) & dout_i3_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    wr_clk 					=> clk_122p88				, --: IN STD_LOGIC;
	rd_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    rd_clk 					=> clk_368p64				, --: IN STD_LOGIC;
    din    					=> fifo_in_3(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> fifo_wr_en			, --: IN STD_LOGIC;
    rd_en  					=> data_sync				, --: IN STD_LOGIC;
    dout   					=> fifo_out_3(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

dout_q3(n) <= fifo_out_3(n)(31 downto 16);
dout_i3(n) <= fifo_out_3(n)(15 downto  0);
end generate;

end beh;




