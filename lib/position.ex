defmodule Position do
  @moduledoc """
  This module defines functions that operate on the probe's position.
  """

  @typedoc """
  The probe's position, specified by an x-coordinate, y-coordinate 
  and direction. Use as `Position.t`.
  """
  @type t :: {Coordinate.t, Direction.t}
end
