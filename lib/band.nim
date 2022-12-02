import types
import unicode

type Band* = ref object of RootObj
    band: seq[Rune]
    #band: string
    bandStart: int
    pos: int
    blank: Symbol

func getPos*(self: Band): int = self.pos
func getBandStart*(self: Band): int = self.bandStart

proc newBand*(input: string, blank: Symbol): Band =
    Band(band: input.toRunes, bandStart: 0, pos: 0, blank: blank)

proc `$`*(band: Band): string =
    $band.band

func read*(self: Band): Rune =
    #[
    "abcdef"  0
    "012345" band position
    "012345" array pos
    "abcdef" bandStart: -2
    "210123" band position
    "012345" array pos
    "###abcdef" bandStart: 3
    "012345678" band position
    "321012345" array pos
    ]#
    var arrayPos = self.pos - self.bandStart
    if arrayPos < 0:
        return self.blank
    if arrayPos >= self.band.len:
        return self.blank
    return self.band[arrayPos]

func move*(self: Band, movement: Movement) =
    case movement:
        of Movement.R:
            inc self.pos
        of Movement.L:
            dec self.pos
        of Movement.N:
            discard

func write*(self: Band, rune: Rune) =
    var arrayPos = self.pos - self.bandStart
    if arrayPos < 0:
        self.band.insert(rune)
        dec self.bandStart
    elif arrayPos >= self.band.len:
        # man muss eh jedesmal schreiben
        self.band.add(rune)
    else:
        self.band[arrayPos] = rune

