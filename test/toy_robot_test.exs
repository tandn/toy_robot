defmodule ToyRobotTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "toy robot test" do
    test "input commands" do
      expected_output = """
      Robot is at (3, 3) while facing EAST
      """
      output = capture_io fn ->
	ToyRobot.CLI.main(["priv/commands.txt"])
      end

      assert output |> String.trim == expected_output |> String.trim

    end

  end
end
