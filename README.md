# Introduction 
This goal of this project is to create a model of an 8-Bit processor that can host an operating system. The following processor features will be implemented:
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

| Code        | Operation                   | Short Name     | Equation             |
| :---------- |:-------------               | :---------     | :---------           |
| 00000000    | No Operation                | NOP            |                      |
| 00000001    | Jump Back                   | JBN            | PC ← RTN             |
| 00000010    | Increment Stack Pointer     | ISP            | SP ← SP+1            |
| 00000011    | Decrement Stack Pointer     | DSP            | SP ← SP-1            |
| 00000100    | Read Return Register        | RRN            | A ← RTN              |
| 00000101    | Write Return Register       | WRN            | A → RTN              |
| 00000110    | Not Accumulator             | NOT            | A ← !A               |
| 00000111    | Read Flags                  | RDF            | Flags → A            |
| 000010Rg    | And                         | AND            | Rg & A → A           |
| 000011Rg    | Or                          | OR             | Rg \| A → A          |
| 000100Rg    | Xor                         | XOR            | Rg ^ A → A           |
| 000101Rg    | Add                         | ADD            | Rg + A → A           |
| 000110Rg    | Compare Equals              | EQ             | Rg = A → A           |
| 000111Rg    | Compare Less Than           | LT             | Rg \< A → A          |
| 0010AdDa    | Write Low                   | WRL            | Da[7:0] → MEM[Ad]    |
| 0011AdDa    | Write High                  | WRH            | Da[15:8] → MEM[Ad]   |
| 0100AdDt    | Read Low                    | RDL            | MEM[Ad] → Dt[7:0]    |
| 0101AdDt    | Read High                   | RDH            | MEM[Ad] → Dt[15:8]   |
| 0110CnGt    | Conditional Jump            | CJP            | if[Cn != 0]; Gt → PC |
| 0111AmDt    | Roll Left                   | ROL            | Dt << Am             |
| 1000ScDt    | Copy                        | CPY            | Dt ← Sc              |
| 1001S1S2    | Swap                        | SWP            | S1 ↔ S2              |
| 101000Dt    | Read Stack Pointer          | RSP            | SP → Dt              |
| 101001Sc    | Write Stack Pointer         | RSP (real)     | SP ← Sc              |
| 101010Gt    | Non-Conditional Jump (prot) | NCP (prot)     | PC ← Gt              |
| 101011Gt    | Non-Conditional Jump (real) | NCP (real)     | PC ← Gt              |
| 10110000    | Set CS (real)               | SCS (real)     | A  → CS              |
| 10110001    | Set CE (real)               | SCE (real)     | A  → CE              |
| 10110010    | Set DS (real)               | SDS (real)     | A  → DS              |
| 10110011    | Set DE (real)               | SDE (real)     | A  → DE              |
| 10110100    | Set SS (real)               | SSS (real)     | A  → SS              |
| 10110101    | Set SE (real)               | SSE (real)     | A  → SE              |
| 10110110    | Not Used                    |                |                      |
| 10110111    | Not Used                    |                |                      |
| 10111000    | Get Amount of Memory        | GAM            | A  ← Max(MEM)        |
| 10111001    | Not Used                    |                |                      |
| 10111010    | Not Used                    |                |                      |
| 10111011    | Not Used                    |                |                      |
| 10111100    | Sofware Interrupt 0         | SW0            |                      |
| 10111101    | Sofware Interrupt 1         | SW1            |                      |
| 10111110    | Sofware Interrupt 2         | SW2            |                      |
| 10111111    | Sofware Interrupt 3         | SW3            |                      |
| 11DtValu    | Set Value                   | SVL            | Dt[3:0] ← Valu       |

That's It!
