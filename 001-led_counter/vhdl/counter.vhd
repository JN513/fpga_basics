library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Counter is
    generic (
        CLK_FREQ : integer := 25_000_000
    );
    port (
        clk        : in  STD_LOGIC;
        rst_n      : in  STD_LOGIC;
        leds       : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity Counter;

architecture Behavioral of Counter is
    constant ONE_SECOND  : integer := CLK_FREQ;
    constant HALF_SECOND : integer := CLK_FREQ / 2;
    
    signal counter     : integer range 0 to 2**33-1 := 0;
    signal led_counter : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
begin

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            counter     <= 0;
            led_counter <= "00000000";
        elsif rising_edge(clk) then
            if counter >= HALF_SECOND then
                counter     <= 0;
                led_counter <= std_logic_vector(unsigned(led_counter) + 1);
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    leds <= led_counter;

end architecture Behavioral;
