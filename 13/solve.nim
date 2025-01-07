import math
include std/prelude

var
    parts = readFile("input")
        .split("\n\n")
        .mapIt(it.splitLines)
    abs = parts
        .mapIt(it[0][10..^1])
        .mapIt(it.split(", "))
        .mapIt(
            it
            .mapIt(it[2..^1])
            .map(parseInt)
        )
        .mapIt((it[0], it[1]))
    bbs = parts
        .mapIt(it[1][10..^1])
        .mapIt(it.split(", "))
        .mapIt(
            it
            .mapIt(it[2..^1])
            .map(parseInt)
        )
        .mapIt((it[0], it[1]))
    prizes = parts
        .mapIt(it[2][7..^1])
        .mapIt(it.split(", "))
        .mapIt(
            it
            .mapIt(it[2..^1])
            .map(parseInt)
        )
        .mapIt((it[0], it[1]))

proc `+`(t: (int, int), a: int): (int, int) = (t[0]+a, t[1]+a)

# finds d s.t. xd = y (mod m)
proc moddiv(x: int, y: int, m: int): int = 
    # scuffed brute force
    for d in 0..<m:
        if (d * x) %% m == y %% m:
            return d
    -1

proc solve(a: (int, int), b: (int, int), p: (int, int)): int = 
    let 
        (ax, bx, px) = (a[0], b[0], p[0])
        (ay, by, py) = (a[1], b[1], p[1])
        (bx_mul, by_mul) = (moddiv(bx, px, ax), moddiv(by, py, ay))

    if bx_mul == -1 or by_mul == -1 or px /% bx < bx_mul: return 0  # Can never sum to prize using b

    # Now we know number of b presses = ax/gcd(ax, bx)*n + bx_mul, where n is an integer
    # Binary search for n
    var 
        period = ax /% gcd(ax, bx)
        l = 0
        r = (px /% bx - bx_mul) /% period
        dir = period * b[1] > b[0] /% gcd(ax, bx) * a[1]  # if dir is true, decrease n when overshoot
    while l <= r:
        let 
            mid = (l + r) /% 2
            b_press = period * mid + bx_mul
            a_press = (px - b_press * bx) /% ax
            y = ay * a_press + by * b_press
        if y > py:
            if dir: r = mid - 1 else: l = mid + 1
        elif y < py:
            if dir: l = mid + 1 else: r = mid - 1
        else:
            return 3*a_press + b_press
    0

# Parts 1 and 2
echo (0..<prizes.len)
    .toSeq
    .mapIt(solve(abs[it], bbs[it], prizes[it]))
    .sum
echo (0..<prizes.len)
    .toSeq
    .mapIt(solve(abs[it], bbs[it], prizes[it] + 10000000000000))
    .sum
