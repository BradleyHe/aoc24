import sequtils, sugar, tables, sets

let
    board: seq[seq[char]] = lines("input")
        .toSeq
        .mapIt(it.toSeq)
    n: int = board.len
    m: int = board[0].len
    idxs: seq[(int, int)] = collect:
        for i in 0..<n:
            for j in 0..<m:
                (i, j)
    
proc valid(t: (int, int)): bool = 
    0 <= t[0] and t[0] < n and 0 <= t[1] and t[1] < m

# Index into 2D seq with tuple
proc `[]`[T](arr: seq[seq[T]], tup: (int, int)): T = arr[tup[0]][tup[1]]

# Tuple ops
proc `-`(t1: (int, int), t2: (int, int)): (int, int) = (t1[0]-t2[0], t1[1]-t2[1])
proc `+`(t1: (int, int), t2: (int, int)): (int, int) = (t1[0]+t2[0], t1[1]+t2[1])
proc `*`(t: (int, int), m: int): (int, int) = (t[0]*m, t[1]*m)

# Helper function
proc inclValid(s: var HashSet[(int, int)], val: (int, int)) = 
    if valid(val): s.incl(val)

# Part 1
let antenna_map = idxs.foldl(
    (
        let c: char = board[b]
        if c != '.':
            a.mgetOrPut(c, @[]).add(b)
        a
    ),
    newTable[char, seq[(int, int)]]()
)

var uniq: HashSet[(int, int)]
for antennas in antenna_map.values:
    for i in 0..<antennas.len-1:
        for j in i+1..<antennas.len:
            let offset = antennas[i] - antennas[j]
            uniq.inclValid(antennas[i] + offset)
            uniq.inclValid(antennas[j] - offset)
echo uniq.len

# Part 2
uniq.clear
for antennas in antenna_map.values:
    for i in 0..<antennas.len-1:
        for j in i+1..<antennas.len:
            let offset = antennas[i] - antennas[j]
            for k in -n..n:
                uniq.inclValid(antennas[i] + offset*k)
echo uniq.len