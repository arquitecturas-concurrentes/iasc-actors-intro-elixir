defmodule Post do
  use GenServer
  #Implementación con actores y Genserver...

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(cantidad_inicial_likes) do
    {:ok, cantidad_inicial_likes}
  end

  def handle_cast({:like, pid}, state) do
    nuevo_estado = state + 1
    #IO.puts "Recibi :like de #{inspect pid}"
    {:noreply, nuevo_estado}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  # --- funciones de uso ---

  def like(post) do
    GenServer.cast(post, {:like, self()})
  end

  def get_likes(post) do
    likes = GenServer.call(post, :get)
    IO.puts "Cantidad de likes: #{likes}. Estoy en #{inspect self}"
  end
end

#{:ok, pid_del_actor} = Post.start_link(0)
#post = pid_del_actor
#GenServer.call(Post, :get)
#GenServer.cast(Post, :like)
#for _ <- 1..1000, do: GenServer.cast(Post, :like)

# recibir_like = fn -> Post.get_likes(Post) end
# aumentar_like = fn -> Post.like(Post) end