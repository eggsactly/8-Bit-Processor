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

entity register_file is 
generic (
    -- Number of registers in the file
    REGS    :     natural          := 4
);
port ( 
    clk     : in  std_logic;
    rst     : in  std_logic;
    addr1   : in  std_logic_vector(positive(ceil(log2(real(REGS))))-1 downto 0);
    iData1  : in  std_logic_vector;
    wrEn1   : in  std_logic;
    addr2   : in  std_logic_vector(positive(ceil(log2(real(REGS))))-1 downto 0);
    iData2  : in  std_logic_vector;
    wrEn2   : in  std_logic;
    oData1  : out std_logic_vector;
    oData2  : out std_logic_vector
);
end register_file;

architecture behavioral of register_file is 
    constant ADDR_SIZE      : positive := positive(ceil(log2(real(REGS))));
    -- Set the register to be the same width as the data 
    type     registerFileType is array(0 to REGS-1) 
        of std_logic_vector(iData1'range); 
    signal   registers      : registerFileType := (others=>(others=>'0'));
begin

    -- Process to write to the address 
    writeRegFile : process (clk) is
    begin
        if rising_edge(clk) 
        then 
            if rst = '1' 
            then
                for I in 0 to REGS-1 
                loop
                    registers(I) <= std_logic_vector(
                        to_unsigned(0, iData1'length));
                end loop;
            else
                -- If the same address is being written to at the same time, 
                -- prefer addr1
                if(wrEn1 = '1' and wrEn2 = '1' 
                    and unsigned(addr1) = unsigned(addr2)) 
                then
                    registers(to_integer(unsigned(addr1))) <= iData1;
                -- If one or none addresses are being written to
                else

                    -- Write register at address 1
                    if(wrEn1 = '1') then
                        registers(to_integer(unsigned(addr1))) <= iData1;
                    end if;

                    -- Write register at address 2
                    if(wrEn2 = '1') then
                        registers(to_integer(unsigned(addr2))) <= iData2;
                    end if;

                end if;
            end if;
        end if;
    end process writeRegFile;

    -- Process to read register at address 1, acts like a mux
    readReg1 : process (addr1, registers) is
    begin
		oData1 <= registers(to_integer(unsigned(addr1)));
    end process readReg1;

    -- Process to read register at address 2, acts like a mux
    readReg2 : process (addr2, registers) is
    begin
		oData2 <= registers(to_integer(unsigned(addr2)));
    end process readReg2;

    

end behavioral;

