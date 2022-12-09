import std/[
  algorithm,
  sequtils,
  strutils,
]

type CrateMatrix = object
  rows: seq[seq[char]]

proc parseCrates(input: seq[string]): CrateMatrix =
  for rowIndex in 0 ..< input.len:
    var outRow: seq[char] = @[]
    let row = input[rowIndex]
    var start = 1
    while start < row.len:
      if row[start].isDigit:
        return
      outRow.add(row[start])
      start += 4
    result.rows.add(outRow)

type Instruction = object
  num: int
  source: int
  dest: int

template indexOfIt(s: string, begin: int, predicate: untyped): untyped =
  var result = -1
  for i in begin ..< s.len:
    let it {.inject.} = s[i]
    if predicate:
      result = i
      break
  result

proc parseInstructions(input: seq[string]): seq[Instruction] =
  for line in input.filterIt(it.startsWith "move"):
    let first = 5
    let firstEnd = line.indexOfIt(first, it notin Digits)
    let second = firstEnd + 6
    let secondEnd = line.indexOfIt(second, it notin Digits)
    let third = secondEnd + 4
    result.add Instruction(
      num: line[first ..< firstEnd].parseInt,
      source: line[second ..< secondEnd].parseInt,
      dest: line[third .. ^1].parseInt
    )

type CrateStacks = object
  stacks: seq[seq[char]]

proc toStacks(parsed: CrateMatrix): CrateStacks =
  let numStacks = parsed.rows.mapIt(it.len).max
  # transpose, add from bottom to top, filter out spaces
  for stackIndex in 0 ..< numStacks:
    var stack: seq[char] = @[]
    for rowIndex in (0 ..< parsed.rows.len).toSeq.reversed:
      let row = parsed.rows[rowIndex]
      if stackIndex < row.len and row[stackIndex] != ' ':
        stack.add(row[stackIndex])
    result.stacks.add(stack)

proc moveCrates(s: var CrateStacks, inst: Instruction, part: int) =
  case part
  of 1:
    for _ in 0 ..< inst.num:
      let crate = s.stacks[inst.source - 1].pop()
      s.stacks[inst.dest - 1].add(crate)
  of 2:
    # grab all crates at once
    var crates = newSeqOfCap[char](inst.num)
    for _ in 0 ..< inst.num:
      crates.add(s.stacks[inst.source - 1].pop())
    # move them to the destination
    for crate in crates.reversed:
      s.stacks[inst.dest - 1].add(crate)
  else: raiseAssert "Invalid part"

proc run*(input: string, part: int): string =
  let input = input.splitLines()
  var stacks = parseCrates(input).toStacks
  for inst in parseInstructions(input):
    moveCrates(stacks, inst, part)
  return stacks.stacks.mapIt(it[^1]).join
