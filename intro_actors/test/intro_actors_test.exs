defmodule ActorsTest do
  use ExUnit.Case

  alias IntroActors

  describe "start/0" do
    test "process remains alive" do
      process = IntroActors.start()

      assert Process.alive?(process) == true
    end

    test "returns the status of the process" do
      process = IntroActors.start()
      process_as_map = Process.info(process) |> Enum.into(%{})
      expected_initial_call = {IntroActors, :actividades, 0}

      assert %{initial_call: {:erlang, :apply, 2}, status: :running} = process_as_map
    end

    test "receives a :camina message" do
      process = IntroActors.start()

      :erlang.trace(process, true, [:receive])

      send process, {:camina}

      assert_receive {:trace, ^process, :receive, {:camina}}
    end

    test "receives a :corre message" do
      process = IntroActors.start()

      :erlang.trace(process, true, [:receive])

      send process, {:corre}

      assert_receive {:trace, ^process, :receive, {:corre}}
    end

    test "handles other types of messages" do
      process = IntroActors.start()

      :erlang.trace(process, true, [:receive])

      send process, {:another_case}

      assert_receive {:trace, ^process, :receive, {:another_case}}
    end
  end
end
