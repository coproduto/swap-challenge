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
  """
  @spec from_strings(String.t, String.t) :: {:ok, t} | {:no_parse, String.t}
  def from_strings(x_string, y_string) do
    :not_implemented
  end

  @doc """
  Moves a `coordinate` along a `direction`.
  """
  @spec move(t, Direction.t) :: t
  def move(coordinate, direction) do
    :not_implemented
  end
end
