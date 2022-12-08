import std/[
  sequtils,
  strutils,
]

import neo

type Direction = enum
  dLeft
  dRight
  dUp
  dDown

type TreeGrid = object
  grid: Matrix[int]

proc newTreeGrid*(input: string): TreeGrid =
  let lines = input.filterIt(it notin Whitespace).mapIt(it.int - '0'.int)
  let numLines = input.countIt(it == '\n')
  result.grid = matrix(rowMajor, numLines, input.find('\n'), lines)

proc go(i: int, j: int, dir: Direction): tuple[r: int, c: int] =
  case dir
  of dLeft: (i, j - 1)
  of dRight: (i, j + 1)
  of dUp: (i - 1, j)
  of dDown: (i + 1, j)

proc countVisible(tg: TreeGrid, dir: Direction, seen: var set[uint16]) =
  # if dir is dLeft or dRight, iterate rows then cols
  # if dir is dUp or dDown, iterate cols then rows

  let (rows, cols) = tg.grid.dim
  case dir
  of {dUp, dDown}:
    for c in 0 ..< cols:
      var r = if dir == dUp: rows - 1 else: 0
      var treetop = -1
      while r >= 0 and r < rows:
        if tg.grid[r, c] > treetop:
          treetop = tg.grid[r, c]
          seen.incl(r.uint16 shl 8 or c.uint16)
        r = go(r, c, dir).r
  of {dLeft, dRight}:
    for r in 0 ..< rows:
      var c = if dir == dLeft: cols - 1 else: 0
      var treetop = -1
      while c >= 0 and c < cols:
        if tg.grid[r, c] > treetop:
          treetop = tg.grid[r, c]
          seen.incl(r.uint16 shl 8 or c.uint16)
        c = go(r, c, dir).c

proc scenicScore(tg: TreeGrid, i: int, j: int): int =
  let (rows, cols) = tg.grid.dim
  proc inbounds(r: int, c: int): bool =
    r >= 0 and r < rows and c >= 0 and c < cols
  result = 1
  for d in Direction:
    var r = i
    var c = j
    var peak = tg.grid[r, c]
    (r, c) = go(r, c, d)
    var partial = 0
    while inbounds(r, c):
      inc partial
      if tg.grid[r, c] >= peak:
        break
      (r, c) = go(r, c, d)
    result *= partial

proc run*(input: string, part: int): string =
  let tg = input.newTreeGrid
  case part
  of 1:
    var seen: set[uint16]
    for d in Direction:
      tg.countVisible(d, seen)
    $seen.len
  of 2:
    var m = 0
    for i in 0 ..< tg.grid.dim.rows:
      for j in 0 ..< tg.grid.dim.columns:
        m = max(m, tg.scenicScore(i, j))
    $m
  else: raiseAssert "invalid part"
