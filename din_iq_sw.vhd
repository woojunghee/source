library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
Library UNISIM;
use UNISIM.vCOMPONENTs.all;
Library xpm;
use xpm.vcomponents.all;
use work.my_package.all;

entity din_iq_sw is
port(
    clk_368p64  : in  std_logic;
    data_sync  : in  std_logic;
    clk_122p88  : in  std_logic;
    clk_100     : in  std_logic;
    axi_clk     : in  std_logic;
    rst         : in  std_logic;

    cpri_linkup : in  std_logic_vector(1 downto 0);

    din_i0      : in  arr_4_16_stdlogic;
    din_q0      : in  arr_4_16_stdlogic;
    din_i1      : in  arr_4_16_stdlogic;
    din_q1      : in  arr_4_16_stdlogic;
    din_i2      : in  arr_4_16_stdlogic;
    din_q2      : in  arr_4_16_stdlogic;
    din_i3      : in  arr_4_16_stdlogic;
    din_q3      : in  arr_4_16_stdlogic;

    op_id0       : in  arr_2_6_stdlogic;
    op_id1       : in  arr_2_6_stdlogic;

    dcm_dout_i  : out arr_4_16_stdlogic;
    dcm_dout_q  : out arr_4_16_stdlogic;
    kddi_dout_i : out arr_4_16_stdlogic;
    kddi_dout_q : out arr_4_16_stdlogic;
    rm_dout_i   : out arr_4_16_stdlogic;
    rm_dout_q   : out arr_4_16_stdlogic;
    sb_dout_i   : out arr_4_16_stdlogic;
    sb_dout_q   : out arr_4_16_stdlogic
);

end din_iq_sw;

architecture beh of din_iq_sw is

  signal rst_122p88  : std_logic;
  signal rst_368p64  : std_logic;
  signal vendor_info : arr_4_6_stdlogic;
  signal link_up     : std_logic_vector(1 downto 0);
signal dcm_dout_i_s  : arr_4_16_stdlogic;
signal dcm_dout_q_s  : arr_4_16_stdlogic;
signal kddi_dout_i_s : arr_4_16_stdlogic;
signal kddi_dout_q_s : arr_4_16_stdlogic;
signal rm_dout_i_s   : arr_4_16_stdlogic;
signal rm_dout_q_s   : arr_4_16_stdlogic;
signal sb_dout_i_s   : arr_4_16_stdlogic;
signal sb_dout_q_s   : arr_4_16_stdlogic;
signal fifo_in_dcm  : arr_4_32_stdlogic;
signal fifo_out_dcm  : arr_4_32_stdlogic;
signal fifo_in_kddi  : arr_4_32_stdlogic;
signal fifo_out_kddi  : arr_4_32_stdlogic;
signal fifo_in_rm  : arr_4_32_stdlogic;
signal fifo_out_rm  : arr_4_32_stdlogic;
signal fifo_in_sb  : arr_4_32_stdlogic;
signal fifo_out_sb  : arr_4_32_stdlogic;
signal fifo_rd_en   : std_logic;

begin

rst_blk_368p64: xpm_cdc_async_rst
  generic map (
     DEST_SYNC_FF    => 2, -- integer; range: 2-10
     RST_ACTIVE_HIGH => 1  -- integer; 0=active low reset, 1=active high reset
  )
  port map (
     src_arst  => rst,
     dest_clk  => clk_368p64,--clk_122p88,
     dest_arst => rst_368p64
  );
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

cpri_linkup_sync : xpm_cdc_array_single
generic map (
   DEST_SYNC_FF   => 4               ,
   INIT_SYNC_FF   => 0               ,
   SIM_ASSERT_CHK => 0               ,
   SRC_INPUT_REG  => 1               ,
   WIDTH          => 2               )
