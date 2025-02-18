library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hamming_code is
    port (
        data_in  : in  std_logic_vector(3 downto 0);
        data_out : out std_logic_vector(6 downto 0)
    );
end entity hamming_code;

architecture Behavioral of hamming_code is
    
begin
    
    data_out(0) <= data_in(0) xor data_in(1) xor data_in(3);
    data_out(1) <= data_in(0) xor data_in(2) xor data_in(3);
    data_out(2) <= data_in(0);
    data_out(3) <= data_in(1) xor data_in(2) xor data_in(3);
    data_out(4) <= data_in(1);
    data_out(5) <= data_in(2);
    data_out(6) <= data_in(3);

end architecture Behavioral;