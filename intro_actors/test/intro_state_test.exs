defmodule IntroStateTest do
  use ExUnit.Case

  alias KV

  describe "start_link/0" do
    test "process remains alive" do
      {:ok, process} = KV.start_link

      assert Process.alive?(process) == true
    end

    test "expect that a :put is received" do
      {:ok, process} = KV.start_link
      message = :world

      :erlang.trace(process, true, [:receive])

      send process, {:put, :hello, :world}

      assert_receive {:trace, ^process, :receive, {:put, :hello, :world}}
    end

    test "expect that a :get is received" do
      {:ok, process} = KV.start_link
      message = :world
      self_process = self()

      :erlang.trace(process, true, [:receive])

      send process, {:get, :hello, self()}

      assert_receive {:trace, ^process, :receive, {:get, :hello, self_process}}
    end
  end
end
