library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.ALL;

entity Ethernet_TB is
end Ethernet_TB;

architecture Behavioral of Ethernet_TB is
    
    -- Component Declaration for the Top-Level Module
    component Ethernet_Top
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
            frame_data : out std_logic_vector(127 downto 0)
        );
    end component;

    -- Signals for Simulation
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal rx_clk    : std_logic := '0';
    signal rx_dv     : std_logic := '0';
    signal rx_data   : std_logic_vector(3 downto 0) := (others => '0');
    signal tx_clk    : std_logic := '0';
    signal tx_en     : std_logic;
    signal tx_data   : std_logic_vector(3 downto 0);
    signal start_transmit : std_logic := '0';
    signal frame_data : std_logic_vector(127 downto 0);
    signal valid_frame : std_logic;
    signal allow_packet : std_logic;

    -- Clock Generation
    constant clk_period : time := 10 ns;

begin
    
    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.Ethernet_Top
    port map (
        clk           => clk,
        rst           => rst,
        rx_clk        => rx_clk,
        rx_dv         => rx_dv,
        rx_data       => rx_data,
        tx_clk        => tx_clk,
        tx_en         => tx_en,
        tx_data       => tx_data,
        start_transmit => start_transmit,
        frame_data    => frame_data
    );
    
    -- Clock Process
    clk_process: process
    begin
        while now < 1 ms loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
        wait;
    end process;
    
    -- RX Clock Process
    rx_clk_process: process
    begin
        while now < 1 ms loop
            rx_clk <= '0';
            wait for clk_period;
            rx_clk <= '1';
            wait for clk_period;
        end loop;
        wait;
    end process;
    
    -- TX Clock Process
    tx_clk_process: process
    begin
        while now < 1 ms loop
            tx_clk <= '0';
            wait for clk_period;
            tx_clk <= '1';
            wait for clk_period;
        end loop;
        wait;
    end process;
    
    -- Stimulus Process
    stimulus_process: process
    begin
        -- Reset the system
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        -- Send sample Ethernet frame that will be allowed
        rx_dv <= '1';
        rx_data <= "1010";
        wait for 10 ns;
        rx_data <= "1100";
        wait for 10 ns;
        rx_data <= "1111";
        wait for 10 ns;
        rx_dv <= '0';

        -- Start transmission
        start_transmit <= '1';
        wait for 50 ns;
        start_transmit <= '0';

        -- Wait and observe TX behavior
        wait for 500 ns;

        -- Send sample Ethernet frame that will be blocked
        rx_dv <= '0';
        rx_data <= "0000";
        wait for 10 ns;
        rx_data <= "0000";
        wait for 10 ns;
        rx_data <= "0000";
        wait for 10 ns;
        rx_dv <= '0';

        -- Start transmission
        start_transmit <= '1';
        wait for 50 ns;
        start_transmit <= '0';

        -- Wait and observe TX behavior
        wait for 500 ns;

        -- End simulation
        wait;
    end process;

    -- Monitoring Process
    monitoring_process: process
    begin
        while true loop
            wait until rising_edge(clk);
            if allow_packet = '1' then
                report "PACKET ALLOWED THROUGH FILTER!";
            end if;
            wait for 10 ns; -- Add a wait statement to avoid continuous reporting
        end loop;
    end process;
    
end Behavioral;
