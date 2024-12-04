import strutils, sequtils

var input: string = readFile("input")

# Part 1
type 
    S = enum  # state
        _, m, u, l, p, n1, c, n2 
    Answer = object
        s: S
        l: int
        r: int
        sum = 0

proc trans(a: var Answer, c: char): var Answer =
    if (a.s, c) == (S._, 'm'):
        a.s = S.m
    elif (a.s, c) == (S.m, 'u'):
        a.s = S.u
    elif (a.s, c) == (S.u, 'l'):
        a.s = S.l
    elif (a.s, c) == (S.l, '('):
        a.s = S.p
    elif a.s in [S.p, S.n1] and c.isDigit:
        a.s = S.n1
        a.l = a.l * 10 + int(c) - int('0')
    elif (a.s, c) == (S.n1, ','):
        a.s = S.c
    elif a.s in [S.c, S.n2] and c.isDigit:
        a.s = S.n2
        a.r = a.r * 10 + int(c) - int('0')
    elif (a.s, c) == (S.n2, ')'):
        a.s = S._
        a.sum += a.l * a.r
        a.l = 0
        a.r = 0
    else: 
        a.s = S._
        a.l = 0
        a.r = 0
    return a

echo input.foldl((var acc = a; acc.trans(b)), Answer()).sum 

# Part 2
type 
    DS = enum  # do/don't state
        _, d, o, p1, n, ap, t, p2 
    Filter = object
        s: DS
        off: bool
        str: seq[char]

proc dTrans(f: var Filter, c: char): var Filter =
    if (f.s, c) == (DS._, 'd'):
        f.s = DS.d
    elif (f.s, c) == (DS.d, 'o'):
        f.s = DS.o
    elif (f.s, c) == (DS.o, '('):
        f.s = DS.p1
    elif (f.s, c) == (DS.p1, ')'):
        f.s = DS._
        f.off = false
    elif (f.s, c) == (DS.o, 'n'):
        f.s = DS.n
    elif (f.s, c) == (DS.n, '\''):
        f.s = DS.ap
    elif (f.s, c) == (DS.ap, 't'):
        f.s = DS.t
    elif (f.s, c) == (DS.t, '('):
        f.s = DS.p2
    elif (f.s, c) == (DS.p2, ')'):
        f.s = DS._
        f.off = true
    else:
        f.s = DS._
    if not f.off: f.str.add(c)
    return f

var filtered = input.foldl((var acc = a; acc.dTrans(b)), Filter())
echo filtered.str.foldl((var acc = a; acc.trans(b)), Answer()).sum 
