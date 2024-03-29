defmodule ExploringMars.Mission.Direction do
  @moduledoc """
  This module defines functions that create and operate on directions in the
  probe's coordinate space.

  This module should change if the coordinate representation used in the
  problem changes in degrees of freedom - for instance, if we decide the probe
  could move in 3D space rather than 2D, or if the probe could move in 8 
  directions instead of 4. In that case, we would need to also change the
  `Coordinate` module in order to handle the new directions.

  This coupling between the `Direction` and `Coordinate` modules is, for now,
  acceptable, because the `Direction`s to be handled are few. If we were to
  choose a case where we would have more possible `Direction`s, it might
  be worthwhile to create an `Axis` module which would specify the *axes of
  movement* available to the probe, and make both `Direction` and `Coordinate`
  modules depend on the `Axis` module - the `Direction` module would produce
  which axis or axes correspond to each direction, and the `Coordinate` module
  would know how to update the coordinate according to motion on each axis.

  That way, we would mitigate the amount of code that should be changed in the
  case of a change in coordinate system degrees of freedom.
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
  @spec from_string(String.t()) :: {:ok, t} | {:no_parse, String.t()}
  def from_string(string) do
    case string do
      "N" -> {:ok, :N}
      "E" -> {:ok, :E}
      "W" -> {:ok, :W}
      "S" -> {:ok, :S}
      _ -> {:no_parse, string}
    end
  end

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
      _ -> raise ArgumentError, message: "argument is not a direction"
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
      _ -> raise ArgumentError, message: "argument is not a direction"
    end
  end

  @doc """
  Converts a `Direction.t` into a representation suitable for user-facing output.

  ## Examples

      iex> Direction.pretty_print(:N)
      "N"

  """
  @spec pretty_print(t) :: String.t()
  def pretty_print(direction), do: Atom.to_string(direction)
end
