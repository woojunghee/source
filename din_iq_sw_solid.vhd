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
  signal vendor_info : arr_4_6_stdlogic;
  signal link_up     : std_logic_vector(1 downto 0);


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
   src_in         => op_id0(1)       );

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
   src_in         => op_id1(0)       );


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
        dcm_dout_i  <= (others => ( others=>'0' ));
        dcm_dout_q  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000001" and vendor_info(1) /= "000001" and vendor_info(2) /= "000001" and vendor_info(3) /= "000001") then
                dcm_dout_i  <= din_i0;
                dcm_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) = "000001" and vendor_info(2) /= "000001" and vendor_info(3) /="000001") then
                dcm_dout_i  <= din_i1;
                dcm_dout_q  <= din_q1;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) /= "000001" and vendor_info(2) = "000001" and vendor_info(3) /= "000001") then
                dcm_dout_i  <= din_i2;
                dcm_dout_q  <= din_q2;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) /= "000001" and vendor_info(2) /= "000001" and vendor_info(3) = "000001") then
                dcm_dout_i  <= din_i3;
                dcm_dout_q  <= din_q3;
            else
                dcm_dout_i  <= (others => ( others=>'0' ));
                dcm_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000001" and vendor_info(1) /= "000001") then
                dcm_dout_i  <= din_i0;
                dcm_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "000001" and vendor_info(1) = "000001") then
                dcm_dout_i  <= din_i1;
                dcm_dout_q  <= din_q1;
            else
                dcm_dout_i  <= (others => ( others=>'0' ));
                dcm_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000001" and vendor_info(3) /= "000001") then
                dcm_dout_i  <= din_i2;
                dcm_dout_q  <= din_q2;
            elsif (vendor_info(2) /= "000001" and vendor_info(3) = "000001") then
                dcm_dout_i  <= din_i3;
                dcm_dout_q  <= din_q3;
            else
                dcm_dout_i  <= (others => ( others=>'0' ));
                dcm_dout_q  <= (others => ( others=>'0' ));
            end if;
        else
            dcm_dout_i  <= (others => ( others=>'0' ));
            dcm_dout_q  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        kddi_dout_i  <= (others => ( others=>'0' ));
        kddi_dout_q  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000010" and vendor_info(1) /= "000010" and vendor_info(2) /= "000010" and vendor_info(3) /= "000010") then
                kddi_dout_i  <= din_i0;
                kddi_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) = "000010" and vendor_info(2) /= "000010" and vendor_info(3) /="000010") then
                kddi_dout_i  <= din_i1;
                kddi_dout_q  <= din_q1;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) /= "000010" and vendor_info(2) = "000010" and vendor_info(3) /= "000010") then
                kddi_dout_i  <= din_i2;
                kddi_dout_q  <= din_q2;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) /= "000010" and vendor_info(2) /= "000010" and vendor_info(3) = "000010") then
                kddi_dout_i  <= din_i3;
                kddi_dout_q  <= din_q3;
            else
                kddi_dout_i  <= (others => ( others=>'0' ));
                kddi_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000010" and vendor_info(1) /= "000010") then
                kddi_dout_i  <= din_i0;
                kddi_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "000010" and vendor_info(1) = "000010") then
                kddi_dout_i  <= din_i1;
                kddi_dout_q  <= din_q1;
            else
                kddi_dout_i  <= (others => ( others=>'0' ));
                kddi_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000010" and vendor_info(3) /= "000010") then
                kddi_dout_i  <= din_i2;
                kddi_dout_q  <= din_q2;
            elsif (vendor_info(2) /= "000010" and vendor_info(3) = "000010") then
                kddi_dout_i  <= din_i3;
                kddi_dout_q  <= din_q3;
            else
                kddi_dout_i  <= (others => ( others=>'0' ));
                kddi_dout_q  <= (others => ( others=>'0' ));
            end if;
        else
            kddi_dout_i  <= (others => ( others=>'0' ));
            kddi_dout_q  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;


