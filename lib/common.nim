import std/math
import strutils

proc log2*(i: int): float = log2(i.toFloat)

proc bin*(i: int): string =
    if i == 0:
        result = "0"
    else:
        result = i.toBin(ceil(log2(i+1)).toInt)
        # wohlformatiert
        result = i.toBin(20)


