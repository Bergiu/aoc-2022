import std/sets
import std/math
import std/tables
import unicode
import strutils
import sequtils
import sugar

let unicodeMode = false

type
    State = string
    Symbol = Rune
    Movement = enum
        R, L, N
    TransitionTableKey = tuple[state: State, symbol: Symbol]
    TransitionTableValue = tuple[newState: State, newSymbol: Symbol, movement: Movement]
    TransitionTable = Table[TransitionTableKey, TransitionTableValue]

proc bin(movement: Movement): string =
    result = case movement:
        of Movement.L:
            "0"
        of Movement.N:
            "1"
        of Movement.R:
            "2"

proc log2(i: int): float = log2(i.toFloat)

proc bin(i: int): string =
    if i == 0:
        result = "0"
    else:
        result = i.toBin(ceil(log2(i+1)).toInt)

proc symbolBin(s: OrderedSet[Symbol]): proc(rune: Rune): string =
    if unicodeMode:
        return (rune: Rune) => bin(ord(rune))
    else:
        return (rune: Rune) => bin(s.find(rune))

proc mapToBin(c: char): string =
    result = case c:
        of '0':
            "00"
        of '1':
            "01"
        of '#':
            "10"
        else:
            raise new OSError

#[
proc toState(state: string): State =
    var index: int
    for i in countdown(high(state), low(state)):
        if not state[i].isDigit:
            index = i+1
            break
    result.name = state[low(state)..<index]
    result.number = state[index..high(state)].parseUInt
]#

proc toState(s: string): string =
    result = s

type Turingmachine = object
    Q: OrderedSet[State]   # states
    q0: State           # initial state
    F: OrderedSet[State]   # final states
    Σ: OrderedSet[Symbol]  # input symbols
    Γ: OrderedSet[Symbol]  # alphabet symbols
    b: Symbol           # blank (Γ\Σ)
    δ: TransitionTable  # partial function, transition function: δ(s1,1) = (0,s2,R)

proc toGoedelnummer(tm: Turingmachine): string =
    # There are different ways to create a goedelnummer
    var statesList = toSeq(tm.Q)
    var symBin = symbolBin(tm.Γ)
    var transitionsCode = ""
    for key, val in tm.δ:
        transitionsCode &= "##"
        transitionsCode &= bin(statesList.find(key.state))
        transitionsCode &= "#"
        transitionsCode &= symBin(key.symbol)
        transitionsCode &= "#"
        transitionsCode &= bin(statesList.find(val.newState))
        transitionsCode &= "#"
        transitionsCode &= symBin(val.newSymbol)
        transitionsCode &= "#"
        transitionsCode &= bin(val.movement)
    result = transitionsCode.map((c) => mapToBin(c)).join


var tm = Turingmachine(
    Q: toOrderedSet(["q0".toState, "q1".toState]),
    q0: "q0".toState,
    F: toOrderedSet(["q1".toState]),
    Σ: toOrderedSet(toRunes("01")),
    Γ: toOrderedSet(toRunes("01#")),
    b: '#'.Rune,
    δ: initTable[TransitionTableKey, TransitionTableValue]()
)
tm.δ[("q0".toState, '0'.Rune)] = ("q0".toState, '0'.Rune, Movement.N)
#tm.δ[("q0".toState, '1'.Rune)] = ("q0".toState, '0'.Rune, Movement.R)
#tm.δ[("q0".toState, '0'.Rune)] = ("q0".toState, '1'.Rune, Movement.R)
#tm.δ[("q0".toState, '#'.Rune)] = ("q1".toState, '#'.Rune, Movement.L)

echo toGoedelnummer(tm)
