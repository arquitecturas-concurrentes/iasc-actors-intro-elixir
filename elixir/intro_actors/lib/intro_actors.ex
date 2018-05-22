defmodule Jose do
  def start do
    spawn(fn -> loop end)
#   Task.start_link (fn -> loop end)
  end

  def loop do
    receive do
      {pid, :camina} -> IO.puts 'Jose empieza a caminar. Proceso #{inspect self()}'
      {pid, :corre} -> IO.puts 'Ni ahi. Proceso #{inspect self()}'
      {pid, _ } -> send pid, {:error, 'Accion Invalida de #{inspect pid}'}
    end
    loop
  end

end

jose = Jose.start
send jose, {self(),:camina}
send jose, {self(),:corre}

Process.register jose, :jose

send :jose, {self(), :corre}
