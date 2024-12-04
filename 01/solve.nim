import strutils
import sequtils
import algorithm
import tables

# Part 1
var
    l: seq[int] = @[]
    r: seq[int] = @[]

for line in lines("input"): 
    var toks = line.splitWhitespace
    l.add(toks[0].parseInt)
    r.add(toks[1].parseInt)

l.sort
r.sort
var p1 = 0
for (a, b) in zip(l, r): 
    p1 += abs(a - b)
echo p1

# Part 2
let r_count = r.toCountTable
var p2 = 0
for num in l:
    p2 += r_count[num] * num
echo p2