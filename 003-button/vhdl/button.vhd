library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Button is
    generic (
        CLK_FREQ : integer := 25_000_000
    );
    port (
        clk    : in  std_logic;
        rst_n  : in  std_logic;
        btn    : in  std_logic;
        led    : out std_logic
    );
end entity Button;

architecture Behavioral of Button is
    signal debouncing  : std_logic_vector(2 downto 0);
    signal posedge_btn : std_logic;
    signal negedge_btn : std_logic;
    signal high_btn    : std_logic;
begin

    -- Bloco de controle do led
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            led <= '0';
        elsif (rising_edge(clk)) then
            led <= high_btn;
        end if;
    end process;

    -- Bloco de debouncing do botão
    process(clk, rst_n)
    begin
        if (rst_n = '0') then
            debouncing <= "000";
        elsif (rising_edge(clk)) then
            debouncing <= debouncing(1 downto 0) & btn;
        end if;
    end process;

    -- Assignments para detecção de bordas
    high_btn <= '1' when (debouncing(2 downto 1) = "11") else '0';
    posedge_btn <= '1' when (debouncing(2 downto 1) = "01") else '0';
    negedge_btn <= '1' when (debouncing(2 downto 1) = "10") else '0';

end architecture Behavioral;
