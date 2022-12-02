include ../lib/types
include ../lib/band
include ../lib/turingmachine
include ../lib/common
import std/sets
import std/tables
import unicode
import strutils
import sequtils
import ../p01/p01

proc createBand(entireFile: string): string =
    for line in entireFile.splitlines():
        if line == "":
            continue
        # well formated input
        result &= "00000000000000" & line.split(" ").join("0") & " |" # contains 2 spaces, so each area is 4 bit long

proc createBandFromFile(filename: string): string =
    let entireFile = readFile(filename)
    return createBand(entireFile)

proc main()=
    var M = newTuringmachine(
        toOrderedSet(["q0", "q1", "q2"]),
        "q0",
        toOrderedSet(["f1", "f2", "f3", "f4"]),
        toOrderedSet(toRunes("ABCXYZ |01")),
        toOrderedSet(toRunes("ABCXYZ |01#")),
        '#'.Rune
    )

    #A, X: Rock (1)
    #B, Y: Paper (2)
    #C, Z: Scissors (3)

    #0: if you lost
    #3: if it was a draw
    #6 if you won

    # XYZ
    #A483
    #B159
    #C726

    #M.setInput("AY|BX|CZ")
    # 2 spurige tm wäre nützlich
    M.δ[("q0", 'A'.Rune)] = ("a1", '0'.Rune, Movement.R)
    M.δ[("q0", 'B'.Rune)] = ("b1", '0'.Rune, Movement.R)
    M.δ[("q0", 'C'.Rune)] = ("c1", '0'.Rune, Movement.R)
    M.δ[("q0", '0'.Rune)] = ("q0", '0'.Rune, Movement.R)
    M.δ[("q0", '1'.Rune)] = ("q0", '1'.Rune, Movement.R)
    M.δ[("q0", ' '.Rune)] = ("q0", ' '.Rune, Movement.R)
    M.δ[("q0", '|'.Rune)] = ("q0", '|'.Rune, Movement.R)
    M.δ[("q0", '#'.Rune)] = ("f1", '#'.Rune, Movement.L)

    M.δ[("a1", '0'.Rune)] = ("a1", '0'.Rune, Movement.R)
    M.δ[("a1", 'X'.Rune)] = ("w4", '0'.Rune, Movement.L) # 4
    M.δ[("a1", 'Y'.Rune)] = ("w8", '0'.Rune, Movement.L) # 8
    M.δ[("a1", 'Z'.Rune)] = ("w2", '1'.Rune, Movement.L) # 3+1
    M.δ[("b1", '0'.Rune)] = ("b1", '0'.Rune, Movement.R)
    M.δ[("b1", 'X'.Rune)] = ("q0", '1'.Rune, Movement.R) # 1
    M.δ[("b1", 'Y'.Rune)] = ("w4", '1'.Rune, Movement.L) # 4+1
    M.δ[("b1", 'Z'.Rune)] = ("w8", '1'.Rune, Movement.L) # 8+1
    M.δ[("c1", '0'.Rune)] = ("c1", '0'.Rune, Movement.R)
    M.δ[("c1", 'X'.Rune)] = ("w6", '1'.Rune, Movement.L) # 6+1
    M.δ[("c1", 'Y'.Rune)] = ("w2", '0'.Rune, Movement.L) # 2
    M.δ[("c1", 'Z'.Rune)] = ("w6", '0'.Rune, Movement.L) # 6

    M.δ[("w2", '0'.Rune)] = ("q0", '1'.Rune, Movement.R) # 1x
    M.δ[("w4", '0'.Rune)] = ("w4a", '0'.Rune, Movement.L) # 10x
    M.δ[("w4a", '0'.Rune)] = ("q0", '1'.Rune, Movement.R) # 10x
    M.δ[("w6", '0'.Rune)] = ("w4a", '1'.Rune, Movement.L) # 11x
    M.δ[("w8", '0'.Rune)] = ("w8a", '0'.Rune, Movement.L) # 100x
    M.δ[("w8a", '0'.Rune)] = ("w8b", '0'.Rune, Movement.L) # 100x
    M.δ[("w8b", '0'.Rune)] = ("q0", '1'.Rune, Movement.R) # 100x


    #let band = createBandFromFile("inp.txt")
    #let band = createBand("A Y\nB X\nC Z")
    let band = createBandFromFile("inp.txt")
    M.setInput(band)

    echo "Input:  " & $M.band
    M.run(false)
    echo "Output:  " & $M.band

    var Adder = getTm()
    Adder.setInput($M.band)
    #Adder.run(false)
    echo "Output: " & $Adder.band
    #var decoded = decode(Adder)
    #echo "Decoded: " & $decoded

    printTM(M)

when isMainModule:
    main()
