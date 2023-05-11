defmodule IntroActors do
  # start es una funcion para inicializar a nuestro procesos.. Le pasamos el comportamiento que queremos
  def start do
    spawn(fn -> loop(n) end)
  end

  def loop(n) do
    receive do
      {_, :camina} -> IO.puts 'Jose empieza a caminar. Proceso #{inspect self()}'
      {_, :corre} -> IO.puts 'Ni ahi. Proceso #{inspect self()}'
      {pid, _ } -> send pid, {:error, 'Accion Invalida de #{inspect pid}'}
    end
    # Si no loopeamos el proceso muere...
    loop(n+1)
  end
end

#jose = IntroActors.start
#send jose, {self(),:camina}
#send jose, {self(),:corre}

# Si queremos registrar el pid en un simbolo...
#Process.register jose, :jose
#send :jose, {self(), :corre}
