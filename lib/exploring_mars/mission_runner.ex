defmodule ExploringMars.MissionRunner do
  @moduledoc """
  File I/O handling module. Reads parameters from an `io_device` (which should
  be either a file or `:stdio` and runs each mission using the `Mission` module.

  This module should change if the specification of how mission parameters are
  laid out changes.
  """

  alias ExploringMars.Mission
  alias ExploringMars.Mission.{Coordinate, Position, Instruction}
  
  @doc """
  Takes an input file, an output file, and tries to read the input file as a
  mission specification, containing bounds and several missions. 

  Outputs for each mission either an error (if the mission was malformed) or
  a mission result. For more information on mission results, check the 
  documentation for the `Mission` module.
  """
  @spec get_bounds_and_run(File.io_device, File.io_device) :: :ok
  def get_bounds_and_run(input, output) do
    case read_bounds(input) do
      {:ok, bounds} ->
        run_missions_in_bounds(bounds, input, output)
        File.close(input)
        File.close(output)
      err -> IO.puts("Invalid bounds: " <> inspect(err))
    end
  end

  # run 0 to N missions, given bounds
  @spec run_missions_in_bounds(
    Coordinate.t,
    File.io_device,
    File.io_device
  ) :: :ok
  defp run_missions_in_bounds(bounds, input, output) do
    case read_position(input) do
      :eof -> :ok
      {:ok, position} ->
        case read_instructions(input) do
          :eof -> IO.puts("Unexpected end of file")
          {:ok, instructions} ->
            result = Mission.run(bounds, position, instructions)
            IO.write(output, Mission.result_to_string(result))
            run_missions_in_bounds(bounds, input, output)
          err -> IO.write(output, "Unexpected error: " <> (inspect err))
        end
      err -> IO.write(output, "Unexpected error: " <> (inspect err))
    end
  end

  # read bounds from input file
  @spec read_bounds(File.io_device) :: {:ok, Coordinate.t} | term
  defp read_bounds(device) do
    with line when line != :eof <- IO.read(device, :line),
         [x, y] <- String.split(line, " ")
    do
      Coordinate.from_strings(x, String.trim(y, "\n"))
    else
      l when is_list(l) -> {:invalid_bounds, l}
      err -> err
    end
  end

  # read position from input file
  @spec read_position(File.io_device) :: {:ok, Position.t} | term
  defp read_position(device) do
    with line when line != :eof <- IO.read(device, :line),
         [sx, sy, dir] <- String.split(line, " ")
    do
      Position.from_strings(sx, sy, String.trim(dir, "\n"))
    else
      l when is_list(l) -> {:invalid_position, l}
      err -> err
    end
  end

  # read instructions from input file as list
  @spec read_instructions(File.io_device) :: {:ok, list(Instruction.t)} | term
  defp read_instructions(device) do
    case IO.read(device, :line) do
      :eof -> :eof
      {:error, err} -> {:error, err}
      line ->
        instructions = String.trim(line, "\n")
        |> String.split(" ")
        |> Enum.map(&Instruction.from_string/1)
        {:ok, instructions}
    end
  end
end
