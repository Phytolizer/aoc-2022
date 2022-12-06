import std/[
  macros,
  monotimes,
  strformat,
  strutils,
  times,
]

macro importDays*(maxDay: int): untyped =
  let maxDay = maxDay.intVal
  result = nnkImportStmt.newTree()
  for day in 1 .. maxDay:
    result.add ident(fmt"dec{day:02}")

macro runFuncs*(maxDay: int): untyped =
  result = nnkBracket.newTree()
  for day in 1 .. maxDay.intVal:
    let module = ident(fmt"dec{day:02}")
    result.add quote do:
      `module`.run

macro runDay*(day: int, fmtDay: string, runFunc: untyped): untyped =
  result = quote do:
    block:
      let simpleInputPath = "tests/dec" & `fmtDay` & "-simple.txt"
      let inputPath = "tests/dec" & `fmtDay` & ".txt"
      let
        simpleInput = simpleInputPath.readFile()
        input = inputPath.readFile()
      let start = getMonoTime()
      for i in 0..<1000:
        discard [
          `runFunc`(simpleInput, 1),
          `runFunc`(input, 1),
          `runFunc`(simpleInput, 2),
          `runFunc`(input, 2),
        ]
      let fin = getMonoTime()
      let elapsed = (fin - start).inMicroseconds
      echo elapsed

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
