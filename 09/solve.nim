import sequtils, strutils, math

var lens: seq[int] = readFile("input")
    .strip
    .toSeq
    .mapIt(parseInt($it))

# Part 1
proc compress(disk: var seq[int]): var seq[int] = 
    var i = 0
    while i < disk.len:
        if disk[i] == -1:
            while i < disk.len and disk[^1] == -1:
                discard disk.pop
            if i < disk.len:
                disk[i] = disk.pop
        i += 1
    disk

proc checksum(disk: var seq[int]): int = 
    (0..<disk.len)
        .mapIt(max(disk[it], 0) * it)
        .sum

echo (0..<lens.len)
    # Creates disk
    .foldl(
        (
            var acc = a
            let id = if b %% 2 == 0: b /% 2 else: -1
            acc.insert(id.repeat(lens[b]), a.len)
            acc
        ),
        newSeq[int]()
    )
    .compress
    .checksum

# Part 2
var diskLen: seq[(int, int)] = (0..<lens.len)
    .mapIt((
        let id = if it %% 2 == 0: it /% 2 else: -1
        (id, lens[it])
    ))

proc moveFile(disk: var seq[(int, int)], idx: int) = 
    let (id, len) = disk[idx]
    if id == -1: return

    for other in 0..<idx:
        let (oid, olen) = disk[other]
        let diff = olen - len
        if oid != -1 or diff < 0: continue

        if diff >= 0:
            disk[other] = (id, len)
            disk[idx] = (-1, len)
        if diff > 0:
            disk.insert((-1, diff), other+1)
        return

for i in countdown(diskLen.len-1, 0):
    diskLen.moveFile(i)

echo diskLen
    # Creates disk
    .foldl(
        (
            var acc = a
            let (id, len) = b
            acc.insert(id.repeat(len), acc.len)
            acc
        ),
        newSeq[int]()
    )
    .checksum
