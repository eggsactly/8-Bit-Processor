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

    R <=    R_Assist & std_logic_vector(signed(A) + signed(B)) 
                when Op = std_logic_vector(to_unsigned(0, Op'length)) else
            R_Assist & std_logic_vector(not A)                 
                when Op = std_logic_vector(to_unsigned(1, Op'length)) else
            R_Assist & std_logic_vector(A and B)               
                when Op = std_logic_vector(to_unsigned(2, Op'length)) else
            R_Assist & std_logic_vector(A or B)                
                when Op = std_logic_vector(to_unsigned(3, Op'length)) else
            R_Assist & std_logic_vector(A xor B)               
                when Op = std_logic_vector(to_unsigned(4, Op'length)) else
            R_Assist & Bool_Assist & To_Std_Logic(A = B) 
                when Op = std_logic_vector(to_unsigned(5, Op'length)) else
            R_Assist & Bool_Assist & To_Std_Logic(A < B)
                when Op = std_logic_vector(to_unsigned(6, Op'length)) else
            R_Assist & (A rol natural(to_integer(unsigned(B))))
                when Op = std_logic_vector(to_unsigned(7, Op'length)) else
            std_logic_vector(to_signed(0, R'length));  

end behavioral;

