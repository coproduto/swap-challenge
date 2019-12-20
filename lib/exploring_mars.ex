defmodule ExploringMars do
  @moduledoc """
  Start reading here.

  The program defined in this project can be ran in three ways:

  * It can be used as a CLI application
  * It can be used interactively, reading the problem statement
    from files and running the program specification
  * Or it can be used interactively, passing the problem statement
    to the relevant functions as an already-parsed data structure.

  There is a module encapsulating each of these ways of running the program:

  * `ExploringMars.CLI` defines the CLI application. Running the command
    `mix escript.build` at the top-level of this project will generate a
    binary file named `exploring_mars` which can be ran on any computer which
    has an Erlang runtime available. For more information on this CLI 
    app, check the documentation for the `ExploringMars.CLI` module.

  * `ExploringMars.MissionRunner` defines the functions which read the
  input and write the output to files (or to standard input/output).
  Calling `ExploringMars.MissionRunner.get_bounds_and_run/2` passing in
  input and output files (or `:stdio` in any of the arguments) will
  attempt to read in bounds followed by a series of mission specifications
  (each mission specification consists of an initial position and a series
  of instructions), outputting the results to the specified output device.
  Note that this function reads from the input device until it finds EOF, so
  press Ctrl+D to end the input if reading from `:stdio`.

  * `ExploringMars.Mission` defines the functions which take the already-parsed
  data for a mission and return the result of the mission as an Elixir data
  structure. Check the module doc for more details. This is probably the module
  you should use if you want to use this from `iex`.
  """
end
