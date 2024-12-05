import strutils, sequtils, tables, sets, math, algorithm

var
    parts = readFile("input")
        .split("\n\n")
    rules = parts[0]
        .splitLines
        .mapIt(it.split("|").map(parseInt))
    updates = parts[1]
        .splitWhitespace
        .mapIt(it.split(",").map(parseInt))

# Part 1
let ban_map = rules.foldl(
    (
        discard a.mgetOrPut(b[0], initHashSet[int]());
        a.mgetOrPut(b[1], initHashSet[int]()).incl(b[0]); 
        a
    ), 
    newTable[int, HashSet[int]]()
)

proc correct(nums: seq[int]): bool =
    var banned: HashSet[int]
    for num in nums:
        if num in banned: return false
        if num in ban_map: banned = banned.union(ban_map[num])
    return true

echo updates.filter(correct)
    .mapIt(it[it.len div 2])
    .sum

# Part 2
proc order(x: int, y: int): int =
    if x in ban_map[y]: 1
    elif y in ban_map[x]: -1
    else: 0

echo updates.filterIt(not correct(it))
    .mapIt(sorted(it, order))
    .mapIt(it[it.len div 2])
    .sum
