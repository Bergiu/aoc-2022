import strutils
import std/sets

var x = """bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw""".splitlines

x = readFile("inp.txt").splitlines

for inp in x:
    for i in low(inp)..high(inp)-14:
        if inp[i..i+13].toHashSet.len == 14:
            echo i+14
            break
