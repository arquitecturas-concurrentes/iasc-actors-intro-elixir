defmodule PostTest do
  use ExUnit.Case

  setup do
    {:ok,server_pid} = Post.start_link(0)
    {:ok,server: server_pid}
  end

  test "post like", %{server: pid} do
    assert :ok == GenServer.cast(Post, :like)
  end

  test "get total posts", %{server: pid} do
    assert 0 == GenServer.call(Post, :get)
  end

  test "get correct total posts", %{server: pid} do
    for _ <- 1..1000, do: GenServer.cast(Post, :like)
    assert 1000 == GenServer.call(Post, :get)
  end
end
