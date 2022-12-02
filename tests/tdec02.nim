import unittest

import aoc2022pkg/dec02

const
  simpleInput = staticRead("dec02-simple.txt")
  input = staticRead("dec02.txt")

suite "December 02":
  test "simple 1":
    check dec02.run(simpleInput, 1) == "15"

  test "full 1":
    check dec02.run(input, 1) == "14531"

  test "simple 2":
    check dec02.run(simpleInput, 2) == "12"

  test "full 2":
    check dec02.run(input, 2) == "11258"
