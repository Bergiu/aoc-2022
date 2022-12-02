import std/sets
import std/tables
import unicode
import types
import band
import strutils
import sequtils
import std/strformat
import std/algorithm


type Turingmachine* = ref object of RootObj
    Q: OrderedSet[State]   # states
    q0: State           # initial state
    F: OrderedSet[State]   # final states
    Σ: OrderedSet[Symbol]  # input symbols
    Γ: OrderedSet[Symbol]  # alphabet symbols
    b: Symbol           # blank (Γ\Σ)
    δ*: TransitionTable  # partial function, transition function: δ(s1,1) = (0,s2,R)
    currentState: State
    band*: Band

proc debug*(self: Turingmachine) =
    echo "Band: " & $self.band
    echo "Symbol under cursor: '" & $self.band.read() & "'"
    echo "Position: " & $self.band.getPos
    echo "Band Position: " & $self.band.getBandStart
    echo "Current State: " & $self.currentState

proc newTuringmachine*(Q: OrderedSet[State], q0: State, F: OrderedSet[State], Σ: OrderedSet[Symbol], Γ: OrderedSet[Symbol], b: Symbol): Turingmachine =
    return Turingmachine(Q: Q, q0: q0, F: F, Σ: Σ, Γ: Γ, b: b, δ: initTable[TransitionTableKey, TransitionTableValue](), currentState: q0)

method isFinished(self: Turingmachine, debuging: bool): bool {.base.} =
    if self.currentState in self.F:
        if debuging:
            self.debug
        return true
    return false

method next(self: Turingmachine, debuging: bool) {.base.} =
    var currentSymbol = self.band.read()
    var key = (self.currentState, currentSymbol)
    if self.band.getPos %% 100 == 0:
        echo $self.currentState & " " & $self.band.getPos & "/" & $len($self.band) & " " & $self.band.getBandStart
    if key notin self.δ:
        if debuging:
            self.debug
        raise newException(OSError, "No transition for: " & $key)
    var transition = self.δ[key]
    self.currentState = transition.newState
    self.band.write(transition.newSymbol)
    self.band.move(transition.movement)

method run*(self: Turingmachine, debuging: bool=true) {.base.} =
    while not self.isFinished(debuging):
        if debuging:
            echo "Band: " & $self.band & " \t(" & $self.band.getPos & ")"
        self.next(debuging)

method setInput*(self: Turingmachine, input: string) {.base.} =
    self.band = newBand(input, self.b)


proc printTM*(tm: Turingmachine)=
    var str = ""
    var table = initTable[State, Table[string, string]]()
    for key, val in tm.δ:
        #TransitionTableKey* = tuple[state: State, symbol: Symbol]
        var tableVal = table.getOrDefault(key.state)
        tableVal[$key.symbol] = "(" & val.newState & "," & $val.newSymbol & "," & $val.movement & ")"
        table[key.state] = tableVal
    var keys: seq[string] = @[]
    for key in table.keys:
        keys.add($key)
    var headers: seq[string] = @[]
    for key in tm.Γ:
        headers.add($key)
    keys.sort()
    headers.sort()

    str &= "Q={" & keys.join(",") & "}\n"
    str &= "Σ={" & tm.Σ.mapIt($it).join(",") & "}\n"
    str &= "Γ={" & tm.Γ.mapIt($it).join(",") & "}\n"
    str &= "q₀=" & tm.q0 & "\n"
    str &= "□=" & $tm.b & "\n"
    str &= "F={" & tm.F.mapIt($it).join(",") & "}\n"
    str &= "δ=\n"

    str &= strutils.align("", 14)
    for header in headers:
        if header == " ":
            str &= strutils.align("space", 18)
        else:
            str &= strutils.align(header, 18)
    str &= "\n"
    str &= strutils.align("", 14)
    str &= strutils.align("", 18*len(headers), '-')
    str &= "\n"
    for key in keys:
        str &= strutils.align(fmt"{key} | ", 14)
        for sym in headers:
            var transition = table[key].getOrDefault(sym, "error")
            str &= strutils.align(transition, 18)
        str &= "\n"

    echo str


