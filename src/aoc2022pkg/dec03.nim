import std/[
  sequtils,
  strutils,
]

proc partition(s: string): (string, string) =
  let middle = s.len div 2
  let left = s[0 ..< middle]
  let right = s[middle ..< s.len]
  (left, right)


proc priority(letter: char): int =
  case letter
  of {'a'..'z'}:
    ord(letter) - ord('a') + 1
  of {'A'..'Z'}:
    ord(letter) - ord('A') + 27
  else:
    0


proc toBitset(s: string): set[char] =
  for c in s:
    result.incl(c)


proc prod(s: openArray[set[char]]): set[char] =
  result = s[0]
  for i in 1 ..< s.len:
    result = result * s[i]


proc run*(input: string, part: int): string =
  var total = 0
  var i = 0
  var groups: array[3, set[char]]
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      continue
    if part == 1:
      let (left, right) = line.partition()
      let uniqueLeft = left.toBitset()
      let uniqueRight = right.toBitset()

      let intersection = uniqueLeft * uniqueRight
      total += intersection.items.toSeq[0].priority
    else:
      groups[i] = line.toBitset()
      inc i
      if i == 3:
        let intersection = groups.prod()
        total += intersection.items.toSeq[0].priority
        i = 0
  $total
