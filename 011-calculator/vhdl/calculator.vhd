library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Calculator is
    port (
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        switchs : in  std_logic_vector(3 downto 0);
        A       : in  std_logic_vector(7 downto 0);
        B       : in  std_logic_vector(7 downto 0);
        S       : out std_logic_vector(7 downto 0);
        zero    : out std_logic
    );
end entity Calculator;

architecture Structural of Calculator is

    -- Componente ALU
    component ALU is
        port (
            opcode : in  std_logic_vector(2 downto 0);
            A      : in  std_logic_vector(7 downto 0);
            B      : in  std_logic_vector(7 downto 0);
            result : out std_logic_vector(7 downto 0);
            zero   : out std_logic
        );
    end component;

begin

    -- Instanciação da ALU
    alu_inst : ALU
        port map (
            opcode => switchs(2 downto 0), -- Apenas 3 bits são usados
            A      => A,
            B      => B,
            result => S,
            zero   => zero
        );

end architecture Structural;
