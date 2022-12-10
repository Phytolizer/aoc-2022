import std/[
  os,
  strutils,
  times,
]

import aoc2022pkg/genStuff

importDays(10)
const RUN_FUNCS = runFuncs(10)

when isMainModule:
  let params = commandLineParams()
  if params.len > 0:
    let day = params[0].parseInt()
    runDay(day, RUN_FUNCS[day - 1])
  else:
    for i in 0 ..< 10:
      echo i
      runDays(10)
