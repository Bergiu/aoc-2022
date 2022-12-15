import matrix

proc between*(num, leftIncluded, rightExcluded: int): bool =
    leftIncluded <= num and num < rightExcluded

proc outside*(num, leftIncluded, rightExcluded: int): bool =
    not between(num, leftIncluded, rightExcluded)

proc between*(tp: tuple[x,y:int], m: Matrix): bool =
    tp.x.between(0, m.w) and tp.y.between(0, m.h)

