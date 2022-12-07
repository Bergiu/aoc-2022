inp = """$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"""

inp = open("inp.txt").read()

def getparent(tree, currentpath):
    if currentpath == "/":
        raise Exception()
    lastparent = None
    currentdir = tree  # /
    for path in currentpath:
        lastparent = currentdir
        currentdir = currentdir[path] # cd path
    return lastparent


def countsize(tree, path):
    mysize = 0
    overallsize = 0
    l = {}
    for key, val in tree.items():
        if isinstance(val, int):
            mysize += val
        else:
            newoverallsize, newl = countsize(val, path+"/"+key)
            mysize += newoverallsize
            l.update(newl)
    l[path] = mysize
    return mysize, l


# assuming filename and dirname in the same directory cant be the same
sizes = 0
tree = {"/": {}}
currentpath = ["/"]
currentdir = tree["/"]
for line in inp.split("\n")[1:]:
    if line == "":
        pass
    elif line.startswith("$ ls"):
        pass
    elif line.startswith("$ cd"):
        dir = line[4:].strip()
        if dir == "..":
            currentdir = getparent(tree, currentpath)
            currentpath.pop()
        else:
            if dir not in currentdir.keys():
                currentdir[dir] = {}
            currentdir = currentdir[dir]
            currentpath.append(dir)
    elif line.startswith("dir"):
        dir = line[3:].strip()
        if dir not in currentdir.keys():
            currentdir[dir] = {}
    else:
        size, fname = line.split(" ", 1)
        currentdir[fname] = int(size)

size, sizes = countsize(tree["/"], "")
need = 30000000 - (70000000 - size)
all_big = list(filter(lambda x: x[1] >= need, sizes.items()))
print(all_big, min(map(lambda b: b[1], all_big)))
