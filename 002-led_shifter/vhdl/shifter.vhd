library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shiffter is
    generic (
        CLK_FREQ : integer := 25_000_000 
    );
    port (
        clk  : in  STD_LOGIC;
        rst_n : in  STD_LOGIC;
        leds  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity Shiffter;

architecture Behavioral of Shiffter is
    constant ONE_SECOND          : integer := CLK_FREQ;
    constant HALF_SECOND         : integer := CLK_FREQ / 2;
    constant QUARTER_OF_A_SECOND : integer := CLK_FREQ / 4;

    signal counter : integer range 0 to 2**33-1 := 0;
begin

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            counter <= 0;
            leds <= "00011111";  -- Valor inicial de 8'h1F
        elsif rising_edge(clk) then
            if counter >= QUARTER_OF_A_SECOND then
                counter <= 0;
                leds <= leds(6 downto 0) & leds(7);  -- Rotaciona os bits
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

end architecture Behavioral;
