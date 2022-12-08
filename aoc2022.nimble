# Package

version       = "0.1.0"
author        = "Kyle Coffey"
description   = "Advent of Code 2022 in Nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
binDir        = "bin"
bin           = @["aoc2022"]

task run, "Run the program":
  exec "nim c -d:release --outDir:bin -r src/main.nim"

task test, "Run tests":
  exec "nim c --outDir:bin -r tests/runTests.nim"

# Dependencies

requires "nim >= 1.6.8"
requires "print"
