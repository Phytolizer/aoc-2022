import std/[
  os,
  strutils,
]

import aoc2022pkg/[
  dec01,
  dec02,
  dec03,
  dec04,
]

when isMainModule:
  if paramCount() < 2:
    echo "Usage: aoc2022 <day> <input>"
    quit(1)

  let params = commandLineParams()

  var dayStr = params[0]
  if dayStr.startsWith("day") or dayStr.startsWith("dec"):
    dayStr = dayStr[3 .. ^1]

  let day = try:
    dayStr.parseInt()
  except ValueError:
    echo "Invalid day: ", dayStr
    echo "Expected format: dayXX or decXX or XX"
    quit 1

  let input = readFile(params[1])
  case day
  of 1:
    echo "Part 1: ", dec01.run(input, 1)
    echo "Part 2: ", dec01.run(input, 2)
  of 2:
    echo "Part 1: ", dec02.run(input, 1)
    echo "Part 2: ", dec02.run(input, 2)
  of 3:
    echo "Part 1: ", dec03.run(input, 1)
    echo "Part 2: ", dec03.run(input, 2)
  of 4:
    echo "Part 1: ", dec04.run(input, 1)
    echo "Part 2: ", dec04.run(input, 2)
  else:
    echo "Day ", day, " not implemented"
    quit 1
