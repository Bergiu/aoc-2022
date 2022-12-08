inp = """30373
25512
65332
33549
35390"""

inp = open("inp.txt").read()

# int, sichtbar
matrix = [[(int(c), False) for c in line] for line in inp.split("\n") if line != ""]

for i, line in enumerate(matrix):
    # now bewerte alle chars beginnend links
    last_biggest_size = -1
    for j, tp in enumerate(line):
        num, visible = tp
        if last_biggest_size < num:
            last_biggest_size = num
            matrix[i][j] = (num, True)
    # now bewerte alle chars beginnend rechts
    last_biggest_size = -1
    for j, tp in reversed(list(enumerate(line))):
        num, visible = tp
        if last_biggest_size < num:
            last_biggest_size = num
            matrix[i][j] = (num, True)

# beginnend von oben
for j, tp in enumerate(matrix[0]):
    last_biggest_size = -1
    for i, line in enumerate(matrix):
        num, visible = line[j]
        if last_biggest_size < num:
            last_biggest_size = num
            matrix[i][j] = (num, True)
    last_biggest_size = -1
    for i, line in reversed(list(enumerate(matrix))):
        num, visible = line[j]
        if last_biggest_size < num:
            last_biggest_size = num
            matrix[i][j] = (num, True)

summed = 0
for line in matrix:
    for c,v in line:
        if v:
            summed += 1
        print(int(v), end="")
    print("")

print(summed)
