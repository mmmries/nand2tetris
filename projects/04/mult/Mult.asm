// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[3], respectively.)

// Put your code here.
@R0
D=M   //D  = R0
@iterations
M=D   //iterations = R0
@R2
M=0   //R2 = 0

(Loop)
@iterations
M=M-1
@End
M;JLT
@R1
D=M   //D  = R1
@R2
M=D+M //R2 = R0 + R1
@Loop
0;JMP

(End)
