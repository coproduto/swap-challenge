defmodule InstructionTest do
  @moduledoc """
  Unit tests for instruction creation.
  """

  alias ExploringMars.Mission.Instruction
  use ExUnit.Case
  doctest Instruction

  test "Parse valid string returns instruction" do
    assert Instruction.from_string("L") == :L
    assert Instruction.from_string("R") == :R
    assert Instruction.from_string("M") == :M
  end

  test "Parse invalid string returns error" do
    assert Instruction.from_string("N") == {:no_parse, "N"}
    assert Instruction.from_string("T")  == {:no_parse, "T"}
    assert Instruction.from_string("01") == {:no_parse, "01"}
    assert Instruction.from_string(nil) == {:no_parse, nil}
  end

  test "Running instructions works correctly" do
    origin = {0, 0}
    assert Instruction.run({origin, :N}, :L) == {origin, :W}
    assert Instruction.run({origin, :N}, :R) == {origin, :E}
    assert Instruction.run({origin, :N}, :M) == {{0, 1}, :N}
  end

  test "Running invalid instruction returns atom" do
    origin = {0, 0}
    assert Instruction.run({origin, :N}, :T) == :invalid_instruction
    assert Instruction.run({origin, :N}, 0) == :invalid_instruction
    assert Instruction.run({origin, :N}, nil) == :invalid_instruction
  end
end
