library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Semaphore is
    generic (
        CLK_FREQ : integer := 100_000_000
    );
    port (
        clk        : in  std_logic;
        rst_n      : in  std_logic;
        pedestrian : in  std_logic;
        green      : out std_logic;
        yellow     : out std_logic;
        red        : out std_logic
    );
end entity Semaphore;

architecture Behavioral of Semaphore is
    
    -- Time constants
    constant SECOND       : integer := CLK_FREQ;
    constant OPENING_TIME : integer := 5 * SECOND;
    constant CLOSING_TIME : integer := 7 * SECOND;

    -- State enumeration
    type state_t is (CLOSED, OPENING, OPEN, CLOSING);
    signal state : state_t;
    signal time_counter : integer range 0 to CLOSING_TIME;

begin

    process (clk, rst_n)
    begin
        if rst_n = '0' then
            state        <= CLOSED;
            time_counter <= 0;
        elsif rising_edge(clk) then
            case state is
                when CLOSED =>
                    if time_counter = OPENING_TIME then
                        state        <= OPENING;
                        time_counter <= 0;
                    else
                        time_counter <= time_counter + 1;
                    end if;
                when OPENING =>
                    state <= OPEN;
                when OPEN =>
                    if time_counter = CLOSING_TIME or pedestrian = '1' then
                        state        <= CLOSING;
                        time_counter <= 0;
                    else
                        time_counter <= time_counter + 1;
                    end if;
                when CLOSING =>
                    state <= CLOSED;
                when others =>
                    state <= CLOSED;
            end case;
        end if;
    end process;

    process (state)
    begin
        case state is
            when CLOSED =>
                green  <= '0';
                yellow <= '0';
                red    <= '1';
            when OPENING | CLOSING =>
                green  <= '0';
                yellow <= '1';
                red    <= '0';
            when OPEN =>
                green  <= '1';
                yellow <= '0';
                red    <= '0';
            when others =>
                green  <= '0';
                yellow <= '0';
                red    <= '1';
        end case;
    end process;

end architecture Behavioral;