port map (
   dest_out       => link_up         ,
   dest_clk       => clk_368p64      ,
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
   dest_clk       => clk_368p64      ,
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
   dest_clk       => clk_368p64      ,
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
   dest_clk       => clk_368p64      ,
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
   dest_clk       => clk_368p64      ,
   src_clk        => clk_100         ,
   src_in         => op_id1(1)       );


process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        dcm_dout_i_s  <= (others => ( others=>'0' ));
        dcm_dout_q_s  <= (others => ( others=>'0' ));
    else
        if (data_sync = '1') then
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000001" and vendor_info(1) /= "000001" and vendor_info(2) /= "000001" and vendor_info(3) /= "000001") then
                dcm_dout_i_s  <= din_i0;
                dcm_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) = "000001" and vendor_info(2) /= "000001" and vendor_info(3) /="000001") then
                dcm_dout_i_s  <= din_i1;
                dcm_dout_q_s  <= din_q1;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) /= "000001" and vendor_info(2) = "000001" and vendor_info(3) /= "000001") then
                dcm_dout_i_s  <= din_i2;
                dcm_dout_q_s  <= din_q2;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) /= "000001" and vendor_info(2) /= "000001" and vendor_info(3) = "000001") then
                dcm_dout_i_s  <= din_i3;
                dcm_dout_q_s  <= din_q3;
            else
                dcm_dout_i_s  <= (others => ( others=>'0' ));
                dcm_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000001" and vendor_info(1) /= "000001") then
                dcm_dout_i_s  <= din_i0;
                dcm_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) = "000001") then
                dcm_dout_i_s  <= din_i1;
                dcm_dout_q_s  <= din_q1;
            else
                dcm_dout_i_s  <= (others => ( others=>'0' ));
                dcm_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000001" and vendor_info(3) /= "000001") then
                dcm_dout_i_s  <= din_i2;
                dcm_dout_q_s  <= din_q2;
            elsif (vendor_info(2) /= "000001" and vendor_info(3) = "000001") then
                dcm_dout_i_s  <= din_i3;
                dcm_dout_q_s  <= din_q3;
            else
                dcm_dout_i_s  <= (others => ( others=>'0' ));
                dcm_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        else
            dcm_dout_i_s  <= (others => ( others=>'0' ));
            dcm_dout_q_s  <= (others => ( others=>'0' ));
        end if;
        end if;
    end if;
end if;
end process;


process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        kddi_dout_i_s  <= (others => ( others=>'0' ));
        kddi_dout_q_s  <= (others => ( others=>'0' ));
    else
        if (data_sync = '1') then
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000010" and vendor_info(1) /= "000010" and vendor_info(2) /= "000010" and vendor_info(3) /= "000010") then
                kddi_dout_i_s  <= din_i0;
                kddi_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) = "000010" and vendor_info(2) /= "000010" and vendor_info(3) /="000010") then
                kddi_dout_i_s  <= din_i1;
                kddi_dout_q_s  <= din_q1;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) /= "000010" and vendor_info(2) = "000010" and vendor_info(3) /= "000010") then
                kddi_dout_i_s  <= din_i2;
                kddi_dout_q_s  <= din_q2;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) /= "000010" and vendor_info(2) /= "000010" and vendor_info(3) = "000010") then
                kddi_dout_i_s  <= din_i3;
                kddi_dout_q_s  <= din_q3;
            else
                kddi_dout_i_s  <= (others => ( others=>'0' ));
                kddi_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000010" and vendor_info(1) /= "000010") then
                kddi_dout_i_s  <= din_i0;
                kddi_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) = "000010") then
                kddi_dout_i_s  <= din_i1;
                kddi_dout_q_s  <= din_q1;
            else
                kddi_dout_i_s  <= (others => ( others=>'0' ));
                kddi_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000010" and vendor_info(3) /= "000010") then
                kddi_dout_i_s  <= din_i2;
                kddi_dout_q_s  <= din_q2;
            elsif (vendor_info(2) /= "000010" and vendor_info(3) = "000010") then
                kddi_dout_i_s  <= din_i3;
                kddi_dout_q_s  <= din_q3;
            else
                kddi_dout_i_s  <= (others => ( others=>'0' ));
                kddi_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        else
            kddi_dout_i_s  <= (others => ( others=>'0' ));
            kddi_dout_q_s  <= (others => ( others=>'0' ));
        end if;
        end if;
    end if;
