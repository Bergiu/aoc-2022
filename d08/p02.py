inp = """30373
25512
65332
33549
35390"""

inp = open("inp.txt").read()

# int, sichtbar
matrix = [[(int(c), -1) for c in line] for line in inp.split("\n") if line != ""]

def calc_viewing_distance(matrix, i, j):
    curval, _ = matrix[i][j]
    # up
    up = 0
    for ii in reversed(range(0, i)):
        val, _ = matrix[ii][j]
        if val >= curval:
            up += 1
            break
        else:
            up += 1
    down = 0
    for ii in range(i+1, len(matrix)):
        val, _ = matrix[ii][j]
        if val >= curval:
            down += 1
            break
        else:
            down += 1
    right = 0
    for jj in range(j+1, len(matrix[0])):
        val, _ = matrix[i][jj]
        if val >= curval:
            right += 1
            break
        else:
            right += 1
    left = 0
    for jj in reversed(range(0, j)):
        val, _ = matrix[i][jj]
        if val >= curval:
            left += 1
            break
        else:
            left += 1
    return up * down * right * left

for i, line in enumerate(matrix):
    # now bewerte alle chars beginnend links
    for j, tp in enumerate(line):
        num, _ = line[j]
        vd = calc_viewing_distance(matrix, i, j)
        matrix[i][j] = (num, vd)


print(max([max([val for _, val in line]) for line in matrix]))
