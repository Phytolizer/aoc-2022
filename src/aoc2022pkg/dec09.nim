import std/[
  math,
  intsets,
  strutils,
]

proc simpleParseInt(s: string, start: int): int =
  for i in start ..< s.len:
    if s[i] notin {'0'..'9'}:
      break
    result = result * 10 + (s[i].ord - '0'.ord)

type Coord = object
  x: int
  y: int

template pack(c: Coord): int =
  (c.x + 10000) * 20001 + (c.y + 10000)

type Dir = enum
  dLeft
  dRight
  dUp
  dDown

type Vec = object
  x: int
  y: int

template `*`(amount: int, dir: Dir): Vec =
  case dir
  of dLeft: Vec(x: -amount, y: 0)
  of dRight: Vec(x: amount, y: 0)
  of dUp: Vec(x: 0, y: amount)
  of dDown: Vec(x: 0, y: -amount)

template `+=`(c: var Coord, vec: Vec) =
  c.x += vec.x
  c.y += vec.y

template `+=`(c: var Coord, dir: Dir) =
  c += 1 * dir

proc touching(c1, c2: Coord): bool =
  abs(c1.x - c2.x) <= 1 and abs(c1.y - c2.y) <= 1

template moveTo(tail: var Coord, head: Coord) =
  tail.x += sgn(head.x - tail.x)
  tail.y += sgn(head.y - tail.y)

proc newDir(c: char): Vec =
  result.x = int(c == 'R') - int(c == 'L')
  result.y = int(c == 'U') - int(c == 'D')

proc run*(input: string, part: int): string =
  var visited = initIntSet()
  var rope = newSeq[Coord](if part == 1: 2 else: 10)
  template head: untyped = rope[0]
  template tail: untyped = rope[^1]
  visited.incl tail.pack
  for line in input.splitLines:
    if line.isEmptyOrWhitespace: break
    let dir = line[0].newDir()
    let amount = line.simpleParseInt(2)
    for _ in 0 ..< amount:
      head += dir
      var i = 1
      while i < rope.len and not touching(rope[i], rope[i - 1]):
        rope[i].moveTo(rope[i - 1])
        inc i
      visited.incl tail.pack

  $visited.len
