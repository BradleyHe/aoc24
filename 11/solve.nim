import strutils, sequtils, tables, math

var 
    stones: seq[string] = readFile("input").splitWhitespace
    cache: Table[(string, int), int]

proc count(stone: string, depth: int): int = 
    if depth == 0:
        return 1
    if (stone, depth) in cache:
        return cache[(stone, depth)]
    
    var res = block:
        if stone == "0":
            count("1", depth-1)
        elif stone.len %% 2 == 0:
            count($(stone[0..<stone.len/%2].parseInt), depth-1) + count($(stone[stone.len/%2..^1].parseInt), depth-1)
        else:
            count($(stone.parseInt * 2024), depth-1)
            
    cache[(stone, depth)] = res
    res

# Parts 1 and 2
echo stones.mapIt(count(it, 25)).sum
echo stones.mapIt(count(it, 75)).sum