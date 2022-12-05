import std/[
  macros,
  strformat,
]

proc adventAssertion(moduleName: string, input: NimNode, part: int, expected: string): NimNode =
  result = nnkCommand.newTree(
    ident"check",
    nnkInfix.newTree(
      ident"==",
      nnkCall.newTree(
        nnkDotExpr.newTree(
          ident(moduleName),
          ident"run"
        ),
        input,
        newLit(part)
      ),
      newLit(expected)
    )
  )

macro adventTest*(day: int, expected: array[4, string]): untyped =
  let day = day.intVal
  let base = fmt"dec{day:02}"
  result = nnkStmtList.newTree()
  result.add nnkImportStmt.newTree nnkInfix.newTree(
    ident"/",
    ident"std",
    ident"unittest",
  )
  result.add nnkImportStmt.newTree nnkInfix.newTree(
    ident"/",
    ident"aoc2022pkg",
    ident(base),
  )
  let
    simpleInput = ident"simpleInput"
    input = ident"input"
  result.add nnkConstSection.newTree(
    nnkConstDef.newTree(
      simpleInput,
      newEmptyNode(),
      nnkCall.newTree(
        ident"staticRead",
        newLit(fmt"{base}-simple.txt")
      )
    ),
    nnkConstDef.newTree(
      input,
      newEmptyNode(),
      nnkCall.newTree(
        ident"staticRead",
        newLit(fmt"{base}.txt")
      )
    ),
  )

  type Test = object
    body: NimNode
    name: string

  # the actual test
  var tests: seq[Test] = @[]
  for i in 0 ..< 4:
    let
      input = [simpleInput, input][i mod 2]
      inputName = ["simple", "full"][i mod 2]
      part = i div 2 + 1
    tests.add Test(
      body: adventAssertion(base, input, part, expected[i].strVal),
      name: fmt"{inputName} {part}"
    )

  var testCases: seq[NimNode] = @[]
  for t in tests:
    testCases.add nnkCommand.newTree(
      ident"test",
      newLit(t.name),
      nnkStmtList.newTree t.body
    )

  result.add nnkCommand.newTree(
    ident"suite",
    newLit(fmt"December {day:02}"),
    nnkStmtList.newTree testCases
  )
