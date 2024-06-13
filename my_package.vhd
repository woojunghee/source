library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package my_package is
    constant CPRI_NUM        : integer range 0 to 3  := 3;
    constant MIMO_NUM        : integer range 0 to 3  := 3;

    TYPE arr_mimo_1_stdlogic   is array (0 to MIMO_NUM) of std_logic;
    TYPE arr_mimo_14_stdlogic  is array (0 to MIMO_NUM) of std_logic_vector( 13 downto 0);
    TYPE arr_mimo_16_stdlogic  is array (0 to MIMO_NUM) of std_logic_vector( 15 downto 0);
    TYPE arr_mimo_32_stdlogic  is array (0 to MIMO_NUM) of std_logic_vector( 31 downto 0);
    TYPE arr_mimo_96_stdlogic  is array (0 to MIMO_NUM) of std_logic_vector( 95 downto 0);
    TYPE arr_mimo_128_stdlogic is array (0 to MIMO_NUM) of std_logic_vector(127 downto 0);

    TYPE arr_cpri_2_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  1 downto 0);
    TYPE arr_cpri_3_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  2 downto 0);
    TYPE arr_cpri_4_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  3 downto 0);
    TYPE arr_cpri_5_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  4 downto 0);
    TYPE arr_cpri_6_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  5 downto 0);
    TYPE arr_cpri_7_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  6 downto 0);
    TYPE arr_cpri_8_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  7 downto 0);
    TYPE arr_cpri_9_stdlogic   is array (0 to CPRI_NUM) of std_logic_vector(  8 downto 0);
    TYPE arr_cpri_10_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector(  9 downto 0);
    TYPE arr_cpri_11_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 10 downto 0);
    TYPE arr_cpri_12_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 11 downto 0);
    TYPE arr_cpri_14_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 13 downto 0);
    TYPE arr_cpri_15_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 14 downto 0);
    TYPE arr_cpri_16_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 15 downto 0);
    TYPE arr_cpri_17_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 16 downto 0);
    TYPE arr_cpri_18_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 17 downto 0);
    TYPE arr_cpri_32_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 31 downto 0);
    TYPE arr_cpri_64_stdlogic  is array (0 to CPRI_NUM) of std_logic_vector( 63 downto 0);
    TYPE arr_cpri_128_stdlogic is array (0 to CPRI_NUM) of std_logic_vector(127 downto 0);


    TYPE arr_16_32_stdlogic    is array (0 to 15)       of std_logic_vector( 31 downto 0);
    TYPE arr_8_32_stdlogic     is array (0 to 7)        of std_logic_vector( 31 downto 0);
    TYPE arr_8_16_stdlogic     is array (0 to 7)        of std_logic_vector( 15 downto 0);
    TYPE arr_4_128_stdlogic    is array (0 to 3)        of std_logic_vector(127 downto 0);
    TYPE arr_4_32_stdlogic     is array (0 to 3)        of std_logic_vector( 31 downto 0);
    TYPE arr_4_16_stdlogic     is array (0 to 3)        of std_logic_vector( 15 downto 0);
	TYPE arr_4_8_stdlogic     is array (0 to 3)        of std_logic_vector( 7 downto 0);
	TYPE arr_4_6_stdlogic      is array (0 to 3)        of std_logic_vector(  5 downto 0);
    TYPE arr_4_5_stdlogic      is array (0 to 3)        of std_logic_vector(  4 downto 0);
	TYPE arr_4_4_stdlogic      is array (0 to 3)        of std_logic_vector(  3 downto 0);		
    TYPE arr_4_2_stdlogic      is array (0 to 3)        of std_logic_vector(  1 downto 0);
	TYPE arr_2_32_stdlogic     is array (0 to 1)        of std_logic_vector( 31 downto 0);
	TYPE arr_2_24_stdlogic     is array (0 to 1)        of std_logic_vector( 23 downto 0);
    TYPE arr_2_16_stdlogic     is array (0 to 1)        of std_logic_vector( 15 downto 0);
	TYPE arr_2_10_stdlogic      is array (0 to 1)        of std_logic_vector(  9 downto 0);
    TYPE arr_2_8_stdlogic      is array (0 to 1)        of std_logic_vector(  7 downto 0);
	TYPE arr_2_6_stdlogic      is array (0 to 1)        of std_logic_vector(  5 downto 0);
    TYPE arr_2_4_stdlogic      is array (0 to 1)        of std_logic_vector(  3 downto 0);
    TYPE arr_2_2_stdlogic      is array (0 to 1)        of std_logic_vector(  1 downto 0);
	TYPE arr_2_1_stdlogic      is array (0 to 1)        of std_logic_vector(  0 downto 0);

  type arr_mac_num_48_stdlogic is array(natural range <>) of std_logic_vector(47 downto 0);



end package my_package;