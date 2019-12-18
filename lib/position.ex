defmodule Position do
  @moduledoc """
  This module defines functions that operate on the probe's position.
  """

  @typedoc """
  The probe's position, specified by an x-coordinate, y-coordinate 
  and direction. Use as `Position.t`.
  """
  @type t :: {Coordinate.t, Direction.t}

  @doc """
  Takes three strings representing the `x_coordinate`, `y_coordinate`
  and `direction` of the probe and returns either :ok and the specified
  position or :no_parse and a description of what went wrong.
  """
  @spec from_strings(
    String.t,
    String.t,
    String.t
  ) :: {:ok, t} | {:no_parse, String.t}
  def from_strings(x_string, y_string, direction_string) do
    :not_implemented
  end

  @doc """
  Takes a `position` and returns the position obtained by moving forward
  from that position.
  """
  @spec move_forward(t) :: t
  def move_forward(position) do
    :not_implemented
  end

  @doc """
  Takes a `position` and returns the position obtained by turning left
  from that position.
  """
  @spec turn_left(t) :: t
  def turn_left(position) do
    :not_implemented
  end

  @doc """
  Takes a `position` and returns the position obtained by turning right
  from that position.
  """
  @spec turn_right(t) :: t
  def turn_right(position) do
    :not_implemented
  end
end
