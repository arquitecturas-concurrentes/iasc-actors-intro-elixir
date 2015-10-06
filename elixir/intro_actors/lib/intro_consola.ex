Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> succ1 = fn -> 1+1 end
#Function<20.90072148/0 in :erl_eval.expr/5>

iex(2)> pid = spawn succ1
#PID<0.62.0>

iex(3)> Process.alive? pid
false

#Obtenemos el id del proceso mediante self()
iex(4)> self()
#PID<0.59.0>

iex(5)> Process.alive? self                                                                                                                                                                           true

#Pasaje de mensajes

#El interprete es un proceso también y puedo mandarle mensajes
iex(4)> send self, self
#PID<0.59.0>
iex(5)> send self, :bleh
:bleh
iex(6)> flush
#PID<0.59.0>
:bleh
:ok

#veamos algo ahora un poco más complejo
iex(9)> send self(), {:hello, "world"}
{:hello, "world"}
iex(10)> receive do
...(10)> {:hello, msg} -> msg
...(10)> {:world, msg} -> 'dont match'
...(10)> end
"world"

#Cuando un mensaje es enviado a un proceso, el mensaje se almacena en el buzón del proceso. El método receive/1 permite que se pueda buscar el mensaje a partir de su estructura, mediante PM. receive/1 soporta guardas y varias clausulas como case/2, entre otras.

receive do
  {:pepe, msg}  -> msg
after
  1_000 -> "No paso nada después de 1s"
end

iex(11)> receive do
...(11)>   {:pepe, msg}  -> msg
...(11)> after
...(11)>   1_000 -> "No paso nada después de 1s"
...(11)> end
"No paso nada después de 1s"

#En este caso se puede ver como no sucede nada después de 1s, podemos definir un timeout para cuando esperamos que la respuesta esté en nuestro buzón.

#intercomunicación entre procesos

#veamos como comunicar dos procesos A->B

self()
padre = self()

spawn fn -> send(padre, {:hola, self()}) end

receive do
  {:hola, pid} -> "Recibi un mensaje hola de #{inspect pid}"
end


iex(13)> self()
#PID<0.59.0>
iex(14)> padre = self()
#PID<0.59.0>
iex(15)>
nil
iex(16)> spawn fn -> send(padre, {:hola, self()}) end
#PID<0.93.0>
iex(17)>
nil
iex(18)> receive do
...(18)>   {:hola, pid} -> "Recibi un mensaje hola de #{inspect pid}"
...(18)> end
"Recibi un mensaje hola de #PID<0.93.0>"

#Aqui se ve como un proceso envía mensajes a otro proceso, se puede ver como
# PID<0.59.0> ---> {:hola} ---> #PID<0.93.0>


send self, :saraza
send self, :pepe
flush

iex(21)> send self, :saraza
:saraza
iex(22)> send self, :pepe
:pepe
iex(23)> flush
:saraza
:pepe
:ok

#flush/0 permite que se muestren todos los mensajes que están en el buzón de un proceso

#hay secuencialidad?

g = fn(x) -> :timer.sleep(50); IO.puts "#{x}" end
for n <- 1..10, do: spawn(fn-> g.(n) end)

iex(1)> g = fn(x) -> :timer.sleep(50); IO.puts "#{x}" end
#Function<6.90072148/1 in :erl_eval.expr/5>
iex(2)> g.(1)
1
:ok
iex(3)> for n <- 1..10, do: spawn(fn-> g.(n) end)
[#PID<0.63.0>, #PID<0.64.0>, #PID<0.65.0>, #PID<0.66.0>, #PID<0.67.0>,
 #PID<0.68.0>, #PID<0.69.0>, #PID<0.70.0>, #PID<0.71.0>, #PID<0.72.0>]
9
10
8
7
6
5
4
3
2
1
