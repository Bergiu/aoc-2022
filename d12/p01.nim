# other libs
import std/strutils
import std/sequtils
import std/deques
# my libs
import matrix
import helper

var inp = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

# inp = """
# Sbcdefghijklmmm
# Eyxwvutsrqponmm
# """

inp = readFile("inp.txt")

proc isValidStep(curr, next: int): bool =
    next <= curr + 1

proc isStart(curr, next: int): bool =
    curr == ord('S') and isValidStep(ord('a'), next)

proc isFinal(curr, next: int): bool =
    next == ord('E') and isValidStep(curr, ord('z'))

proc isPossible(curr, next: int): bool =
    isValidStep(curr, next) or isStart(curr, next) or isFinal(curr, next)

proc findPos(puzzle: seq[seq[int]], item: int): tuple[x,y:int]=
    var sList = puzzle.mapIt(it.find(item))
    result.x = sList.filterIt(it != -1)[0]
    result.y = sList.find(result.x)


var heightMap = inp.splitlines().filterIt(it!="").mapIt(it.mapIt(ord(it)))

var heightMatrix = newMatrix[int](heightMap[0].len, heightMap.len)
var charMatrix = newMatrix[int](heightMatrix.w, heightMatrix.h)
for y, line in heightMap:
    for x, c in line:
        if c == ord('S'):
            heightMatrix[x,y] = ord('a')
        elif c == ord('E'):
            heightMatrix[x,y] = ord('z')
        else:
            heightMatrix[x,y] = c
        charMatrix[x,y] = c

proc getNexts(m: Matrix, pos: tuple[x, y: int]): seq[tuple[x,y:int]] =
    var nexts = [
        (x: pos.x+1, y: pos.y),
        (x: pos.x-1, y: pos.y),
        (x: pos.x, y: pos.y+1),
        (x: pos.x, y: pos.y-1),
    ]
    result = nexts.filterIt(it.between(m))

var startPos = findPos(heightMap, ord('S'))
echo "Start Position: ", startPos
echo "Start Character: ", chr(charMatrix[startPos.x, startPos.y])
# tracking if we already visited a position
var visited = newMatrix[bool](heightMatrix.w, heightMatrix.h)
# the way where we are going
var way = newMatrix[tuple[x,y:int]](heightMatrix.w, heightMatrix.h)
# the distance that we needed to get to the point
var distance = newMatrix[int](heightMatrix.w, heightMatrix.h)
# list of positions that we should visit next (BFS)
var queue = @[startPos].toDeque
# the first round doesn't have a previous round, so we need to track it
var first = true
# the final position
var finalPos: tuple[x,y:int]
while queue.len > 0:
    # get the next position
    var pos = queue.popFirst
    # mark pos as visited
    if visited[pos.x, pos.y]:
        continue
    visited[pos.x, pos.y] = true
    # increase the distance to the current position (except for the start position)
    if not first:
        var last = way[pos.x, pos.y]
        distance[pos.x, pos.y] = distance[last.x, last.y] + 1
    else:
        first = false
    var nexts = getNexts(charMatrix, pos)
    for next in nexts:
        # decide if the next position is the final position or a possible next step
        if isFinal(charMatrix[pos.x, pos.y], charMatrix[next.x, next.y]):
            way[next.x, next.y] = pos
            distance[next.x, next.y] = distance[pos.x, pos.y] + 1
            finalPos = next
            queue.clear()
            break
        if isPossible(charMatrix[pos.x, pos.y], charMatrix[next.x, next.y]):
            if not visited[next.x, next.y]:
                # if next position is possible and not already visited, add it to the queue
                way[next.x, next.y] = pos
                queue.addLast(next)

echo distance
echo "Final Position: ", finalPos
echo "Final Character: ", chr(charMatrix[finalPos.x, finalPos.y])
echo "Shortest Way: ", distance[finalPos.x, finalPos.y]
