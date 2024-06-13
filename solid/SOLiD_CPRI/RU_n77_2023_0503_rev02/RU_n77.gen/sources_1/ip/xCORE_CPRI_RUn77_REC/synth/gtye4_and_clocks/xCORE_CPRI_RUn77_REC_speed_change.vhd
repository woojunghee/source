-----------------------------------------------------------------------
-- Title      : State machine to implement changing between speeds
-- Project    : cpri_v8_11_14
-----------------------------------------------------------------------
-- File       : xCORE_CPRI_RUn77_REC_speed_change.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: This block implements the speed change state machine
-----------------------------------------------------------------------
-- (c) Copyright 2009 - 2021 Xilinx, Inc. All rights reserved.
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
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library cpri_v8_11_14;
use cpri_v8_11_14.all;

entity xCORE_CPRI_RUn77_REC_speed_change is
port (
  reset                : in  std_logic;
  clk                  : in  std_logic;
  speed_select         : in  std_logic_vector(10 downto 0);
  qpll_select          : in  std_logic;

  gt_daddr             : out std_logic_vector(9 downto 0);
  gt_den               : out std_logic;
  gt_dwe               : out std_logic;
  gt_di                : out std_logic_vector(15 downto 0);
  gt_drdy              : in  std_logic;
  gt_do                : in  std_logic_vector(15 downto 0);

  sm_busy              : out std_logic;
  sm_drp_arb_gnt       : in  std_logic;
  gt_reset_req_toggle  : out std_logic;
  cpllreset            : in  std_logic;
  cplllkdet            : in  std_logic);
end xCORE_CPRI_RUn77_REC_speed_change;

architecture rtl of xCORE_CPRI_RUn77_REC_speed_change is

  signal speed_select_r           : std_logic_vector(10 downto 0);
  signal rdata                    : std_logic_vector(15 downto 0);
  signal sm_busy_i                : std_logic;
  signal wait_for_cpll_lock       : std_logic;
  signal gt_reset_req_toggle_i    : std_logic := '0';

type t_state is (idle,
                   read_28_clear, wait_for_28r_clear_rdy,
                   read_28, wait_for_28r_rdy, write_28, wait_for_28_rdy,
                   read_2A, wait_for_2Ar_rdy, write_2A, wait_for_2A_rdy,
                   read_63, wait_for_63r_rdy, write_63, wait_for_63_rdy,
                   read_8A, wait_for_8Ar_rdy, write_8A, wait_for_8A_rdy,
                   read_7C, wait_for_7Cr_rdy, write_7C, wait_for_7C_rdy,
                   write_10, wait_for_10_rdy, write_11, wait_for_11_rdy,
                   read_66, wait_for_66r_rdy, write_66, wait_for_66_rdy,
                   read_85, wait_for_85r_rdy, write_85, wait_for_85_rdy,
                   read_8C, wait_for_8Cr_rdy, write_8C, wait_for_8C_rdy,
                   read_D0, wait_for_D0r_rdy, write_D0, wait_for_D0_rdy,
                   read_52, wait_for_52r_rdy, write_52, wait_for_52_rdy,
                   write_73, wait_for_73_rdy, write_CF, wait_for_CF_rdy,
                   write_3D, wait_for_3D_rdy,
                   read_62, wait_for_62r_rdy, write_62, wait_for_62_rdy,
                   read_DD, wait_for_DDr_rdy, write_DD, wait_for_DD_rdy,
                   read_D3, wait_for_D3r_rdy, write_D3, wait_for_D3_rdy,
                   write_116, wait_for_116_rdy,
                   write_103, wait_for_103_rdy, write_105, wait_for_105_rdy,
                   write_101, wait_for_101_rdy, write_108, wait_for_108_rdy,
                   write_109, wait_for_109_rdy, write_10A, wait_for_10A_rdy,
                   write_10B, wait_for_10B_rdy, write_10C, wait_for_10C_rdy,
                   write_10D, wait_for_10D_rdy, write_10E, wait_for_10E_rdy,
                   write_F7, wait_for_F7_rdy,
                   write_F8, wait_for_F8_rdy, write_F9, wait_for_F9_rdy,
                   read_FA, wait_for_FAr_rdy, write_FA, wait_for_FA_rdy,
                   read_9B, wait_for_9Br_rdy, write_9B, wait_for_9B_rdy,
                   write_9D, wait_for_9D_rdy, write_A1, wait_for_A1_rdy,
                   write_53, wait_for_53_rdy, write_54, wait_for_54_rdy,
                   write_9F, wait_for_9F_rdy, write_8F, wait_for_8F_rdy,
                   write_A0, wait_for_A0_rdy, write_6F, wait_for_6F_rdy,
                   write_BC, wait_for_BC_rdy, write_57, wait_for_57_rdy,
                   write_A7, wait_for_A7_rdy, write_A8, wait_for_A8_rdy,
                   read_FB, wait_for_FBr_rdy, write_FB, wait_for_FB_rdy,
                   write_75, wait_for_75_rdy, write_D2, wait_for_D2_rdy,
                   read_27, wait_for_27r_rdy, write_27, wait_for_27_rdy,
                   read_55, wait_for_55r_rdy, write_55, wait_for_55_rdy,
                   read_56, wait_for_56r_rdy, write_56, wait_for_56_rdy,
                   read_1E, wait_for_1Er_rdy, write_1E, wait_for_1E_rdy,
                   read_1F, wait_for_1Fr_rdy, write_1F, wait_for_1F_rdy,
                   read_20, wait_for_20r_rdy, write_20, wait_for_20_rdy,
                   read_21, wait_for_21r_rdy, write_21, wait_for_21_rdy,
                   read_22, wait_for_22r_rdy, write_22, wait_for_22_rdy,
                   read_23, wait_for_23r_rdy, write_23, wait_for_23_rdy,
                   read_24, wait_for_24r_rdy, write_24, wait_for_24_rdy,
                   read_25, wait_for_25r_rdy, write_25, wait_for_25_rdy,
                   read_CD, wait_for_CDr_rdy, write_CD, wait_for_CD_rdy,
                   read_2C, wait_for_2Cr_rdy, write_2C, wait_for_2C_rdy,
                   read_99, wait_for_99r_rdy, write_99, wait_for_99_rdy,
                   read_64, wait_for_64r_rdy, write_64, wait_for_64_rdy,
                   read_03, wait_for_03r_rdy, write_03, wait_for_03_rdy,
                   write_C6, wait_for_C6_rdy,
                   read_7A, wait_for_7Ar_rdy, write_7A, wait_for_7A_rdy,
                   read_0A, wait_for_0Ar_rdy, write_0A, wait_for_0A_rdy,
                   wait_for_lock,
                   reset_gt, wait_for_cpll_reset, wait_for_cplllock_low,
                   wait_for_cplllock_high);

  signal speed_sm_state : t_state := idle;

