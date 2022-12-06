import std/[
  strutils,
]

type Range = object
  min: int
  max: int

proc parseInt(bounds: (int, int), s: string): int =
  for i in bounds[0] ..< bounds[1]:
    result *= 10
    result += s[i].ord - '0'.ord

proc toRanges(s: string): array[2, Range] =
  var matches: array[4, (int, int)]
  var hyphen = s.find('-')
  matches[0] = (0, hyphen)
  let comma = s.find(',', hyphen + 1)
  matches[1] = (hyphen + 1, comma)
  hyphen = s.find('-', comma + 1)
  matches[2] = (comma + 1, hyphen)
  matches[3] = (hyphen + 1, s.len)
  result[0] = Range(min: matches[0].parseInt(s), max: matches[1].parseInt(s))
  result[1] = Range(min: matches[2].parseInt(s), max: matches[3].parseInt(s))

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

    let ranges = (line).toRanges
    case part
    of 1:
      if ranges[0].contains(ranges[1]) or ranges[1].contains(ranges[0]):
        total += 1
    of 2:
      if ranges[0].overlaps(ranges[1]) or ranges[1].overlaps(ranges[0]):
        total += 1
    else: raiseAssert "Invalid part"
  $total
