defmodule ExploringMars.Mission.Position do
  @moduledoc """
  This module defines functions that operate on the probe's position.

  This module should change if the way a position is specified changes.
  For instance, if we had 3D space instead of 2D, or further degrees of
  freedom. See the notes in the `Coordinate` and `Direction` modules.
  """

  alias ExploringMars.Mission.{Coordinate, Direction}

  @typedoc """
  The probe's position, specified by an x-coordinate, y-coordinate 
  and direction. Use as `Position.t`.
  """
  @type t :: {Coordinate.t, Direction.t}

  @doc """
  Takes three strings representing the `x_coordinate`, `y_coordinate`
  and `direction` of the probe and returns either :ok and the specified
  position or :no_parse and a description of what went wrong.

  ## Examples

      iex> Position.from_strings("1", "1", "N")
      {:ok, {{1, 1}, :N}}

      iex> Position.from_strings("1", "1", "K")
      {:no_parse, "Invalid direction K"}

      iex> Position.from_strings("x", "1", "N")
      {:no_parse, "Invalid coordinates x 1"}

      iex> Position.from_strings("x", "1", "K")
      {:no_parse, "Invalid coordinates x 1, Invalid direction K"}
      
  """
  @spec from_strings(
    String.t,
    String.t,
    String.t
  ) :: {:ok, t} | {:no_parse, String.t}
  def from_strings(x_string, y_string, direction_string) do
    coordinate = Coordinate.from_strings(x_string, y_string)
    direction = Direction.from_string(direction_string)
    case {coordinate, direction} do
      {{:ok, coords}, {:ok, dir}} -> {:ok, {coords, dir}}
      _ ->
        coord_error = get_error coordinate, fn data ->
          "Invalid coordinates #{data}"
        end
        direction_error = get_error direction, fn data ->
          "Invalid direction #{data}"
        end
        error = [coord_error, direction_error]
        |> Enum.filter(fn s -> String.trim(s) != "" end)
        |> Enum.join(", ")
        {:no_parse, error}
    end
  end

  # Takes a potential error tuple and converts it into a description
  # if it is indeed an error
  @spec get_error({atom, term}, (term -> String.t)) :: String.t
  defp get_error({err, data}, desc) do
    if err != :ok do
      desc.(data)
    else
      ""
    end
  end

  @doc """
  Takes a `position` and returns the position obtained by moving forward
  from that position.

  ## Examples
      
      iex> Position.move_forward({{0, 0}, :N})
      {{0, 1}, :N}

      iex> Position.move_forward({{0, 0}, :W})
      {{-1, 0}, :W}

  """
  @spec move_forward(t) :: t
  def move_forward(position)
  def move_forward({coordinate, direction}) do
    {Coordinate.move(coordinate, direction), direction}
  end

  @doc """
  Takes a `position` and returns the position obtained by turning left
  from that position.

  ## Examples

      iex> Position.turn_left({{2, 2}, :N})
      {{2, 2}, :W}

  """
  @spec turn_left(t) :: t
  def turn_left(position)
  def turn_left({coordinate, direction}) do
    {coordinate, Direction.turn_left(direction)}
  end

  @doc """
  Takes a `position` and returns the position obtained by turning right
  from that position.

  ## Examples

      iex> Position.turn_right({{2, 2}, :N})
      {{2, 2}, :E}

  """
  @spec turn_right(t) :: t
  def turn_right(position)
  def turn_right({coordinate, direction}) do
    {coordinate, Direction.turn_right(direction)}
  end

  @doc """
  Converts a `position` into a representation suitable for user-facing output.

  ## Examples

      iex> Position.pretty_print({{2, 2}, :S})
      "2 2 S"
  """
  @spec pretty_print(t) :: String.t
  def pretty_print(position)
  def pretty_print({coord, dir}) do
    "#{Coordinate.pretty_print(coord)} #{Direction.pretty_print(dir)}"
  end
end
