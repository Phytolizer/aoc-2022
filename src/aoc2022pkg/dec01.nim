import std/[
  math,
  strutils,
]

import max_list

proc run*(input: string, part: int): string =
  var currTotal = 0
  let n = case part
    of 1: 1
    of 2: 3
    else: raiseAssert "Invalid part " & $part
  var bestTotals = newMaxList[int](n)
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
