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
    var forbidden = [ord('S'), ord('E')]
    if curr in forbidden or next in forbidden:
        return false
    next <= curr + 1

proc isFinal(curr, next: int): bool =
    (curr == ord('S') or curr == ord('a')) and isValidStep(ord('a'), next)

proc isStart(curr, next: int): bool =
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
        (x: pos.x, y: pos.y-1),
        (x: pos.x, y: pos.y+1),
        (x: pos.x-1, y: pos.y),
        (x: pos.x+1, y: pos.y),
    ]
    result = nexts.filterIt(it.between(m))

var startPos = findPos(heightMap, ord('E'))
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
    # current (pos) is E, prev would be z
    var prevs = getNexts(charMatrix, pos)
    var next = pos
    for prev in prevs:
        # decide if the next position is the final position or a possible next step
        if isFinal(charMatrix[prev.x, prev.y], charMatrix[next.x, next.y]):
            way[prev.x, prev.y] = next
            distance[prev.x, prev.y] = distance[next.x, next.y] + 1
            finalPos = prev
            queue.clear()
            break
        if isPossible(charMatrix[prev.x, prev.y], charMatrix[next.x, next.y]):
            if not visited[prev.x, prev.y]:
                # if next position is possible and not already visited, add it to the queue
                way[prev.x, prev.y] = next
                queue.addLast(prev)

echo distance
echo "Final Position: ", finalPos
echo "Final Character: ", chr(charMatrix[finalPos.x, finalPos.y])
echo "Shortest Way: ", distance[finalPos.x, finalPos.y]

proc printWay()=
    var visual = newMatrix[char](heightMatrix.w, heightMatrix.h)
    for i, c in visual:
        visual[i.x, i.y] = ' '
    var step = finalPos
    while true:
        if charMatrix[step.x, step.y] == ord('S'):
            break
        var prev = way[step.x, step.y]
        if prev.x < step.x:
            visual[step.x, step.y] = '<'
        elif prev.x > step.x:
            visual[step.x, step.y] = '>'
        elif prev.y < step.y:
            visual[step.x, step.y] = '^'
        elif prev.y > step.y:
            visual[step.x, step.y] = 'v'
        else:
            break
        step = prev
    echo $visual


printWay()
