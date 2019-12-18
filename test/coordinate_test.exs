defmodule CoordinateTest do
  @moduledoc """
  Unit tests for coordinate-handling functions.
  """

  use ExUnit.Case
  doctest Direction

  test "Parse valid numbers returns coordinate" do
    assert Coordinate.from_strings("0", "0")  == {:ok, {0, 0}}
    assert Coordinate.from_strings("2", "2")  == {:ok, {2, 2}}
    assert Coordinate.from_strings("-1", "0") == {:ok, {-1, 0}}
  end

  test "Parse invalid numbers returns error" do
    assert Coordinate.from_strings("x", "y")  == {:no_parse, "{x, y}"}
    assert Coordinate.from_strings("0", "0x") == {:no_parse, "{0, 0x}"}
    assert Coordinate.from_strings("0x", "0") == {:no_parse, "{0x, 0}"}
  end

  test "Moves coordinates along specified directions" do
    assert Coordinate.move({0, 0}, :N) == {0, 1}
    assert Coordinate.move({0, 1}, :E) == {1, 1}
    assert Coordinate.move({1, 0}, :W) == {0, 0}
    assert Coordinate.move({1, 2}, :S) == {1, 1}
  end

  test "Move throws if argument is not a direction" do
    assert_raise ArgumentError, fn ->
      Coordinate.move({0, 0}, :Z)
    end
    assert_raise ArgumentError, fn ->
      Coordinate.move({0, 1}, "Blah")
    end
    assert_raise ArgumentError, fn ->
      Coordinate.move({1, 0}, -1)
    end
  end
end
