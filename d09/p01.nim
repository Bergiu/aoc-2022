import std/tables
import std/strformat
import std/sequtils
import std/strutils
import system

type Dir = enum
    U, D, L, R

type coord = tuple[x: int, y: int]

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

inp = readFile("inp.txt")
var commands = inp.splitlines()
                  .filterIt(it != "")
                  .mapIt(it.split(" "))
                  .mapIt((dir: it[0].parseDir, amount: it[1].parseInt))
var visited = @[(x: 0, y: 0)]
var head_pos = (x: 0, y: 0)
var tail_pos = (x: 0, y: 0)

proc new_head_pos(head_pos: coord, dir: Dir): coord =
    result = head_pos
    case dir:
        of Dir.U:
            result.y += 1
        of Dir.D:
            result.y -= 1
        of Dir.R:
            result.x += 1
        of Dir.L:
            result.x -= 1

proc new_tail_pos(tail: coord, head: coord): coord=
    result = tail
    var dif = (abs(head.x - tail.x), abs(head.y - tail.y))
    if dif == (2,1):
        result.x += (head.x - tail.x).div(2)
        result.y += (head.y - tail.y).div(2) + (head.y-tail.y)
    elif dif == (1,2):
        result.x += (head.x - tail.x).div(2) + (head.x-tail.x)
        result.y += (head.y - tail.y).div(2)
    elif dif == (2,0) or dif == (0,2):
        result.x += (head.x - tail.x).div(2)
        result.y += (head.y - tail.y).div(2)

proc printMap(head_pos: coord, tail_pos: coord): string =
    var vmaxx = max(visited.mapIt(it[0]))
    var vmaxy = max(visited.mapIt(it[1]))
    var vminx = min(visited.mapIt(it[0]))
    var vminy = min(visited.mapIt(it[1]))
    var minx = min(0, min(vminx, min(head_pos.x, tail_pos.x)))
    var maxx = max(0, max(vmaxx, max(head_pos.x, tail_pos.x)))
    var miny = min(0, min(vminy, min(head_pos.y, tail_pos.y)))
    var maxy = max(0, max(vmaxy, max(head_pos.y, tail_pos.y)))
    for j in countdown(maxy, miny):
        for i in minx..maxx:
            var cur = (x: i, y: j)
            if head_pos == cur:
                result &= "H"
            elif tail_pos == cur:
                result &= "T"
            elif visited.contains(cur):
                result &= "#"
            else:
                result &= "."
        result &= "\n"

for line in commands:
    for step in 1..line.amount:
        head_pos = new_head_pos(head_pos, line.dir)
        tail_pos = new_tail_pos(tail_pos, head_pos)
        if not visited.contains(tail_pos):
            visited.add(tail_pos)
        #echo printMap(head_pos, tail_pos)

echo len(visited)
