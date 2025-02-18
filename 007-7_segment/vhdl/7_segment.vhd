library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity 7_segment is
    generic (
        CLK_FREQ : integer := 100_000_000
    );
    port (
        clk   : in  std_logic;
        rst_n : in  std_logic;

        -- 7 segment display
        CA : out std_logic;
        CB : out std_logic;
        CC : out std_logic;
        CD : out std_logic;
        CE : out std_logic;
        CF : out std_logic;
        CG : out std_logic;
        DP : out std_logic
    );
end entity 7_segment;

architecture Behavioral of 7_segment is
    constant SECOND : integer := CLK_FREQ;

    signal hex          : std_logic_vector(3 downto 0) := "0000";
    signal seg          : std_logic_vector(6 downto 0);
    signal time_counter : integer range 0 to SECOND := 0;

    -- Componete do decodificador de 7 segmentos
    component Decoder is 
        port (
            hex : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component Decoder;

begin
    decoder : Decoder 
        port map(
            hex => hex, 
            seg => seg
        );
    
    process(clk, rst_n)
    begin
        if(rst_n = '0') then
            hex          <= "0000";
            time_counter <= 0;
        elsif rising_edge(clk) then
            if time_counter = SECOND then
                time_counter <= 0;
                hex          <= std_logic_vector(unsigned(hex) + 1);
            else
                time_counter <= time_counter + 1;
            end if;
        end if;
    end process;

end architecture Behavioral;
