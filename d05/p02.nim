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

for command in commands:
    let fromTower = command[1] - 1
    let toTower = command[2] - 1
    let amount = command[0]
    let slice = tuerme[fromTower][^(amount)..^1]
    tuerme[fromTower] = tuerme[fromTower][0..^(amount+1)]
    tuerme[toTower].add(slice)

var output = collect(newSeq):
    for line in tuerme:
        line[^1]

echo output.join
