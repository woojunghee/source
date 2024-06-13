
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity pow_mea_16_if is
port(
    clk             :  in std_logic;
    reset_n         :  in std_logic;
    enb             :  in std_logic;
    din             :  in std_logic_vector(15 downto 0);
    powcnt          :  in std_logic_vector( 7 downto 0);
    power           : out std_logic_vector(31 downto 0)
    );
end pow_mea_16_if;

architecture data of pow_mea_16_if is

signal square_i     : std_logic_vector(31 downto 0);
signal din_square   : std_logic_vector(32 downto 0);
signal din_ave      : std_logic_vector(56 downto 0);
signal din_sum      : std_logic_vector(32 downto 0);
signal ave_buff     : std_logic_vector(32 downto 0);

COMPONENT mult_16x16
  PORT (
    CLK             : IN STD_LOGIC;
    A               : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    B               : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CE              : IN STD_LOGIC;
    P               : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

begin

 i_mult_16x16 : mult_16x16  port map(
    clk             => clk              ,
    a               => din              ,
    b               => din              ,
    ce              => enb              ,
    p               => square_i         );


din_square  <= '0' & square_i;


process (clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        ave_buff <= (others => '0');
    else
        if (enb = '1') then
            case (powcnt) is
              when x"00"  => ave_buff <= din_ave(33 downto 1 );
              when x"01"  => ave_buff <= din_ave(34 downto 2 );
              when x"02"  => ave_buff <= din_ave(35 downto 3 );
              when x"03"  => ave_buff <= din_ave(36 downto 4 );
              when x"04"  => ave_buff <= din_ave(37 downto 5 );
              when x"05"  => ave_buff <= din_ave(38 downto 6 );
              when x"06"  => ave_buff <= din_ave(39 downto 7 );
              when x"07"  => ave_buff <= din_ave(40 downto 8 );
              when x"08"  => ave_buff <= din_ave(41 downto 9 );
              when x"09"  => ave_buff <= din_ave(42 downto 10);
              when x"0a"  => ave_buff <= din_ave(43 downto 11);
              when x"0b"  => ave_buff <= din_ave(44 downto 12);
              when x"0c"  => ave_buff <= din_ave(45 downto 13);
              when x"0d"  => ave_buff <= din_ave(46 downto 14);
              when x"0e"  => ave_buff <= din_ave(47 downto 15);
              when x"0f"  => ave_buff <= din_ave(48 downto 16);
              when x"10"  => ave_buff <= din_ave(49 downto 17);
              when x"11"  => ave_buff <= din_ave(50 downto 18);
              when x"12"  => ave_buff <= din_ave(51 downto 19);
              when x"13"  => ave_buff <= din_ave(52 downto 20);
              when x"14"  => ave_buff <= din_ave(53 downto 21);
              when x"15"  => ave_buff <= din_ave(54 downto 22);
              when x"16"  => ave_buff <= din_ave(55 downto 23);
              when others => ave_buff <= din_ave(56 downto 24);
            end case;
        end if;
     end if;
end if;
end process;

process (clk)
begin
if rising_edge(clk) then
    if (reset_n ='0') then
        din_sum    <= (others => '0');
        din_ave    <= (others => '0');
    else
        if (enb = '1') then
            din_sum  <= din_square - ave_buff;
            din_ave  <= din_ave + din_sum;
        else
            din_sum  <= din_sum;
            din_ave  <= din_ave;
        end if;
    end if;
end if;
end process;

power     <= ave_buff(31 downto 0) when ( ave_buff(31) = '0' ) else (others => '0');
    


end data;