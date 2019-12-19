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

  ## Examples

      iex> Direction.from_string("N")
      {:ok, :N}

      iex> Direction.from_string("Not a direction")
      {:no_parse, "Not a direction"}
  """
  @spec from_string(String.t) :: {:ok, t} | {:no_parse, String.t}
  def from_string(string) do
    case string do
      "N" -> {:ok, :N}
      "E" -> {:ok, :E}
      "W" -> {:ok, :W}
      "S" -> {:ok, :S}
      _   -> {:no_parse, string}
    end
  end

  def pretty_print(direction), do: Atom.to_string(direction)

  @doc """
  Takes a `direction` and returns the direction obtained by turning left.

  ## Examples

     iex> Direction.turn_left(:N)
     :W
     iex> Direction.turn_left(:Not_a_direction)
     ** (ArgumentError) argument is not a direction

  """
  @spec turn_left(t) :: t
  def turn_left(direction) do
    case direction do
      :N -> :W
      :E -> :N
      :W -> :S
      :S -> :E
      _  -> raise ArgumentError, message: "argument is not a direction"
    end
  end

  @doc """
  Takes a `direction` and returns the direction obtained by turning right.

  ## Examples

     iex> Direction.turn_right(:N)
     :E
     iex> Direction.turn_right(:Not_a_direction)
     ** (ArgumentError) argument is not a direction
  """
  @spec turn_right(t) :: t
  def turn_right(direction) do
    case direction do
      :N -> :E
      :E -> :S
      :W -> :N
      :S -> :W
      _  -> raise ArgumentError, message: "argument is not a direction"
    end
  end
end
