import strutils, sequtils

var reports = lines("input").toSeq.mapIt(it.splitWhitespace.mapIt(it.parseInt))

# Part 1
proc adj(rep: seq[int]): bool = countup(1, rep.len-2).toSeq.allIt((rep[it-1]-rep[it])*(rep[it]-rep[it+1]) > 0)
proc bound(rep: seq[int]): bool = countup(1, rep.len-1).toSeq.allIt((rep[it-1]-rep[it]).abs <= 3)

echo reports.filter(adj).filter(bound).len

# Part 2
proc drop(rep: seq[int]): seq[seq[int]] = countup(0, rep.len-1).toSeq.mapIt(rep[0..<it]&rep[it+1..^1])

echo reports.mapIt(drop(it)).filterIt(it.anyIt(adj(it) and bound(it))).len

