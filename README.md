# Register Map
![Register Map](https://docs.google.com/drawings/d/e/2PACX-1vSF-PthyUAP-zF97gdNV2D4nN0EQKxJt4iW48JPhNAF4zAdomu0ihIHaXag0rTDXatp69aeBcFj2l8z/pub?w=898&amp;h=1551)

# Instruction Set
| Code        | Operation                | Short Name     | Equation    |
| :---------- |:-------------            | :---------     | :---------  |
| 00000000    | No Operation             | NOP            |             |
| 00000001    | Jump Back                | JBN            | PC <\- RTN  |
| 00000010    | Increment Stack Pointer  | ISP            | SP <\- SP+1 |
| 00000011    | Decrement Stack Pointer  | DSP            | SP <\- SP-1 |
| 00000100    | Read Return Register     | RRN            | PC <\- RTN  |
| 00000101    | Write Return Register    | WRN            | PC -> RTN   |
| 00000110    | Not Accumulator          | NOT            | A <\- !A    |
| 00000111    | Read Flags               | RDF            | Flags -> A  |


