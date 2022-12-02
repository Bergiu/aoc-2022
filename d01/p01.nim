include ../lib/types
include ../lib/band
include ../lib/turingmachine
include ../lib/common
import std/sets
import std/tables
import unicode
import strutils
import sequtils


proc createBand(filename: string): string =
    let entireFile = readFile(filename)
    for line in entireFile.splitlines():
        if line != "":
            result &= bin(strutils.strip(line).parseInt)
            result &= " |"
        else:
            result &= "|"

proc decode*(M: Turingmachine): string =
    # decode band
    $($M.band)
            .replace(" ", "")
            .replace("#", "")
            .split("|")
            .filterit(it.len != 0)
            .mapIt(align(it, 64, '0'))
            .mapIt(fromBin[int64](it))

proc getTm*(): Turingmachine=
    # Doppelkreuz (#): Blank
    # Newline (|): Trennzeichen
    # Space ( ): Leer
    var M = newTuringmachine(
        toOrderedSet(["q0", "q1", "q2"]),
        "q0",
        toOrderedSet(["f1", "f2", "f3", "f4"]),
        toOrderedSet(toRunes("01 |")),
        toOrderedSet(toRunes("01 |#")),
        '#'.Rune
    )

    # Add Numbers
    # Add the next two numbers 1010 0011 -> 1101
    M.δ[("q0", '#'.Rune)] = ("f1", '#'.Rune, Movement.N)
    M.δ[("q0", ' '.Rune)] = ("f1", ' '.Rune, Movement.N)
    M.δ[("q0", '|'.Rune)] = ("f1", '|'.Rune, Movement.N)
    M.δ[("q0", '0'.Rune)] = ("a0", '0'.Rune, Movement.R)
    M.δ[("q0", '1'.Rune)] = ("a0", '1'.Rune, Movement.R)
    # goto end of second number
    M.δ[("a0", '0'.Rune)] = ("a0", '0'.Rune, Movement.R)
    M.δ[("a0", '1'.Rune)] = ("a0", '1'.Rune, Movement.R)
    M.δ[("a0", ' '.Rune)] = ("a0", ' '.Rune, Movement.R)
    M.δ[("a0", '|'.Rune)] = ("a1", '|'.Rune, Movement.R)
    M.δ[("a0", '#'.Rune)] = ("f1", '#'.Rune, Movement.N) # don't need to add numbers

    M.δ[("a1", '0'.Rune)] = ("a1_2", '0'.Rune, Movement.R)
    M.δ[("a1", '1'.Rune)] = ("a1_2", '1'.Rune, Movement.R)
    M.δ[("a1", '#'.Rune)] = ("f2", '|'.Rune, Movement.N) # end of file, and only one number
    M.δ[("a1", '|'.Rune)] = ("a0", '|'.Rune, Movement.R) # only one number
    M.δ[("a1_2", '0'.Rune)] = ("a1_2", '0'.Rune, Movement.R)
    M.δ[("a1_2", '1'.Rune)] = ("a1_2", '1'.Rune, Movement.R)
    #M.δ[("a1_2", '|'.Rune)] = ("move1", '|'.Rune, Movement.N)
    #M.δ[("a1_2", '#'.Rune)] = ("move1", '|'.Rune, Movement.N) # end of file equivalent to |
    M.δ[("a1_2", ' '.Rune)] = ("a1_2", ' '.Rune, Movement.R)
    M.δ[("a1_2", '|'.Rune)] = ("a2", '|'.Rune, Movement.L)
    M.δ[("a1_2", '#'.Rune)] = ("a2", '|'.Rune, Movement.L) # end of file equivalent to |
    # insert one space
    #move("move1", "a2", ' '.Rune)
    # skip this number to left
    M.δ[("a2", '0'.Rune)] = ("a2", '0'.Rune, Movement.L) # skip all numbers
    M.δ[("a2", '1'.Rune)] = ("a2", '1'.Rune, Movement.L) # skip all numbers
    M.δ[("a2", ' '.Rune)] = ("a3", ' '.Rune, Movement.L) # now i'm at the first space
    # M.δ[("a2", '|'.Rune)] #error, missing space
    # find next number left
    M.δ[("a3", ' '.Rune)] = ("a3", ' '.Rune, Movement.L) # skip all spaces
    M.δ[("a3", '0'.Rune)] = ("a4_0", ' '.Rune, Movement.R) # remember the number
    M.δ[("a3", '1'.Rune)] = ("a4_1", ' '.Rune, Movement.R) # remember the number
    M.δ[("a3", '|'.Rune)] = ("a_again", ' '.Rune, Movement.R) # fertig, repeat adding
    M.δ[("a3_u", ' '.Rune)] = ("a3_u", ' '.Rune, Movement.L) # skip all spaces
    M.δ[("a3_u", '0'.Rune)] = ("a4_1", ' '.Rune, Movement.R) # remember übertrag
    M.δ[("a3_u", '1'.Rune)] = ("a4_u", ' '.Rune, Movement.R) # remember the number
    M.δ[("a3_u", '|'.Rune)] = ("au1", ' '.Rune, Movement.R) # fehlt noch uebertrag
    # find next number right
    M.δ[("a4_0", ' '.Rune)] = ("a4_0", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a4_0", '0'.Rune)] = ("a5_0", '0'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_0", '1'.Rune)] = ("a5_0", '1'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_0", '|'.Rune)] = ("a5_0", '|'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_1", ' '.Rune)] = ("a4_1", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a4_1", '0'.Rune)] = ("a5_1", '0'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_1", '1'.Rune)] = ("a5_1", '1'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_1", '|'.Rune)] = ("a5_1", '|'.Rune, Movement.L) # links vom ersten char
    # a4_u contains a 1 from the number and an übertrag from before
    M.δ[("a4_u", ' '.Rune)] = ("a4_u", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a4_u", '0'.Rune)] = ("a5_u", '0'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_u", '1'.Rune)] = ("a5_u", '1'.Rune, Movement.L) # links vom ersten char
    M.δ[("a4_u", '|'.Rune)] = ("a5_u", '|'.Rune, Movement.L) # links vom ersten char
    # write number
    M.δ[("a5_0", ' '.Rune)] = ("a6", '0'.Rune, Movement.L)
    M.δ[("a5_1", ' '.Rune)] = ("a6", '1'.Rune, Movement.L)
    M.δ[("a5_u", ' '.Rune)] = ("a6_u", '0'.Rune, Movement.L)
    # M.δ[("a5_0", '0'.Rune)] #error, missing a space
    # M.δ[("a5_1", '0'.Rune)] #error, missing a space
    # M.δ[("a5_0", '1'.Rune)] #error, missing a space
    # M.δ[("a5_1", '1'.Rune)] #error, missing a space
    # M.δ[("a5_0", '|'.Rune)] #error, missing a space
    # M.δ[("a5_1", '|'.Rune)] #error, missing a space
    # currently on the space
    # now goto the left number
    M.δ[("a6", ' '.Rune)] = ("a6", ' '.Rune, Movement.L) # skip all spaces
    M.δ[("a6", '0'.Rune)] = ("a6", '0'.Rune, Movement.L) # skip all numbers
    M.δ[("a6", '1'.Rune)] = ("a6", '1'.Rune, Movement.L) # skip all numbers
    M.δ[("a6", '|'.Rune)] = ("a7", '|'.Rune, Movement.L) # now enter the left number area
    M.δ[("a6_u", ' '.Rune)] = ("a6_u", ' '.Rune, Movement.L) # skip all spaces
    M.δ[("a6_u", '0'.Rune)] = ("a6_u", '0'.Rune, Movement.L) # skip all numbers
    M.δ[("a6_u", '1'.Rune)] = ("a6_u", '1'.Rune, Movement.L) # skip all numbers
    M.δ[("a6_u", '|'.Rune)] = ("a7_u", '|'.Rune, Movement.L) # now enter the left number area
    M.δ[("a7", ' '.Rune)] = ("a7", ' '.Rune, Movement.L) # skip all spaces
    M.δ[("a7", '|'.Rune)] = ("a8_0", '|'.Rune, Movement.L) # number is empty
    M.δ[("a7", '#'.Rune)] = ("a8_0", '#'.Rune, Movement.R) # number is empty
    M.δ[("a7", '0'.Rune)] = ("a8_0", ' '.Rune, Movement.R) # save number in state
    M.δ[("a7", '1'.Rune)] = ("a8_1", ' '.Rune, Movement.R) # save number in state
    M.δ[("a7_u", ' '.Rune)] = ("a7_u", ' '.Rune, Movement.L) # skip all spaces
    M.δ[("a7_u", '|'.Rune)] = ("f1", '|'.Rune, Movement.L) # finished
    M.δ[("a7_u", '#'.Rune)] = ("a8_0_u", '#'.Rune, Movement.R) # number is empty
    M.δ[("a7_u", '0'.Rune)] = ("a8_0_u", ' '.Rune, Movement.R) # save number in state
    M.δ[("a7_u", '1'.Rune)] = ("a8_1_u", ' '.Rune, Movement.R) # save number in state
    # now go back to the sum number
    M.δ[("a8_0", ' '.Rune)] = ("a8_0", ' '.Rune, Movement.R) # skip all spaces
    M.δ[("a8_0", '|'.Rune)] = ("a9_0", '|'.Rune, Movement.R) # now enter the right number area
    M.δ[("a8_1", ' '.Rune)] = ("a8_1", ' '.Rune, Movement.R) # skip all spaces
    M.δ[("a8_1", '|'.Rune)] = ("a9_1", '|'.Rune, Movement.R) # now enter the right number area
    M.δ[("a8_0_u", ' '.Rune)] = ("a8_0_u", ' '.Rune, Movement.R) # skip all spaces
    M.δ[("a8_0_u", '|'.Rune)] = ("a9_0_u", '|'.Rune, Movement.R) # now enter the right number area
    M.δ[("a8_1_u", ' '.Rune)] = ("a8_1_u", ' '.Rune, Movement.R) # skip all spaces
    M.δ[("a8_1_u", '|'.Rune)] = ("a9_1_u", '|'.Rune, Movement.R) # now enter the right number area
    #M.δ[("a8_0", '0'.Rune)] #error, not possible
    #M.δ[("a8_1", '0'.Rune)] #error, not possible
    #M.δ[("a8_0", '1'.Rune)] #error, not possible
    #M.δ[("a8_1", '1'.Rune)] #error, not possible
    # now i'm in the right number area
    #M.δ[("a9_0", '|'.Rune)] #error, missing number and sum
    M.δ[("a9_0", '0'.Rune)] = ("a9_0", '0'.Rune, Movement.R) # skip numbers
    M.δ[("a9_0", '1'.Rune)] = ("a9_0", '1'.Rune, Movement.R) # skip numbers
    M.δ[("a9_0", ' '.Rune)] = ("a10_0", ' '.Rune, Movement.R) # entering the sum number
    M.δ[("a9_1", '0'.Rune)] = ("a9_1", '0'.Rune, Movement.R) # skip numbers
    M.δ[("a9_1", '1'.Rune)] = ("a9_1", '1'.Rune, Movement.R) # skip numbers
    M.δ[("a9_1", ' '.Rune)] = ("a10_1", ' '.Rune, Movement.R) # entering the sum number
    M.δ[("a9_0_u", '0'.Rune)] = ("a9_0_u", '0'.Rune, Movement.R) # skip numbers
    M.δ[("a9_0_u", '1'.Rune)] = ("a9_0_u", '1'.Rune, Movement.R) # skip numbers
    M.δ[("a9_0_u", ' '.Rune)] = ("a10_0_u", ' '.Rune, Movement.R) # entering the sum number
    M.δ[("a9_1_u", '0'.Rune)] = ("a9_1_u", '0'.Rune, Movement.R) # skip numbers
    M.δ[("a9_1_u", '1'.Rune)] = ("a9_1_u", '1'.Rune, Movement.R) # skip numbers
    M.δ[("a9_1_u", ' '.Rune)] = ("a10_1_u", ' '.Rune, Movement.R) # entering the sum number
    # now i'm in the sum number area
    M.δ[("a10_0", ' '.Rune)] = ("a10_0", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a10_0", '0'.Rune)] = ("a3", '0'.Rune, Movement.L) # finished adding char
    M.δ[("a10_0", '1'.Rune)] = ("a3", '1'.Rune, Movement.L) # finished adding char
    M.δ[("a10_1", ' '.Rune)] = ("a10_1", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a10_1", '0'.Rune)] = ("a3", '1'.Rune, Movement.L) # finished adding char
    M.δ[("a10_1", '1'.Rune)] = ("a3_u", '0'.Rune, Movement.L) # übertrag
    M.δ[("a10_0_u", ' '.Rune)] = ("a10_0", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a10_0_u", '0'.Rune)] = ("a3_u", '0'.Rune, Movement.L) # finished adding char
    M.δ[("a10_0_u", '1'.Rune)] = ("a3_u", '1'.Rune, Movement.L) # übertrag
    M.δ[("a10_1_u", ' '.Rune)] = ("a10_0", ' '.Rune, Movement.R) # skip spaces
    M.δ[("a10_1_u", '0'.Rune)] = ("a3_u", '1'.Rune, Movement.L) # finished adding char
    M.δ[("a10_1_u", '1'.Rune)] = ("a3_u", '1'.Rune, Movement.L) # übertrag
    #M.δ[("a10_0", '|'.Rune)] #error
    #M.δ[("a10_1", '|'.Rune)] #error
    # schreibe übertrag wenn fertig
    M.δ[("au1", ' '.Rune)] = ("au1", ' '.Rune, Movement.R) # skip spaces
    M.δ[("au1", '0'.Rune)] = ("au2", '0'.Rune, Movement.L) # left from number
    M.δ[("au1", '1'.Rune)] = ("au2", '1'.Rune, Movement.L) # left from number
    M.δ[("au2", ' '.Rune)] = ("a_again", '1'.Rune, Movement.N)

    # prüfe ob hier 2 zahlen stehen die mit | getrennt sind
    # wenn || oder # dann ende
    M.δ[("a_again", ' '.Rune)] = ("a_again", ' '.Rune, Movement.R)
    M.δ[("a_again", '0'.Rune)] = ("a_again", '0'.Rune, Movement.R)
    M.δ[("a_again", '1'.Rune)] = ("a_again", '1'.Rune, Movement.R)
    M.δ[("a_again", '#'.Rune)] = ("f3", '#'.Rune, Movement.N)
    M.δ[("a_again", '|'.Rune)] = ("a_again2", '|'.Rune, Movement.R)
    M.δ[("a_again2", ' '.Rune)] = ("a_again2", ' '.Rune, Movement.R) # 01| 0
    M.δ[("a_again2", '0'.Rune)] = ("a_again!", '0'.Rune, Movement.L) # 01|0
    M.δ[("a_again2", '1'.Rune)] = ("a_again!", '1'.Rune, Movement.L) # 01|1
    M.δ[("a_again2", '|'.Rune)] = ("b0", '|'.Rune, Movement.R) # 01||01
    M.δ[("a_again2", '#'.Rune)] = ("f3", '#'.Rune, Movement.R) # 01|#
    # ich bin links vom start der zweiten zahl, also | oder space
    # gehe zurück zum start der ersten zahl
    M.δ[("a_again!", ' '.Rune)] = ("a_again!", ' '.Rune, Movement.L)
    M.δ[("a_again!", '|'.Rune)] = ("a_again!2", '|'.Rune, Movement.L)
    M.δ[("a_again!2", '0'.Rune)] = ("a_again!2", '0'.Rune, Movement.L)
    M.δ[("a_again!2", '1'.Rune)] = ("a_again!2", '1'.Rune, Movement.L)
    M.δ[("a_again!2", ' '.Rune)] = ("a0", ' '.Rune, Movement.R)
    M.δ[("a_again!2", '|'.Rune)] = ("a0", '|'.Rune, Movement.R)
    M.δ[("a_again!2", '#'.Rune)] = ("a0", '#'.Rune, Movement.R)

    # alle zahlen wurden addiert. jetzt gehe in den nächsten block
    M.δ[("b0", '#'.Rune)] = ("f4", '#'.Rune, Movement.N)
    M.δ[("b0", ' '.Rune)] = ("b0", ' '.Rune, Movement.R)
    M.δ[("b0", '0'.Rune)] = ("a0", '0'.Rune, Movement.N)
    M.δ[("b0", '1'.Rune)] = ("a0", '1'.Rune, Movement.N)
    # M.δ[("b0", '|'.Rune)] #error, three pipes?

    return M

proc main()=
    var M = getTm()

    # addition
    #|1010|0011||
    #|1010|0011 ||
    #|101 |001 1||
    #|10  |00 01||
    #|1   |0 101||
    #|    | 1101||
    #|      1101||
    #|1101||


    #M.setInput("añyóng")
    let band = createBand("inp.txt")
    #let band = createBand("test.txt")
    M.setInput(band)
    #[
    M.setInput("1010|0011")
    M.setInput("1010|1011")
    M.setInput("10|111111")
    M.setInput("1010|1011|101010")
    M.setInput("1010|0011|101010")
    M.setInput("1010|0011|101010||10|10|100")
    ]#

    echo "Input:  " & $M.band
    M.run(false)
    echo "Output:  " & $M.band
    var decoded = decode(M)
    echo "Decoded: " & $decoded

    printTM(M)


when isMainModule:
    main()
