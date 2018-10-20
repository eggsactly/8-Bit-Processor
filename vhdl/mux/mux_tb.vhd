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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use std.textio.all; -- Imports the standard textio package.

library processor;
use processor.processor_package.all;

--  A testbench has no ports.
entity mux_tb is
end mux_tb;

architecture sim of mux_tb is

    component mux is port ( 
        I0  : in  std_logic_vector;
        I1  : in  std_logic_vector;
        Sel : in  std_logic;
        O   : out std_logic_vector
    );
    end component;

    -- Declare signals
    constant Clk_period : time                          := 10 ns;
    signal A, B, O : std_logic_vector(15 downto 0);
    signal Sel : std_logic;
    signal CLK : std_logic := '1';
    signal runTest : std_logic := '1';

-- Instantiate all components below
begin
    -- Instatiate alu
    muxInst : mux 
    port map ( 
        I0  => A,
        I1  => B,
        Sel => sel,
        O   => O
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
        variable expectedValue : std_logic_vector(O'range) := (others => '0');
        -- We have to create an arbitraily large number for a string
        variable errorMessage : String(1 to 4096);
        variable result       : Boolean;
        variable accumulatedResult : Boolean := true;
    begin

    -- Select 0
    A <= std_logic_vector(to_unsigned(2, A'length));
    B <= std_logic_vector(to_unsigned(3, B'length));
    sel <= '0';

    wait until rising_edge(CLK);
    expectedValue := A;
    result := slvAssert(expectedValue, O, String'("Mux Test 1"));
    accumulatedResult := accumulatedResult and result;
    
    wait until falling_edge(CLK);
    sel <= '1';

    wait until rising_edge(CLK);
    expectedValue := B;
    result := slvAssert(expectedValue, O, String'("Mux Test 2"));
    accumulatedResult := accumulatedResult and result;

    wait until falling_edge(CLK);
    B <= std_logic_vector(to_unsigned(4, B'length));

    wait until rising_edge(CLK);
    expectedValue := B;
    result := slvAssert(expectedValue, O, String'("Mux Test 3"));
    accumulatedResult := accumulatedResult and result;

    wait until falling_edge(CLK);
    A <= std_logic_vector(to_unsigned(5, A'length));
    sel <= '0';

    wait until rising_edge(CLK);
    expectedValue := A;
    result := slvAssert(expectedValue, O, String'("Mux Test 4"));
    accumulatedResult := accumulatedResult and result;

    wait until falling_edge(CLK);
    A <= std_logic_vector(to_unsigned(6, A'length));

    wait until rising_edge(CLK);
    expectedValue := A;
    result := slvAssert(expectedValue, O, String'("Mux Test 5"));
    accumulatedResult := accumulatedResult and result;

    -- End the test
    assert (not accumulatedResult) report "Tests Successful" severity note;
    assert accumulatedResult report "Tests Failed" severity note;
    assert false report "end of test." severity note;
    runTest <= '0';
    -- Wait forever, this will finish the simulation
    wait;

    end process;
end sim; 
