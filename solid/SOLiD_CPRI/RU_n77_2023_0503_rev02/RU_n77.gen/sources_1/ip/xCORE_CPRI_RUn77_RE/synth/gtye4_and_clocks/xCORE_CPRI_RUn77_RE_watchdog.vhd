-----------------------------------------------------------------------
-- Title      :  Watchdog
-- Project    : cpri_v8_11_14
-----------------------------------------------------------------------
-- File       : xCORE_CPRI_RUn77_RE_watchdog.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description:  Provides watchdog logic to allow the core to reset if 
--               the core fails to achieve hfnsync within a certain time.
--               Watchdog defaults to disabled for Ultrascale parts and
--               to a value of 0x10000000 for 7-series parts. This gives
--               268.4e6 / 125e6 = 2.14 seconds.
-----------------------------------------------------------------------
-- (c) Copyright 2004 - 2018 Xilinx, Inc. All rights reserved. 
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

entity xCORE_CPRI_RUn77_RE_watchdog is
  port(
    clk                      : in  std_logic;
    hfnsync                  : in  std_logic;
    reset                    : in  std_logic;
    watchdog_timeout_value   : in  std_logic_vector(31 downto 0);
    done                     : out std_logic;
    hfnsync_achieved_rising  : out std_logic
  );
end xCORE_CPRI_RUn77_RE_watchdog;

architecture rtl of xCORE_CPRI_RUn77_RE_watchdog is
  -- Define the size of our watchdog timer. Runs from management/aux clock.
  -- Defaults to 125MHz, if the frequency of this clock is not 125MHz please
  -- change the rx_wdog_count to a more suitable value.
  signal rx_wdog_count       : unsigned(31 downto 0) := (others => '0');
  signal hfnsync_achieved    : std_logic;
  signal hfnsync_achieved_d1 : std_logic;

begin

  -- This counter monitors the sync state to determine if it is necessary to redo phase alignment.
  wdog_count_p : process (clk)
  begin
    if rising_edge(clk) then
      if watchdog_timeout_value = x"00000000" or hfnsync = '1' then
        rx_wdog_count <= (others => '0');
        done <= '0';
      elsif rx_wdog_count = unsigned(watchdog_timeout_value) then
        rx_wdog_count <= (others => '0');
        done <= '1';
      else
        rx_wdog_count <= rx_wdog_count + 1;
        done <= '0';
      end if;
    end if;
  end process;

  -- We set this register when sync is achieved. The rising edge detect triggers
  -- the 2nd run of rxsync
  hfnsync_achieved_p : process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        hfnsync_achieved <= '0';
      else
        if hfnsync = '1' then
          hfnsync_achieved <= '1';
        end if;
      end if;
    end if;
  end process;

  hfnsync_achieved_rising_d1_p : process (clk)
  begin
    if rising_edge(clk) then
      hfnsync_achieved_d1 <= hfnsync_achieved;
    end if;
  end process;

  hfnsync_achieved_rising_p : process(clk)
  begin
    if rising_edge(clk) then
      if (hfnsync_achieved_d1 = '0' and hfnsync_achieved = '1') then
        hfnsync_achieved_rising <= '1';
      else
        hfnsync_achieved_rising <= '0';
      end if;
    end if;
  end process;

end rtl;
