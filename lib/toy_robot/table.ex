defmodule ToyRobot.Table do
  defstruct [:north_boundary, :east_boundary]

  @spec validPosition?(struct(), struct()) :: bool()

  def validPosition?(robot, table) do
    0 <= robot.north && 0 <= robot.east &&
      robot.north <= table.north_boundary &&
      robot.east <= table.east_boundary
  end
end
