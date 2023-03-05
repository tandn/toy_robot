defmodule ToyRobot.Robot do
  defstruct facing: :north, east: 0, north: 0

  def move(%{facing: facing} = robot) do
    case facing do
      :north -> %{robot | north: robot.north + 1}
      :east -> %{robot | east: robot.east + 1}
      :south -> %{robot | north: robot.north - 1}
      :west -> %{robot | east: robot.east - 1}
    end
  end

  def turn_left(%{facing: facing} = robot) do
    new_facing =
      case facing do
        :north -> :west
        :west -> :south
        :south -> :east
        :east -> :north
      end

    %{robot | facing: new_facing}
  end

  def turn_right(%{facing: facing} = robot) do
    new_facing =
      case facing do
        :north -> :east
        :east -> :south
        :south -> :west
        :west -> :east
      end

    %{robot | facing: new_facing}
  end
end
