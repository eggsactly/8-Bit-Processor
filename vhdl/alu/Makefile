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

SIM:=ghdl
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))
SOURCES:=$(wildcard *.vhd)
FLAGS:=--std=08
ELABORATION:=$(CURRENT_DIR)_tb
WAVEFORM:=$(CURRENT_DIR).ghw

.PHONY: test
test: $(ELABORATION) 
	$(SIM) -r $(FLAGS) $(ELABORATION) --wave=$(WAVEFORM)

.PHONY: $(ELABORATION) 
$(ELABORATION): work-obj08.cf
	$(SIM) -e $(FLAGS) $(ELABORATION)

work-obj08.cf: $(SOURCES)
	$(SIM) -a $(FLAGS) $(SOURCES) 

.PHONY: clean
clean:
	rm -f *.cf $(WAVEFORM)

