library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Ethernet_RX is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        rx_clk      : in  std_logic;
        rx_dv       : in  std_logic;
        rx_data     : in  std_logic_vector(3 downto 0);
        valid_frame : out std_logic;
        frame_data  : out std_logic_vector(127 downto 0)
    );
end Ethernet_RX;

architecture Behavioral of Ethernet_RX is
    signal internal_frame_data : std_logic_vector(127 downto 0) := (others => '0');
    signal byte_count : integer := 0; -- Count received bytes
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                internal_frame_data <= (others => '0');
                valid_frame <= '0';
                byte_count <= 0; -- Reset counter
            elsif rx_dv = '1' then
                internal_frame_data <= rx_data & internal_frame_data(127 downto 4); -- Correct shifting
                if byte_count < 31 then
                    byte_count <= byte_count + 1;
                    valid_frame <= '0'; -- Wait until full frame is received
                else
                    valid_frame <= '1'; -- Assert when full frame is received
                end if;
            else
                valid_frame <= '0';
                byte_count <= 0; -- Reset when frame is not valid
            end if;
        end if;
    end process;

    frame_data <= internal_frame_data;
    
end Behavioral;
