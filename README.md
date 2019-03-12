# Introduction 
I made this project to experiment with processor design and to understand topics
such as paging, segmentation, branch prediction and protection rings. This 
project demonstrates how an 8-Bit processor can be implemented and does not
implement any existing architectures.  

The following processor features will be implemented:
* Basic logical operations (and, or, not, xor)
* Basic comparison operations (Less-than, Equals)
* Basic branching operations (jump non-conditional, conditional jump)
* Basic memory access operations (read, write)
* Protection Rings (such as real, for OS, and protected modes for programs)
* Segmentation (for code, data and stack in protected mode)
* Paging (with 256 byte pages)
* Interrupts

# Register Map
![Register Map](https://docs.google.com/drawings/d/e/2PACX-1vSF-PthyUAP-zF97gdNV2D4nN0EQKxJt4iW48JPhNAF4zAdomu0ihIHaXag0rTDXatp69aeBcFj2l8z/pub?w=898&amp;h=1551)

# Instruction Set

The following instruction table is meant to be a short hand of the instructions. There is no description and interpretation can be ambiguous. No full documentation of the instruction set has yet been made. 

| Code        | Operation                   | Short Name     | Equation                           |
| :---------- |:--------------------------- | :------------- | :--------------------------------- |
| 00000000    | No Operation                | NOP            |                                    |
| 00000001    | Jump Back                   | JBN            | PC ← RTN                           |
| 00000010    | Increment Stack Pointer     | ISP            | SP ← SP+1                          |
| 00000011    | Decrement Stack Pointer     | DSP            | SP ← SP-1                          |
| 00000100    | Read Return Register        | RRN            | A ← RTN                            |
| 00000101    | Write Return Register       | WRN            | A → RTN                            |
| 00000110    | Not Accumulator             | NOT            | A ← !A                             |
| 00000111    | Read Flags                  | RDF            | Flags → A                          |
| 000010Rg    | And                         | AND            | REG(Rg) & A → A                    |
| 000011Rg    | Or                          | OR             | REG(Rg) \| A → A                   |
| 000100Rg    | Xor                         | XOR            | REG(Rg) ^ A → A                    |
| 000101Rg    | Add                         | ADD            | REG(Rg) + A → A                    |
| 000110Rg    | Compare Equals              | EQ             | REG(Rg) = A → A                    |
| 000111Rg    | Compare Less Than           | LT             | REG(Rg) \< A → A                   |
| 0010AdDa    | Write Low                   | WRL            | REG(Da)[7:0] → MEM(REG(Ad))        |
| 0011AdDa    | Write High                  | WRH            | REG(Da)[15:8] → MEM(REG(Ad))       |
| 0100AdDt    | Read Low                    | RDL            | MEM(REG(Ad)) → REG(Dt)[7:0]        |
| 0101AdDt    | Read High                   | RDH            | MEM(REG(Ad)) → REG(Dt)[15:8]       |
| 0110CnGt    | Conditional Jump            | CJP            | if[REG(Cn) != 0] then REG(Gt) → PC |
| 0111AmDt    | Roll Left                   | ROL            | REG(Dt) << REG(Am)                 |
| 1000ScDt    | Copy                        | CPY            | REG(Dt) ← REG(Sc)                  |
| 1001S1S2    | Swap                        | SWP            | REG(S1) ↔ REG(S2)                  |
| 101000Dt    | Read Stack Pointer          | RSP            | SP → REG(Dt)                       |
| 101001Sc    | Write Stack Pointer         | RSP (real)     | SP ← REG(Sc)                       |
| 101010Gt    | Non-Conditional Jump (prot) | NCP            | PC ← REG(Gt); MODE ← 1             |
| 101011Gt    | Non-Conditional Jump (real) | NCR (real)     | PC ← REG(Gt); MODE ← 0             |
| 10110000    | Set CS (real)               | SCS (real)     | A  → CS                            |
| 10110001    | Set CE (real)               | SCE (real)     | A  → CE                            |
| 10110010    | Set DS (real)               | SDS (real)     | A  → DS                            |
| 10110011    | Set DE (real)               | SDE (real)     | A  → DE                            |
| 10110100    | Set SS (real)               | SSS (real)     | A  → SS                            |
| 10110101    | Set SE (real)               | SSE (real)     | A  → SE                            |
| 10110110    | Not Used                    |                |                                    |
| 10110111    | Get Amount of Memory        | GAM            | A  ← Max(MEM)                      |
| 10111000    | Not Used                    |                |                                    |
| 10111001    | Not Used                    |                |                                    |
| 10111010    | Not Used                    |                |                                    |
| 10111011    | Not Used                    |                |                                    |
| 10111100    | Sofware Interrupt 0         | SW0            |                                    |
| 10111101    | Sofware Interrupt 1         | SW1            |                                    |
| 10111110    | Sofware Interrupt 2         | SW2            |                                    |
| 10111111    | Sofware Interrupt 3         | SW3            |                                    |
| 11DtValu    | Set Value                   | SVL            | REG(Dt) ← 000000000000Valu         |

# Code
The processor is implemented in VHDL and is stored in the vhdl folder. Each type of component in stored in a folder with the same name as that component. Each folder in vhdl/ is filled with at-least three items, a behavioral implementation of the component, a test bench for the component and a Makefile. The Makefile supports two directives: test and clean. Test runs the test bench and clean removes all intermediate files. 

That's It!
