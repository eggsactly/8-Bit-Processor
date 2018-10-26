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
entity we_flip_flop_tb is
end we_flip_flop_tb;

architecture sim of we_flip_flop_tb is

    component we_flip_flop is 
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
    end component;

    -- Declare signals
    constant Clk_period : time                          := 10 ns;
    signal CLK : std_logic := '1';
    signal runTest : std_logic := '1';

    signal rst     : std_logic := '0';
    signal wrEn    : std_logic                     := '0';
    signal iData   : std_logic_vector(15 downto 0) := (others => '0');
    signal oData   : std_logic_vector(15 downto 0) := (others => '0');

-- Instantiate all components below
begin

    flipFlopInst : we_flip_flop
    generic map (
        -- Initial value after reset
        initVal    => 5
    )
    port map ( 
        clk     => CLK,
        rst     => rst,
        wrEn    => wrEn,
        iData   => iData,
        oData   => oData
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
        variable expectedValue : std_logic_vector(oData'range) 
            := (others => '0');
        -- An arbitraily large number needs to be used
        variable errorMessage : String(1 to 4096);
        variable result       : Boolean;
        variable accumulatedResult : Boolean := true;
    begin

    wait until rising_edge(CLK);

    rst     <= '1';
    iData   <= std_logic_vector(to_unsigned(0, iData'length));
    wrEn    <= '0';

    wait until rising_edge(CLK);

    rst     <= '0';
    iData   <= std_logic_vector(to_unsigned(0, iData'length));
    wrEn    <= '0';

    wait until falling_edge(CLK);

    expectedValue := std_logic_vector(to_unsigned(5, oData'length));
    result := slvAssert(expectedValue, oData, String'("Rst Test 1"));
    accumulatedResult := accumulatedResult and result;

    rst     <= '0';
    iData   <= std_logic_vector(to_unsigned(10, iData'length));
    wrEn    <= '1';

    wait until rising_edge(CLK);

    wait until falling_edge(CLK);

    expectedValue := std_logic_vector(to_unsigned(10, oData'length));
    result := slvAssert(expectedValue, oData, String'("Wr Test 1"));
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

