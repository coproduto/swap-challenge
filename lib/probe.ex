defmodule Probe do
  @moduledoc """
  This module defines the operation of the probe.
  """

  @doc """
  Takes a probe position and an instruction and returns the next position of the
  probe.
  """
  @spec run_instruction(Position.t, Instruction.t)
    :: Position.t | :invalid_instruction
  def run_instruction(position, instruction) do
    case instruction do
      :L -> Position.turn_left(position)
      :R -> Position.turn_right(position)
      :M -> Position.move_forward(position)
      _  -> :invalid_instruction
    end
  end
end
