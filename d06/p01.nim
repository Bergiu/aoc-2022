import strutils
import std/sets

var x = """bvwbjplbgvbhsrlpgdmjqwftvncz
nppdvjthqldpwncqszvftbrmjlhg
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw""".splitlines

x = readFile("inp.txt").splitlines

for inp in x:
    for i in low(inp)..high(inp)-4:
        if inp[i..i+3].toHashSet.len == 4:
            echo i+4
            break
