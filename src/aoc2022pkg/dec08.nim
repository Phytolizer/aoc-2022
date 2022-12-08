import std/[
  sequtils,
  strutils,
  sugar,
]

type Direction = enum
  dLeft
  dRight
  dUp
  dDown

type TreeGrid = object
  grid: seq[int]
  rows: int
  cols: int

template `[]`(tg: ptr TreeGrid, i: int, j: int): int =
  tg.grid[i * tg.cols + j]

proc newTreeGrid*(input: string): TreeGrid =
  let lines = collect(newSeqOfCap(input.len)):
    for c in input:
      if c notin Whitespace:
        c.int - '0'.int
  let numLines = input.countIt(it == '\n')
  result.grid = lines
  result.rows = numLines
  result.cols = input.find('\n')

template go(i: int, j: int, dir: Direction): tuple[r: int, c: int] =
  case dir
  of dLeft: (i, j - 1)
  of dRight: (i, j + 1)
  of dUp: (i - 1, j)
  of dDown: (i + 1, j)

proc countVisible(tg: ptr TreeGrid, dir: Direction, seen: var set[uint16]) =
  # if dir is dLeft or dRight, iterate rows then cols
  # if dir is dUp or dDown, iterate cols then rows

  case dir
  of {dUp, dDown}:
    for c in 0 ..< tg.cols:
      var r = if dir == dUp: tg.rows - 1 else: 0
      var treetop = -1
      while r >= 0 and r < tg.rows:
        if tg[r, c] > treetop:
          treetop = tg[r, c]
          seen.incl(r.uint16 shl 8 or c.uint16)
        r = go(r, c, dir).r
  of {dLeft, dRight}:
    for r in 0 ..< tg.rows:
      var c = if dir == dLeft: tg.cols - 1 else: 0
      var treetop = -1
      while c >= 0 and c < tg.cols:
        if tg[r, c] > treetop:
          treetop = tg[r, c]
          seen.incl(r.uint16 shl 8 or c.uint16)
        c = go(r, c, dir).c

template scenicScore(tg: ptr TreeGrid, i: int, j: int): int =
  block:
    template inbounds(r: int, c: int): bool =
      r >= 0 and r < tg.rows and c >= 0 and c < tg.cols
    var res = 1
    for d in Direction:
      var r = i
      var c = j
      var peak = tg[r, c]
      (r, c) = go(r, c, d)
      var partial = 0
      while inbounds(r, c):
        inc partial
        if tg[r, c] >= peak:
          break
        (r, c) = go(r, c, d)
      res *= partial
    res

proc run*(input: string, part: int): string =
  let tgAlloc = input.newTreeGrid
  let tg = unsafeAddr tgAlloc
  case part
  of 1:
    var seen: set[uint16]
    for d in Direction:
      tg.countVisible(d, seen)
    $seen.len
  of 2:
    var m = 0
    for i in 0 ..< tg.rows:
      for j in 0 ..< tg.cols:
        m = max(m, tg.scenicScore(i, j))
    $m
  else: raiseAssert "invalid part"
