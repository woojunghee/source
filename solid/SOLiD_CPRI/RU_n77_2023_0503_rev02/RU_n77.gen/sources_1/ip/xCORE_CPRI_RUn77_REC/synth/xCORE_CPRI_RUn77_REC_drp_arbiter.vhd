-- Title      : DRP Arbiter for CPRI block
-- Project    : cpri_v8_11_14
-----------------------------------------------------------------------
-- File       : xCORE_CPRI_RUn77_REC_drp_arbiter.vhd
-- Author     : Xilinx
-----------------------------------------------------------------------
-- Description: The DRP arbiter ensures that 1 accessor is able to
--              have the bus for as long as is needed.
--              This allows the core and the user to use the DRP bus.
--              and ensures that read / modify writes are continuous
--              However the arbiter does not enforce this and
--              requires that the users comply with req / gnt
-----------------------------------------------------------------------
-- (c) Copyright 2004 - 2013 Xilinx, Inc. All rights reserved. 
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

entity xCORE_CPRI_RUn77_REC_drp_arbiter is

  port (
    clk   : in std_logic;
    reset : in std_logic;
    -- Core DRP
    core_drp_arb_req : in  std_logic;
    core_drp_arb_gnt : out std_logic;
    core_drp_dout    : in  std_logic_vector(15 downto 0);
    core_drp_daddr   : in  std_logic_vector(9 downto 0);
    core_drp_dwe     : in  std_logic;
    core_gt_din      : out std_logic_vector(15 downto 0);    
    core_gt_den      : in  std_logic;
    core_gt_drdy     : out std_logic;
    -- User DRP - GT only
    user_drp_arb_req  : in  std_logic;
    user_drp_arb_gnt  : out std_logic;
    user_drp_dout     : in  std_logic_vector(15 downto 0);
    user_drp_daddr    : in  std_logic_vector(9 downto 0);
    user_drp_dwe      : in  std_logic;
    user_gt_din       : out std_logic_vector(15 downto 0);    
    user_gt_den       : in  std_logic;
    user_gt_drdy      : out std_logic;
    -- State machine DRP
    sm_drp_arb_req    : in  std_logic;
    sm_drp_arb_gnt    : out std_logic;
    sm_drp_dout       : in  std_logic_vector(15 downto 0);
    sm_drp_daddr      : in  std_logic_vector(9 downto 0);
    sm_drp_dwe        : in  std_logic;
    sm_gt_din         : out std_logic_vector(15 downto 0);    
    sm_gt_den         : in  std_logic;
    sm_gt_drdy        : out std_logic;
    --- DRP Outputs
    drp_arb_req       : out std_logic;
    drp_arb_gnt       : in  std_logic;
    drp_dout          : out std_logic_vector(15 downto 0);
    drp_daddr         : out std_logic_vector(9 downto 0);
    drp_dwe           : out std_logic;
    gt_din            : in  std_logic_vector(15 downto 0);    
    gt_den            : out std_logic;
    gt_drdy           : in  std_logic
  );
  
end xCORE_CPRI_RUn77_REC_drp_arbiter;

-------------------------------------------------------------------------------


architecture rtl of xCORE_CPRI_RUn77_REC_drp_arbiter is
  type STATE_TYPE is (IDLE, GNT_core, GNT_USER, GNT_sm);
  signal fsm_cs              : STATE_TYPE;
  signal fsm_ns              : STATE_TYPE;
  signal drp_arb_req_i       : std_logic;
  signal core_drp_arb_gnt_i  : std_logic;
  signal user_drp_arb_gnt_i  : std_logic;
  signal sm_drp_arb_gnt_i    : std_logic;
  
begin

  drp_dout  <= core_drp_dout  when fsm_cs = GNT_core else
               sm_drp_dout when fsm_cs = GNT_sm else
               user_drp_dout;
  drp_daddr <= core_drp_daddr when fsm_cs = GNT_core else
               sm_drp_daddr when fsm_cs = GNT_sm else
               user_drp_daddr;

  drp_dwe       <= core_drp_dwe when fsm_cs = GNT_core else sm_drp_dwe when fsm_cs = GNT_sm else user_drp_dwe;
  gt_den        <= core_gt_den when fsm_cs = GNT_core else sm_gt_den when fsm_cs = GNT_sm else user_gt_den;
  core_gt_din   <= gt_din;
  user_gt_din   <= gt_din;
  sm_gt_din     <= gt_din;
  core_gt_drdy  <= gt_drdy when fsm_cs = GNT_core else '0';
  user_gt_drdy  <= gt_drdy when fsm_cs = GNT_USER else '0';
  sm_gt_drdy    <= gt_drdy when fsm_cs = GNT_sm else '0';

  state_p : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        fsm_cs <= IDLE;
      else
        fsm_cs <= fsm_ns;
      end if;
    end if;
  end process;

  next_state_p : process(core_drp_arb_req, user_drp_arb_req, sm_drp_arb_req, drp_arb_gnt, fsm_cs)
  begin
    --Default assignments for the requesters
    core_drp_arb_gnt_i  <= '0';
    user_drp_arb_gnt_i  <= '0';
    sm_drp_arb_gnt_i    <= '0';
    
    case fsm_cs is
      when IDLE =>
        -- Simple priority arbitration
        if core_drp_arb_req = '1' and drp_arb_gnt = '1' then
          fsm_ns <= GNT_core;
        elsif user_drp_arb_req = '1' and drp_arb_gnt = '1' then
          fsm_ns <= GNT_USER;
        elsif sm_drp_arb_req = '1' and drp_arb_gnt = '1' then
          fsm_ns <= GNT_sm;
        else
          fsm_ns <= IDLE;
        end if;        
      when GNT_core =>
        core_drp_arb_gnt_i <= '1';
        if (core_drp_arb_req = '0' or drp_arb_gnt = '0') then
          fsm_ns <= IDLE;
        else
          fsm_ns <= GNT_core;
        end if;
      when GNT_USER=>
        user_drp_arb_gnt_i <= '1';
        if (user_drp_arb_req = '0' or drp_arb_gnt = '0') then
          fsm_ns <= IDLE;
        else
          fsm_ns <= GNT_USER;
        end if;
      when GNT_sm=>
        sm_drp_arb_gnt_i <= '1';
        if (sm_drp_arb_req = '0' or drp_arb_gnt = '0') then
          fsm_ns <= IDLE;
        else
          fsm_ns <= GNT_sm;
        end if;
      when others =>
        fsm_ns <= IDLE;
    end case;
  end process;
  
  drp_arb_req_i <= core_drp_arb_req or user_drp_arb_req or sm_drp_arb_req;
  
  -- Register the state machine combinatorial output.
  reg_gnt_p : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        core_drp_arb_gnt  <= '0';
        user_drp_arb_gnt  <= '0';
        sm_drp_arb_gnt    <= '0';
        drp_arb_req       <= '0';
      else
        core_drp_arb_gnt  <= core_drp_arb_gnt_i;
        user_drp_arb_gnt  <= user_drp_arb_gnt_i;
        sm_drp_arb_gnt    <= sm_drp_arb_gnt_i;
        drp_arb_req       <= drp_arb_req_i;
      end if;
    end if;
  end process;
        
end rtl;
