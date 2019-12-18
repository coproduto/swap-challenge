defmodule Coordinate do
  @moduledoc """
  This module defines functions that create and operate on coordinates.
  """

  @typedoc """
  A coordinate is defined as a pair of integers specifying a position on the
  cartesian plane. The order of coordinates is {x, y}.
  """
  @type t :: {integer, integer}

  @doc """
  Takes a pair of strings, `x_string` and `y_string` and tries to 
  parse them as a coordinate.

  ## Examples

     iex> Coordinate.from_strings("100", "200")
     {:ok, {100, 200}}
     iex> Coordinate.from_strings("100x", "200y")
     {:no_parse, "{100x, 200y}"}
  """
  @spec from_strings(String.t, String.t) :: {:ok, t} | {:no_parse, String.t}
  def from_strings(x_string, y_string) do
    x = safe_parse_integer(x_string)
    y = safe_parse_integer(y_string)
    case {x, y} do
      {{x_val, ""}, {y_val, ""}} -> # we require parsing to be exact -
        {:ok, {x_val, y_val}}       # no remaining characters!
      _ -> {:no_parse, "{#{x_string}, #{y_string}}"}
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
  @spec move(t, Direction.t) :: t
  def move(coordinate, direction)
  def move({x, y}, direction) do
    case direction do
      :N -> {x,   y+1}
      :E -> {x+1, y  }
      :W -> {x-1, y  }
      :S -> {x,   y-1}
      _ -> raise ArgumentError, message: "argument is not a direction"
    end
  end
end
