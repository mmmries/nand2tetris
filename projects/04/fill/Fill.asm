// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

@8192
D=A
@max
M=D


(BEGIN)
@0
D=A
@iteration
M=D

(LOOP)
//Increment iteration
@iteration
M=M+1

//Reset iteration if needed
D=M
@max
D=M-D
@BEGIN
D;JEQ

//Read the keyboard
@KBD
D=M
@DRAWBLACK
D;JNE //Draw Black Pixels If A key Was Pressed

  //Draw White Pixels
  @iteration
  D=M
  @SCREEN
  A=A+D
  M=0
  @LOOP
  0;JMP //Back to Beginning

  (DRAWBLACK)
  @iteration
  D=M
  @SCREEN
  A=A+D
  M=-1
  @LOOP
  0;JMP //Back to Beginning
