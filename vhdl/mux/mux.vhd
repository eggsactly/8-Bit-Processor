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

entity mux is port ( 
    I0  : in  std_logic_vector;
    I1  : in  std_logic_vector;
    Sel : in  std_logic;
    O   : out std_logic_vector
);
end mux;

architecture behavioral of mux is 
begin
    process(I0, I1, Sel)
    begin
        if Sel = '1' then
            O <= I1;
        else
            O <= I0;
        end if;
    end process; 

end behavioral;

