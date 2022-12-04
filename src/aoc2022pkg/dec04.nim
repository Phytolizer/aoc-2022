import std/[
  sequtils,
  strutils,
  sugar,
]

type Range = object
  min: int
  max: int

proc toRanges(s: seq[seq[string]]): seq[Range] =
  result.add Range(min: s[0][0].parseInt, max: s[0][1].parseInt)
  result.add Range(min: s[1][0].parseInt, max: s[1][1].parseInt)

proc contains(r: Range, sub: Range): bool =
  r.min <= sub.min and r.max >= sub.max

proc overlaps(r: Range, sub: Range): bool =
  r.min <= sub.min and r.max >= sub.min or
  r.min <= sub.max and r.max >= sub.max

proc run*(input: string, part: int): string =
  var total = 0
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      continue

    let ranges = line.split(',').map(s => s.split('-')).toRanges
    case part
    of 1:
      if ranges[0].contains(ranges[1]) or ranges[1].contains(ranges[0]):
        total += 1
    of 2:
      if ranges[0].overlaps(ranges[1]) or ranges[1].overlaps(ranges[0]):
        total += 1
    else: raiseAssert "Invalid part"
  $total
