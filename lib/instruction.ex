defmodule Instruction do
  @moduledoc """
  This module defines functions that operate on the probe's instructions.
  """

  @typedoc """
  A single instruction, one of :L, :R, :M, representing "Turn left", 
  "Turn right", and "Move forward", respectively. Use as `Instruction.t`.
  """
  @type t :: :L | :R | :M

  @doc """
  Takes a `string` and tries to parse it as an instruction.
  """
  @spec from_string(String.t) :: {:ok, t} | {:no_parse, String.t}
  def from_string(string) do
    case string do
      "L" -> {:ok, :L}
      "R" -> {:ok, :R}
      "M" -> {:ok, :M}
      _   -> {:no_parse, string}
    end
  end
end
