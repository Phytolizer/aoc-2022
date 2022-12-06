import std/[
  macros,
  strformat,
  strutils,
]

macro importDays*(maxDay: int): untyped =
  let maxDay = maxDay.intVal
  result = nnkImportStmt.newTree()
  for day in 1 .. maxDay:
    result.add ident(fmt"dec{day:02}")

macro runDays*(maxDay: int): untyped =
  let maxDay = maxDay.intVal
  result = nnkStmtList.newTree()
  for day in 1 .. maxDay:
    let module = ident(fmt"dec{day:02}")
    let simpleInput = fmt"../../tests/dec{day:02}-simple.txt"
    let input = fmt"../../tests/dec{day:02}.txt"
    result.add quote do:
      block:
        const
          simpleInput = `simpleInput`.staticRead
          input = `input`.staticRead
        discard [
          `module`.run(simpleInput, 1),
          `module`.run(input, 1),
          `module`.run(simpleInput, 2),
          `module`.run(input, 2),
        ]
