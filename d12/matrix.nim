import math
import sequtils

type Matrix*[T] = object
    data: seq[T]
    w: int
    h: int

proc w*(m: Matrix): int =
    m.w

proc h*(m: Matrix): int =
    m.h

proc posToIndex*(m: Matrix, x, y: int): int {.inline.} =
    x + y*m.w

proc posToIndex*(m: Matrix, t: tuple[x, y: int]): int {.inline.} =
    t.x + t.y*m.w

proc newMatrix*[T](w, h: int): Matrix[T] =
    result.w = w
    result.h = h
    result.data = newSeq[T](w*h)

proc `[]`*(m: Matrix, x, y: int): m.T {.inline.} =
    assert x < m.w
    assert y < m.h
    m.data[x + y*m.w]

proc `[]=`*(m: var Matrix, x, y: int, o: m.T) {.inline.} =
    assert x < m.w
    assert y < m.h
    m.data[x + y*m.w] = o

iterator items*(m: Matrix): m.T =
    for x in m.data:
        yield x

iterator pairs*(m: Matrix): (tuple[x, y: int], m.T) =
    for i, t in m.data:
        yield ((x: i.div(m.h), y: i.mod(m.h)), t)

proc `$`*(m: Matrix): string =
    var longestNumber = max(m.data.mapIt(len($it))) + 1
    # var longestNumber = max(m.data.mapIt(len($it)))
    # var longestNumber: int = log10(max(m.data).toFloat).int + 2
    for i, t in m.data:
        if i.mod(m.w) == 0 and i != 0:
            result &= "\n"
        result &= ($t).align(longestNumber)

