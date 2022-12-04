import unittest

import aoc2022pkg/dec04

const
  simpleInput = staticRead("dec04-simple.txt")
  input = staticRead("dec04.txt")

suite "December 04":
  test "simple 1":
    check dec04.run(simpleInput, 1) == "2"

  test "full 1":
    check dec04.run(input, 1) == "433"

  test "simple 2":
    check dec04.run(simpleInput, 2) == "4"

  test "full 2":
    check dec04.run(input, 2) == "852"
