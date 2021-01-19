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

The first two bits of the opcode indicate the length of the instruction. This is made for forward compatibility reasons to add more instructions in the future.
* 00: 1-byte instruction
* 01: 2-byte instruction
* 10: 3-byte instruction
* 11: 4-byte instruction

1 Byte instructions:
| Code     | Operation                   | Short Name     | Equation                                 |
| :--------|:--------------------------- | :------------- | :--------------------------------------- |
| 00000000 | No Operation                | NOP            |                                          |
| 00000001 | Jump Back                   | JBN            | PC ← RTN                                 |
| 00000010 | Increment Stack Pointer     | ISP            | SP ← SP+1                                |
| 00000011 | Decrement Stack Pointer     | DSP            | SP ← SP-1                                |
| 00000100 | Read Return Register        | RRN            | A ← RTN                                  |
| 00000101 | Write Return Register       | WRN            | A → RTN                                  |
| 00000110 | Read Flags                  | RDF            | Flags → A                                |
| 000010Dt | Read Stack Pointer          | RSP            | SP → REG(Dt)                             |
| 000011Sc | Write Stack Pointer         | RSP (real)     | if[MODE = 0] then SP ← REG(Sc)           |
| 000100Gt | Non-Conditional Jump (prot) | NCP            | PC ← REG(Gt); MODE ← 1                   |
| 000101Gt | Non-Conditional Jump (real) | NCR (real)     | if[MODE = 0] then PC ← REG(Gt); MODE ← 0 |
| 000110xx | Not Used                    |                |                                          |
| 000111xx | Not Used                    |                |                                          |
| 0010CnGt | Conditional Jump            | CJP            | if[REG(Cn) != 0] then REG(Gt) → PC       |
| 0011xxxx | Not Used                    |                |                                          |

2-Byte Instructions:
| Code              | Operation                   | Short Name     | Equation                                                              |
| :---------------- |:--------------------------- | :------------- | :-------------------------------------------------------------------- |
| 01000000 00xxDsSc | Not                         | NOT            | REG(Ds) ← !REG(Sc)                                                    |
| 01000000 01DsS1S2 | And                         | AND            | REG(Ds) ← REG(S1) & REG(S2)                                           |
| 01000000 10DsS1S2 | Or                          | OR             | REG(Ds) ← REG(S1) | REG(S2)                                           |
| 01000000 11DsS1S2 | Xor                         | XOR            | REG(Ds) ← REG(S1) ^ REG(S2)                                           |
| 01000001 00DsS1S2 | Compare Equals              | EQ             | REG(Ds) ← REG(S1) = REG(S2)                                           |
| 01000001 01DsS1S2 | Compare Less Than           | LT             | REG(Ds) ← REG(S1) < REG(S2)                                           |
| 01000001 10DsS1S2 | Compare Less Than Or Equals | LE             | REG(Ds) ← REG(S1) ≤ REG(S2)                                           |
| 01000001 11xxxxxx | Not Used (reserved for ALU) |                |                                                                       |
| 01000010 00DsS1S2 | Add                         | ADD            | REG(Ds) ← REG(S1) + REG(S2)[15:0]; CRY ← REG(S1) + REG(S2)[16]        |
| 01000010 01DsS1S2 | Subtract                    | SUB            | REG(Ds) ← REG(S1) - REG(S2)                                           |
| 01000010 10DsS1S2 | Multiply                    | MUL            | REG(Ds) ← (REG(S1) * REG(S2))[15:0]; CRY ← (REG(S1) * REG(S2))[31:16] |
| 01000010 11DsS1S2 | Divide                      | DIV            | REG(Ds) ← REG(S1) / REG(S2); CRY ← REG(S1) % REG(S2)                  |
| 01000011 00xxAmDt | Roll Left                   | ROL            | REG(Dt) << REG(Am)                                                    |
| 01000011 01xxAmDt | Shift Left Logical          | SLL            | REG(Dt) << REG(Am)                                                    |
| 01000011 10xxAmDt | Shift Left Arithmetic       | SLA            | REG(Dt) << REG(Am)                                                    |
| 01000011 11xxAmDt | Shift Right                 | SR             | REG(Dt) << REG(Am)                                                    |
| 01000100 0000AdDa | Write Low                   | WRL            | REG(Da)[7:0] → MEM(REG(Ad))                                           |
| 01000100 0001AdDa | Write High                  | WRH            | REG(Da)[15:8] → MEM(REG(Ad))                                          |
| 01000100 0010AdDa | Read Low                    | RDL            | MEM(REG(Ad)) → REG(Dt)[7:0]                                           |
| 01000100 0011AdDa | Read High                   | RDH            | MEM(REG(Ad)) → REG(Dt)[15:8]                                          |
| 01000100 0100ScDt | Copy                        | CPY            | REG(Dt) ← REG(Sc)                                                     |
| 01000100 0101S1S2 | Swap                        | SWP            | REG(S1) ↔ REG(S2)                                                     |
| 01000100 0110xxDt | Get Carry                   | GCY            | REG(Dt) ← CRY                                                         |
| 01000100 0111xxxx | Not Used                    |                |                                                                       |
| 01000101 000000Sc | Set CS (real)               | SCS (real)     | if[MODE = 0] then REG(Sc) → CS                                        |
| 01000101 000001Sc | Set CE (real)               | SCE (real)     | if[MODE = 0] then REG(Sc) → CE                                        |
| 01000101 000010Sc | Set DS (real)               | SDS (real)     | if[MODE = 0] then REG(Sc) → DS                                        |
| 01000101 000011Sc | Set DE (real)               | SDE (real)     | if[MODE = 0] then REG(Sc) → DE                                        |
| 01000101 000100Sc | Set SS (real)               | SSS (real)     | if[MODE = 0] then REG(Sc) → SS                                        |
| 01000101 000101Sc | Set SE (real)               | SSE (real)     | if[MODE = 0] then REG(Sc) → SE                                        |
| 01000101 000110Sc | Get Amount of Memory        | GAM            | if[MODE = 0] then REG(Sc) ← Max(MEM)                                  |
| 01000110 yyyyyyy  | Software Interrupt          | SWI            | RTN ← PC; PC ← INT(Y); MODE ← 0                                       |
| 01000111 xxxxxxx  | Not Used                    |                |                                                                       |
| 010010Sc yyyyyyy  | Set Software Interrupt      | SSI (real)     | if[MODE = 0] then INT(Y) ← REG(Sc)                                    |

3-Btye Instructions:
| Code                       | Operation                   | Short Name     | Equation                           |
| :------------------------- |:--------------------------- | :------------- | :--------------------------------- |
| 100000Dt yyyyyyyy yyyyyyyy | Set Value                   | SVL            | REG(Dt) ← yyyyyyyyyyyyyyyy         |

# Code
The processor is implemented in VHDL and is stored in the vhdl folder. Each type of component is stored in a folder with the same name as that component. Each folder in vhdl/ is filled with at-least three items, a behavioral implementation of the component, a test bench for the component and a Makefile. The Makefile supports two directives: test and clean. Test runs the test bench and clean removes all intermediate files. 

That's It!
