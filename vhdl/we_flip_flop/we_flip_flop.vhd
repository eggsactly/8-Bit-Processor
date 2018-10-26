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

-- we_flip_flop stands for write enable flip flop
entity we_flip_flop is 
generic (
    -- Initial value after reset
    initVal    :     integer := 0
);
port ( 
    clk     : in  std_logic;
    rst     : in  std_logic;
    wrEn    : in  std_logic;
    iData   : in  std_logic_vector;
    oData   : out std_logic_vector
);
end we_flip_flop;

architecture behavioral of we_flip_flop is 
    signal reg : std_logic_vector(iData'RANGE);
begin

    oData <= reg;

    writeReg : process (clk) is
    begin
        if rising_edge(clk) 
        then 
            if rst = '1' 
            then
                reg <= std_logic_vector(to_signed(initVal, reg'LENGTH));
            else
                if wrEn = '1' 
                then
                    reg <= iData;
                else
                    reg <= reg;
                end if;
            end if;
        end if;
    end process writeReg;

end behavioral;
