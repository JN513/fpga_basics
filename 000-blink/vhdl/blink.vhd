LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY blink IS
    GENERIC (
        CLK_FREQ : integer := 25_000_000
    );
    PORT (
        clk   : IN STD_LOGIC;
        rst_n : IN STD_LOGIC;
        led   : OUT STD_LOGIC
    );
END ENTITY blink;

ARCHITECTURE rtl OF blink IS
    constant ONE_SECOND  : integer := CLK_FREQ;
    constant HALF_SECOND : integer := CLK_FREQ / 2;

    SIGNAL counter : INTEGER RANGE 0 TO CLK_FREQ;
    SIGNAL led_reg : STD_LOGIC;

BEGIN
    PROCESS (clk, rst_n)
    BEGIN
        IF rst_n = '0' THEN
            counter <= 0;
            led_reg <= '0';
        ELSIF rising_edge(clk) THEN
            IF counter = HALF_SECOND THEN
                counter <= 0;
                led_reg <= NOT led_reg;
            ELSE
                counter <= counter + 1;
            END IF;
        END IF;
    END PROCESS;

    led <= led_reg;
END ARCHITECTURE rtl;