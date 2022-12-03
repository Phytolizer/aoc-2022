import std/[
  sequtils,
  sets,
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


proc run*(input: string, part: int): string =
  var total = 0
  var i = 0
  var groups: seq[HashSet[char]] = @[]
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      continue
    if part == 1:
      let (left, right) = line.partition()
      let uniqueLeft = left.toHashSet()
      let uniqueRight = right.toHashSet()

      let intersection = uniqueLeft * uniqueRight
      total += intersection.items.toSeq[0].priority
    else:
      groups.add line.toHashSet()
      inc i
      if i == 3:
        let intersection = groups[0] * groups[1] * groups[2]
        total += intersection.items.toSeq[0].priority
        groups.setLen(0)
        i = 0
  $total
