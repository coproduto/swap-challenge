# ExploringMars

**(Hiring challenge) An application that simulates a probe exploring Mars**

Using this application requires [Elixir](https://elixir-lang.org/) and
[Erlang](https://www.erlang.org/) to be installed. Running the end-to-end
tests requires a POSIX environment (Linux, MacOS, BSD, etc)

## Setup

To install the dependencies needed for typechecking and generating 
documentation, run `mix do deps.get, deps.compile`.

## Building

To build the application as a command line app, use `mix escript.build` in the
project's root directory. This will create a binary named `exploring_mars` in
the root directory, which can be ran on any system with an Erlang VM.

There are other ways to interact with this project. Check the documentation
available in the `doc` directory for more details.

## Usage

When running the application, it takes two optional command-line flags:

* `-f, --file`: path to the input file to read.
    if this flag is not given, read input from standard input.
* `-o, --output`: path to the output file to write.
    if this flag is not given, write to standard output.
    if a path is given and the file does not exist, it will be created.
    if a path is given and the file exists, *its contents will be erased*.
    
Check the documentation for the `ExploringMars.CLI` module for more details
on command-line flags.

There are examples of input and output for the application in the `examples`
directory. The file `input_n.txt` generates the file `output_n.txt` as output,
for each `n`. (This can be checked - read [Testing](#testing) below)

## Extensions

The application specified here has a few extensions beyond the problem 
specification originally given.

* If invalid bounds are given, this condition will be outputted and no more output
will be generated.

* If a probe's input is invalid, the invalid condition will be outputted on the 
line corresponding to that probe and the application will attempt to skip lines
in order to read the next probe's data.

* If a probe ever falls off the plateau, this will be signaled on the line 
corresponding to that probe, with the position which the probe was moving to
when it fell off.

* If a probe's instructions contain an invalid instruction (i.e.: An instruction
other than "L", "R" or "M", the probe will stop reading instructions when it
reaches the invalid instruction and the abnormal condition will be signaled on
the line corresponding to the probe, together with the position where the probe
read the invalid instruction.

Once again, the examples in the `examples` directory show all of these features.

## Testing
There are 3 kinds of tests: Doctests become part of the documentation and ensure
the documentation is up-to-date, unit tests check that the various code modules
each function correctly and end-to-end tests ensure that the application 
performs correctly when given input.

In order to run unit tests and doctests, use `mix test`.

End-to-end tests are performed by checking that, for each example input file in
the `examples` directory, the application produces the corresponding output file.
This is done by the `test_examples.sh` shell script in the root directory.

If there are differences in any of the example input's output from the 
corresponding output file, the script will signal this.

### Typechecking

This project is fully typed, and the typings can be checked with the `dialyzer`
tool. To typecheck the project, run `mix dialyzer` in the root directory after
running the setup as specified in the [Setup](#setup) section.

## Documentation

All of the public functions and types in this project are documented. The
documentation is available as HTML in the `doc` directory. Start by reading
`doc/index.html`.

The documentation also explains many of the design decisions and features of
this project. It is recommended reading.

The documentation is generated automatically from the code using 
[ExDoc](https://github.com/elixir-lang/ex_doc). If you change any of the 
code and wish to update the documentation, run `mix docs`, after having ran
the setup as specified in the [Setup](#setup) section.
