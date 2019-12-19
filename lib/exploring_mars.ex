defmodule ExploringMars do
  @moduledoc """
  Top-level module, encapsulating the entire solution.

  Contains mainly functions dealing with file and command-line IO.
  Should be the only module in the project to contain impure functions.
  """

  defp parser_options do
    [ strict: [ file: :string, output: :string ],
      aliases: [ f: :file, o: :output ]
    ]
  end

  defp open_file_or_stdio(nil), do: {:ok, :stdio}
  defp open_file_or_stdio(path) do
    File.open(path, :utf8)
  end

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

  defp run_missions(input, output) do
    case read_bounds(input) do
      {:ok, bounds} ->
        run_missions_in_bounds(bounds, input, output)
        File.close(input)
        File.close(output)
      err -> IO.puts("Invalid bounds: " <> inspect(err))
    end
  end

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
          err -> IO.puts("Unexpected error: " <> (inspect err))
        end
      err -> IO.puts("Unexpected error: " <> (inspect err))
    end
  end

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