process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        rm_dout_i  <= (others => ( others=>'0' ));
        rm_dout_q  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "000100" and vendor_info(1) /= "000100" and vendor_info(2) /= "000100" and vendor_info(3) /= "000100") then
                rm_dout_i  <= din_i0;
                rm_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) = "000100" and vendor_info(2) /= "000100" and vendor_info(3) /="000100") then
                rm_dout_i  <= din_i1;
                rm_dout_q  <= din_q1;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) /= "000100" and vendor_info(2) = "000100" and vendor_info(3) /= "000100") then
                rm_dout_i  <= din_i2;
                rm_dout_q  <= din_q2;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) /= "000100" and vendor_info(2) /= "000100" and vendor_info(3) = "000100") then
                rm_dout_i  <= din_i3;
                rm_dout_q  <= din_q3;
            else
                rm_dout_i  <= (others => ( others=>'0' ));
                rm_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "000100" and vendor_info(1) /= "000100") then
                rm_dout_i  <= din_i0;
                rm_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "000100" and vendor_info(1) = "000100") then
                rm_dout_i  <= din_i1;
                rm_dout_q  <= din_q1;
            else
                rm_dout_i  <= (others => ( others=>'0' ));
                rm_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "000100" and vendor_info(3) /= "000100") then
                rm_dout_i  <= din_i2;
                rm_dout_q  <= din_q2;
            elsif (vendor_info(2) /= "000100" and vendor_info(3) = "000100") then
                rm_dout_i  <= din_i3;
                rm_dout_q  <= din_q3;
            else
                rm_dout_i  <= (others => ( others=>'0' ));
                rm_dout_q  <= (others => ( others=>'0' ));
            end if;
        else
            rm_dout_i  <= (others => ( others=>'0' ));
            rm_dout_q  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;

process(clk_122p88)
begin
if rising_edge(clk_122p88) then
    if (rst_122p88 = '1') then
        sb_dout_i  <= (others => ( others=>'0' ));
        sb_dout_q  <= (others => ( others=>'0' ));
    else
        if ( link_up(0) = '1' and link_up(1) = '1') then
            if (vendor_info(0) = "001000" and vendor_info(1) /= "001000" and vendor_info(2) /= "001000" and vendor_info(3) /= "001000") then
                sb_dout_i  <= din_i0;
                sb_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) = "001000" and vendor_info(2) /= "001000" and vendor_info(3) /="001000") then
                sb_dout_i  <= din_i1;
                sb_dout_q  <= din_q1;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) /= "001000" and vendor_info(2) = "001000" and vendor_info(3) /= "001000") then
                sb_dout_i  <= din_i2;
                sb_dout_q  <= din_q2;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) /= "001000" and vendor_info(2) /= "001000" and vendor_info(3) = "001000") then
                sb_dout_i  <= din_i3;
                sb_dout_q  <= din_q3;
            else
                sb_dout_i  <= (others => ( others=>'0' ));
                sb_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '1' and link_up(1) = '0') then
            if (vendor_info(0) = "001000" and vendor_info(1) /= "001000") then
                sb_dout_i  <= din_i0;
                sb_dout_q  <= din_q0;
            elsif (vendor_info(0) /= "001000" and vendor_info(1) = "001000") then
                sb_dout_i  <= din_i1;
                sb_dout_q  <= din_q1;
            else
                sb_dout_i  <= (others => ( others=>'0' ));
                sb_dout_q  <= (others => ( others=>'0' ));
            end if;
        elsif ( link_up(0) = '0' and link_up(1) = '1') then
            if (vendor_info(2) = "001000" and vendor_info(3) /= "001000") then
                sb_dout_i  <= din_i2;
                sb_dout_q  <= din_q2;
            elsif (vendor_info(2) /= "001000" and vendor_info(3) = "001000") then
                sb_dout_i  <= din_i3;
                sb_dout_q  <= din_q3;
            else
                sb_dout_i  <= (others => ( others=>'0' ));
                sb_dout_q  <= (others => ( others=>'0' ));
            end if;
        else
            sb_dout_i  <= (others => ( others=>'0' ));
            sb_dout_q  <= (others => ( others=>'0' ));
        end if;
    end if;
end if;
end process;



end beh;




