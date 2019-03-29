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

use std.textio.all; -- Imports the standard textio package.

library processor;
use processor.processor_package.all;

--  A testbench has no ports.
entity memory_tb is
end memory_tb;

architecture sim of memory_tb is
    component memory is 
    generic (
        -- Number memory cells
        CELLS    :     natural          := 1024
    );
    port ( 
        clk    : in  std_logic;
        rst    : in  std_logic;
        addr1  : in  std_logic_vector(
            positive(ceil(log2(real(CELLS))))-1 downto 0);
        addr2  : in  std_logic_vector(
            positive(ceil(log2(real(CELLS))))-1 downto 0);
        iData  : in  std_logic_vector;
        wr     : in  std_logic;
        oData1 : out std_logic_vector;
        oData2 : out std_logic_vector
    );
    end component;

    -- Declare signals
    constant Clk_period : time                          := 10 ns;
    signal CLK          : std_logic                     := '1';
    signal runTest      : std_logic                     := '1';

    signal rst          : std_logic                     := '0';
    signal addr1        : std_logic_vector(9 downto 0)  := (others => '0');
    signal iData        : std_logic_vector(15 downto 0) := (others => '0');
    signal wr           : std_logic                     := '0';
    signal addr2        : std_logic_vector(9 downto 0)  := (others => '0');
    signal oData1       : std_logic_vector(15 downto 0) := (others => '0');
    signal oData2       : std_logic_vector(15 downto 0) := (others => '0');

-- Instantiate all components below
begin
    -- Instatiate memory
    memoryInst : memory 
    generic map (
        CELLS => 1024
    )
    port map ( 
        clk    => clk,
        rst    => rst,
        addr1  => addr1,
        addr2  => addr2,
        iData  => iData,
        wr     => wr,
        oData1 => oData1,
        oData2 => oData2
    );

    -- Create the clock
    clockProc : process
    begin
        if runTest = '1' then
            wait for Clk_period/2;
            CLK <= not CLK;
        else
            wait;
        end if;
    end process;


    ----------------------------------------
    -- testProc implements the unit tests --
    ----------------------------------------

    testProc : process 
        variable myLine : line; 
        variable expectedValue1 : std_logic_vector(oData1'range) 
            := (others => '0');
        variable expectedValue2 : std_logic_vector(oData2'range) 
            := (others => '0');
        -- An arbitraily large number needs to be used
        variable errorMessage : String(1 to 4096);
        variable result       : Boolean;
        variable accumulatedResult : Boolean := true;
    begin

    wait until rising_edge(CLK);

    rst     <= '1';
    addr1   <= std_logic_vector(to_unsigned(0, addr1'length));
    iData   <= std_logic_vector(to_unsigned(0, iData'length));
    wr      <= '0';
    addr2   <= std_logic_vector(to_unsigned(0, addr2'length));

    wait until rising_edge(CLK);

    rst     <= '0';
    addr1   <= std_logic_vector(to_unsigned(1, addr1'length));
    iData   <= std_logic_vector(to_unsigned(2, iData'length));
    wr      <= '1';
    addr2   <= std_logic_vector(to_unsigned(1, addr2'length));

    wait until falling_edge(CLK);

    expectedValue1 := std_logic_vector(to_unsigned(0, oData1'length));
    expectedValue2 := std_logic_vector(to_unsigned(0, oData2'length));

    result := slvAssert(expectedValue1, oData1, String'("Rst Test 1 addr1"));
    accumulatedResult := accumulatedResult and result;
    result := slvAssert(expectedValue2, oData2, String'("Rst Test 1 addr2"));
    accumulatedResult := accumulatedResult and result;    

    wait until rising_edge(CLK);

    rst     <= '0';
    addr1   <= std_logic_vector(to_unsigned(1, addr1'length));
    iData   <= std_logic_vector(to_unsigned(2, iData'length));
    wr      <= '0';
    addr2   <= std_logic_vector(to_unsigned(1, addr2'length));

    wait until falling_edge(CLK);

    expectedValue1 := std_logic_vector(to_unsigned(2, oData1'length));
    expectedValue2 := std_logic_vector(to_unsigned(2, oData2'length));

    result := slvAssert(expectedValue1, oData1, String'("Read Test 1 addr1"));
    accumulatedResult := accumulatedResult and result;
    result := slvAssert(expectedValue2, oData2, String'("Read Test 1 addr2"));
    accumulatedResult := accumulatedResult and result;    

    wait until rising_edge(CLK);

    -- End the test
    assert (not accumulatedResult) report "Tests Successful" severity note;
    assert accumulatedResult report "Tests Failed" severity note;
    assert false report "end of test." severity note;
    runTest <= '0';
    -- Wait forever, this will finish the simulation
    wait;

    end process;
end sim; 

