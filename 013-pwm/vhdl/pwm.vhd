library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm is
    .generic (
        COUNTER_WIDTH : integer := 32;
        CLK_FREQ      : integer := 50_000_000
    );
    port (
        clk        : in std_logic;
        rst_n      : in std_logic;
        duty_cycle : in std_logic_vector( 20 downto 0);
        period     : in std_logic_vector( 20 downto 0);
        pwm_out    : out std_logic
    );
end entity pwm;

architecture Behavior of pwm is
    signal counter: integer range 0 to 2**COUNTER_WIDTH - 1 := 0;
begin
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            counter <= 0;
            pwm_out <= '0';
        elsif rising_edge(clk) then
            if counter = period then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;

            if counter < duty_cycle then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
        end if;
    end process;    
end architecture Behavior;
