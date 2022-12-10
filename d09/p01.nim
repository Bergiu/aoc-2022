import std/sequtils
import std/strutils
import system
import std/sets

type Dir = enum
    U, D, L, R

type Coord = tuple[x: int, y: int]

proc parseDir(s: string): Dir =
    case s:
        of "U":
            Dir.U
        of "D":
            Dir.D
        of "R":
            Dir.R
        of "L":
            Dir.L
        else:
            raise newException(ValueError, "invalid value")


var inp = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"""

inp = readFile("inp.txt").repeat(1000)  # for testing the performance
var commands = inp.splitlines()
                  .filterIt(it != "")
                  .mapIt(it.split(" "))
                  .mapIt((dir: it[0].parseDir, amount: it[1].parseInt))
var visited = [(0,0)].toHashSet
var headPos = (x: 0, y: 0)
var tailPos = (x: 0, y: 0)

proc moveHead(headPos: var Coord, dir: Dir) =
    case dir:
        of Dir.U:
            headPos.y += 1
        of Dir.D:
            headPos.y -= 1
        of Dir.R:
            headPos.x += 1
        of Dir.L:
            headPos.x -= 1

proc newTailPos(tail: Coord, head: Coord): Coord=
    result = tail
    var dif = (x: head.x - tail.x, y: head.y - tail.y)
    var absdif = (x: abs(dif.x), y: abs(dif.y))
    if absdif.x > 1 or absdif.y > 1:
        result.x += dif.x.div(2)
        result.y += dif.y.div(2)
    if absdif == (2,1):
        result.y += dif.y
    elif absdif == (1,2):
        result.x += dif.x

for line in commands:
    for step in 1..line.amount:
        moveHead(headPos, line.dir)
        tailPos = newTailPos(tailPos, headPos)
        visited.incl(tailPos)

echo len(visited)
