import std/options
import std/strutils
import std/sequtils

var inp = """addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
"""

proc parseIntruction(s: string): Option[int]=
    if s.startswith("addx"):
        return s.split(" ")[1].parseInt.some
    elif s.startswith("noop"):
        return none(int)

inp = readFile("inp.txt")

var instructions = inp.splitlines()
                      .filterIt(it != "")
                      .map(parseIntruction)

var registerX = 1
var cycles = 1

var instructionCounter = 0
var currentInstruction = 0
var sum = 0
while true:
    cycles += 1
    if (cycles-20).mod(40) == 0:
        echo cycles, ": ", registerX
        sum += cycles * registerX
    if currentInstruction > 0:
        currentInstruction -= 1
    else:
        var instruction = instructions[instructionCounter]
        if instruction.isSome:
            #echo "addx ", instruction.get(), "  ", registerX
            registerX += instruction.get()
            currentInstruction = 1
        instructionCounter += 1
        if instructionCounter >= instructions.len:
            break

echo sum
