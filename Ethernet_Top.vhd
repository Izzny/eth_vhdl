library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Ethernet_Top is
    Port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        rx_clk       : in  std_logic;
        rx_dv        : in  std_logic;
        rx_data      : in  std_logic_vector(3 downto 0);
        tx_clk       : in  std_logic;
        tx_en        : out std_logic;
        tx_data      : out std_logic_vector(3 downto 0);
        start_transmit : in std_logic;
        frame_data   : out std_logic_vector(127 downto 0);
        valid_frame  : out std_logic;
        allow_packet : out std_logic;
        frame_data_debug : out std_logic_vector(7 downto 0)  -- Add this line for debugging
    );
end Ethernet_Top;

architecture Behavioral of Ethernet_Top is

    -- Signals
    signal valid_frame_sig : std_logic := '0';  -- Initialize valid_frame_sig
    signal frame_data_sig  : std_logic_vector(127 downto 0) := (others => '0');  -- Initialize frame_data_sig
    signal allow_packet_sig : std_logic := '0';  -- Initialize allow_packet_sig

begin

    -- RX Module
    RX_Inst : entity work.Ethernet_RX
    port map (
        clk         => clk,
        rst         => rst,
        rx_clk      => rx_clk,
        rx_dv       => rx_dv,
        rx_data     => rx_data,
        valid_frame => valid_frame_sig,
        frame_data  => frame_data_sig  
    );

    -- Filter Module
    Filter_Inst : entity work.Ethernet_Filter
    port map (
        clk          => clk,
        rst          => rst,
        valid_frame  => valid_frame_sig,
        mac_dest     => (others => '0'),
        mac_src      => (others => '0'),
        eth_type     => (others => '0'),
        frame_data   => frame_data_sig,
        allow_packet => allow_packet_sig
    );

    -- TX Module
    TX_Inst : entity work.Ethernet_TX
    port map (
        clk         => clk,
        rst         => rst,
        tx_clk      => tx_clk,
        tx_en       => tx_en,
        tx_data     => tx_data,
        allow_packet => allow_packet_sig,
        frame_data  => frame_data_sig,
        start_transmit => start_transmit
    );

    -- Connect internal signals to top-level ports
    frame_data <= frame_data_sig;
    valid_frame <= valid_frame_sig;
    allow_packet <= allow_packet_sig;
    frame_data_debug <= frame_data_sig(7 downto 0);  -- Extract first 8 bits for debugging

end Behavioral;
