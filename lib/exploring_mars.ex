defmodule ExploringMars do
  @moduledoc """
  Top-level module, encapsulating the entire solution.

  Contains mainly functions dealing with file and command-line IO.
  Should be the only module in the project to contain impure functions.

  Most functions in this module should be private, as it should only
  expose the full command-line interface.
  """

  @doc """
  The main program entry point.

  Takes the following command-line arguments:

    * --file, -f: Should be a string specifying a file path.
    The mission commands will be read from this file. If not specified,
    the program will read from standard input.

    * --output, -o: Should be a string specifying a file path.
    The mission results for each specified probe will be output to this
    file. If not specified, the program will write to standard output.

  If called in interactive mode, the arguments should be passed as a list
  of strings.
  """
  def main(args \\ []) do
    {opts, _, _} = OptionParser.parse(args, parser_options())

    input = Keyword.get(opts, :file)
    output = Keyword.get(opts, :output)
    with {:ok, input_device} <- open_file_or_stdio(input),
         {:ok, output_device} <- open_file_or_stdio(output)
    do
      run_missions(input_device, output_device)
    else
      {:error, err} -> IO.puts("Error opening device: " <> inspect err)
    end
  end

  # definition of command-line parameters
  @spec parser_options :: Keyword.t
  defp parser_options do
    [ strict: [ file: :string, output: :string ],
      aliases: [ f: :file, o: :output ]
    ]
  end

  # if input or output files are not specified, use :stdio.
  @spec open_file_or_stdio(
    nil | Path.t
  ) :: {:ok, File.io_device} | {:error, File.posix}
  defp open_file_or_stdio(nil), do: {:ok, :stdio}
  defp open_file_or_stdio(path) do
    File.open(path, :utf8)
  end

  # read bounds and then run missions
  @spec run_missions(File.io_device, File.io_device) :: :ok
  defp run_missions(input, output) do
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
    with line <- IO.read(device, :line),
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
    with line <- IO.read(device, :line),
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
