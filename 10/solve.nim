import strutils, sequtils, sugar, sets, math

let 
    map: seq[seq[int]] = lines("input")
        .toSeq
        .mapIt(
            it
            .toSeq
            .mapIt(parseInt($it))
        )
    n = map.len
    deltas = @[(1, 0), (-1, 0), (0, 1), (0, -1)]

proc valid(t: (int, int)): bool = 
    0 <= t[0] and t[0] < n and 0 <= t[1] and t[1] < n

# Tuple operation overloads
proc `[]`[T](arr: openarray[seq[T]], t: (int, int)): T = arr[t[0]][t[1]]
proc `+`(t1: (int, int), t2: (int, int)): (int, int) = (t1[0]+t2[0], t1[1]+t2[1])

# Parts 1 and 2
let heads: seq[(int, int)] = collect:
    for i in 0..<n:
        for j in 0..<n:
            if map[i][j] == 0:
                (i, j)

proc count(head: (int, int), dup: bool): int =
    var 
        st = @[head]
        seen = st.toHashSet
        res = 0

    while st.len > 0:
        let p = st.pop
        if map[p] == 9:
            res += 1
            continue
        for delta in deltas:
            let np = p + delta
            if (not seen.contains(np) or dup) and valid(np) and map[np] == map[p] + 1:
                seen.incl(np)
                st.add(np)
    res

echo heads.mapIt(it.count(false)).sum
echo heads.mapIt(it.count(true)).sum

