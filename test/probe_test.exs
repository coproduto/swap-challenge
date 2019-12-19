defmodule ProbeTest do
  @moduledoc """
  Unit tests for the `Probe`.
  """

  use ExUnit.Case
  doctest Probe

  test "Running instructions works correctly" do
    origin = {0, 0}
    assert Probe.run_instruction({origin, :N}, :L) == {origin, :W}
    assert Probe.run_instruction({origin, :N}, :R) == {origin, :E}
    assert Probe.run_instruction({origin, :N}, :M) == {{0, 1}, :N}
  end

  test "Running invalid instruction returns atom" do
    origin = {0, 0}
    assert Probe.run_instruction({origin, :N}, :T) == :invalid_instruction
    assert Probe.run_instruction({origin, :N}, 0) == :invalid_instruction
    assert Probe.run_instruction({origin, :N}, nil) == :invalid_instruction
  end
end
