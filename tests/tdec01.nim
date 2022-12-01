import unittest

import aoc2022pkg/dec01

const
  simpleInput = staticRead("dec01-simple.txt")
  input = staticRead("dec01.txt")

suite "December 01":
  test "simple 1":
    check dec01.run(simpleInput, 1) == "24000"

  test "full 1":
    check dec01.run(input, 1) == "69289"

  test "simple 2":
    check dec01.run(simpleInput, 2) == "45000"

  test "full 2":
    check dec01.run(input, 2) == "205615"
