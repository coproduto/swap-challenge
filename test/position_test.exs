defmodule PositionTest do
  @moduledoc """
  Unit tests for functions that operate on the probe's position.
  """

  alias ExploringMars.Mission.Position
  use ExUnit.Case
  doctest Position

  test "Parse valid options returns position" do
    assert Position.from_strings("0", "0", "N") == {:ok, {{0, 0}, :N}}
    assert Position.from_strings("1", "-1", "S") == {:ok, {{1, -1}, :S}}
  end

  test "Parse invalid options returns error" do
    # We do not specify the error messages here. The Position module should
    # emit user-facing error messages which should be able to change for many
    # reasons.
    assert Position.from_strings("A", "B", "C")  |> elem(0) == :no_parse
    assert Position.from_strings("0", "0", "Z")  |> elem(0) == :no_parse
    assert Position.from_strings("0Y", "0", "S") |> elem(0) == :no_parse
    assert Position.from_strings("0", "0X", "E") |> elem(0) == :no_parse
    assert Position.from_strings(:"0", :"0", :N) |> elem(0) == :no_parse
  end

  test "Move forward moves the probe along current direction" do
    assert Position.move_forward({{0, 0}, :N}) == {{0, 1}, :N}
    assert Position.move_forward({{0, 0}, :S}) == {{0, -1}, :S}
    assert Position.move_forward({{0, 0}, :E}) == {{1, 0}, :E}
    assert Position.move_forward({{0, 0}, :W}) == {{-1, 0}, :W}
  end

  test "Turn left changes the current direction to the left once" do
    assert Position.turn_left({{0, 0}, :N}) == {{0, 0}, :W}
    assert Position.turn_left({{0, 0}, :E}) == {{0, 0}, :N}
    assert Position.turn_left({{0, 0}, :W}) == {{0, 0}, :S}
    assert Position.turn_left({{0, 0}, :S}) == {{0, 0}, :E}
  end

  test "Turn right changes the current direction to the right once" do
    assert Position.turn_right({{0, 0}, :N}) == {{0, 0}, :E}
    assert Position.turn_right({{0, 0}, :E}) == {{0, 0}, :S}
    assert Position.turn_right({{0, 0}, :W}) == {{0, 0}, :N}
    assert Position.turn_right({{0, 0}, :S}) == {{0, 0}, :W}
  end
end
