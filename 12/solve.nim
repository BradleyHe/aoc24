include std/prelude
import sugar

var 
    map: seq[seq[char]] = lines("input")
        .toSeq
        .mapIt(it.toSeq)
    n = map.len
    deltas = @[(1, 0), (-1, 0), (0, 1), (0, -1)]
    seen: HashSet[(int, int)]
    groups: seq[HashSet[(int, int)]] = @[]

proc valid(t: (int, int)): bool = 
    0 <= t[0] and t[0] < n and 0 <= t[1] and t[1] < n

# Tuple operation overloads
proc `[]`[T](arr: openarray[seq[T]], t: (int, int)): T = arr[t[0]][t[1]]
proc `+`(t1: (int, int), t2: (int, int)): (int, int) = (t1[0]+t2[0], t1[1]+t2[1])

# Part 1
proc count(pos: (int, int), c: char): (int, int) =
    var res = (1, 0)  # area, perimeter
    groups[^1].incl(pos)
    for newPos in deltas.mapIt(it + pos):
        if not valid(newPos) or map[newPos] != c:  # Edge
            res[1] += 1
        elif not (newPos in seen):  # Area
            seen.incl(newPos)
            res = res + count(newPos, c)
    return res

var res = 0
for i in 0..<n:
    for j in 0..<n:
        let idx = (i, j)
        if not (idx in seen):
            seen.incl(idx)
            groups.add(initHashSet[(int, int)]())
            let (area, perim) = count(idx, map[idx])
            res += area * perim
echo res

# Part 2
# For every group, scan every row/column edge and count # of contiguous runs
res = 0
for group in groups:
    var runs = 0
    for dir in @[false, true]:
        for i in -1..<n:
            var prev = (false, false)
            for j in 0..<n:
                let 
                    inside = if dir: (i, j) else: (j, i)
                    outside = if dir: (i+1, j) else: (j, i+1)
                    curr = (inside in group, outside in group)
                if (curr[0] xor curr[1]) and curr != prev:
                    runs += 1
                prev = curr
    res += runs * group.len
echo res