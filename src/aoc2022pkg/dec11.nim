import std/[
  math,
  sequtils,
  strutils,
]

import max_list

type Operation = object
  lhs: int
  op: char
  rhs: int

type Monkey = object
  startingItems: seq[int]
  operation: Operation
  test: int
  throw: array[bool, int]
  inspectCount: int

proc inspect(m: Monkey, item: int): int =
  let lhs = if m.operation.lhs == 0: item else: m.operation.lhs
  let rhs = if m.operation.rhs == 0: item else: m.operation.rhs
  case m.operation.op
  of '+': lhs + rhs
  of '*': lhs * rhs
  else: raiseAssert "unreachable"

proc parseExpr(exp: string): Operation =
  let space = exp.find(' ')
  let first = exp[0 ..< space]
  let firstInt = if first == "old": 0 else: first.parseInt
  let space2 = exp.find(' ', space + 1)
  let op = exp[space + 1 ..< space2]
  let second = exp[space2 + 1 .. ^1]
  let secondInt = if second == "old": 0 else: second.parseInt
  return Operation(
    lhs: firstInt,
    op: op[0],
    rhs: secondInt
  )

proc run*(input: string, part: int): string =
  var monkeys = newSeq[Monkey]()
  var lineStart = 0

  template nextLine: string =
    let lineEnd = input[lineStart .. ^1].find('\n')
    if lineEnd == 0:
      inc lineStart
      continue
    if lineEnd == -1:
      break

    let line = input[lineStart ..< lineStart + lineEnd]
    lineStart += lineEnd + 1
    line

  var tests = newSeq[int]()

  while true:
    var line = nextLine()
    assert line.startsWith "Monkey "
    line = nextLine()
    assert line.startsWith "  Starting items: "
    let startingItems = line[18 .. ^1].split(", ").mapIt(it.parseInt)
    line = nextLine()
    assert line.startsWith("  Operation: new = ")
    let operation = line[19 .. ^1].parseExpr
    line = nextLine()
    assert line.startsWith("  Test: divisible by ")
    let test = line[21 .. ^1].parseInt
    tests.add test
    line = nextLine()
    assert line.startsWith("    If true: throw to monkey ")
    let throwTrue = line[29 .. ^1].parseInt
    line = nextLine()
    assert line.startsWith("    If false: throw to monkey ")
    let throwFalse = line[30 .. ^1].parseInt
    monkeys.add Monkey(
      startingItems: startingItems,
      operation: operation,
      test: test,
      throw: [throwFalse, throwTrue]
    )

  let testLcm = lcm(tests)

  let rounds = if part == 1: 20 else: 10000
  let divisor = if part == 1: 3 else: 1

  var round = 0
  while round < rounds:
    for monkey in monkeys.mitems:
      var throwTargets = newSeqOfCap[int](monkey.startingItems.len)
      for item in monkey.startingItems.mitems:
        inc monkey.inspectCount
        item = monkey.inspect(item) div divisor mod testLcm
        if item mod monkey.test == 0:
          throwTargets.add(monkey.throw[true])
        else:
          throwTargets.add(monkey.throw[false])
      for (i, target) in throwTargets.pairs:
        monkeys[target].startingItems.add(monkey.startingItems[i])
      monkey.startingItems.setLen(0)
    inc round

  var maxes = newMaxList[int](2)
  for monkey in monkeys:
    maxes.add(monkey.inspectCount)

  return $maxes.list.prod
