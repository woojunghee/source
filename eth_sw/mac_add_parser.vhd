
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mac_add_parser is
port(
    clk                 : in  std_logic;
    reset_n             : in  std_logic;
    rx_axis_eth_tdata   : in  std_logic_vector(7 downto 0);
    rx_axis_eth_tvalid  : in  std_logic;
    rx_axis_eth_tlast   : in  std_logic;
    dest_mac_address    : out std_logic_vector(47 downto 0);
    source_mac_address  : out std_logic_vector(47 downto 0);
    d_add_vld           : out std_logic;
    s_add_vld           : out std_logic
    );
end mac_add_parser;

architecture data of mac_add_parser is

signal add_cnt              : integer range 0 to 13;
signal sfd_status           : std_logic_vector(1 downto 0)  := "00";
signal preamble             : std_logic_vector(31 downto 0);
signal mac_address0         : std_logic_vector(47 downto 0);
signal mac_address1         : std_logic_vector(47 downto 0);
signal sfd_rst_n            : std_logic;
signal rx_axis_eth_tdata_s0 : std_logic_vector(7 downto 0);





begin

process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        sfd_rst_n   <= '0';
    else
        if (rx_axis_eth_tvalid = '1' and rx_axis_eth_tlast = '1') then
            sfd_rst_n   <= '0';
        else
            sfd_rst_n   <= '1';
        end if;
    end if;
end if;
end process;


process(clk)
begin
if rising_edge(clk) then
    if (reset_n = '0') then
        preamble     <= (others => '0');
        mac_address0 <= (others => '0');
        mac_address1 <= (others => '0');
        sfd_status   <= "00";
        add_cnt      <= 0;
        d_add_vld    <= '0';
        s_add_vld    <= '0';
    else
        if (sfd_rst_n = '0') then
            preamble     <= (others => '0');
            mac_address0 <= (others => '0');
            mac_address1 <= (others => '0');
            sfd_status   <= "00";
            add_cnt      <= 0;
            d_add_vld    <= '0';
            s_add_vld    <= '0';
        else
            if (rx_axis_eth_tvalid = '1') then
                rx_axis_eth_tdata_s0 <= rx_axis_eth_tdata;
                preamble             <= preamble(23 downto 0) & rx_axis_eth_tdata(3 downto 0) & rx_axis_eth_tdata(7 downto 4);
                mac_address0         <= mac_address0(39 downto 0) & rx_axis_eth_tdata;
                mac_address1         <= mac_address1(39 downto 0) & rx_axis_eth_tdata(3 downto 0) & rx_axis_eth_tdata_s0(7 downto 4);
                if (sfd_status = "00") then
                    if (preamble = x"5555555d") then
                        sfd_status <= "01";
                    elsif (preamble(31 downto 4) = x"555555d") then
                        sfd_status <= "10";
                    else
                        sfd_status <= "00";
                    end if;
                else
                    sfd_status <= sfd_status;
                end if;

                if (sfd_status = "00") then
                    add_cnt <= 0;
                else
                    if (add_cnt = 13) then
                        add_cnt   <= add_cnt;
                        s_add_vld <= '0';
                    elsif (add_cnt = 5) then
                        if (sfd_status = "01") then
                            dest_mac_address <= mac_address0;
                        else
                            dest_mac_address <= mac_address1;
                        end if;
                        d_add_vld   <= '1';
                        add_cnt <= add_cnt + 1;
                    elsif (add_cnt = 8) then
                        d_add_vld   <= '0';
                        add_cnt <= add_cnt + 1;
                    elsif (add_cnt = 11) then
                        if (sfd_status = "01") then
                            source_mac_address <= mac_address0;
                        else
                            source_mac_address <= mac_address1;
                        end if;
                        s_add_vld   <= '1';
                        add_cnt <= add_cnt + 1;
                    else
                        add_cnt <= add_cnt + 1;
                    end if;
                end if;

            end if;
        end if;
    end if;
end if;
end process;





end data;