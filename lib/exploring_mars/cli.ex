defmodule ExploringMars.CLI do
  @moduledoc """
  Top-level module for the CLI application, encapsulating the
  interpretation of command-line arguments. Delegates actual execution to the
  `ExploringMars.MissionRunner` module.

  Contains mainly functions dealing with finding and opening files.
  Should contain only impure functions.

  Most functions in this module should be private, as it should only
  expose the full command-line interface as `main`.

  This module should change if the command-line arguments to the CLI program
  change.
  """

  alias ExploringMars.MissionRunner

  @doc """
  The main command-line program entry point.

  Takes the following command-line arguments:

    * --file, -f: Should be a string specifying a file path.
    The mission commands will be read from this file. If not specified,
    the program will read from standard input.

    * --output, -o: Should be a string specifying a file path.
    The mission results for each specified probe will be output to this
    file. If not specified, the program will write to standard output.

  If called in interactive mode, the arguments should be passed as a list
  of strings.

  When the program is compiled to a CLI application, pass the flags as
  usual on the terminal.

  ## Example:

      main([
        "-f", "examples/input.txt", 
        "-o", "output.txt"
      ]) # will read input from examples/input.txt and output to output.txt

  """
  def main(args \\ []) do
    {opts, _, _} = OptionParser.parse(args, parser_options())

    input = Keyword.get(opts, :file)
    output = Keyword.get(opts, :output)

    with {:ok, input_device} <- open_file_or_stdio(input, :read),
         {:ok, output_device} <- open_file_or_stdio(output, :write) do
      MissionRunner.get_bounds_and_run(input_device, output_device)
    else
      {:error, :enoent} -> IO.puts("Error: Input file does not exist.")
      {:error, err} -> IO.puts("Error opening device: " <> inspect(err))
      err -> IO.puts("Unknown error opening device: " <> inspect(err))
    end
  end

  # definition of command-line parameters
  @spec parser_options :: Keyword.t()
  defp parser_options do
    [strict: [file: :string, output: :string], aliases: [f: :file, o: :output]]
  end

  # if input or output files are not specified, use :stdio.
  @spec open_file_or_stdio(
          nil | Path.t(),
          File.mode()
        ) :: {:ok, File.io_device()} | {:error, File.posix()}
  defp open_file_or_stdio(nil, _), do: {:ok, :stdio}

  defp open_file_or_stdio(path, mode) do
    File.open(path, [mode, :utf8])
  end
end
