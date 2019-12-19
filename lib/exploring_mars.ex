defmodule ExploringMars do
  @moduledoc """
  Top-level module, encapsulating the entire solution.
  """

  defp parser_options do
    [ strict: [ file: :string ],
      aliases: [ f: :file ]
    ]
  end

  defp openInput(nil), do: {:ok, :stdio}
  defp openInput(path) do
    File.open(path, :utf8)
  end
  
  def main(args \\ []) do
    {opts, _, _} = OptionParser.parse(args, parser_options())

    path = Keyword.get(opts, :file)
    case openInput(path) do
      {:ok, device} -> run_missions(device)
      {:error, error} -> IO.puts("Error opening input: " <> error)
    end
  end

  defp run_missions(device) do
    case read_bounds(device) do
      {:ok, bounds} ->
        run_missions_in_bounds(bounds, device, 1)
      err -> IO.puts("Invalid bounds: " <> inspect(err))
    end
  end

  defp run_missions_in_bounds(bounds, device, count) do
    case read_position(device) do
      :eof -> nil
      {:ok, position} ->
        case read_instructions(device) do
          :eof -> IO.puts("Unexpected end of file")
          {:ok, instructions} ->
            IO.puts(inspect(Mission.run(bounds, position, instructions)))
            run_missions_in_bounds(bounds, device, count + 1)
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
      line -> {:ok, String.split(line, " ")}
    end
  end
end
