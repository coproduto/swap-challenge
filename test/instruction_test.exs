defmodule InstructionTest do
  @moduledoc """
  Unit tests for instruction creation.
  """

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
end
