defmodule ToyRobot.CLI do
  alias ToyRobot.{Simulation, CLI}

  def main([filepath]) do
    with true <- File.exists?(filepath) do
      File.stream!(filepath)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&CLI.interpret/1)
      |> CLI.run()
    else
      false ->
        IO.puts("File #{filepath} does not exist")
    end
  end

  def main(_) do
    IO.puts("Usage: toy_robot commands.txt")
  end

  @spec interpret(String.t()) ::
          {:ok, Simulation.t()} | function() | {:invalid_command, String.t()}

  def interpret("PLACE" <> _rest = command) do
    regex = ~r/\APLACE (\d+),(\d+),(NORTH|EAST|SOUTH|WEST)\z/

    case Regex.run(regex, command) do
      [^command, east, north, facing] ->
        placement = %{
          east: east |> String.trim() |> String.to_integer(),
          north: north |> String.trim() |> String.to_integer(),
          facing: facing |> String.trim() |> String.downcase() |> String.to_atom()
        }

        {:place, placement}

      nil ->
        {:invalid_command, command}
    end
  end

  def interpret("MOVE"), do: :move
  def interpret("LEFT"), do: :turn_left
  def interpret("RIGHT"), do: :turn_right
  def interpret("REPORT"), do: :report
  def interpret(command), do: {:invalid_command, command}

  @spec run(list()) :: nil

  def run([]) do
    IO.puts("No valid commands")
    nil
  end

  def run([{:place, placement} | commands]) do
    case apply(Simulation, :place, [placement]) do
      {:ok, simulation} ->
        run(commands, simulation)

      {:error, _} ->
        run(commands)
    end
  end

  def run([_ | rest]), do: run(rest)

  def run([], _simulation), do: nil
  def run([{:invalid_command, _} | commands], simulation), do: run(commands, simulation)

  def run([{:place, placement} | commands], simulation) do
    case apply(Simuliaton, :place, [placement]) do
      {:ok, new_simulation} ->
        run(commands, new_simulation)

      {:error, _} ->
        run(commands, simulation)
    end
  end

  def run([command | commands], simulation) do
    case apply(Simulation, command, [simulation]) do
      {:ok, new_simulation} ->
        run(commands, new_simulation)

      {:error, _reason} ->
        run(commands, simulation)
    end
  end
end
