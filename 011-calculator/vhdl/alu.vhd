library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
    port (
        opcode : in std_logic_vector(2 downto 0);
        a      : in std_logic_vector(7 downto 0);
        b      : in std_logic_vector(7 downto 0);
        result : out std_logic_vector(7 downto 0);
        zero   : out std_logic
    );

end entity alu;

architecture Behavior of alu is
    -- Definição do tipo enum para os opcodes
    type alu_opcode_t is (
        AND, OR, ADD, SUB, XOR, NOT
    );

    function to_opcode(op: std_logic_vector(2 downto 0)) return alu_opcode_t is
    begin
        case op is
            when "000" => return AND;
            when "001" => return OR;
            when "010" => return ADD;
            when "011" => return SUB;
            when "100" => return XOR;
            when "101" => return NOT;
            when others => return AND;
        end case;
    end function;

    signal result_reg : std_logic_vector(7 downto 0);
begin
    process (opcode, a, b)
        variable op: alu_opcode_t;
    begin
        op := to_opcode(opcode); -- Converte o opcode para o tipo enum

        case op is
            when AND => result_reg <= a and b;
            when OR  => result_reg <= a or b;
            when ADD => result_reg <= a + b;
            when SUB => result_reg <= a - b;
            when XOR => result_reg <= a xor b;
            when NOT => result_reg <= not a;
            when others => result_reg <= a; -- Default
        end case;
    end process;

    result <= result_reg;
    zero   <= '1' when result_reg = "00000000" else '0';
end architecture Behavior;