defmodule Jose do
  # start es una funcion para inicializar a nuestro actor.. Le pasamos el comportamiento que queremos
  def start do
    spawn(fn -> actividades end)
  end

  def actividades do
    receive do
      {pid, :camina} -> IO.puts 'Jose empieza a caminar. Proceso #{inspect self()}'
      {pid, :corre} -> IO.puts 'Ni ahi. Proceso #{inspect self()}'
      {pid, _ } -> send pid, {:error, 'Accion Invalida de #{inspect pid}'}
    end
  end

end

#jose = Jose.start
#send jose, {self(),:camina}
#send jose, {self(),:corre}

# Si queremos registrar el pid en un simbolo...
#Process.register jose, :jose
#send :jose, {self(), :corre}
