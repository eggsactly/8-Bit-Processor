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

package processor_package is
    function slvAssert (
        expected : std_logic_vector;
        actual   : std_logic_vector;
        testName : String)
        return BOOLEAN;
end processor_package;

package body processor_package is

    -- slvAssert function encapsulates the assertion checking code for standard 
    -- logic vectors
    function slvAssert (
        expected : std_logic_vector;
        actual   : std_logic_vector;
        testName : String)
        return BOOLEAN is
        variable myLine : line; 
        -- Strings are not dynamically allocated, so the size 4096 is allocated
        variable errorMessage : String(1 to 4096);
    begin
        write (myLine, String'("Expecting: "));
        hwrite (myLine, expected);
        write (myLine, String'(", Got: "));
        hwrite (myLine, actual);
        write (myLine, String'(" """));
        write (myLine, testName);
        write (myLine, String'(""" failed."));
        assert myLine'length < errorMessage'length; -- make sure S is big enough
        if myLine'length > 0 then
            read(myLine, errorMessage(1 to myLine'length));
        end if;
        assert actual = expected report errorMessage severity error;

        return (actual = expected);
    end slvAssert;

end package body processor_package;
