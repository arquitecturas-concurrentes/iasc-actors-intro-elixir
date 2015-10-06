defmodule Jose do
  def start do
    spawn_link(fn -> loop end)
  end

  def loop do
    receive do
      {pid, :camina} -> IO.puts 'Jose empieza a caminar'
      {pid, :corre} -> IO.puts 'Ni ahi'
      {pid, _ } -> send :pid, {:error, 'Accion Invalida de #{inspect pid}'}
    end
  end

end

{:ok, jose} = Jose.start
send jose, {self,:camina}

Process.register jose, :jose

send :jose, {self, :corre}
