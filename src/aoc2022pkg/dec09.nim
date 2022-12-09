import std/[
  math,
  sequtils,
  strformat,
  strutils,
]

const DEBUGGING = false

when DEBUGGING:
  import print

template dprint(x: varargs[untyped]): untyped =
  when DEBUGGING:
    print x

proc simpleParseInt(s: string, start: int): int =
  for i in start ..< s.len:
    if s[i] notin {'0'..'9'}:
      break
    result = result * 10 + (s[i].ord - '0'.ord)

type Coord = object
  x: int
  y: int

when DEBUGGING:
  template unpackChunk(packed: uint16): Coord =
    Coord(
      x: (packed shr 8).int,
      y: (packed and 0xFF).int,
    )

template `div`(c: Coord, amount: int): Coord =
  Coord(x: c.x.floorDiv amount, y: c.y.floorDiv amount)

template pack(c: Coord): (Coord, uint16) =
  (
    c div 256,
    (c.x.uint16 shl 8) or (c.y.uint16 and 0xFF),
  )

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

template `+`(c: Coord, vec: Vec): Coord =
  Coord(x: c.x + vec.x, y: c.y + vec.y)

template `+=`(c: var Coord, vec: Vec) =
  c = c + vec

template `+=`(c: var Coord, dir: Dir) =
  c += 1 * dir

template sign(x: int): int =
  if x < 0: -1
  elif x > 0: 1
  else: 0

template moveTo(tail: Coord, head: Coord) =
  let dist = abs(head.x - tail.x) + abs(head.y - tail.y)
  if (dist > 2 or ((head.x == tail.x or head.y == tail.y) and dist > 1)):
    tail += Vec(
      x: sign(head.x - tail.x),
      y: sign(head.y - tail.y),
    )

template newDir(c: char): Dir =
  case c
  of 'L': dLeft
  of 'R': dRight
  of 'U': dUp
  of 'D': dDown
  else: raiseAssert "Invalid direction"

type Chunk = object
  pos: Coord
  visited: set[uint16]

type ChunkMap = distinct seq[Chunk]

template newChunkMap: ChunkMap =
  ChunkMap(newSeqOfCap[Chunk](4))

proc add(m: var ChunkMap, chunk: sink Chunk) =
  seq[Chunk](m).add chunk

proc `[]`(m: var ChunkMap, i: int): var Chunk =
  seq[Chunk](m)[i]

proc len(m: ChunkMap): int =
  seq[Chunk](m).len

proc countVisited(m: ChunkMap): int =
  seq[Chunk](m).mapIt(it.visited.len).sum

proc incl(m: var ChunkMap, coord: Coord) =
  let (chunkPos, packed) = coord.pack
  for i in 0 ..< m.len:
    if m[i].pos == chunkPos:
      if packed notin m[i].visited:
        dprint "[NEW]  ", chunkPos, packed.unpackChunk
      else:
        dprint "[DUPE] ", chunkPos, packed.unpackChunk
      m[i].visited.incl packed
      return
  dprint "[CHUNK]", chunkPos, packed.unpackChunk
  m.add Chunk(pos: chunkPos, visited: {packed})

when DEBUGGING:
  template all(m: ChunkMap): seq[Coord] =
    var result = newSeq[Coord]()
    for i in 0 ..< m.len:
      result.add m[i].visited.toSeq.mapIt(it.unpackChunk)
    result

proc run*(input: string, part: int): string =
  var visited = newChunkMap()
  var head = Coord(x: 0, y: 0)
  var tail = head
  visited.incl tail
  for line in input.splitLines:
    if line.isEmptyOrWhitespace: break
    let dir = line[0].newDir()
    let amount = line.simpleParseInt(2)
    let target = head + amount * dir
    while head != target:
      head += dir
      tail.moveTo(head)
      when DEBUGGING:
        print tail
      visited.incl tail

  when DEBUGGING:
    if input.len > 10000 or true:
      print visited.countVisited
      quit 0
  else:
    $visited.countVisited
