defmodule DirectionTest do
  @moduledoc """
  Unit tests for direction-handling functions.
  """

  use ExUnit.Case
  doctest Direction

  test "Parse valid string returns direction" do
    assert Direction.from_string("N") == {:ok, :N}
    assert Direction.from_string("E") == {:ok, :E}
    assert Direction.from_string("W") == {:ok, :W}
    assert Direction.from_string("S") == {:ok, :S}
  end

  test "Parse invalid string returns error" do
    assert Direction.from_string("Not valid")   == {:no_parse, "Not valid"}
    assert Direction.from_string(:not_a_string) == {:no_parse, :not_a_string}
  end

  test "Turn left turns to the left" do
    assert Direction.turn_left(:N) == :W
    assert Direction.turn_left(:E) == :N
    assert Direction.turn_left(:W) == :S
    assert Direction.turn_left(:S) == :E
  end

  test "Turn right turns to the right" do
    assert Direction.turn_right(:N) == :E
    assert Direction.turn_right(:E) == :S
    assert Direction.turn_right(:W) == :N
    assert Direction.turn_right(:S) == :W
  end

  test "Turn left throws if given invalid data" do
    assert_raise ArgumentError, fn -> 
        Direction.turn_left(:Not_valid)
    end
    assert_raise ArgumentError, fn ->
      Direction.turn_left(0)
    end
    assert_raise ArgumentError, fn ->
      Direction.turn_left("E")
    end
  end

  test "Turn right throws if given invalid data" do
    assert_raise ArgumentError, fn ->
      Direction.turn_right(:Not_valid)
    end
    assert_raise ArgumentError, fn ->
      Direction.turn_right(0)
    end
    assert_raise ArgumentError, fn ->
      Direction.turn_left("W")
    end
  end
end
