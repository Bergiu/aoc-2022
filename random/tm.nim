import strutils
include lib/types
include lib/band
include lib/turingmachine

proc main()=
    var M = newTuringmachine(
        toOrderedSet(["q0", "q1", "q2"]),
        "q0",
        toOrderedSet(["q2"]),
        toOrderedSet(toRunes("01")),
        toOrderedSet(toRunes("01#")),
        '#'.Rune
    )
    M.δ[("q0", '1'.Rune)] = ("q0", '0'.Rune, Movement.R)
    M.δ[("q0", '0'.Rune)] = ("q0", '1'.Rune, Movement.R)
    M.δ[("q0", '#'.Rune)] = ("q1", '#'.Rune, Movement.L)
    M.δ[("q1", '1'.Rune)] = ("q1", '#'.Rune, Movement.L)
    M.δ[("q1", '0'.Rune)] = ("q1", '0'.Rune, Movement.L)
    M.δ[("q1", '#'.Rune)] = ("q2", '#'.Rune, Movement.R)

    #M.setInput("añyóng")
    M.setInput($toBin(42, 6))

    echo "Input:  " & $M.band
    M.run()
    echo "Output: " & $M.band
    echo "Symbol under cursor: " & $M.band.read()
    echo "Position: " & $M.band.getPos
    echo "Band Position: " & $M.band.getBandStart

    M = newTuringmachine(
        toOrderedSet(["q0", "q1"]),
        "q0",
        toOrderedSet(["q1"]),
        toOrderedSet(toRunes("ñó")),
        toOrderedSet(toRunes("ñó#")),
        '#'.Rune
    )
    M.δ[("q0", "ó".runeAtPos(0))] = ("q0", "ñ".runeAtPos(0), Movement.R)
    M.δ[("q0", "ñ".runeAtPos(0))] = ("q0", "ó".runeAtPos(0), Movement.R)
    M.δ[("q0", '#'.Rune)] = ("q1", '#'.Rune, Movement.L)

    M.setInput("óñóñóñ")

    echo "Input:  " & $M.band

    M.run()

    echo "Output: " & $M.band
    echo "Symbol under cursor: " & $M.band.read()
    echo "Position: " & $M.band.getPos
    echo "Band Position: " & $M.band.getBandStart

when isMainModule:
    main()


runnableExamples:
    import std/sets
    import std/tables
    import unicode
    var M = newTuringmachine(
        toOrderedSet(["q0", "q1"]),
        "q0",
        toOrderedSet(["q1"]),
        toOrderedSet(toRunes("01")),
        toOrderedSet(toRunes("01#")),
        '#'.Rune
    )
    M.δ[("q0", '0'.Rune)] = ("q1", '0'.Rune, Movement.R)
    M.setInput("010101")
    M.run()
    assert '1'.Rune == M.band.read()