end if;
end process;


process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        rm_dout_i_s  <= (others => ( others=>'0' ));
        rm_dout_q_s  <= (others => ( others=>'0' ));
    else
        if (data_sync = '1') then
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000100" and vendor_info(1) /= "000100" and vendor_info(2) /= "000100" and vendor_info(3) /= "000100") then
                rm_dout_i_s  <= din_i0;
                rm_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) = "000100" and vendor_info(2) /= "000100" and vendor_info(3) /="000100") then
                rm_dout_i_s  <= din_i1;
                rm_dout_q_s  <= din_q1;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) /= "000100" and vendor_info(2) = "000100" and vendor_info(3) /= "000100") then
                rm_dout_i_s  <= din_i2;
                rm_dout_q_s  <= din_q2;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) /= "000100" and vendor_info(2) /= "000100" and vendor_info(3) = "000100") then
                rm_dout_i_s  <= din_i3;
                rm_dout_q_s  <= din_q3;
            else
                rm_dout_i_s  <= (others => ( others=>'0' ));
                rm_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000100" and vendor_info(1) /= "000100") then
                rm_dout_i_s  <= din_i0;
                rm_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) = "000100") then
                rm_dout_i_s  <= din_i1;
                rm_dout_q_s  <= din_q1;
            else
                rm_dout_i_s  <= (others => ( others=>'0' ));
                rm_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000100" and vendor_info(3) /= "000100") then
                rm_dout_i_s  <= din_i2;
                rm_dout_q_s  <= din_q2;
            elsif (vendor_info(2) /= "000100" and vendor_info(3) = "000100") then
                rm_dout_i_s  <= din_i3;
                rm_dout_q_s  <= din_q3;
            else
                rm_dout_i_s  <= (others => ( others=>'0' ));
                rm_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        else
            rm_dout_i_s  <= (others => ( others=>'0' ));
            rm_dout_q_s  <= (others => ( others=>'0' ));
        end if;
        end if;
    end if;
end if;
end process;

process(clk_368p64)
begin
if rising_edge(clk_368p64) then
    if (rst_368p64 = '1') then
        sb_dout_i_s  <= (others => ( others=>'0' ));
        sb_dout_q_s  <= (others => ( others=>'0' ));
    else
        if (data_sync = '1') then
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "001000" and vendor_info(1) /= "001000" and vendor_info(2) /= "001000" and vendor_info(3) /= "001000") then
                sb_dout_i_s  <= din_i0;
                sb_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) = "001000" and vendor_info(2) /= "001000" and vendor_info(3) /="001000") then
                sb_dout_i_s  <= din_i1;
                sb_dout_q_s  <= din_q1;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) /= "001000" and vendor_info(2) = "001000" and vendor_info(3) /= "001000") then
                sb_dout_i_s  <= din_i2;
                sb_dout_q_s  <= din_q2;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) /= "001000" and vendor_info(2) /= "001000" and vendor_info(3) = "001000") then
                sb_dout_i_s  <= din_i3;
                sb_dout_q_s  <= din_q3;
            else
                sb_dout_i_s  <= (others => ( others=>'0' ));
                sb_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "001000" and vendor_info(1) /= "001000") then
                sb_dout_i_s  <= din_i0;
                sb_dout_q_s  <= din_q0;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) = "001000") then
                sb_dout_i_s  <= din_i1;
                sb_dout_q_s  <= din_q1;
            else
                sb_dout_i_s  <= (others => ( others=>'0' ));
                sb_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "001000" and vendor_info(3) /= "001000") then
                sb_dout_i_s  <= din_i2;
                sb_dout_q_s  <= din_q2;
            elsif (vendor_info(2) /= "001000" and vendor_info(3) = "001000") then
                sb_dout_i_s  <= din_i3;
                sb_dout_q_s  <= din_q3;
            else
                sb_dout_i_s  <= (others => ( others=>'0' ));
                sb_dout_q_s  <= (others => ( others=>'0' ));
            end if;
        else
            sb_dout_i_s  <= (others => ( others=>'0' ));
            sb_dout_q_s  <= (others => ( others=>'0' ));
        end if;
        end if;
    end if;
