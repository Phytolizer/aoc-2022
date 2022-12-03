import unittest

import aoc2022pkg/dec03

const
  simpleInput = staticRead("dec03-simple.txt")
  input = staticRead("dec03.txt")

suite "December 03":
  test "simple 1":
    check dec03.run(simpleInput, 1) == "157"

  test "full 1":
    check dec03.run(input, 1) == "7766"

  test "simple 2":
    check dec03.run(simpleInput, 2) == "70"

  test "full 2":
    check dec03.run(input, 2) == "2415"
