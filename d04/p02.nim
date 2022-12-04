import strutils
import sequtils

proc overlaps(l, r: seq[int]): bool =
    l[0] <= r[0] and r[0] <= l[1] or
    l[1] <= r[0] and r[1] <= l[1] or
    r[0] <= l[0] and l[0] <= r[1] or
    r[1] <= l[0] and l[1] <= r[1]


var inp = """2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8"""

inp = readFile("inp.txt")

echo inp.strip.splitlines.mapIt(it.split(",").mapIt(it.split("-").map(parseInt)))
        .countIt(overlaps(it[0], it[1]))