begin

  -- Detect a speed change
  speed_change_det : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        speed_select_r  <= (others => '0');
      else
        if sm_busy_i = '0' then
          speed_select_r  <= speed_select;
        end if;
      end if;
    end if;
  end process speed_change_det;


  --------------------------------------------------------------------------------
  -- DRP speed change state machine.
  -- Dynamically switches between line rates from 24.33024Gbps down to 0.6144Gbps.
  --------------------------------------------------------------------------------
  speed_change_sm : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        speed_sm_state <= idle;
        sm_busy_i <= '0';
        gt_den  <= '0';
      else
        case speed_sm_state is
          when idle =>
            gt_daddr             <= (others => '0');
            gt_den               <= '0';
            gt_dwe               <= '0';
            gt_di                <= (others => '0');
            if (speed_select_r /= speed_select
              and speed_select /= "00000000000") then
              if (speed_select(5 downto 0) /= "000000" and
                 (speed_select_r = "00000000000" or speed_select_r(10 downto 6) /= "00000")) then
                wait_for_cpll_lock <= '1';
              else
                wait_for_cpll_lock <= '0';
              end if;
              gt_daddr(9 downto 8) <= "00";
              sm_busy_i <= '1';
            end if;
            if (sm_drp_arb_gnt = '1' and sm_busy_i = '1') then
              speed_sm_state <= read_28_clear;
            end if;

          -- Clear any pending DRP transactions
          when read_28_clear =>
            sm_busy_i <= '1';
            gt_daddr(7 downto 0) <= x"28";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_28r_clear_rdy;
          when wait_for_28r_clear_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_28;
            end if;

          -- 28 holds CPLL_FBDIV & CPLL_FBDIV_45
          -- CPLL_FBDIV 9.8G:         = 4 (00000010)
          -- CPLL_FBDIV 6.1G & 3.0G:  = 5 (00000011)
          -- CPLL_FBDIV All others:   = 2 (00000000)
          -- CPLL_FBDIV_45 All rates: = 5 (1)
          when read_28 =>
            sm_busy_i <= '1';
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"28";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_28r_rdy;
          when wait_for_28r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_28;
            end if;
          when write_28 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "00001000000" =>
                gt_di <= "00000010" & '1' & rdata(6 downto 0);
              when "00000100000" | "00000001000" =>
                gt_di <= "00000011" & '1' & rdata(6 downto 0);
              when others =>
                gt_di <= "00000000" & '1' & rdata(6 downto 0);
            end case;
            speed_sm_state <= wait_for_28_rdy;
          when wait_for_28_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_2A;
            end if;

          -- 2A holds CPLL_REFCLK_DIV
          -- 6.1G & 3.0G:     = 2 (00000)
          -- All other rates: = 1 (10000)
          when read_2A =>
            sm_busy_i <= '1';
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"2A";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_2Ar_rdy;
          when wait_for_2Ar_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_2A;
            end if;
          when write_2A =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 2A holds REFCLK_DIV
            case speed_select is
              when "00000100000" | "00000001000" =>
                gt_di <= "00000" & rdata(10 downto 0);
              when others =>
                gt_di <= "10000" & rdata(10 downto 0);
            end case;
            speed_sm_state <= wait_for_2A_rdy;
          when wait_for_2A_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_63;
            end if;

          -- 63 holds RXOUT_DIV & CBCC_DATA_SOURCE_SEL
          -- 24.3G               = 1 & 0 (encoded)
          -- 12.1G, 8.1G(QPLL1): = 1 & 0 (encoded)
          -- 8.1G(QPLL0):        = 2 & 0 (encoded)
          -- 10.1G:              = 1 & 0 (encoded)
          -- 9.8G, 6.1g, 4.9G:   = 1 & 1 (decoded)
          -- 3.0G, 2.4G:         = 2 & 1 (decoded)
          -- 1.2G:               = 4 & 1 (decoded)
          -- 0.6G:               = 8 & 1 (decoded)
          when read_63 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"63";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_63r_rdy;
          when wait_for_63r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_63;
            end if;
          when write_63 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" =>
                gt_di <= '0' & rdata(14 downto 3) & "000";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di <= '0' & rdata(14 downto 3) & "001";
                else
                  gt_di <= '0' & rdata(14 downto 3) & "000";
                end if;
              when "00010000000" =>
                gt_di <= "0" & rdata(14 downto 3) & "000";
              when "00001000000" | "00000100000" | "00000010000" =>
                gt_di <= "1" & rdata(14 downto 3) & "000";
              when "00000001000" | "00000000100" =>
                gt_di <= "1" & rdata(14 downto 3) & "001";
              when "00000000010" =>
                gt_di <= "1" & rdata(14 downto 3) & "010";
              when others =>
                gt_di <= "1" & rdata(14 downto 3) & "011";
            end case;
            speed_sm_state <= wait_for_63_rdy;
          when wait_for_63_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_8A;
            end if;

          -- 8A holds TXSYNC_OVRD.
          -- 24.3G, 12.1G, 10.1G, 8.1G: Tx manual phase alignment mode disabled.
          -- All other rates:           Tx manual phase alignment mode enabled.
          when read_8A =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"8A";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_8Ar_rdy;
          when wait_for_8Ar_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_8A;
            end if;
          when write_8A =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 14) & '0' & rdata(12 downto 0);
              when others =>
                gt_di <= rdata(15 downto 14) & '1' & rdata(12 downto 0);
            end case;
            speed_sm_state <= wait_for_8A_rdy;
          when wait_for_8A_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_7C;
            end if;

          -- 7C holds TXOUT_DIV & TXBUF_EN & TXGEARBOX_EN
          when read_7C =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"7C";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_7Cr_rdy;
          when wait_for_7Cr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_7C;
            end if;
          when write_7C =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" =>
                gt_di <= rdata(15 downto 14) & "1" & rdata(12 downto 11) & "000" & '1' & rdata(6 downto 0);
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di <= rdata(15 downto 14) & "1" & rdata(12 downto 11) & "001" & '1' & rdata(6 downto 0);
                else
                  gt_di <= rdata(15 downto 14) & "1" & rdata(12 downto 11) & "000" & '1' & rdata(6 downto 0);
                end if;
              when "00010000000" =>
                gt_di <= rdata(15 downto 14) & "1" & rdata(12 downto 11) & "000" & '1' & rdata(6 downto 0);
              when "00001000000" | "00000100000" | "00000010000" =>
                gt_di <= rdata(15 downto 14) & "0" & rdata(12 downto 11) & "000" & '0' & rdata(6 downto 0);
              when "00000001000" | "00000000100" =>
                gt_di <= rdata(15 downto 14) & "0" & rdata(12 downto 11) & "001" & '0' & rdata(6 downto 0);
              when "00000000010" =>
                gt_di <= rdata(15 downto 14) & "0" & rdata(12 downto 11) & "010" & '0' & rdata(6 downto 0);
              when others =>
                gt_di <= rdata(15 downto 14) & "0" & rdata(12 downto 11) & "011" & '0' & rdata(6 downto 0);
            end case;
            speed_sm_state <= wait_for_7C_rdy;
          when wait_for_7C_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_10;
            end if;

          -- 10 holds RXCDR_CFG2
          when write_10 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"10";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000111101001"
            -- 12.16512G : "0000001001101001"
            -- 8.11008G  : "0000001001011001" (QPLL0)
            --           : "0000001001101001" (QPLL1)
            -- 10.1376G  : "0000001001101001"
            -- 9.8304G   : "0000001001101001"
            -- 6.144G    : "0000001001101001"
            -- 4.9512G   : "0000001001101001"
            -- 3.072G    : "0000001001011001"
            -- 2.4576G   : "0000001001011001"
            -- 1.2288G   : "0000001001001001"
            -- 0.6144G   : "0000001000111001"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000111101001";
              when "01000000000" =>
                gt_di            <= "0000001001101001";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0000001001011001";
                else
                  gt_di            <= "0000001001101001";
                end if;
              when "00010000000" =>
                gt_di            <= "0000001001101001";
              when "00001000000" =>
                gt_di            <= "0000001001101001";
              when "00000100000" =>
                gt_di            <= "0000001001101001";
              when "00000010000" =>
                gt_di            <= "0000001001101001";
              when "00000001000" =>
                gt_di            <= "0000001001011001";
              when "00000000100" =>
                gt_di            <= "0000001001011001";
              when "00000000010" =>
                gt_di            <= "0000001001001001";
              when others =>
                gt_di            <= "0000001000111001";
            end case;
            speed_sm_state <= wait_for_10_rdy;
          when wait_for_10_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_11;
            end if;

          -- 11 holds RXCDR_CFG3
          when write_11 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"11";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000010010"
            -- 12.16512G : "0000000000010010"
            -- 8.11008G  : "0000000000010010" (QPLL0)
            --           : "0000000000010010" (QPLL1)
            -- 10.1376G  : "0000000000010010"
            -- 9.8304G   : "0000000000010010"
            -- 6.144G    : "0000000000010010"
            -- 4.9512G   : "0000000000010010"
            -- 3.072G    : "0000000000010010"
            -- 2.4576G   : "0000000000010010"
            -- 1.2288G   : "0000000000010010"
            -- 0.6144G   : "0000000000010010"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000010010";
              when "01000000000" =>
                gt_di            <= "0000000000010010";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0000000000010010";
                else
                  gt_di            <= "0000000000010010";
                end if;
              when "00010000000" =>
                gt_di            <= "0000000000010010";
              when "00001000000" =>
                gt_di            <= "0000000000010010";
              when "00000100000" =>
                gt_di            <= "0000000000010010";
              when "00000010000" =>
                gt_di            <= "0000000000010010";
              when "00000001000" =>
                gt_di            <= "0000000000010010";
              when "00000000100" =>
                gt_di            <= "0000000000010010";
              when "00000000010" =>
                gt_di            <= "0000000000010010";
              when others =>
                gt_di            <= "0000000000010010";
            end case;
            speed_sm_state <= wait_for_11_rdy;
          when wait_for_11_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_66;
            end if;

          -- 66 holds RX_WIDEMODE_CDR
          when read_66 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"66";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_66r_rdy;
          when wait_for_66r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_66;
            end if;
          when write_66 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "10"
            -- 12.16512G : "01"
            -- 8.11008G  : "01"
            -- 10.1376G  : "01"
            -- 9.8304G   : "00"
            -- 6.144G    : "00"
            -- 4.9512G   : "00"
            -- 3.072G    : "00"
            -- 2.4576G   : "00"
            -- 1.2288G   : "00"
            -- 0.6144G   : "00"
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 4) & "10" & "10";
              when "01000000000" =>
                gt_di            <= rdata(15 downto 4) & "01" & "10";
              when "00100000000" =>
                gt_di            <= rdata(15 downto 4) & "01" & "10";
              when "00010000000" =>
                gt_di            <= rdata(15 downto 4) & "01" & "10";
              when "00001000000" =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
              when "00000100000" =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
              when "00000010000" =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
              when "00000001000" =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
              when "00000000100" =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
              when "00000000010" =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
              when others =>
                gt_di            <= rdata(15 downto 4) & "00" & "01";
            end case;
            speed_sm_state <= wait_for_66_rdy;
          when wait_for_66_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_85;
            end if;

          -- 85 holds TX_INT_DATAWIDTH
          when read_85 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"85";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_85r_rdy;
          when wait_for_85r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_85;
            end if;
          when write_85 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 12) & "10" & rdata(9 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 12) & "10" & rdata(9 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 12) & "10" & rdata(9 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 12) & "10" & rdata(9 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 12) & "01" & rdata(9 downto 0);
            end case;
            speed_sm_state <= wait_for_85_rdy;
          when wait_for_85_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_52;
            end if;

          -- 52 holds RX_DFE_AGC_CFG1
          when read_52 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"52";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_52r_rdy;
          when wait_for_52r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_52;
            end if;
          when write_52 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "100"
            -- 12.16512G : "100"
            -- 8.11008G  : "100"
            -- 10.1376G  : "100"
            -- 9.8304G   : "100"
            -- 6.144G    : "100"
            -- 4.9512G   : "100"
            -- 3.072G    : "010"
            -- 2.4576G   : "010"
            -- 1.2288G   : "010"
            -- 0.6144G   : "010"
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 5) & "100" & rdata(1 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 5) & "010" & rdata(1 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 5) & "010" & rdata(1 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 5) & "010" & rdata(1 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 5) & "010" & rdata(1 downto 0);
            end case;
            speed_sm_state <= wait_for_52_rdy;
          when wait_for_52_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_73;
            end if;

          -- 73 holds RXDFE_VP_CFG1
          when write_73 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"73";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000110011"
            -- 12.16512G : "0000000000110011"
            -- 8.11008G  : "0000000000110011"
            -- 10.1376G  : "0000000000110011"
            -- 9.8304G   : "1000000000110011"
            -- 6.144G    : "1000000000110011"
            -- 4.9512G   : "1000000000110011"
            -- 3.072G    : "1000000000110011"
            -- 2.4576G   : "1000000000110011"
            -- 1.2288G   : "1000000000110011"
            -- 0.6144G   : "1000000000110011"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000110011";
              when "01000000000" =>
                gt_di            <= "0000000000110011";
              when "00100000000" =>
                gt_di            <= "0000000000110011";
              when "00010000000" =>
                gt_di            <= "0000000000110011";
              when "00001000000" =>
                gt_di            <= "1000000000110011";
              when "00000100000" =>
                gt_di            <= "1000000000110011";
              when "00000010000" =>
                gt_di            <= "1000000000110011";
              when "00000001000" =>
                gt_di            <= "1000000000110011";
              when "00000000100" =>
                gt_di            <= "1000000000110011";
              when "00000000010" =>
                gt_di            <= "1000000000110011";
              when others =>
                gt_di            <= "1000000000110011";
            end case;
            speed_sm_state <= wait_for_73_rdy;
          when wait_for_73_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_9F;
            end if;

          -- 9F holds CPLL_CFG0
          when write_9F =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"9F";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000111111010"
            -- 12.16512G : "0000000111111010"
            -- 8.11008G  : "0000000111111010"
            -- 10.1376G  : "0000000111111010"
            -- 9.8304G   : "0000001111111110"
            -- 6.144G    : "0000111111111010"
            -- 4.9512G   : "0000000111111010"
            -- 3.072G    : "0000111111111010"
            -- 2.4576G   : "0000000111111010"
            -- 1.2288G   : "0000000111111010"
            -- 0.6144G   : "0000000111111010"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000111111010";
              when "01000000000" =>
                gt_di            <= "0000000111111010";
              when "00100000000" =>
                gt_di            <= "0000000111111010";
              when "00010000000" =>
                gt_di            <= "0000000111111010";
              when "00001000000" =>
                gt_di            <= "0000001111111110";
              when "00000100000" =>
                gt_di            <= "0000111111111010";
              when "00000010000" =>
                gt_di            <= "0000000111111010";
              when "00000001000" =>
                gt_di            <= "0000111111111010";
              when "00000000100" =>
                gt_di            <= "0000000111111010";
              when "00000000010" =>
                gt_di            <= "0000000111111010";
              when others =>
                gt_di            <= "0000000111111010";
            end case;
            speed_sm_state <= wait_for_9F_rdy;
          when wait_for_9F_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_8F;
            end if;

          -- 8F holds TXPH_CFG
          when write_8F =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"8F";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000011100100011"
            -- 12.16512G : "0000011100100011"
            -- 8.11008G  : "0000011100100011" (QPLL0)
            --           : "0000011100100011" (QPLL1)
            -- 10.1376G  : "0000011100100011"
            -- 9.8304G   : "0000001100100011"
            -- 6.144G    : "0000001100100011"
            -- 4.9512G   : "0000001100100011"
            -- 3.072G    : "0000011100100011"
            -- 2.4576G   : "0000011100100011"
            -- 1.2288G   : "0000011100100011"
            -- 0.6144G   : "0000011100100011"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000011100100011";
              when "01000000000" =>
                gt_di            <= "0000011100100011";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0000011100100011";
                else
                  gt_di            <= "0000011100100011";
                end if;
              when "00010000000" =>
                gt_di            <= "0000011100100011";
              when "00001000000" =>
                gt_di            <= "0000001100100011";
              when "00000100000" =>
                gt_di            <= "0000001100100011";
              when "00000010000" =>
                gt_di            <= "0000001100100011";
              when "00000001000" =>
                gt_di            <= "0000011100100011";
              when "00000000100" =>
                gt_di            <= "0000011100100011";
              when "00000000010" =>
                gt_di            <= "0000011100100011";
              when others =>
                gt_di            <= "0000011100100011";
            end case;
            speed_sm_state <= wait_for_8F_rdy;
          when wait_for_8F_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_A0;
            end if;

          -- A0 holds CPLL_CFG1
          when write_A0 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"A0";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000101011"
            -- 12.16512G : "0000000000101011"
            -- 8.11008G  : "0000000000101011"
            -- 10.1376G  : "0000000000101011"
            -- 9.8304G   : "0000000000101001"
            -- 6.144G    : "0000000000101001"
            -- 4.9512G   : "0000000000101011"
            -- 3.072G    : "0000000000101001"
            -- 2.4576G   : "0000000000101011"
            -- 1.2288G   : "0000000000101011"
            -- 0.6144G   : "0000000000101011"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000101011";
              when "01000000000" =>
                gt_di            <= "0000000000101011";
              when "00100000000" =>
                gt_di            <= "0000000000101011";
              when "00010000000" =>
                gt_di            <= "0000000000101011";
              when "00001000000" =>
                gt_di            <= "0000000000101001";
              when "00000100000" =>
                gt_di            <= "0000000000101001";
              when "00000010000" =>
                gt_di            <= "0000000000101011";
              when "00000001000" =>
                gt_di            <= "0000000000101001";
              when "00000000100" =>
                gt_di            <= "0000000000101011";
              when "00000000010" =>
                gt_di            <= "0000000000101011";
              when others =>
                gt_di            <= "0000000000101011";
            end case;
            speed_sm_state <= wait_for_A0_rdy;
          when wait_for_A0_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_6F;
            end if;

          -- 6F holds TXPHDLY_CFG1
          when write_6F =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"6F";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000001110"
            -- 12.16512G : "0000000000001110"
            -- 8.11008G  : "0000000000001111" (QPLL0)
            --           : "0000000000001110" (QPLL1)
            -- 10.1376G  : "0000000000001110"
            -- 9.8304G   : "0000000000001111"
            -- 6.144G    : "0000000000001111"
            -- 4.9512G   : "0000000000001111"
            -- 3.072G    : "0000000000001111"
            -- 2.4576G   : "0000000000001111"
            -- 1.2288G   : "0000000000001111"
            -- 0.6144G   : "0000000000001111"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000001110";
              when "01000000000" =>
                gt_di            <= "0000000000001110";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0000000000001111";
                else
                  gt_di            <= "0000000000001110";
                end if;
              when "00010000000" =>
                gt_di            <= "0000000000001110";
              when "00001000000" =>
                gt_di            <= "0000000000001111";
              when "00000100000" =>
                gt_di            <= "0000000000001111";
              when "00000010000" =>
                gt_di            <= "0000000000001111";
              when "00000001000" =>
                gt_di            <= "0000000000001111";
              when "00000000100" =>
                gt_di            <= "0000000000001111";
              when "00000000010" =>
                gt_di            <= "0000000000001111";
              when others =>
                gt_di            <= "0000000000001111";
            end case;
            speed_sm_state <= wait_for_6F_rdy;
          when wait_for_6F_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_BC;
            end if;

          -- BC holds CPLL_CFG2
          when write_BC =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"BC";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000000010"
            -- 12.16512G : "0000000000000010"
            -- 8.11008G  : "0000000000000010"
            -- 10.1376G  : "0000000000000010"
            -- 9.8304G   : "0000001000000011"
            -- 6.144G    : "0000001000000010"
            -- 4.9512G   : "0000000000000010"
            -- 3.072G    : "0000001000000010"
            -- 2.4576G   : "0000000000000010"
            -- 1.2288G   : "0000000000000010"
            -- 0.6144G   : "0000000000000010"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000010";
              when "01000000000" =>
                gt_di            <= "0000000000000010";
              when "00100000000" =>
                gt_di            <= "0000000000000010";
              when "00010000000" =>
                gt_di            <= "0000000000000010";
              when "00001000000" =>
                gt_di            <= "0000001000000011";
              when "00000100000" =>
                gt_di            <= "0000001000000010";
              when "00000010000" =>
                gt_di            <= "0000000000000010";
              when "00000001000" =>
                gt_di            <= "0000001000000010";
              when "00000000100" =>
                gt_di            <= "0000000000000010";
              when "00000000010" =>
                gt_di            <= "0000000000000010";
              when others =>
                gt_di            <= "0000000000000010";
            end case;
            speed_sm_state <= wait_for_BC_rdy;
          when wait_for_BC_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_CF;
            end if;

          -- CF holds RXDFE_CFG1
          when write_CF =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"CF";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000000000"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000000";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_CF_rdy;
          when wait_for_CF_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_3D;
            end if;

          -- 3D holds RXDFE_GC_CFG2
          when write_3D =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"3D";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "1111111111010000"
            -- 12.16512G : "1111111111010000"
            -- 8.11008G  : "1111111111010000"
            -- 10.1376G  : "1111111111010000"
            -- 9.8304G   : "1111111111100000"
            -- 6.144G    : "1111111111100000"
            -- 4.9512G   : "1111111111100000"
            -- 3.072G    : "1111111111100000"
            -- 2.4576G   : "1111111111100000"
            -- 1.2288G   : "1111111111100000"
            -- 0.6144G   : "1111111111100000"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "1111111111010000";
              when "01000000000" =>
                gt_di            <= "1111111111010000";
              when "00100000000" =>
                gt_di            <= "1111111111010000";
              when "00010000000" =>
                gt_di            <= "1111111111010000";
              when "00001000000" =>
                gt_di            <= "1111111111100000";
              when "00000100000" =>
                gt_di            <= "1111111111100000";
              when "00000010000" =>
                gt_di            <= "1111111111100000";
              when "00000001000" =>
                gt_di            <= "1111111111100000";
              when "00000000100" =>
                gt_di            <= "1111111111100000";
              when "00000000010" =>
                gt_di            <= "1111111111100000";
              when others =>
                gt_di            <= "1111111111100000";
            end case;
            speed_sm_state <= wait_for_3D_rdy;
          when wait_for_3D_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_57;
            end if;

          -- 57 holds TX_PROGDIV_CFG
          -- 614.4Mbps:    TX_PROGDIV_CFG = 40
          -- 1228.8Mbps:   TX_PROGDIV_CFG = 40
          -- 2457.6Mbps:   TX_PROGDIV_CFG = 40
          -- 3072.0Mbps:   TX_PROGDIV_CFG = 40
          -- 4915.2Mbps:   TX_PROGDIV_CFG = 20
          -- 6144.0Mbps:   TX_PROGDIV_CFG = 20
          -- 9830.4Mbps:   TX_PROGDIV_CFG = 20
          -- 10137.6Mbps:  TX_PROGDIV_CFG = 33.0
          -- 8110.08Mbps:  TX_PROGDIV_CFG = 66.0 QPLL0, 33.0 QPLL1
          -- 12165.12Mbps: TX_PROGDIV_CFG = 33.0
          -- 24330.24Mbps: TX_PROGDIV_CFG = 16.5
          when write_57 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"57";
            gt_den               <= '1';
            gt_dwe               <= '1';
            if (speed_select = "10000000000") then
              gt_di              <= x"E218";
            elsif (speed_select = "01000000000") then
              gt_di              <= x"E200";
            elsif (speed_select = "00100000000") then
              if (qpll_select = '0') then
                gt_di            <= x"E202";
              else
                gt_di            <= x"E200";
              end if;
            elsif (speed_select = "00010000000") then
              gt_di              <= x"E200";
            elsif (speed_select(6 downto 4) /= "000") then
              gt_di              <= x"E062";
            else
              gt_di              <= x"E047";
            end if;
            speed_sm_state <= wait_for_57_rdy;
          when wait_for_57_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_A7;
            end if;

          -- A7 holds TXPI_CFG0
          when write_A7 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"A7";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0011000000000000"
            -- 12.16512G : "0000000100000000"
            -- 8.11008G  : "0011000000000000" (QPLL0)
            --             "0000001100000000" (QPLL1)
            -- 10.1376G  : "0000001100000000"
            -- 9.8304G   : "0000001100000000"
            -- 6.144G    : "0000001100000000"
            -- 4.9512G   : "0000001100000000"
            -- 3.072G    : "0000001100000000"
            -- 2.4576G   : "0000001100000000"
            -- 1.2288G   : "0000001100000000"
            -- 0.6144G   : "0000001100000000"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0011000000000000";
              when "01000000000" =>
                gt_di            <= "0000000100000000";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0011000000000000";
                else
                  gt_di            <= "0000001100000000";
                end if;
              when "00010000000" =>
                gt_di            <= "0000001100000000";
              when "00001000000" =>
                gt_di            <= "0000001100000000";
              when "00000100000" =>
                gt_di            <= "0000001100000000";
              when "00000010000" =>
                gt_di            <= "0000001100000000";
              when "00000001000" =>
                gt_di            <= "0000001100000000";
              when "00000000100" =>
                gt_di            <= "0000001100000000";
              when "00000000010" =>
                gt_di            <= "0000001100000000";
              when others =>
                gt_di            <= "0000001100000000";
            end case;
            speed_sm_state <= wait_for_A7_rdy;
          when wait_for_A7_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_A8;
            end if;

          -- A8 holds TXPI_CFG1
          when write_A8 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"A8";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000000000"
            -- 12.16512G : "0001000000000000"
            -- 8.11008G  : "0000000000000000" (QPLL0)
            --             "0001000000000000" (QPLL1)
            -- 10.1376G  : "0001000000000000"
            -- 9.8304G   : "0001000000000000"
            -- 6.144G    : "0111010101010101"
            -- 4.9512G   : "0111010101010101"
            -- 3.072G    : "0111010101010101"
            -- 2.4576G   : "0111010101010101"
            -- 1.2288G   : "0111010101010101"
            -- 0.6144G   : "0111010101010101"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000000";
              when "01000000000" =>
                gt_di            <= "0001000000000000";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0000000000000000";
                else
                  gt_di            <= "0001000000000000";
                end if;
              when "00010000000" =>
                gt_di            <= "0001000000000000";
              when "00001000000" =>
                gt_di            <= "0001000000000000";
              when "00000100000" =>
                gt_di            <= "0111010101010101";
              when "00000010000" =>
                gt_di            <= "0111010101010101";
              when "00000001000" =>
                gt_di            <= "0111010101010101";
              when "00000000100" =>
                gt_di            <= "0111010101010101";
              when "00000000010" =>
                gt_di            <= "0111010101010101";
              when others =>
                gt_di            <= "0111010101010101";
            end case;
            speed_sm_state <= wait_for_A8_rdy;
          when wait_for_A8_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_FB;
            end if;

          -- FB holds PREIQ_FREQ_BST and TX_PI_BIASSET
          when read_FB =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"FB";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_FBr_rdy;
          when wait_for_FBr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_FB;
            end if;
          when write_FB =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "10" & "10"
            -- 12.16512G : "01" & "01"
            -- 8.11008G  : "01" & "01" (QPLL0)
            --             "00" & "00" (QPLL1)
            -- 10.1376G  : "00" & "00"
            -- 9.8304G   : "00" & "00"
            -- 6.144G    : "00" & "00"
            -- 4.9512G   : "00" & "00"
            -- 3.072G    : "00" & "00"
            -- 2.4576G   : "00" & "00"
            -- 1.2288G   : "00" & "00"
            -- 0.6144G   : "00" & "00"
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 6) & "10" & rdata(3) & "10" & rdata(0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 6) & "01" & rdata(3) & "01" & rdata(0);
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= rdata(15 downto 6) & "01" & rdata(3) & "01" & rdata(0);
                else
                  gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
                end if;
              when "00010000000" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
              when others =>
                gt_di            <= rdata(15 downto 6) & "00" & rdata(3) & "00" & rdata(0);
            end case;
            speed_sm_state <= wait_for_FB_rdy;
          when wait_for_FB_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_62;
            end if;

          -- 62 holds RX_SUM_IREF_TUNE and RX_SUM_VCMTUNE
          when read_62 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"62";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_62r_rdy;
          when wait_for_62r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_62;
            end if;
          when write_62 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000" & "1001"
            -- 12.16512G : "0000" & "1001"
            -- 8.11008G  : "0000" & "1001"
            -- 10.1376G  : "0000" & "1001"
            -- 9.8304G   : "0000" & "1001"
            -- 6.144G    : "0000" & "1001"
            -- 4.9512G   : "0000" & "1001"
            -- 3.072G    : "0000" & "0011"
            -- 2.4576G   : "0000" & "0011"
            -- 1.2288G   : "0000" & "0011"
            -- 0.6144G   : "0000" & "0011"
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "1001" & rdata(2 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "0011" & rdata(2 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "0011" & rdata(2 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "0011" & rdata(2 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 13) & "0000" & rdata(8 downto 7) & "0011" & rdata(2 downto 0);
            end case;
            speed_sm_state <= wait_for_62_rdy;
          when wait_for_62_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_DD;
            end if;

          -- DD holds RTX_BUF_TERM_CTRL and RTX_BUF_CML_CTRL
          when read_DD =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"DD";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_DDr_rdy;
          when wait_for_DDr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_DD;
            end if;
          when write_DD =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "00" & "110"
            -- 12.16512G : "00" & "100"
            -- 8.11008G  : "00" & "101" (QPLL0)
            --             "00" & "011" (QPLL1)
            -- 10.1376G  : "00" & "011"
            -- 9.8304G   : "00" & "011"
            -- 6.144G    : "00" & "011"
            -- 4.9512G   : "00" & "011"
            -- 3.072G    : "00" & "011"
            -- 2.4576G   : "00" & "011"
            -- 1.2288G   : "00" & "011"
            -- 0.6144G   : "00" & "011"
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "110";
              when "01000000000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "100";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= rdata(15 downto 5) & "00" & "101";
                else
                  gt_di            <= rdata(15 downto 5) & "00" & "011";
                end if;
              when "00010000000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when "00001000000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when "00000100000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when "00000010000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when "00000001000" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when "00000000100" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when "00000000010" =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
              when others =>
                gt_di            <= rdata(15 downto 5) & "00" & "011";
            end case;
            speed_sm_state <= wait_for_DD_rdy;
          when wait_for_DD_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_D3;
            end if;

          -- D3 holds RX_XMODE_SEL
          when read_D3 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"D3";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_D3r_rdy;
          when wait_for_D3r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_D3;
            end if;
          when write_D3 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0"
            -- 12.16512G : "0"
            -- 8.11008G  : "1"
            -- 10.1376G  : "1"
            -- 9.8304G   : "1"
            -- 6.144G    : "1"
            -- 4.9512G   : "1"
            -- 3.072G    : "1"
            -- 2.4576G   : "1"
            -- 1.2288G   : "1"
            -- 0.6144G   : "1"
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 2) & "0" & rdata(0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 2) & "0" & rdata(0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
              when others =>
                gt_di            <= rdata(15 downto 2) & "1" & rdata(0);
            end case;
            speed_sm_state <= wait_for_D3_rdy;
          when wait_for_D3_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_116;
            end if;

          -- 116 holds CH_HSPMUX
          when write_116 =>
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"16";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0110000001100000"
            -- 12.16512G : "0100000001000000"
            -- 8.11008G  : "0100000001000000" (QPLL0)
            --             "0010000000100000" (QPLL1)
            -- 10.1376G  : "0010000000100000"
            -- 9.8304G   : "0010000000100000"
            -- 6.144G    : "0010000000100000"
            -- 4.9512G   : "0010000000100000"
            -- 3.072G    : "0010000000100000"
            -- 2.4576G   : "0010000000100000"
            -- 1.2288G   : "0010000000100000"
            -- 0.6144G   : "0010000000100000"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0110000001100000";
              when "01000000000" =>
                gt_di            <= "0100000001000000";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0100000001000000";
                else
                  gt_di            <= "0010000000100000";
                end if;
              when "00010000000" =>
                gt_di            <= "0010000000100000";
              when "00001000000" =>
                gt_di            <= "0010000000100000";
              when "00000100000" =>
                gt_di            <= "0010000000100000";
              when "00000010000" =>
                gt_di            <= "0010000000100000";
              when "00000001000" =>
                gt_di            <= "0010000000100000";
              when "00000000100" =>
                gt_di            <= "0010000000100000";
              when "00000000010" =>
                gt_di            <= "0010000000100000";
              when others =>
                gt_di            <= "0010000000100000";
            end case;
            speed_sm_state <= wait_for_116_rdy;
          when wait_for_116_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_103;
            end if;

          -- 103 holds RX_PROGDIV_RATE
          -- 24330.24Mbps:    RX_PROGDIV_RATE = x"0000"
          -- All other rates: RX_PROGDIV_RATE = x"0001"
          when write_103 =>
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"03";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>  -- 24.3G
                gt_di            <= x"0000";
              when others =>
                gt_di            <= x"0001";
            end case;
            speed_sm_state <= wait_for_103_rdy;
          when wait_for_103_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_105;
            end if;

          -- 105 holds TX_PROGDIV_RATE
          -- 24330.24Mbps:    TX_PROGDIV_RATE = x"0000"
          -- All other rates: TX_PROGDIV_RATE = x"0001"
          when write_105 =>
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"05";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>  -- 24.3G
                gt_di            <= x"0000";
              when others =>
                gt_di            <= x"0001";
            end case;
            speed_sm_state <= wait_for_105_rdy;
          when wait_for_105_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_101;
            end if;

          -- 101 holds CKCAL2_CFG_1
          when write_101 =>
            -- 24.33024G : "0000000001000000"
            -- 12.16512G : "1000000011000000"
            -- 8.11008G  : "1000000011000000"
            -- 10.1376G  : "1000000011000000"
            -- 9.8304G   : "1000000011000000"
            -- 6.144G    : "1000000011000000"
            -- 4.9512G   : "1000000011000000"
            -- 3.072G    : "1000000011000000"
            -- 2.4576G   : "1000000011000000"
            -- 1.2288G   : "1000000011000000"
            -- 0.6144G   : "1000000011000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"01";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000001000000";
              when "01000000000" =>
                gt_di            <= "1000000011000000";
              when "00100000000" =>
                gt_di            <= "1000000011000000";
              when "00010000000" =>
                gt_di            <= "1000000011000000";
              when "00001000000" =>
                gt_di            <= "1000000011000000";
              when "00000100000" =>
                gt_di            <= "1000000011000000";
              when "00000010000" =>
                gt_di            <= "1000000011000000";
              when "00000001000" =>
                gt_di            <= "1000000011000000";
              when "00000000100" =>
                gt_di            <= "1000000011000000";
              when "00000000010" =>
                gt_di            <= "1000000011000000";
              when others =>
                gt_di            <= "1000000011000000";
            end case;
            speed_sm_state <= wait_for_101_rdy;
          when wait_for_101_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_108;
            end if;

          -- 108 holds RXCKCAL1_I_LOOP_RST_CFG
          when write_108 =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"08";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_108_rdy;
          when wait_for_108_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_109;
            end if;

          -- 109 holds RXCKCAL1_Q_LOOP_RST_CFG
          when write_109 =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"09";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_109_rdy;
          when wait_for_109_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_10A;
            end if;

          -- 10A holds RXCKCAL1_IQ_LOOP_RST_CFG
          when write_10A =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"0A";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_10A_rdy;
          when wait_for_10A_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_10B;
            end if;

          -- 10B holds RXCKCAL2_D_LOOP_RST_CFG
          when write_10B =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"0B";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_10B_rdy;
          when wait_for_10B_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_10C;
            end if;

          -- 10C holds RXCKCAL2_X_LOOP_RST_CFG
          when write_10C =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"0C";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_10C_rdy;
          when wait_for_10C_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_10D;
            end if;

          -- 10D holds RXCKCAL2_S_LOOP_RST_CFG
          when write_10D =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"0D";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_10D_rdy;
          when wait_for_10D_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_10E;
            end if;

          -- 10E holds RXCKCAL2_DX_LOOP_RST_CFG
          when write_10E =>
            -- 24.33024G : "0000000000000100"
            -- 12.16512G : "0000000000000000"
            -- 8.11008G  : "0000000000000000"
            -- 10.1376G  : "0000000000000000"
            -- 9.8304G   : "0000000000000000"
            -- 6.144G    : "0000000000000000"
            -- 4.9512G   : "0000000000000000"
            -- 3.072G    : "0000000000000000"
            -- 2.4576G   : "0000000000000000"
            -- 1.2288G   : "0000000000000000"
            -- 0.6144G   : "0000000000000000"
            gt_daddr(9 downto 8) <= "01";
            gt_daddr(7 downto 0) <= x"0E";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000100";
              when "01000000000" =>
                gt_di            <= "0000000000000000";
              when "00100000000" =>
                gt_di            <= "0000000000000000";
              when "00010000000" =>
                gt_di            <= "0000000000000000";
              when "00001000000" =>
                gt_di            <= "0000000000000000";
              when "00000100000" =>
                gt_di            <= "0000000000000000";
              when "00000010000" =>
                gt_di            <= "0000000000000000";
              when "00000001000" =>
                gt_di            <= "0000000000000000";
              when "00000000100" =>
                gt_di            <= "0000000000000000";
              when "00000000010" =>
                gt_di            <= "0000000000000000";
              when others =>
                gt_di            <= "0000000000000000";
            end case;
            speed_sm_state <= wait_for_10E_rdy;
          when wait_for_10E_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_F7;
            end if;

          -- F7 holds CKCAL1_CFG_0
          when write_F7 =>
            -- 24.33024G : "0100000001000000"
            -- 12.16512G : "1100000011000000"
            -- 8.11008G  : "1100000011000000"
            -- 10.1376G  : "1100000011000000"
            -- 9.8304G   : "1100000011000000"
            -- 6.144G    : "1100000011000000"
            -- 4.9512G   : "1100000011000000"
            -- 3.072G    : "1100000011000000"
            -- 2.4576G   : "1100000011000000"
            -- 1.2288G   : "1100000011000000"
            -- 0.6144G   : "1100000011000000"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"F7";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0100000001000000";
              when "01000000000" =>
                gt_di            <= "1100000011000000";
              when "00100000000" =>
                gt_di            <= "1100000011000000";
              when "00010000000" =>
                gt_di            <= "1100000011000000";
              when "00001000000" =>
                gt_di            <= "1100000011000000";
              when "00000100000" =>
                gt_di            <= "1100000011000000";
              when "00000010000" =>
                gt_di            <= "1100000011000000";
              when "00000001000" =>
                gt_di            <= "1100000011000000";
              when "00000000100" =>
                gt_di            <= "1100000011000000";
              when "00000000010" =>
                gt_di            <= "1100000011000000";
              when others =>
                gt_di            <= "1100000011000000";
            end case;
            speed_sm_state <= wait_for_F7_rdy;
          when wait_for_F7_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_F8;
            end if;

          -- F8 holds CKCAL1_CFG_1
          when write_F8 =>
            -- 24.33024G : "0001000001000000"
            -- 12.16512G : "0001000011000000"
            -- 8.11008G  : "0001000011000000"
            -- 10.1376G  : "0001000011000000"
            -- 9.8304G   : "0001000011000000"
            -- 6.144G    : "0001000011000000"
            -- 4.9512G   : "0001000011000000"
            -- 3.072G    : "0001000011000000"
            -- 2.4576G   : "0001000011000000"
            -- 1.2288G   : "0001000011000000"
            -- 0.6144G   : "0001000011000000"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"F8";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0001000001000000";
              when "01000000000" =>
                gt_di            <= "0001000011000000";
              when "00100000000" =>
                gt_di            <= "0001000011000000";
              when "00010000000" =>
                gt_di            <= "0001000011000000";
              when "00001000000" =>
                gt_di            <= "0001000011000000";
              when "00000100000" =>
                gt_di            <= "0001000011000000";
              when "00000010000" =>
                gt_di            <= "0001000011000000";
              when "00000001000" =>
                gt_di            <= "0001000011000000";
              when "00000000100" =>
                gt_di            <= "0001000011000000";
              when "00000000010" =>
                gt_di            <= "0001000011000000";
              when others =>
                gt_di            <= "0001000011000000";
            end case;
            speed_sm_state <= wait_for_F8_rdy;
          when wait_for_F8_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_F9;
            end if;

          -- F9 holds CKCAL2_CFG_0
          when write_F9 =>
            -- 24.33024G : "0100000001000000"
            -- 12.16512G : "1100000011000000"
            -- 8.11008G  : "1100000011000000"
            -- 10.1376G  : "1100000011000000"
            -- 9.8304G   : "1100000011000000"
            -- 6.144G    : "1100000011000000"
            -- 4.9512G   : "1100000011000000"
            -- 3.072G    : "1100000011000000"
            -- 2.4576G   : "1100000011000000"
            -- 1.2288G   : "1100000011000000"
            -- 0.6144G   : "1100000011000000"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"F9";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0100000001000000";
              when "01000000000" =>
                gt_di            <= "1100000011000000";
              when "00100000000" =>
                gt_di            <= "1100000011000000";
              when "00010000000" =>
                gt_di            <= "1100000011000000";
              when "00001000000" =>
                gt_di            <= "1100000011000000";
              when "00000100000" =>
                gt_di            <= "1100000011000000";
              when "00000010000" =>
                gt_di            <= "1100000011000000";
              when "00000001000" =>
                gt_di            <= "1100000011000000";
              when "00000000100" =>
                gt_di            <= "1100000011000000";
              when "00000000010" =>
                gt_di            <= "1100000011000000";
              when others =>
                gt_di            <= "1100000011000000";
            end case;
            speed_sm_state <= wait_for_F9_rdy;
          when wait_for_F9_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_FA;
            end if;

          -- FA holds TXDRV_FREQBAND
          when read_FA =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"FA";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_FAr_rdy;
          when wait_for_FAr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_FA;
            end if;
          when write_FA =>
            -- 24.33024G : "11"
            -- 12.16512G : "00"
            -- 8.11008G  : "00"
            -- 10.1376G  : "00"
            -- 9.8304G   : "00"
            -- 6.144G    : "00"
            -- 4.9512G   : "00"
            -- 3.072G    : "00"
            -- 2.4576G   : "00"
            -- 1.2288G   : "00"
            -- 0.6144G   : "00"
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 11) & "11" & rdata(8 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 11) & "00" & rdata(8 downto 0);
            end case;
            speed_sm_state <= wait_for_FA_rdy;
          when wait_for_FA_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_9B;
            end if;

          -- 9B holds RX_DFE_KL_LPM_KH_CFG0
          when read_9B =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"9B";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_9Br_rdy;
          when wait_for_9Br_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_9B;
            end if;
          when write_9B =>
            -- 24.33024G : "01"
            -- 12.16512G : "11"
            -- 8.11008G  : "11"
            -- 10.1376G  : "11"
            -- 9.8304G   : "11"
            -- 6.144G    : "11"
            -- 4.9512G   : "11"
            -- 3.072G    : "11"
            -- 2.4576G   : "11"
            -- 1.2288G   : "11"
            -- 0.6144G   : "11"
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 10) & "01" & rdata(7 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 0);
            end case;
            speed_sm_state <= wait_for_9B_rdy;
          when wait_for_9B_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_9D;
            end if;

          -- 9D holds TXFE_CFG0
          when write_9D =>
            -- 24.33024G : "0000001111000110"
            -- 12.16512G : "0000001111000010"
            -- 8.11008G  : "0000001111000010"
            -- 10.1376G  : "0000001111000010"
            -- 9.8304G   : "0000001111000010"
            -- 6.144G    : "0000001111000010"
            -- 4.9512G   : "0000001111000010"
            -- 3.072G    : "0000001111000010"
            -- 2.4576G   : "0000001111000010"
            -- 1.2288G   : "0000001111000010"
            -- 0.6144G   : "0000001111000010"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"9D";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000001111000110";
              when "01000000000" =>
                gt_di            <= "0000001111000010";
              when "00100000000" =>
                gt_di            <= "0000001111000010";
              when "00010000000" =>
                gt_di            <= "0000001111000010";
              when "00001000000" =>
                gt_di            <= "0000001111000010";
              when "00000100000" =>
                gt_di            <= "0000001111000010";
              when "00000010000" =>
                gt_di            <= "0000001111000010";
              when "00000001000" =>
                gt_di            <= "0000001111000010";
              when "00000000100" =>
                gt_di            <= "0000001111000010";
              when "00000000010" =>
                gt_di            <= "0000001111000010";
              when others =>
                gt_di            <= "0000001111000010";
            end case;
            speed_sm_state <= wait_for_9D_rdy;
          when wait_for_9D_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_A1;
            end if;

          -- A1 holds TXFE_CFG1
          when write_A1 =>
            -- 24.33024G : "1111100000000000"
            -- 12.16512G : "0110110000000000"
            -- 8.11008G  : "0110110000000000"
            -- 10.1376G  : "0110110000000000"
            -- 9.8304G   : "0110110000000000"
            -- 6.144G    : "0110110000000000"
            -- 4.9512G   : "0110110000000000"
            -- 3.072G    : "0110110000000000"
            -- 2.4576G   : "0110110000000000"
            -- 1.2288G   : "0110110000000000"
            -- 0.6144G   : "0110110000000000"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"A1";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "1111100000000000";
              when "01000000000" =>
                gt_di            <= "0110110000000000";
              when "00100000000" =>
                gt_di            <= "0110110000000000";
              when "00010000000" =>
                gt_di            <= "0110110000000000";
              when "00001000000" =>
                gt_di            <= "0110110000000000";
              when "00000100000" =>
                gt_di            <= "0110110000000000";
              when "00000010000" =>
                gt_di            <= "0110110000000000";
              when "00000001000" =>
                gt_di            <= "0110110000000000";
              when "00000000100" =>
                gt_di            <= "0110110000000000";
              when "00000000010" =>
                gt_di            <= "0110110000000000";
              when others =>
                gt_di            <= "0110110000000000";
            end case;
            speed_sm_state <= wait_for_A1_rdy;
          when wait_for_A1_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_53;
            end if;

          -- 53 holds TXFE_CFG2
          when write_53 =>
            -- 24.33024G : "1111100000000000"
            -- 12.16512G : "0110110000000000"
            -- 8.11008G  : "0110110000000000"
            -- 10.1376G  : "0110110000000000"
            -- 9.8304G   : "0110110000000000"
            -- 6.144G    : "0110110000000000"
            -- 4.9512G   : "0110110000000000"
            -- 3.072G    : "0110110000000000"
            -- 2.4576G   : "0110110000000000"
            -- 1.2288G   : "0110110000000000"
            -- 0.6144G   : "0110110000000000"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"53";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "1111100000000000";
              when "01000000000" =>
                gt_di            <= "0110110000000000";
              when "00100000000" =>
                gt_di            <= "0110110000000000";
              when "00010000000" =>
                gt_di            <= "0110110000000000";
              when "00001000000" =>
                gt_di            <= "0110110000000000";
              when "00000100000" =>
                gt_di            <= "0110110000000000";
              when "00000010000" =>
                gt_di            <= "0110110000000000";
              when "00000001000" =>
                gt_di            <= "0110110000000000";
              when "00000000100" =>
                gt_di            <= "0110110000000000";
              when "00000000010" =>
                gt_di            <= "0110110000000000";
              when others =>
                gt_di            <= "0110110000000000";
            end case;
            speed_sm_state <= wait_for_53_rdy;
          when wait_for_53_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_54;
            end if;

          -- 54 holds TXFE_CFG3
          when write_54 =>
            -- 24.33024G : "1111100000000000"
            -- 12.16512G : "0110110000000000"
            -- 8.11008G  : "0110110000000000"
            -- 10.1376G  : "0110110000000000"
            -- 9.8304G   : "0110110000000000"
            -- 6.144G    : "0110110000000000"
            -- 4.9512G   : "0110110000000000"
            -- 3.072G    : "0110110000000000"
            -- 2.4576G   : "0110110000000000"
            -- 1.2288G   : "0110110000000000"
            -- 0.6144G   : "0110110000000000"
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"54";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= "1111100000000000";
              when "01000000000" =>
                gt_di            <= "0110110000000000";
              when "00100000000" =>
                gt_di            <= "0110110000000000";
              when "00010000000" =>
                gt_di            <= "0110110000000000";
              when "00001000000" =>
                gt_di            <= "0110110000000000";
              when "00000100000" =>
                gt_di            <= "0110110000000000";
              when "00000010000" =>
                gt_di            <= "0110110000000000";
              when "00000001000" =>
                gt_di            <= "0110110000000000";
              when "00000000100" =>
                gt_di            <= "0110110000000000";
              when "00000000010" =>
                gt_di            <= "0110110000000000";
              when others =>
                gt_di            <= "0110110000000000";
            end case;
            speed_sm_state <= wait_for_54_rdy;
          when wait_for_54_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_8C;
            end if;

          -- 8C holds RX_DFE_KL_LPM_KL_CFG0 and RX_SUM_DEGEN_AVTT_OVERITE
          when read_8C =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"8C";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_8Cr_rdy;
          when wait_for_8Cr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_8C;
            end if;
          when write_8C =>
            -- 24.33024G : "01" & "1"
            -- 12.16512G : "11" & "1"
            -- 8.11008G  : "11" & "1"
            -- 10.1376G  : "11" & "1"
            -- 9.8304G   : "11" & "1"
            -- 6.144G    : "11" & "1"
            -- 4.9512G   : "11" & "1"
            -- 3.072G    : "11" & "0"
            -- 2.4576G   : "11" & "0"
            -- 1.2288G   : "11" & "0"
            -- 0.6144G   : "11" & "0"
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 10) & "01" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "1" & rdata(3 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "0" & rdata(3 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "0" & rdata(3 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "0" & rdata(3 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 10) & "11" & rdata(7 downto 5) & "0" & rdata(3 downto 0);
            end case;
            speed_sm_state <= wait_for_8C_rdy;
          when wait_for_8C_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_D0;
            end if;

          -- D0 holds RX_DEGEN_CTRL
          when read_D0 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"D0";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_D0r_rdy;
          when wait_for_D0r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_D0;
            end if;
          when write_D0 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "01000000000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "00100000000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "00010000000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "00001000000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "00000100000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "00000010000" =>
                gt_di            <= rdata(15 downto 7) & "111" & rdata(3 downto 0);
              when "00000001000" =>
                gt_di            <= rdata(15 downto 7) & "100" & rdata(3 downto 0);
              when "00000000100" =>
                gt_di            <= rdata(15 downto 7) & "100" & rdata(3 downto 0);
              when "00000000010" =>
                gt_di            <= rdata(15 downto 7) & "100" & rdata(3 downto 0);
              when others =>
                gt_di            <= rdata(15 downto 7) & "100" & rdata(3 downto 0);
            end case;
            speed_sm_state <= wait_for_D0_rdy;
          when wait_for_D0_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_75;
            end if;

          -- 75 holds RXPI_CFG0
          when write_75 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"75";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0011000000000100"
            -- 12.16512G : "0000000100000010"
            -- 8.11008G  : "0011000000000010" (QPLL0)
            --             "0000000100000000" (QPLL1)
            -- 10.1376G  : "0000000100000000"
            -- 9.8304G   : "0000000100000000"
            -- 6.144G    : "0000001100000001"
            -- 4.9512G   : "0000001100000001"
            -- 3.072G    : "0000001100000001"
            -- 2.4576G   : "0000001100000001"
            -- 1.2288G   : "0000001100000001"
            -- 0.6144G   : "0000001100000001"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0011000000000100";
              when "01000000000" =>
                gt_di            <= "0000000100000010";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0011000000000010";
                else
                  gt_di            <= "0000000100000000";
                end if;
              when "00010000000" =>
                gt_di            <= "0000000100000000";
              when "00001000000" =>
                gt_di            <= "0000000100000000";
              when "00000100000" =>
                gt_di            <= "0000001100000001";
              when "00000010000" =>
                gt_di            <= "0000001100000001";
              when "00000001000" =>
                gt_di            <= "0000001100000001";
              when "00000000100" =>
                gt_di            <= "0000001100000001";
              when "00000000010" =>
                gt_di            <= "0000001100000001";
              when others =>
                gt_di            <= "0000001100000001";
            end case;
            speed_sm_state <= wait_for_75_rdy;
          when wait_for_75_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_D2;
            end if;

          -- D2 holds RXPI_CFG1
          when write_D2 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"D2";
            gt_den               <= '1';
            gt_dwe               <= '1';
            -- 24.33024G : "0000000000000000"
            -- 12.16512G : "0000000001010100"
            -- 8.11008G  : "0000000001010100" (QPLL0)
            --             "0000000001010100" (QPLL1)
            -- 10.1376G  : "0000000001010100"
            -- 9.8304G   : "0000000001010100"
            -- 6.144G    : "0000000011111100"
            -- 4.9512G   : "0000000011111100"
            -- 3.072G    : "0000000011111100"
            -- 2.4576G   : "0000000011111100"
            -- 1.2288G   : "0000000011111100"
            -- 0.6144G   : "0000000011111100"
            case speed_select is
              when "10000000000" =>
                gt_di            <= "0000000000000000";
              when "01000000000" =>
                gt_di            <= "0000000001010100";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di            <= "0000000001010100";
                else
                  gt_di            <= "0000000001010100";
                end if;
              when "00010000000" =>
                gt_di            <= "0000000001010100";
              when "00001000000" =>
                gt_di            <= "0000000001010100";
              when "00000100000" =>
                gt_di            <= "0000000011111100";
              when "00000010000" =>
                gt_di            <= "0000000011111100";
              when "00000001000" =>
                gt_di            <= "0000000011111100";
              when "00000000100" =>
                gt_di            <= "0000000011111100";
              when "00000000010" =>
                gt_di            <= "0000000011111100";
              when others =>
                gt_di            <= "0000000011111100";
            end case;
            speed_sm_state <= wait_for_D2_rdy;
          when wait_for_D2_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_27;
            end if;

          -- 27 holds ALIGN_COMMA_WORD & ALIGN_COMMA_ENABLE
          when read_27 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"27";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_27r_rdy;
          when wait_for_27r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_27;
            end if;
          when write_27 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= "001" & rdata(12 downto 10) & "0000000000";
              when others =>
                gt_di <= "100" & rdata(12 downto 10) & "1111111111";
            end case;
            speed_sm_state <= wait_for_27_rdy;
          when wait_for_27_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_55;
            end if;

          -- 55 holds ALIGN_MCOMMA_DET
          when read_55 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"55";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_55r_rdy;
          when wait_for_55r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_55;
            end if;
          when write_55 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 11) & "0" & rdata(9 downto 0);
              when others =>
                gt_di <= rdata(15 downto 11) & "1" & rdata(9 downto 0);
            end case;
            speed_sm_state <= wait_for_55_rdy;
          when wait_for_55_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_56;
            end if;

          -- 56 holds ALIGN_PCOMMA_DET
          when read_56 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"56";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_56r_rdy;
          when wait_for_56r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_56;
            end if;
          when write_56 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 11) & "0" & rdata(9 downto 0);
              when others =>
                gt_di <= rdata(15 downto 11) & "1" & rdata(9 downto 0);
            end case;
            speed_sm_state <= wait_for_56_rdy;
          when wait_for_56_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_1E;
            end if;

          -- 1E holds CLK_COR_SEQ_1_1
          when read_1E =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"1E";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_1Er_rdy;
          when wait_for_1Er_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_1E;
            end if;
          when write_1E =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_1E_rdy;
          when wait_for_1E_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_1F;
            end if;

          -- 1F holds CLK_COR_SEQ_1_2
          when read_1F =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"1F";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_1Fr_rdy;
          when wait_for_1Fr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_1F;
            end if;
          when write_1F =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_1F_rdy;
          when wait_for_1F_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_20;
            end if;

          -- 20 holds CLK_COR_SEQ_1_3
          when read_20 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"20";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_20r_rdy;
          when wait_for_20r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_20;
            end if;
          when write_20 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_20_rdy;
          when wait_for_20_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_21;
            end if;

          -- 21 holds CLK_COR_SEQ_1_4
          when read_21 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"21";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_21r_rdy;
          when wait_for_21r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_21;
            end if;
          when write_21 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_21_rdy;
          when wait_for_21_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_22;
            end if;

          -- 22 holds CLK_COR_SEQ_2_1
          when read_22 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"22";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_22r_rdy;
          when wait_for_22r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_22;
            end if;
          when write_22 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_22_rdy;
          when wait_for_22_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_23;
            end if;

          -- 23 holds CLK_COR_SEQ_2_2
          when read_23 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"23";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_23r_rdy;
          when wait_for_23r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_23;
            end if;
          when write_23 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_23_rdy;
          when wait_for_23_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_24;
            end if;

          -- 24 holds CLK_COR_SEQ_2_3
          when read_24 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"24";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_24r_rdy;
          when wait_for_24r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_24;
            end if;
          when write_24 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_24_rdy;
          when wait_for_24_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_25;
            end if;

          -- 25 holds CLK_COR_SEQ_2_4
          when read_25 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"25";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_25r_rdy;
          when wait_for_25r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_25;
            end if;
          when write_25 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 10) & "0000000000";
              when others =>
                gt_di <= rdata(15 downto 10) & "0100000000";
            end case;
            speed_sm_state <= wait_for_25_rdy;
          when wait_for_25_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_CD;
            end if;

          -- CD holds DEC_MCOMMA_DETECT
          when read_CD =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"CD";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_CDr_rdy;
          when wait_for_CDr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_CD;
            end if;
          when write_CD =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 1) & "0";
              when others =>
                gt_di <= rdata(15 downto 1) & "1";
            end case;
            speed_sm_state <= wait_for_CD_rdy;
          when wait_for_CD_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_2C;
            end if;

          -- 2C holds DEC_PCOMMA_DETECT
          when read_2C =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"2C";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_2Cr_rdy;
          when wait_for_2Cr_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_2C;
            end if;
          when write_2C =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= "0" & rdata(14 downto 0);
              when others =>
                gt_di <= "1" & rdata(14 downto 0);
            end case;
            speed_sm_state <= wait_for_2C_rdy;
          when wait_for_2C_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_99;
            end if;

          -- 99 holds GEARBOX_MODE
          when read_99 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"99";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_99r_rdy;
          when wait_for_99r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_99;
            end if;
          when write_99 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= "10001" & rdata(10 downto 0);
              when others =>
                gt_di <= "00000" & rdata(10 downto 0);
            end case;
            speed_sm_state <= wait_for_99_rdy;
          when wait_for_99_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_64;
            end if;

          -- 64 holds RXGEARBOX_EN, RXBUF_EN and RX_XCLK_SEL
          when read_64 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"64";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_64r_rdy;
          when wait_for_64r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_64;
            end if;
          when write_64 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 4) & "1001";
              when others =>
                gt_di <= rdata(15 downto 4) & "0010";
            end case;
            speed_sm_state <= wait_for_64_rdy;
          when wait_for_64_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_03;
            end if;

          -- 03 holds RX_DATA_WIDTH
          when read_03 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"03";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_03r_rdy;
          when wait_for_03r_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_03;
            end if;
          when write_03 =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 9) & "0110" & rdata(4 downto 0);
              when others =>
                gt_di <= rdata(15 downto 9) & "0101" & rdata(4 downto 0);
            end case;
            speed_sm_state <= wait_for_03_rdy;
          when wait_for_03_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= write_C6;
            end if;

          -- C6 holds RX_PROGDIV_CFG
          -- 24330.24Mbps: RX_PROGDIV_CFG = 16.5 (E218)
          -- 12165.12Mbps: RX_PROGDIV_CFG = 33.0 (E200)
          -- 10137.6Mbps:  RX_PROGDIV_CFG = 33.0 (E200)
          -- 8110.08Mbps:  RX_PROGDIV_CFG = 66.0 (E202) QPLL0
          -- 8110.08Mbps:  RX_PROGDIV_CFG = 33.0 (E200) QPLL1
          -- 9830.4Mbps:   RX_PROGDIV_CFG = 16.0 (E042)
          -- 6144.0Mbps:   RX_PROGDIV_CFG = 10.0 (E060)
          -- 4915.2Mbps:   RX_PROGDIV_CFG = 8.0  (E040)
          -- 3072.0Mbps:   RX_PROGDIV_CFG = 10.0 (E060)
          -- 2457.6Mbps:   RX_PROGDIV_CFG = 8.0  (E040)
          -- 1228.8Mbps:   RX_PROGDIV_CFG = 8.0  (E040)
          -- 614.4Mbps:    RX_PROGDIV_CFG = 8.0  (E040)
          when write_C6 =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"C6";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" =>
                gt_di            <= x"E218";
              when "01000000000" | "00010000000" =>
                gt_di            <= x"E200";
              when "00100000000" =>
                if (qpll_select = '0') then
                  gt_di          <= x"E202";
                else
                  gt_di          <= x"E200";
                end if;
              when "00001000000" =>
                gt_di            <= x"E042";
              when "00000100000" | "00000001000" =>
                gt_di            <= x"E060";
              when others =>
                gt_di            <= x"E040";
            end case;
            speed_sm_state <= wait_for_C6_rdy;
          when wait_for_C6_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_0A;
            end if;

          -- 0A holds TX_FIFO_BYP_EN
          when read_0A =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"0A";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_0Ar_rdy;
          when wait_for_0Ar_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_0A;
            end if;
          when write_0A =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"0A";
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 1) & '0'; -- UG578 is wrong TX_FIFO_BYP_EN is bit 0 not bit 3
              when others =>
                gt_di <= rdata(15 downto 1) & '1';
            end case;
            speed_sm_state <= wait_for_0A_rdy;
          when wait_for_0A_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              speed_sm_state <= read_7A;
            end if;

          -- 7A holds TX_DATA_WIDTH and TX_XCLK_SEL
          when read_7A =>
            gt_daddr(9 downto 8) <= "00";
            gt_daddr(7 downto 0) <= x"7A";
            gt_den               <= '1';
            gt_dwe               <= '0';
            speed_sm_state <= wait_for_7Ar_rdy;
          when wait_for_7Ar_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              rdata <= gt_do;
              speed_sm_state <= write_7A;
            end if;
          when write_7A =>
            gt_den               <= '1';
            gt_dwe               <= '1';
            case speed_select is
              when "10000000000" | "01000000000" | "00100000000" | "00010000000" =>
                gt_di <= rdata(15 downto 11) & '0' & rdata(9 downto 4) & "0110";
              when others =>
                gt_di <= rdata(15 downto 11) & '1' & rdata(9 downto 4) & "0111";
            end case;
            speed_sm_state <= wait_for_7A_rdy;
          when wait_for_7A_rdy =>
            gt_den               <= '0';
            gt_dwe               <= '0';
            if (gt_drdy = '1') then
              if wait_for_cpll_lock = '1' then
                speed_sm_state <= wait_for_lock;
              else
                speed_sm_state <= reset_gt;
              end if;
            end if;
          when wait_for_lock =>
            sm_busy_i <= '0';
            if cplllkdet = '1' then
              speed_sm_state <= reset_gt;
            end if;
          when reset_gt =>
            sm_busy_i <= '0';
            gt_reset_req_toggle_i <= not(gt_reset_req_toggle_i);
            if (speed_select(10 downto 7) /= "0000" or speed_select = "00000000000") then
              speed_sm_state <= idle;
            else
              speed_sm_state <= wait_for_cpll_reset;
            end if;
          when wait_for_cpll_reset =>
            if cpllreset = '1' then
              speed_sm_state <= wait_for_cplllock_low;
            end if;
          when wait_for_cplllock_low =>
            if cplllkdet = '0' then
              speed_sm_state <= wait_for_cplllock_high;
            end if;
          when wait_for_cplllock_high =>
            if cplllkdet = '1' then
              speed_sm_state <= idle;
            end if;
          when others =>
            speed_sm_state <= idle;
        end case;
      end if;
    end if;
  end process;

  -- Assign outputs
  sm_busy <= sm_busy_i;
  gt_reset_req_toggle <= gt_reset_req_toggle_i;

end rtl;
