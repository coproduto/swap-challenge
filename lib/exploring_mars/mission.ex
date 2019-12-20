defmodule ExploringMars.Mission do
  @moduledoc """
  This module defines a mission. A mission encapsulates a single run of a probe,
  being defined by a single set of problem parameters (bounds, initial position,
  and instructions).

  Calling `ExploringMars.Mission.run/3` with these parameters will produce the
  status in which the probe ended (mission outcome -- see below), together with
  the final position of the probe.

  This module should change if the way a mission is represented changes.
  """

  alias ExploringMars.Mission.{Position, Coordinate, Instruction}

  @typedoc """
  A mission outcome represents the final status of a mission.

  * `:ok` → All commands were executed successfully

  * `:out_of_bounds` → The probe fell off the plateau. The position reported
    will be the position the probe was attempting to move to when it fell off.

  * `:illegal_instruction` → The probe tried to execute something that was not
  a valid instruction. The position reported will be the position where the
  probe was when it executed the invalid instruction.

  """
  @type outcome :: :ok | :out_of_bounds | :illegal_instruction

  @typedoc """
  A mission's result is its outcome together with its final position.
  See the `t:outcome/0` type's documentation above for further details.
  """
  @type result :: {outcome, Position.t}

  @doc """
  Run a mission by setting its parameters. Returns mission outcome and final
  position. Each outcome specifies how its final position should be interpreted.
  Check the `t:outcome/0` type's documentation above for further details.

  ## Examples

      iex> Mission.run({2, 2}, {{0, 0}, :N}, [:M, :R, :M])
      {:ok, {{1, 1}, :E}}

      iex> Mission.run({1, 1}, {{0, 0}, :N}, [:M, :R, :M, :M])
      {:out_of_bounds, {{2, 1}, :E}}

      iex> Mission.run({1, 1}, {{0, 0}, :N}, [:M, :R, "%", :M, :M])
      {:invalid_instruction, {{0, 1}, :E}}

  """
  @spec run(
    Coordinate.t,
    Position.t,
    list(Instruction.t)
  ) :: result
  def run(bounds, position, instructions) do
    coordinate = position |> elem(0)
    if in_bounds(bounds, coordinate) do
      do_run(bounds, position, instructions)
    else
      {:out_of_bounds, position}
    end
  end

  # run a mission when we know the initial position is in bounds.
  # the reason we delegate to this function is so that we only need
  # to bounds check after running each instructions, instead of bounds
  # checking before *and* after running each instruction.
  @spec do_run(
    Coordinate.t,
    Position.t,
    list(Instruction.t)
  ) :: result
  defp do_run(_bounds, position, []), do: {:ok, position}
  defp do_run(bounds, position, [instruction | rest]) do
    case Instruction.run(position, instruction) do
      :invalid_instruction -> {:invalid_instruction, position}
      {coord, direction} -> if in_bounds(bounds, coord) do
        do_run(bounds, {coord, direction}, rest)
      else
        {:out_of_bounds, {coord, direction}}
      end
    end
  end

  # Checks if a coordinate is in-bounds.
  @spec in_bounds(Coordinate.t, Coordinate.t) :: as_boolean(atom)
  defp in_bounds({x_max, y_max}, {x, y}) do
    x >= 0 && y >= 0 && x <= x_max && y <= y_max
  end

  @doc """
  Converts the result of a mission into a string suitable for user-facing
  output.

  ## Examples

      iex> Mission.result_to_string({:ok, {{1, 1}, :N}})
      "1 1 N\\n"

      iex> Mission.result_to_string({:out_of_bounds, {{1, 1}, :N}})
      "OUT OF BOUNDS @ 1 1 N\\n"

      iex> Mission.result_to_string({:invalid_instruction, {{1, 1}, :N}})
      "INVALID INSTRUCTION @ 1 1 N\\n"
  """
  @spec result_to_string(result) :: String.t
  def result_to_string(mission_result)
  def result_to_string({outcome, position}) do
    output = case outcome do
               :ok -> Position.pretty_print(position)
               :out_of_bounds ->
                 "OUT OF BOUNDS @ #{Position.pretty_print(position)}"
               :invalid_instruction ->
                 "INVALID INSTRUCTION @ #{Position.pretty_print(position)}"
             end
    output <> "\n"
  end
end
