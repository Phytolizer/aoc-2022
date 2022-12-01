import std/[
  math,
  strutils,
]

proc insertSorted(s: var seq[int], item: int) =
  var i = 0
  while i < s.len and s[i] < item:
    inc i
  s.insert(item, i)

proc run*(input: string, part: int): string =
  var currTotal = 0
  var bestTotals = newSeq[int]()
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      bestTotals.insertSorted(currTotal)
      currTotal = 0
      continue

    let calories = line.parseInt()
    currTotal += calories

  case part
  of 1:
    return $bestTotals[^1]
  of 2:
    return $sum(bestTotals[^3 .. ^1])
  else:
    raiseAssert "invalid part " & $part
