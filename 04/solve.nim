import sequtils

let
    board = lines("input").toSeq.mapIt(it.toSeq)
    n = board.len
    m = board[0].len

# Part 1
var res = 0
for i in 0..<n:
    for j in 0..<m:
        var words: seq[seq[char]] = @[]
        if j < m-3: 
            words.add(board[i][j..<j+4])
        if i < n-3:
            words.add((0..<4).mapIt(board[i+it][j]))
        if i < n-3 and j < m-3:
            words.add((0..<4).mapIt(board[i+it][j+it]))
        if i >= 3 and j < m-3:
            words.add((0..<4).mapIt(board[i-it][j+it]))
        res += words.countIt(it == "XMAS" or it == "SAMX")
echo res

# Part 2
var res2 = 0
for i in 1..<n-1:
    for j in 1..<m-1:
        let w1 = (-1..1).mapIt(board[i+it][j+it])
        let w2 = (-1..1).mapIt(board[i-it][j+it])
        res2 += int((w1 == "MAS" or w1 == "SAM") and (w2 == "MAS" or w2 == "SAM"))
echo res2