end if;
end process;
------------------------------------------------------
dcm_cdc : for n in 0 to 3 generate
fifo_in_dcm(n) <= dcm_dout_q_s(n) & dcm_dout_i_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    wr_clk 					=> clk_368p64				, --: IN STD_LOGIC;
	rd_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    rd_clk 					=> clk_122p88				, --: IN STD_LOGIC;
    din    					=> fifo_in_dcm(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> data_sync			, --: IN STD_LOGIC;
    rd_en  					=> fifo_rd_en				, --: IN STD_LOGIC;
    dout   					=> fifo_out_dcm(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

dcm_dout_q(n) <= fifo_out_dcm(n)(31 downto 16);
dcm_dout_i(n) <= fifo_out_dcm(n)(15 downto  0);
end generate;

kddi_cdc : for n in 0 to 3 generate
fifo_in_kddi(n) <= kddi_dout_q_s(n) & kddi_dout_i_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    wr_clk 					=> clk_368p64				, --: IN STD_LOGIC;
	rd_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    rd_clk 					=> clk_122p88				, --: IN STD_LOGIC;
    din    					=> fifo_in_kddi(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> data_sync			, --: IN STD_LOGIC;
    rd_en  					=> fifo_rd_en				, --: IN STD_LOGIC;
    dout   					=> fifo_out_kddi(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

kddi_dout_q(n) <= fifo_out_kddi(n)(31 downto 16);
kddi_dout_i(n) <= fifo_out_kddi(n)(15 downto  0);
end generate;

rm_cdc : for n in 0 to 3 generate
fifo_in_rm(n) <= rm_dout_q_s(n) & rm_dout_i_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    wr_clk 					=> clk_368p64				, --: IN STD_LOGIC;
	rd_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    rd_clk 					=> clk_122p88				, --: IN STD_LOGIC;
    din    					=> fifo_in_rm(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> data_sync			, --: IN STD_LOGIC;
    rd_en  					=> fifo_rd_en				, --: IN STD_LOGIC;
    dout   					=> fifo_out_rm(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

rm_dout_q(n) <= fifo_out_rm(n)(31 downto 16);
rm_dout_i(n) <= fifo_out_rm(n)(15 downto  0);
end generate;

sb_cdc : for n in 0 to 3 generate
fifo_in_sb(n) <= sb_dout_q_s(n) & sb_dout_i_s(n);

cdc_fifo : entity work.fifo_32bit
port map (
    wr_rst 					=> rst_368p64				, --: IN STD_LOGIC;
    wr_clk 					=> clk_368p64				, --: IN STD_LOGIC;
	rd_rst 					=> rst_122p88				, --: IN STD_LOGIC;
    rd_clk 					=> clk_122p88				, --: IN STD_LOGIC;
    din    					=> fifo_in_sb(n)					, --: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    wr_en  					=> data_sync			, --: IN STD_LOGIC;
    rd_en  					=> fifo_rd_en				, --: IN STD_LOGIC;
    dout   					=> fifo_out_sb(n)					, --: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    full   					=> open						, --: OUT STD_LOGIC;
    empty  					=> open						); --: OUT STD_LOGIC

sb_dout_q(n) <= fifo_out_sb(n)(31 downto 16);
sb_dout_i(n) <= fifo_out_sb(n)(15 downto  0);
end generate;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        fifo_rd_en  <= '0';
    else
        fifo_rd_en  <= '1';
    end if;
end if;
end process;


end beh;




