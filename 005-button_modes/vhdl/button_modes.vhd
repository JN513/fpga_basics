library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Button_Modes is
    generic (
        CLK_FREQ : integer := 25_000_000
    );
    port (
        clk        : in  std_logic;
        rst_n      : in  std_logic;
        btn        : in  std_logic;
        leds       : out std_logic_vector(7 downto 0)
    );
end entity Button_Modes;

architecture Behavioral of Button_Modes is

    -- Parametros
    constant ONE_SECOND          : integer := CLK_FREQ;
    constant HALF_SECOND         : integer := CLK_FREQ / 2;
    constant QUARTER_OF_A_SECOND : integer := CLK_FREQ / 4;

    -- Estados
    type state_type is (SHIFFTER, COUNTER, FIVES, BLINK, INVERSE_COUNTER);
    signal state       : state_type := SHIFFTER;
    signal led_counter : std_logic_vector(7 downto 0) := "00000000";
    signal counter     : integer := 0;
    signal button_pressed : std_logic := '0';

    -- Debounce
    signal debouncing_counter : integer := 0;
    signal btn_reg            : std_logic := '0';

begin

    -- Máquina de estados
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                state       <= SHIFFTER;
                leds        <= "00011111"; -- LEDs iniciais
                counter     <= 0;
                led_counter <= "00000000";
            else
                case state is
                    when SHIFFTER =>
                        if counter >= QUARTER_OF_A_SECOND then
                            counter <= 0;
                            leds <= leds(6 downto 0) & leds(7); -- Rotacionar LEDs
                        else
                            counter <= counter + 1;
                        end if;
                        
                        if button_pressed = '1' then
                            state <= COUNTER;
                            leds <= "00000000";
                            counter <= 0;
                        end if;
                    
                    when COUNTER =>
                        if counter >= HALF_SECOND then
                            counter <= 0;
                            led_counter <= std_logic_vector(unsigned(led_counter) + 1);
                        else
                            counter <= counter + 1;
                        end if;
                        
                        leds <= led_counter;
                        
                        if button_pressed = '1' then
                            state <= FIVES;
                            leds <= "01010101";
                            counter <= 0;
                        end if;

                    when FIVES =>
                        if counter >= QUARTER_OF_A_SECOND then
                            counter <= 0;
                            leds <= leds(6 downto 0) & leds(7);
                        else
                            counter <= counter + 1;
                        end if;

                        if button_pressed = '1' then
                            state <= BLINK;
                            leds <= "11111111";
                            counter <= 0;
                        end if;

                    when BLINK =>
                        if counter >= HALF_SECOND then
                            counter <= 0;
                            leds <= not leds;
                        else
                            counter <= counter + 1;
                        end if;

                        if button_pressed = '1' then
                            state <= INVERSE_COUNTER;
                            leds <= "11111111";
                            counter <= 0;
                        end if;

                    when INVERSE_COUNTER =>
                        if counter >= HALF_SECOND then
                            counter <= 0;
                            led_counter <= std_logic_vector(unsigned(led_counter) - 1);
                        else
                            counter <= counter + 1;
                        end if;

                        leds <= led_counter;

                        if button_pressed = '1' then
                            state <= SHIFFTER;
                            leds <= "00011111";
                            counter <= 0;
                        end if;

                    when others =>
                        state <= SHIFFTER;
                        leds <= "00011111";
                        counter <= 0;
                end case;
            end if;
        end if;
    end process;

    -- Lógica de debounce
    process(clk)
    begin
        if rising_edge(clk) then
            btn_reg <= btn;
            if rst_n = '0' then
                debouncing_counter <= 0;
                button_pressed <= '0';
            else
                if btn_reg = '1' then
                    debouncing_counter <= debouncing_counter + 1;
                else
                    debouncing_counter <= 0;
                end if;

                if debouncing_counter >= HALF_SECOND then
                    debouncing_counter <= 0;
                    button_pressed <= '1';
                end if;
            end if;
        end if;
    end process;

end architecture Behavioral;
