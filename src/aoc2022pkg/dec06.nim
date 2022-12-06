import std/[
  deques,
  math,
]

proc run*(input: string, part: int): string =
  var seen: array[char, int]
  let uniqueLen =
    if part == 1: 4
    else: 14
  var deq = initDeque[char](uniqueLen + 1)
  for (i, c) in input.pairs:
    seen[c] += 1
    deq.addLast(c)
    block main:
      if i >= uniqueLen:
        seen[deq.popFirst()] -= 1
        for dc in deq:
          if seen[dc] > 1:
            break main
        return $(i + 1)
