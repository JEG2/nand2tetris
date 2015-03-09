// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.

    @white
    M=0
    D=-1
    @black
    M=D
    @RESETCURSOR
    0;JMP

(LOOP)
    @KBD
    D=M
    @SETBLACK
    D;JNE
    @SETWHITE
    0;JMP

(DRAW)
    @color
    D=M

    @cursor
    A=M
    M=D

    @cursor
    M=M+1

    @24576
    D=A
    @cursor
    D=D-M
    @RESETCURSOR
    D;JLE
    @LOOP
    0;JMP

(SETBLACK)
    @black
    D=M
    @color
    M=D
    @DRAW
    0;JMP

(SETWHITE)
    @white
    D=M
    @color
    M=D
    @DRAW
    0;JMP

(RESETCURSOR)
    @SCREEN
    D=A
    @cursor
    M=D
    @LOOP
    0;JMP
