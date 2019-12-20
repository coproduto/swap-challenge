defmodule ExploringMars.Mission.Instruction do
  @moduledoc """
  This module defines functions that operate on the probe's instructions.

  This module - and only this module - should change if new instructions are
  added, instructions are removed or if the meaning of instructions is changed.
  """

  alias ExploringMars.Mission.Position

  @typedoc """
  A single instruction, one of :L, :R, :M, representing "Turn left",
  "Turn right", and "Move forward", respectively. Use as `Instruction.t`.
  """
  @type t :: :L | :R | :M

  @doc """
  Takes a `string` and tries to parse it as an instruction.

  ## Examples

      iex> Instruction.from_string("L")
      :L

      iex> Instruction.from_string("")
      {:no_parse, ""}

  """
  @spec from_string(String.t) :: t | {:no_parse, String.t}
  def from_string(string) do
    case string do
      "L" -> :L
      "R" -> :R
      "M" -> :M
      _   -> {:no_parse, string}
    end
  end

  @doc """
  Takes a probe position and an instruction and returns the next position of the
  probe.

  ## Examples

      iex> Instruction.run({{0, 0}, :N}, :M)
      {{0, 1}, :N}

      iex> Instruction.run({{0, 0}, :N}, :L)
      {{0, 0}, :W}

      iex> Instruction.run({{0, 0}, :N}, :K)
      :invalid_instruction

  """
  @spec run(Position.t, t) :: Position.t | :invalid_instruction
  def run(position, instruction) do
    case instruction do
      :L -> Position.turn_left(position)
      :R -> Position.turn_right(position)
      :M -> Position.move_forward(position)
      _  -> :invalid_instruction
    end
  end
end
