import std/[
  os,
  strutils,
  times,
]

import aoc2022pkg/genStuff

importDays(6)
const RUN_FUNCS = runFuncs(6)

when isMainModule:
  let params = commandLineParams()
  if params.len > 0:
    let day = params[0].parseInt()
    runDay(day, align($day, 2, '0'), RUN_FUNCS[day - 1])
  else:
    for i in 0 ..< 10:
      echo i
      runDays(6)
