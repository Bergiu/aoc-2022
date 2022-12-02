import std/[sequtils,strutils,tables,math]

let mapping = {
    "A X": 4, "A Y": 8, "A Z": 3,
    "B X": 1, "B Y": 5, "B Z": 9,
    "C X": 7, "C Y": 2, "C Z": 6
}.toTable

echo readFile("inp.txt").splitlines()
            .filterIt(it != "")
            .mapIt(mapping[it])
            .sum
