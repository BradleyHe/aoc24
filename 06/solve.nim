import sequtils, sugar, sets

var
    board = lines("input")
        .toSeq
        .mapIt(it.toSeq)
    n = board.len
    m = board[0].len
    deltas = @[(-1, 0), (0, 1), (1, 0), (0, -1)]
    idxs = collect:
        for i in 0..<n:
            for j in 0..<m:
                (i, j)

proc valid(i: int, j: int): bool = 
    0 <= i and i < n and 0 <= j and j < m

# Part 1
proc move(i: int, j: int, dir: var int): (int, int) = 
    let 
        ni = i + deltas[dir][0]
        nj = j + deltas[dir][1]
    if valid(ni, nj) and board[ni][nj] == '#':
        dir = (dir + 1) %% 4
        return move(i, j, dir)
    (ni, nj)

var 
    seen: HashSet[(int, int)]
    (si, sj) = idxs.filterIt(board[it[0]][it[1]] == '^')[0]
    (i, j, dir) = (si, sj, 0)

while valid(i, j):
    seen.incl((i, j))
    (i, j) = move(i, j, dir)
    
echo seen.len

# Part 2
proc loop(bi: int, bj: int): bool = 
    var
        seen: HashSet[(int, int, int)]
        (i, j, dir) = (si, sj, 0)

    let last = board[bi][bj]    
    board[bi][bj] = '#'

    while valid(i, j):
        if (i, j, dir) in seen:
            break
        seen.incl((i, j, dir))
        (i, j) = move(i, j, dir)

    board[bi][bj] = last
    return (i, j, dir) in seen

echo idxs.countIt(loop(it[0], it[1]))
