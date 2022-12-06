import std/[
  deques,
  sequtils,
  sets,
]

proc run*(input: string, part: int): string =
  let uniqueLen = if part == 1:
    4
  else:
    14
  var stream = initDeque[char](uniqueLen)
  for (i, c) in input.pairs:
    stream.addLast c
    if stream.len > uniqueLen:
      stream.popFirst()
    if stream.items.toSeq.toHashSet.len == uniqueLen:
      return $(i + 1)
