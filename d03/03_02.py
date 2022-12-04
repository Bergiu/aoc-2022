inp = """vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
inp = open("inp.txt").read()

lines = [set(line) for line in inp.splitlines()]
intersections = [list(lines[i*3].intersection(lines[i*3+1]).intersection(lines[i*3+2]))[0] for i,_ in enumerate(lines[::3])]
priorities = [ord(inter) - 65 + 27 if ord(inter) < 97 else ord(inter) - 96 for inter in intersections]

print(sum(priorities))
