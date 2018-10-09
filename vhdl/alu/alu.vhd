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

entity alu is port ( 
    A  : in  std_logic_vector;
    B  : in  std_logic_vector;
    Op : in  std_logic_vector(2 downto 0);
    R  : out std_logic_vector
);
end alu;

architecture behavioral of alu is 
    -- R_Assist is used to fill any extra bits from the input operation with 
    -- zeros
    constant R_Assist : std_logic_vector(R'length - A'length - 1 downto 0)
        := (others => '0'); 
    -- R_Assist is used to fill any bits from the length of an input vector with
    -- the length of a std_vector
    constant Bool_Assist : std_logic_vector(A'length - 1 downto 0) 
        := (others => '0');

    function To_Std_Logic(L: BOOLEAN) return std_ulogic is 
    begin 
        if L then 
            return('1'); 
        else 
            return('0'); 
        end if; 
    end function To_Std_Logic; 

    begin

    process(A, B, Op)
    begin
        case to_integer(unsigned(Op)) is
            when 0 =>
                R <= R_Assist & std_logic_vector(signed(A) + signed(B)); 
            when 1 =>
                R <= R_Assist & std_logic_vector(not A);
            when 2 =>
                R <= R_Assist & std_logic_vector(A and B);
            when 3 =>
                R <= R_Assist & std_logic_vector(A or B);
            when 4 =>
                R <= R_Assist & std_logic_vector(A xor B);
            when 5 =>
                R <= R_Assist & Bool_Assist & To_Std_Logic(A = B);
            when 6 =>
                R <= R_Assist & Bool_Assist & To_Std_Logic(A < B);
            when 7 =>
                R <= R_Assist & (A rol natural(to_integer(unsigned(B))));
            when others =>
                R(R'range) <= (others => '0');
        end case;
    end process; 

end behavioral;

