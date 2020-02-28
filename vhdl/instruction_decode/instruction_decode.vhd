--  This file is part of 8-Bit-Processor.
--
--  8-Bit-Processor is free software: you can redistribute it and/or modify
--  it under the terms of the GNU Lesser General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  8-Bit-Processor is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with 8-Bit-Processor.  If not, see <https://www.gnu.org/licenses/>.

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.NUMERIC_STD.ALL;

entity instruction_decode is port ( 
    -- Input instruction from instruction memory
    ISTRCT  : in  std_logic_vector(7 downto 0);
    -- Output instruction for ALU
    ALU_Op  : out std_logic_vector(2 downto 0);
    -- Trigger to branch
    branch  : out std_logic
);
end instruction_decode;

architecture behavioral of instruction_decode is 
begin
    -- Decoding for ALS
    process(ISTRCT)
    begin
        case ISTRCT(7 downto 2) is
            -- Not
            when "000001" =>
                ALU_Op <= "001";
            -- And
            when "000010" =>
                ALU_Op <= "010";

            -- Or
            when "000011" =>
                ALU_Op <= "011";

            -- Xor
            when "000100" =>
                ALU_Op <= "100";

            -- Add
            when "000101" =>
                ALU_Op <= "000";

            -- Compare Equals
            when "000110" =>
                ALU_Op <= "101";

            -- Compare less than 
            when "000111" =>
                ALU_Op <= "110";

            -- Roll Left
            when "011100" =>
                ALU_Op <= "111";
            when "011101" =>
                ALU_Op <= "111";
            when "011110" =>
                ALU_Op <= "111";
            when "011111" =>
                ALU_Op <= "111";
        end case;
    end process; 

end behavioral;

