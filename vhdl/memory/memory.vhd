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
    USE IEEE.math_real.ALL;

entity memory is 
generic (
    -- Number memory cells
    CELLS    :     natural          := 65536
);
port ( 
    clk    : in  std_logic;
    rst    : in  std_logic;
    addr1  : in  std_logic_vector;
    addr2  : in  std_logic_vector;
    iData  : in  std_logic_vector;
    wr     : in  std_logic;
    oData1 : out std_logic_vector;
    oData2 : out std_logic_vector
);
end memory;

architecture behavioral of memory is 
    constant ADDR_SIZE      : positive := positive(ceil(log2(real(CELLS))));
    -- Set the register to be the same width as the data 
    type     memoryArrayType is array(0 to CELLS-1) 
        of std_logic_vector(iData'range); 
    signal   memoryArray      : memoryArrayType := (others=>(others=>'0'));
begin

    -- Process to write to the address 
    writeRegFile : process (clk) is
    begin
        if rising_edge(clk) 
        then 
            if rst = '1' 
            then
                for I in 0 to CELLS-1 
                loop
                    memoryArray(I) <= std_logic_vector(
                        to_unsigned(0, iData'length));
                end loop;
            else
                if wr = '1'
                then
                    memoryArray(to_integer(unsigned(addr2))) <= iData;
                end if;
            end if;
        end if;
    end process writeRegFile;

    -- Process to read memory at address 1, acts like a mux
    readMem1 : process (addr1, memoryArray) is
    begin
		oData1 <= memoryArray(to_integer(unsigned(addr1)));
    end process readMem1;

    -- Process to read memory at address 2, acts like a mux
    readMem2 : process (addr2, memoryArray) is
    begin
		oData2 <= memoryArray(to_integer(unsigned(addr2)));
    end process readMem2;

end behavioral; 
