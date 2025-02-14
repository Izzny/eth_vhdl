library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Ethernet_Filter is
    Port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        valid_frame  : in  std_logic;
        mac_dest     : in  std_logic_vector(47 downto 0);
        mac_src      : in  std_logic_vector(47 downto 0);
        eth_type     : in  std_logic_vector(15 downto 0);
        frame_data   : in  std_logic_vector(127 downto 0);
        allow_packet : out std_logic
    );
end Ethernet_Filter;

architecture Behavioral of Ethernet_Filter is

    signal allowed_mac : std_logic_vector(47 downto 0) := X"FFFFFFFFFFFF"; -- Allowed MAC address
    signal allow_packet_sig : std_logic := '0'; -- Prevent 'U' values
    
begin
    
    -- Filtering logic
    process(clk)  -- Removed `rst` from sensitivity list
    begin
        if rising_edge(clk) then
            if rst = '1' then
                allow_packet_sig <= '0';  -- Reset value
            elsif valid_frame = '1' then
                if mac_dest = allowed_mac then  -- Proper MAC filtering
                    allow_packet_sig <= '1';
                else
                    allow_packet_sig <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Ensure output gets correct value
    allow_packet <= allow_packet_sig;
    
end Behavioral;
