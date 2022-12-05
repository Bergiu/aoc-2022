import strutils
import sequtils

proc contains(l, r: HSlice): bool =
    l.a in r and l.b in r


var inp = """2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8"""

inp = readFile("inp.txt")

echo inp.strip.splitlines
        .mapIt(it.split(",").mapIt(it.split("-").map(parseInt)).mapIt(it[0]..it[1]))
        .countIt(it[0] in it[1] or it[1] in it[0])

