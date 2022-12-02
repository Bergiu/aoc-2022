# example code to move the band
# Move Band
# Insert a # to current position and move every character on the right
# 0101
# #0101
proc move(name: string, retptr: string, firstSymbol: Rune='#'.Rune) =
    # bei raute beenden
    M.δ[(name, '#'.Rune)] = (retptr, '#'.Rune, Movement.N)
    M.δ[(name, '0'.Rune)] = (name & "_m0", '#'.Rune, Movement.R)
    M.δ[(name, '1'.Rune)] = (name & "_m1", '#'.Rune, Movement.R)
    M.δ[(name, ' '.Rune)] = (name & "_ms", '#'.Rune, Movement.R)
    M.δ[(name, '|'.Rune)] = (name & "_mn", '#'.Rune, Movement.R)
    M.δ[(name & "_m0", '#'.Rune)] = (name & "_me", '0'.Rune, Movement.L)
    M.δ[(name & "_m0", '0'.Rune)] = (name & "_m0", '0'.Rune, Movement.R)
    M.δ[(name & "_m0", '1'.Rune)] = (name & "_m1", '0'.Rune, Movement.R)
    M.δ[(name & "_m0", ' '.Rune)] = (name & "_ms", '0'.Rune, Movement.R)
    M.δ[(name & "_m0", '|'.Rune)] = (name & "_mn", '0'.Rune, Movement.R)
    M.δ[(name & "_m1", '#'.Rune)] = (name & "_me", '1'.Rune, Movement.L)
    M.δ[(name & "_m1", '0'.Rune)] = (name & "_m0", '1'.Rune, Movement.R)
    M.δ[(name & "_m1", '1'.Rune)] = (name & "_m1", '1'.Rune, Movement.R)
    M.δ[(name & "_m1", ' '.Rune)] = (name & "_ms", '1'.Rune, Movement.R)
    M.δ[(name & "_m1", '|'.Rune)] = (name & "_mn", '1'.Rune, Movement.R)
    M.δ[(name & "_ms", '#'.Rune)] = (name & "_me", ' '.Rune, Movement.L)
    M.δ[(name & "_ms", '0'.Rune)] = (name & "_m0", ' '.Rune, Movement.R)
    M.δ[(name & "_ms", '1'.Rune)] = (name & "_m1", ' '.Rune, Movement.R)
    M.δ[(name & "_ms", ' '.Rune)] = (name & "_ms", ' '.Rune, Movement.R)
    M.δ[(name & "_ms", '|'.Rune)] = (name & "_mn", ' '.Rune, Movement.R)
    M.δ[(name & "_mn", '#'.Rune)] = (name & "_me", '|'.Rune, Movement.L)
    M.δ[(name & "_mn", '0'.Rune)] = (name & "_m0", '|'.Rune, Movement.R)
    M.δ[(name & "_mn", '1'.Rune)] = (name & "_m1", '|'.Rune, Movement.R)
    M.δ[(name & "_mn", ' '.Rune)] = (name & "_ms", '|'.Rune, Movement.R)
    M.δ[(name & "_mn", '|'.Rune)] = (name & "_mn", '|'.Rune, Movement.R)
    M.δ[(name & "_me", '#'.Rune)] = (retptr, firstSymbol, Movement.N)
    M.δ[(name & "_me", '0'.Rune)] = (name & "_me", '0'.Rune, Movement.L)
    M.δ[(name & "_me", '1'.Rune)] = (name & "_me", '1'.Rune, Movement.L)
    M.δ[(name & "_me", ' '.Rune)] = (name & "_me", ' '.Rune, Movement.L)
    M.δ[(name & "_me", '|'.Rune)] = (name & "_me", '|'.Rune, Movement.L)

