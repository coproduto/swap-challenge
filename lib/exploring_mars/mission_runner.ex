defmodule ExploringMars.MissionRunner do
  @moduledoc """
  File I/O handling module. Reads parameters from an `io_device` (which should
  be either a file or `:stdio` and runs each mission using the 
  `ExploringMars.Mission` module.

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
  documentation for the `ExploringMars.Mission` module.
  """
  @spec get_bounds_and_run(File.io_device, File.io_device) :: :ok
  def get_bounds_and_run(input, output) do
    case read_bounds(input) do
      {:ok, bounds} ->
        run_missions_in_bounds(bounds, input, output)
        File.close(input)
        File.close(output)
      {_, msg} -> IO.write(output, "Invalid bounds: " <> msg <> "\n")
    end
  end

  # run 0 to N missions, given bounds.
  # does most of the input and error handling. Should probably be split
  # into smaller functions.
  @spec run_missions_in_bounds(
    Coordinate.t,
    File.io_device,
    File.io_device
  ) :: :ok
  defp run_missions_in_bounds(bounds, input, output) do
    case read_position(input) do
      :eof -> :ok
      {:no_parse, err} ->
        IO.write(output, err <> "\n")
        skip_line_and_keep_going(bounds, input, output)      
      {:ok, position} ->
        case read_instructions(input) do
          :eof -> IO.write(output, "Unexpected end of file")
          {:ok, instructions} ->
            result = Mission.run(bounds, position, instructions)
            IO.write(output, Mission.result_to_string(result))
            run_missions_in_bounds(bounds, input, output)
          err -> IO.write(output, "Unexpected error: " <> inspect err)
        end
      {:invalid_position, pos} ->
        IO.write(output, "Invalid position: " <> strip_and_join(pos) <> "\n")
        skip_line_and_keep_going(bounds, input, output)
      err ->
        IO.write(output, "Unexpected error: " <> (inspect err) <> "\n")
        skip_line_and_keep_going(bounds, input, output)
    end
  end

  @spec skip_line_and_keep_going(
    Coordinate.t,
    File.io_device,
    File.io_device
  ) :: :ok
  defp skip_line_and_keep_going(bounds, input, output) do
    if IO.read(input, :line) != :eof do
      run_missions_in_bounds(bounds, input, output)
    else
      IO.write(output, "Unexpected end of file")
      :ok
    end
  end

  @spec strip_and_join(list(String.t)) :: String.t
  defp strip_and_join(strings) do
    Enum.map(strings, &String.trim/1) |> Enum.join(" ")
  end

  @typep bounds_error :: {:invalid_bounds, String.t}
                       | {:no_parse, String.t}
                       | IO.nodata
        
  # read bounds from input file
  @spec read_bounds(File.io_device) :: {:ok, Coordinate.t} | bounds_error
  defp read_bounds(device) do
    with line when line != :eof <- IO.read(device, :line),
         [x, y] <- String.split(line, " ")
    do
      Coordinate.positive_from_strings(x, String.trim(y, "\n"))
    else
      l when is_list(l) ->
        {:invalid_bounds, strip_and_join(l)}
      err -> err
    end
  end

  @typep position_error :: {:invalid_position, list(String.t)}
                         | {:no_parse, String.t}
                         | IO.nodata

  # read position from input file
  @spec read_position(File.io_device) :: {:ok, Position.t} | position_error
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
  @spec read_instructions(File.io_device) :: {:ok, list(Instruction.t)}
                                           | IO.nodata
  defp read_instructions(device) do
    case IO.read(device, :line) do
      line when is_binary(line) ->
        instructions = String.trim(line, "\n")
        |> String.graphemes()
        |> Enum.filter(fn c -> c != " " end)
        |> Enum.map(&Instruction.from_string/1)
        {:ok, instructions}
      err -> err
    end
  end
end
