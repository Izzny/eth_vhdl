library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Ethernet_TX is
    Port (
        -- Clock and reset
        clk        : in  std_logic;
        rst        : in  std_logic;
        
        -- MII TX Interface
        tx_clk     : in  std_logic;
        tx_en      : out std_logic;
        tx_data    : out std_logic_vector(3 downto 0);
        
        -- Transmission inputs
        allow_packet : in std_logic;
        frame_data  : in std_logic_vector(127 downto 0);
        start_transmit : in std_logic
    );
end Ethernet_TX;

architecture Behavioral of Ethernet_TX is

    signal tx_buffer : std_logic_vector(127 downto 0) := (others => '0');
    signal byte_count : integer := 0;
    signal transmitting : std_logic := '0';
    
begin
    
    -- Transmit frame process
    process(tx_clk)  -- Removed `rst` from sensitivity list
    begin
        if rising_edge(tx_clk) then
            if rst = '1' then
                tx_en <= '0';
                tx_data <= (others => '0');
                transmitting <= '0';
                byte_count <= 0;
            elsif start_transmit = '1' and allow_packet = '1' and transmitting = '0' then
                tx_buffer <= frame_data;
                transmitting <= '1';
                byte_count <= 0;
                tx_en <= '1';
                tx_data <= frame_data(127 downto 124); -- Send the first 4 bits
            elsif transmitting = '1' then
                if byte_count < 31 then
                    tx_data <= tx_buffer(127 downto 124); -- Send top 4 bits
                    tx_buffer <= tx_buffer(123 downto 0) & "0000"; -- Shift left by 4
                    byte_count <= byte_count + 1;
                else
                    tx_en <= '0';
                    transmitting <= '0';
                end if;
            else
                tx_en <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
