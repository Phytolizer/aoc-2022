import std/[
  algorithm,
  re,
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

let instRe = re(r"move (\d+) from (\d+) to (\d+)", {reStudy})

proc parseInstructions(input: seq[string]): seq[Instruction] =
  for line in input.filterIt(it.startsWith "move"):
    var matches = newSeq[string](3)
    assert line.match(instRe, matches)
    result.add Instruction(
      num: matches[0].parseInt,
      source: matches[1].parseInt,
      dest: matches[2].parseInt
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
