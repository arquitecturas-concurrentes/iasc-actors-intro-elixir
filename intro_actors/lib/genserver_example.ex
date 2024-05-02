defmodule Post do
  use GenServer
  #Implementación con actores y Genserver...

  def start(state, name) do
    GenServer.start(__MODULE__, state, name: name)
  end

  def start_link(state, name) do
    GenServer.start_link(__MODULE__, state, name: name)
  end

  def init(cantidad_inicial_likes) do
    {:ok, cantidad_inicial_likes}
  end

  def handle_call(:get, from, state) do
    IO.puts 'Recibi pedido de cant de likes de #{inspect from}'
    {:reply, state, state}
  end

  def handle_cast({:like, pid}, state) do
    IO.puts "Recibi :like de #{inspect pid}"
    send pid, {:ok, "Recibi tu like"}
    nuevo_estado = state + 1
    {:noreply, nuevo_estado}
  end

  # --- funciones de uso ---

  def like(post, pid) do
    GenServer.cast(post, {:like, pid})
  end

  def get_likes(post) do
    GenServer.call(post, :get)
  end
end

#{:ok, post} = Post.start_link(0, :post_principal)
#for _ <- 1..1000, do: Post.like(:post_principal)
# aumentar_like = fn -> for _ <- 1..1000, do
# Post.like(:post_principal) 
# :timer.sleep(50)
# end
# end

#GenServer.call(Post, :get)
#GenServer.cast(Post, :like, self)
# recibir_like = fn -> Post.get_likes(:post_) end
# aumentar_like = fn -> Post.like(Post) end
