defmodule ExploringMars.Mission.Coordinate do
  @moduledoc """
  This module defines functions that create and operate on coordinates in the
  probe's space of movement.

  This module and the `Direction` module should change if the
  coordinate representation used in the problem changes - for instance,
  if we choose to use `{y, x}` coordinates instead of `{x, y}` or if we choose
  to model a probe moving in 3D space.

  This means this module is coupled to the `ExploringMars.Mission.Direction` 
  module, as it depends directly on the representation of the 
  `t:ExploringMars.Mission.Direction.t/0` type. This is acceptable for now, as 
  the Direction type is quite simple, but it might need change. Check the 
  note in the documentation of the `ExploringMars.Mission.Direction` module for
  further details.
  """

  alias ExploringMars.Mission.Direction

  @typedoc """
  A coordinate is defined as a pair of integers specifying a position on the
  cartesian plane. The order of coordinates is `{x, y}`.
  """
  @type t :: {integer, integer}

  @doc """
  Takes a pair of strings, `x_string` and `y_string` and tries to
  parse them as a coordinate.

  ## Examples

      iex> Coordinate.from_strings("100", "200")
      {:ok, {100, 200}}

      iex> Coordinate.from_strings("100x", "200y")
      {:no_parse, "100x 200y"}

  """
  @spec from_strings(String.t(), String.t()) :: {:ok, t} | {:no_parse, String.t()}
  def from_strings(x_string, y_string) do
    # we require parsing to be exact - no remaining characters!
    with {x_val, ""} <- safe_parse_integer(x_string),
         {y_val, ""} <- safe_parse_integer(y_string) do
      {:ok, {x_val, y_val}}
    else
      _ -> {:no_parse, "#{x_string} #{y_string}"}
    end
  end

  @doc """
  Does the same as `from_strings`, but fails if any of the coordinate's 
  components would be negative.
  """
  @spec positive_from_strings(
          String.t(),
          String.t()
        ) :: {:ok, t} | {:no_parse, String.t()}
  def positive_from_strings(x_string, y_string) do
    with {x_val, ""} when x_val >= 0 <- safe_parse_integer(x_string),
         {y_val, ""} when y_val >= 0 <- safe_parse_integer(y_string) do
      {:ok, {x_val, y_val}}
    else
      _ -> {:no_parse, "#{x_string} #{y_string}"}
    end
  end

  # Integer.parse can throw in many situations. This can lead to unexpected
  # cases which we wish to avoid.
  defp safe_parse_integer(string) do
    try do
      Integer.parse(string)
    rescue
      _ -> :no_parse
    end
  end

  @doc """
  Moves a `coordinate` along a `direction`.

  ## Examples

      iex> Coordinate.move({-1, 0}, :E)
      {0, 0}

      iex> Coordinate.move({0, 0}, "Not a direction")
      ** (ArgumentError) argument is not a direction

  """
  @spec move(t, Direction.t()) :: t
  def move(coordinate, direction)

  def move({x, y}, direction) do
    case direction do
      :N -> {x, y + 1}
      :E -> {x + 1, y}
      :W -> {x - 1, y}
      :S -> {x, y - 1}
      _ -> raise ArgumentError, message: "argument is not a direction"
    end
  end

  @doc """
  Converts a `coordinate` into a representation suitable for user-facing output.

  ## Examples

      iex> Coordinate.pretty_print({2, -2})
      "2 -2"

  """
  @spec pretty_print(t) :: String.t()
  def pretty_print(coordinate)

  def pretty_print({x, y}) do
    "#{x} #{y}"
  end
end
