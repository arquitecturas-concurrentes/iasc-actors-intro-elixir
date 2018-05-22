defmodule Echoserver do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, :ok, [])
    end

    def start do
      GenServer.start(__MODULE__, :ok, [])
    end

    def init(:ok) do
      {:ok, []}
    end

    def handle_call({:echo, msg}, _from, state) do
       {:reply, msg, state}
    end

    def handle_cast(:ping,  state) do
       IO.puts "pong"
       {:noreply, state} 
    end

    # --> fxs para el "cliente"
    def echo(pid, msg) do
       GenServer.call pid, {:echo, msg}
    end

    def ping(pid) do
      GenServer.cast pid, :ping
    end        

end


{_, pid} = Echoserver.start



bloque = fn -> 
    receive do
      :vola -> IO.puts 'Pepita vuela'
      :come -> Io.puts 'Pepita come'
      _ -> IO.puts 'Default'
    end
    IO.puts 'La tarea de pepita ha terminado'
    bloque
end 

pid = spawn bloque