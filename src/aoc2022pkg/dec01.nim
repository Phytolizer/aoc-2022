import std/[
  math,
  strutils,
]

type MaxList = object
  n: int
  list: seq[int]

proc newMaxList(n: int): MaxList =
  result.n = n
  result.list = newSeq[int](n)

proc add(self: var MaxList, x: int) =
  if self.list.len == 0:
    self.list.add(x)
    return

  var insertIndex = self.list.len
  for (i, v) in self.list.pairs:
    if x <= v:
      insertIndex = i
      break

  self.list.insert(x, insertIndex)
  if self.list.len > self.n:
    self.list = self.list[1 .. ^1]

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

  return $bestTotals.list.sum()
