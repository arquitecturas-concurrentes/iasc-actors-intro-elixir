defmodule PostTest do
  use ExUnit.Case

  setup do
    {:ok, server_pid} = Post.start_link(0, :testPost)
    {:ok, server: server_pid}
  end

  test "post like", %{server: pid} do
    assert :ok == Post.like(pid, self())
  end

  test "get total posts", %{server: pid} do
    assert 0 == Post.get_likes(pid)
  end

  test "get correct total posts", %{server: pid} do
    for _ <- 1..1000, do: Post.like(pid, self())
    assert 1000 == Post.get_likes(pid)
  end
end
