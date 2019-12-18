defmodule ExploringMars do
  @moduledoc """
  Top-level module, encapsulating the entire solution.
  """

  @doc """
  Takes the `upperRightLimit` of the plateau, the initial
  `startingPosition`, and a list of `instructions`, and
  returns a pair of whether the instructions were successfully
  executed and the final position of the probe.

  ## Examples

      iex> ExploringMars.explore({1, 1}, {0, 0, :N}, [:M])
      {:ok, {0, 1, :N}}

  """
  @spec explore(
    {non_neg_integer(), non_neg_integer()},
    {non_neg_integer(), non_neg_integer(), atom()},
    list(atom())
  ) :: {atom(), {integer(), integer(), atom()}}
  def explore(upperRightLimit, startingPosition, instructions) do
    :not_implemented
  end
end
