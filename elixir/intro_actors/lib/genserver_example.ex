defmodule Post do
  use GenServer
  #Implementación con actores y Genserver...

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(_args) do
    cantidad_inicial_likes = 0
    {:ok, cantidad_inicial_likes}
  end

  def handle_cast(:like, cantidad_likes) do
    nuevo_estado = cantidad_likes + 1
    {:noreply, nuevo_estado}
  end
end

#{:ok, pid_del_actor} = Post.start_link
#post = pid_del_actor
#for _ <- 1..1000, do: GenServer.cast(post, :like)
