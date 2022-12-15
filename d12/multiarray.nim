type MultiArray*[W, H: static[int], T] = object
    data: array[W * H, T]

proc `[]`*(m: MultiArray, x, y: int): m.T {.inline.} =
    assert x < m.W
    assert y < m.H
    m.data[x*m.H + y]

proc `[]=`*(m: var MultiArray, x, y: int, o: m.T) {.inline.} =
    assert x < m.W
    assert y < m.H
    m.data[x*m.H + y] = o

iterator items*(m: MultiArray): m.T =
    for x in m.data:
        yield x

iterator pairs*(m: MultiArray): (tuple[x, y: int], m.T) =
    for i, t in m.data:
        yield ((x: i.div(m.H), y: i.mod(m.H)), t)

proc `$`*(m: MultiArray): string =
    for i, t in m.data:
        if i.mod(m.W) == 0 and i != 0:
            result &= "\n"
        result &= $t
