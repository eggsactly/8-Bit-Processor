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
entity instruction_decode_tb is
end instruction_decode_tb;

architecture sim of instruction_decode_tb is

    component instruction_decode is port ( 
        ISTRCT  : in  std_logic_vector(7 downto 0);
        ALU_Op  : out std_logic_vector(2 downto 0);
        branch  : out std_logic
    );
    end component;

    -- Declare signals
    constant Clk_period : time                          := 10 ns;
    signal ISTRCT : std_logic_vector(7 downto 0);
    signal ALU_Op : std_logic_vector(2 downto 0) := (others => '0');
    signal branch : std_logic;
    signal CLK : std_logic := '1';
    signal runTest : std_logic := '1';

-- Instantiate all components below
begin
    -- Instatiate alu
    instDec : instruction_decode 
    port map ( 
        ISTRCT  => ISTRCT,
        ALU_Op  => ALU_Op,
        branch  => branch
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
        -- We have to create an arbitraily large number for a string (super annoying)
        variable errorMessage : String(1 to 4096);
        variable result       : Boolean;
        variable accumulatedResult : Boolean := true;
    begin

    

    -- End the test
    assert (not accumulatedResult) report "Tests Successful" severity note;
    assert accumulatedResult report "Tests Failed" severity note;
    assert false report "end of test." severity note;
    runTest <= '0';
    -- Wait forever, this will finish the simulation
    wait;

    end process;
end sim; 
