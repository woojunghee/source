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
-------------------------------------------------------------------------------
-- Filename:        xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper.vhd
-- Version:         v1.00.a
-- Description:     A simple wrapper to convert between aloowed generics etc
--                 in verilog and those used in the axi_ipif block
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library axi_lite_ipif_v3_0_4; 
use axi_lite_ipif_v3_0_4.ipif_pkg.calc_num_ce;
use axi_lite_ipif_v3_0_4.ipif_pkg.INTEGER_ARRAY_TYPE;
use axi_lite_ipif_v3_0_4.ipif_pkg.SLV64_ARRAY_TYPE;


ENTITY xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper IS
  PORT (
    S_AXI_ACLK : IN STD_LOGIC;
    S_AXI_ARESETN : IN STD_LOGIC;
    S_AXI_AWADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_AWVALID : IN STD_LOGIC;
    S_AXI_AWREADY : OUT STD_LOGIC;
    S_AXI_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    S_AXI_WVALID : IN STD_LOGIC;
    S_AXI_WREADY : OUT STD_LOGIC;
    S_AXI_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_BVALID : OUT STD_LOGIC;
    S_AXI_BREADY : IN STD_LOGIC;
    S_AXI_ARADDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_ARVALID : IN STD_LOGIC;
    S_AXI_ARREADY : OUT STD_LOGIC;
    S_AXI_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    S_AXI_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    S_AXI_RVALID : OUT STD_LOGIC;
    S_AXI_RREADY : IN STD_LOGIC;
    Bus2IP_Clk : OUT STD_LOGIC;
    Bus2IP_Resetn : OUT STD_LOGIC;
    Bus2IP_Addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    Bus2IP_RNW : OUT STD_LOGIC;
    Bus2IP_BE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    Bus2IP_RdCE : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    Bus2IP_WrCE : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    Bus2IP_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    IP2Bus_Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    IP2Bus_WrAck : IN STD_LOGIC;
    IP2Bus_RdAck : IN STD_LOGIC;
    IP2Bus_Error : IN STD_LOGIC
  );
END xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper;

ARCHITECTURE xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper_arch OF xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper IS
  
BEGIN
  U0 : entity axi_lite_ipif_v3_0_4.axi_lite_ipif
    GENERIC MAP (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001FF",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_ARD_ADDR_RANGE_ARRAY => (X"0000_0000_0000_0000",
                                 X"0000_0000_0000_00FF"),
      C_ARD_NUM_CE_ARRAY => (1, 0),
      C_FAMILY => "virtex7"
    )
    PORT MAP (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      Bus2IP_Clk => Bus2IP_Clk,
      Bus2IP_Resetn => Bus2IP_Resetn,
      Bus2IP_Addr => Bus2IP_Addr,
      Bus2IP_RNW => Bus2IP_RNW,
      Bus2IP_BE => Bus2IP_BE,
      Bus2IP_RdCE => Bus2IP_RdCE,
      Bus2IP_WrCE => Bus2IP_WrCE,
      Bus2IP_Data => Bus2IP_Data,
      IP2Bus_Data => IP2Bus_Data,
      IP2Bus_WrAck => IP2Bus_WrAck,
      IP2Bus_RdAck => IP2Bus_RdAck,
      IP2Bus_Error => IP2Bus_Error
    );
END xCORE_CPRI_RUn77_RE_axi_lite_ipif_wrapper_arch;
