import std/sets
import unicode


var inp = "{1,2,3}"

proc parseSet(inp: string) {.raises: [OSError].}=
    var stripped = inp.strip
    if stripped.runeAtPos(0) != '{'.Rune:
        raise newException(OSError, "Not a set.")
    if stripped.runeAtPos(stripped.runeLen-1) != '}'.Rune:
        raise newException(OSError, "Not a set.")
    var content = inp.runeSubStr(1, stripped.runeLen-2)
    echo content

parseSet(inp)
