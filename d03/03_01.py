inp = """vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
inp = open("inp.txt").read()

lines = [(line[:len(line)//2], line[len(line)//2:]) for line in inp.splitlines()]
intersections = [list(set(l).intersection(set(r)))[0] for l,r in lines]
priorities = [ord(inter) - 65 + 27 if ord(inter) < 97 else ord(inter) - 96 for inter in intersections]
print(sum(priorities))
