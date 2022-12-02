import numpy as np

lines = [line.replace(" ", "") for line in open("inp.txt").read().splitlines()]

mapping = {
    "A": np.array([1,0,0]),
    "B": np.array([0,1,0]),
    "C": np.array([0,0,1]),
    "X": np.array([1,0,0]),
    "Y": np.array([0,1,0]),
    "Z": np.array([0,0,1])
}

actions = [[mapping[c] for c in line] for line in lines]

r_mapping = np.array([
    [1,0,0],
    [0,1,0],
    [0,0,1],
    [1,2,3]
])

l_mapping = np.array([
    [3,6,0,1],
    [0,3,6,1],
    [6,0,3,1]
])

m = np.matmul(l_mapping, r_mapping)

s = sum([np.matmul(L, np.matmul(m, R)) for L, R in actions])
print(s)
