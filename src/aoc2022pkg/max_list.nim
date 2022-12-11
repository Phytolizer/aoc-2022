import std/sequtils

type MaxList*[T] = object
  n*: int
  list*: seq[T]

proc newMaxList*[T](n: int): MaxList[T] =
  result.n = n
  result.list = newSeqOfCap[T](n)

proc add*[T](self: var MaxList, x: T) =
  if self.list.len < self.n:
    self.list.add(x)
    return

  let min = self.list.min()
  if x < min:
    return
  self.list = self.list.filterIt(it != min).concat(@[x])

