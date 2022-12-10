import std/strutils

type Cpu = object
  x: int = 1
  cycle: int

type Crt = object
  scanlines: array[6, array[40, bool]]
  scannerX: int
  scannerY: int

proc drawNext(crt: var Crt, cpu: Cpu) =
  if abs(crt.scannerX - cpu.x) <= 1:
    crt.scanlines[crt.scannerY][crt.scannerX] = true
  crt.scannerX += 1
  if crt.scannerX >= 40:
    crt.scannerX = 0
    crt.scannerY += 1
    if crt.scannerY >= 6:
      crt.scannerY = 0

proc render(crt: Crt): seq[string] =
  for y in 0 ..< 6:
    var line = ""
    for x in 0 ..< 40:
      line.add(if crt.scanlines[y][x]: '#' else: '.')
    result.add(line)
  result

proc run*(input: string, part: int): string =
  var cpu = Cpu()
  var crt = Crt()
  var checkpoint = 20
  var strength = 0

  for line in input.splitLines:
    if line.len == 0:
      continue

    let (add, cycles) = case line[0]
    of 'n':
      # noop
      (0, 1)
    of 'a':
      # addx <n>
      (line[5..^1].parseInt, 2)
    else:
      raiseAssert "Unknown instruction: " & line

    if cpu.cycle + cycles >= checkpoint:
      strength += cpu.x * checkpoint
      checkpoint += 40

    for _ in 0 ..< cycles:
      drawNext(crt, cpu)
    cpu.x += add
    cpu.cycle += cycles

  case part
  of 1: result = $strength
  of 2:
    for line in crt.render:
      result &= line & '\n'
  else: discard
