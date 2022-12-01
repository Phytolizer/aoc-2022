import std/[
  math,
  sequtils,
  strutils,
]

type MaxList = object
  n: int
  list: seq[int]

proc newMaxList(n: int): MaxList =
  result.n = n
  result.list = newSeqOfCap[int](n)

proc add(self: var MaxList, x: int) =
  if self.list.len < self.n:
    self.list.add(x)
    return

  let min = self.list.min()
  if x < min:
    return
  self.list = self.list.filterIt(it != min).concat(@[x])

proc run*(input: string, part: int): string =
  var currTotal = 0
  let n = case part
    of 1: 1
    of 2: 3
    else: raiseAssert "Invalid part " & $part
  var bestTotals = newMaxList(n)
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      bestTotals.add(currTotal)
      currTotal = 0
      continue

    let calories = line.parseInt()
    currTotal += calories

  if currTotal > 0:
    bestTotals.add(currTotal)

  return $bestTotals.list.sum()
