defmodule Direction do
  @moduledoc """
  This module defines functions that create and operate on directions.
  """

  @typedoc """
  A direction is represented by an atom - either :N, :E, :W or :S representing
  North, East, West and South respectively. Use as `Direction.t`.
  """
  @type t :: :N | :E | :W | :S

  @doc """
  Takes a `string` and tries to parse it as a direction.
  """
  @spec from_string(String.t) :: {:ok, t} | {:no_parse, String.t}
  def from_string(string) do
    :not_implemented
  end

  @doc """
  Takes a `direction` and returns the direction obtained by turning left.
  """
  @spec turn_left(t) :: t
  def turn_left(direction) do
    :not_implemented
  end

  @doc """
  Takes a `direction` and returns the direction obtained by turning right.
  """
  @spec turn_right(t) :: t
  def turn_right(direction) do
    :not_implemented
  end
end
