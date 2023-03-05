defmodule ToyRobot.Simulation do
  defstruct [:robot, :table]

  alias ToyRobot.{Robot, Table, Simulation}

  @spec place(map()) :: {:error, :invalid_placement} | {:ok, struct()}
  def place(placement) do
    robot = struct(Robot, placement)
    table = struct(Table, %{north_boundary: 4, east_boundary: 4})

    case Table.validPosition?(robot, table) do
      false ->
        {:error, :invalid_placement}

      true ->
        {:ok, struct(Simulation, robot: robot, table: table)}
    end
  end

  @spec move(struct()) :: {:ok, struct()} | {:error, :at_table_boundary}
  def move(%{robot: robot, table: table} = simulation) do
    with moved_robot <- robot |> Robot.move(),
         true <- moved_robot |> Table.validPosition?(table) do
      {:ok, %{simulation | robot: moved_robot}}
    else
      _ ->
        {:error, :at_table_boundary}
    end
  end

  @spec turn_left(struct()) :: {:ok, struct()}
  def turn_left(%{robot: robot} = simulation) do
    {:ok, %{simulation | robot: robot |> Robot.turn_left()}}
  end

  @spec turn_right(struct()) :: {:ok, struct()}
  def turn_right(%{robot: robot} = simulation) do
    {:ok, %{simulation | robot: robot |> Robot.turn_right()}}
  end

  @spec report(struct()) :: {:ok, struct()}
  def report(%{robot: robot} = simulation) do
    facing = robot.facing |> Atom.to_string() |> String.upcase()
    IO.puts("Robot is at (#{robot.east}, #{robot.north}) while facing #{facing}")
    {:ok, simulation}
  end
end
