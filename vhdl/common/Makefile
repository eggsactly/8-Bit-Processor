#   This file is part of 8-Bit-Processor.
# 
#   8-Bit-Processor is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   8-Bit-Processor is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public License
#   along with 8-Bit-Processor.  If not, see <https://www.gnu.org/licenses/>.

# Declared Variables (Variables that may be changed by the user)
VHDL_SIM?=ghdl
SIM_LIBRARY?=processor
VHDL_VERSION?=08

# Derived Variables (Variables are based on other variables, don't change them)
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
SOURCES:=../common/processor_package.vhd $(wildcard *.vhd)
FLAGS:=--std=$(VHDL_VERSION) --work=$(SIM_LIBRARY)
ELABORATION:=$(CURRENT_DIR)_tb
WAVEFORM:=$(CURRENT_DIR).ghw
LIBRARY_DATABASE:=$(SIM_LIBRARY)-obj$(VHDL_VERSION).cf

.PHONY: test
test: $(ELABORATION) 
	$(VHDL_SIM) -r $(FLAGS) $(ELABORATION) --wave=$(WAVEFORM)

.PHONY: $(ELABORATION) 
$(ELABORATION): $(LIBRARY_DATABASE)
	$(VHDL_SIM) -e $(FLAGS) $(ELABORATION)

$(LIBRARY_DATABASE): $(SOURCES) 
	$(VHDL_SIM) -a $(FLAGS) $^

.PHONY: clean
clean:
	rm -f *.cf $(WAVEFORM)

