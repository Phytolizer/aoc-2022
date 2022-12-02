import std/[
  strutils,
  tables,
]

type PlayResult = enum
  prLoss,
  prDraw,
  prWin,

type Shape = enum
  sRock,
  sPaper,
  sScissors,

const shapeScores = static:
  toTable([
    (sRock, 1),
    (sPaper, 2),
    (sScissors, 3),
  ])

const winScores = static:
  toTable([
    (prLoss, 0),
    (prDraw, 3),
    (prWin, 6),
  ])

const games = static:
  toTable([
    ((sRock, sRock), prDraw),
    ((sRock, sPaper), prWin),
    ((sRock, sScissors), prLoss),
    ((sPaper, sRock), prLoss),
    ((sPaper, sPaper), prDraw),
    ((sPaper, sScissors), prWin),
    ((sScissors, sRock), prWin),
    ((sScissors, sPaper), prLoss),
    ((sScissors, sScissors), prDraw),
  ])

const invertedGames = static:
  toTable([
    ((sRock, prDraw), sRock),
    ((sRock, prWin), sPaper),
    ((sRock, prLoss), sScissors),
    ((sPaper, prDraw), sPaper),
    ((sPaper, prWin), sScissors),
    ((sPaper, prLoss), sRock),
    ((sScissors, prDraw), sScissors),
    ((sScissors, prWin), sRock),
    ((sScissors, prLoss), sPaper),
  ])

const textToShape = static:
  toTable([
    ("A", sRock),
    ("B", sPaper),
    ("C", sScissors),
    ("X", sRock),
    ("Y", sPaper),
    ("Z", sScissors),
  ])

const textToPlayResult = static:
  toTable([
    ("X", prLoss),
    ("Y", prDraw),
    ("Z", prWin),
  ])

proc run*(input: string, part: int): string =
  var total = 0
  for line in input.splitLines:
    if line.isEmptyOrWhitespace:
      continue
    let words = line.splitWhitespace()
    let (call, response) = (textToShape[words[0]], words[1])

    case part
    of 1:
      let response = textToShape[response]
      let playResult = games[(call, response)]
      let score = winScores[playResult] + shapeScores[response]
      total += score
    of 2:
      let response = textToPlayResult[response]
      let shape = invertedGames[(call, response)]
      let score = winScores[response] + shapeScores[shape]
      total += score
    else:
      raiseAssert "Invalid part: " & $part

  $total
