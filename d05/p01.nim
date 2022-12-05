import sugar
import sequtils
import strutils
import algorithm

var inp = """    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"""

inp = readFile("inp.txt")

var groups = inp.split("\n\n").mapIt(splitlines(it).filterIt(it != ""))

var tuermeList = collect(newSeq):
    for i in countup(1, high(groups[0][0]), 4):
        for line in groups[0][0..^2]:
            line[i]

var tuerme = tuermeList.distribute(tuermeList.len div 8).mapIt(it.filterIt(it != ' ').reversed)
var commands = groups[1].mapIt(it.split(" ")).mapIt(@[it[1], it[3], it[5]].map(parseInt))

echo tuerme

for command in commands:
    for i in countup(1, command[0]):
        tuerme[command[2] - 1].add(pop tuerme[command[1] - 1])

var output = collect(newSeq):
    for line in tuerme:
        echo line
        line[^1]

echo output.join
