import std/[
  deques,
  sets,
]

template `^^`(s: untyped, i: untyped): untyped =
  when i is BackwardsIndex:
    s.len - int(i)
  else:
    int(i)

proc `[]`[T, I: Ordinal, J: Ordinal](d: Deque[T], x: HSlice[I, J]): seq[T] =
  let a = d ^^ x.a
  let L = (d ^^ x.b) - a + 1
  result = newSeq[T](L)
  for i in 0 ..< L:
    result[i] = d[i + a]

proc checkUnique(d: Deque[char], L: int): bool =
  return d.len >= L and d[^L .. ^1].toHashSet.len == L

proc run*(input: string, part: int): string =
  let uniqueLen = if part == 1:
    4
  else:
    14
  var stream = initDeque[char](uniqueLen)
  for (i, c) in input.pairs:
    stream.addLast c
    if stream.checkUnique(uniqueLen):
      return $(i + 1)
