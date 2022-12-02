import unicode
import std/tables

type
    State* = string
    Symbol* = Rune
    Movement* = enum
        R, L, N
    TransitionTableKey* = tuple[state: State, symbol: Symbol]
    TransitionTableValue* = tuple[newState: State, newSymbol: Symbol, movement: Movement]
    TransitionTable* = Table[TransitionTableKey, TransitionTableValue]

