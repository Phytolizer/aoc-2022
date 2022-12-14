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

macro runDay*(day: int, runFunc: untyped): untyped =
  result = quote do:
    block:
      let inputPath = "tests/dec" & align($`day`, 2, '0') & ".txt"
      let input = inputPath.readFile()
      for part in 1 .. 2:
        let start = getMonoTime()
        const runs = 1000
        for i in 0 ..< runs:
          discard `runFunc`(input, part)

        let fin = getMonoTime()
        let elapsed = (fin - start).inNanoseconds div runs
        let elapsedUs = elapsed.float64 / 1000.0
        echo(
          "December ",
          align($`day`, 2, '0'),
          ", part ",
          part,
          ": ",
          formatFloat(elapsedUs, ffDecimal, 3).align(8),
          " μs/run (",
          runs,
          " runs)"
        )

macro runDayOnce*(day: int, runFunc: untyped, part: int): untyped =
  result = quote do:
    block:
      let inputPath = "tests/dec" & align($`day`, 2, '0') & ".txt"
      let input = inputPath.readFile()
      discard `runFunc`(input, `part`)

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
