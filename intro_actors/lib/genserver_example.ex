defmodule Post do
  use GenServer
  #Implementación con actores y Genserver...
  
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(cantidad_inicial_likes) do
    {:ok, cantidad_inicial_likes}
  end

  def handle_cast(:like, cantidad_likes) do
    nuevo_estado = cantidad_likes + 1
    {:noreply, nuevo_estado}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end

#{:ok, pid_del_actor} = Post.start_link(0)
#post = pid_del_actor
#GenServer.call(Post, :get)
#GenServer.cast(Post, :like)
#for _ <- 1..1000, do: GenServer.cast(Post, :like)
