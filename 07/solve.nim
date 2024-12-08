import strutils, sequtils, math

let 
    eqs: seq[seq[string]] = lines("input").toSeq
        .mapIt(it.split(": "))
    lhs: seq[int] = eqs.mapIt(it[0].parseInt)
    rhs: seq[seq[int]] = eqs.mapIt(
            it[1].splitWhitespace
            .toSeq
            .mapIt(it.parseInt)
        )
    n: int = eqs.len

# Part 1
proc valid(target: int, nums: seq[int]): bool = 
    var
        curr: seq[int] = @[nums[0]]
        next: seq[int] = @[]

    for i in 1..<nums.len:
        for c in curr:
            if c > target: continue
            next.add(c + nums[i])
            next.add(c * nums[i])
        curr = next
        next = @[]
    return target in curr

echo (0..<n).toSeq
    .filterIt(valid(lhs[it], rhs[it]))
    .mapIt(lhs[it])
    .sum

# Part 2
proc valid2(target: int, nums: seq[int]): bool = 
    var
        curr: seq[int] = @[nums[0]]
        next: seq[int] = @[]
        
    for i in 1..<nums.len:
        for c in curr:
            if c > target: continue
            next.add(c + nums[i])
            next.add(c * nums[i])
            next.add(($c & $nums[i]).parseInt)
        curr = next
        next = @[]
    return target in curr

echo (0..<n).toSeq
    .filterIt(valid2(lhs[it], rhs[it]))
    .mapIt(lhs[it])
    .sum
        