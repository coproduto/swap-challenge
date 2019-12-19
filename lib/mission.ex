defmodule Mission do
  @moduledoc """
  This module defines the concept of a "mission". A mission is defined by a set
  of parameters to the problem - upper-right `bounds`, `initialPosition` of the 
  probe and probe `instructions`. Calling `Mission.run` with these parameters
  will produce the status in which the probe ended (mission outcome -- see 
  below), together with the final position of the probe.
  """

  @typedoc """
  A mission outcome represents the final status of a mission.

  * :ok            -> All commands were executed successfully

  * :out_of_bounds -> The probe fell off the plateau. The position reported
    will be the position the probe was attempting to move to when it fell off.

  * :illegal_instruction -> The probe tried to execute something that was not
  a valid instruction. The position reported will be the position where the 
  probe was when it executed the invalid instruction.

  """
  @type outcome :: :ok | :out_of_bounds | :illegal_instruction

  @doc """
  Run a mission by setting its parameters. Returns mission outcome and final
  position. Each outcome specifies how its final position should be interpreted.
  Check the `outcome` documentation above for details.
  """
  @spec run(
    Coordinate.t,
    Position.t,
    list(Instruction.t)
  ) :: {outcome, Position.t}
  def run(bounds, position, instructions) do
    coordinate = position |> elem(0)
    if in_bounds(bounds, coordinate) do
      do_run(bounds, position, instructions)
    else
      {:out_of_bounds, position}
    end
  end

  @spec do_run(
    Coordinate.t,
    Position.t,
    list(Instruction.t)
  ) :: {outcome, Position.t}
  defp do_run(_bounds, position, []), do: {:ok, position}
  defp do_run(bounds, position, [instruction | rest]) do
    case Probe.run_instruction(position, instruction) do
      :invalid_instruction -> {:invalid_instruction, position}
      {coord, direction} -> if in_bounds(bounds, coord) do
        do_run(bounds, {coord, direction}, rest)
      else
        {:out_of_bounds, {coord, direction}}
      end
    end
  end
  
  # This module-private function serves to check if a coordinate is in-bounds.
  @spec in_bounds(Coordinate.t, Coordinate.t) :: as_boolean(atom)
  defp in_bounds({x_max, y_max}, {x, y}) do
    x >= 0 && y >= 0 && x <= x_max && y <= y_max
  end
end
