# Intro a actores

En esta clase vamos a estar viendo el modelo de actores, en el que la unidad de computación más primitiva es un actor, que es una computación que recibe un mensaje y hace un procesamiento en base a eso, también puede recibir mensajes, y enviar. Ademas los actores son en realidad un contexto de ejecución y están completamente aislados uno de otros y nunca van a compartir memorias u otros recursos.

## Erlang

[Erlang](https://www.youtube.com/watch?v=xrIjfIjssLE) es un lenguaje de programación concurrente, originalmente diseñado por Ericsson. Fue diseñado para ser distribuido y tolerante a fallos, para su uso en aplicaciones de comunicaciones en tiempo real de alta disponibilidad (ininterrumpidas). Es un lenguaje funcional puro. También tiene construcciones de lenguaje integradas para distribución y concurrencia. Ademas tiene un sistema de tipos dinámico.

## Elixir

Elixir es un lenguaje de programación funcional, concurrente, de propósito general que se ejecuta sobre la máquina virtual de Erlang (BEAM). Elixir está escrito sobre Erlang y comparte las mismas abstracciones para desarrollar aplicaciones distribuidas y tolerantes a fallos.

### Procesos

En Elixir, todo el código se ejecuta dentro de los procesos. Los procesos están aislados entre sí, se ejecutan "simultáneamente" y se comunican mediante el paso de mensajes.

Los procesos de Elixir no deben confundirse con los procesos del sistema operativo. Los procesos en Elixir son extremadamente ligeros en términos de memoria y CPU (incluso en comparación con los hilos que se utilizan en muchos otros lenguajes de programación). Debido a esto, no es raro tener decenas o incluso cientos de miles de procesos ejecutándose simultáneamente.

### Spawn

La función spawn/1 crea un proceso que ejecuta la función que le es enviada por parámetro, retorna el PID del proceso creado y este deja de existir al completar la ejecución de su tarea.

```elixir
iex> pid = spawn fn -> 1 + 2 end
#PID<0.44.0>
iex> Process.alive?(pid)
false
```

### Send y Receive

Podemos enviar mensajes a los procesos con la funcion send/2 y recivirlos con receive/1

```elixir
iex> send self(), {:hello, "world"}
{:hello, "world"}
iex> receive do
...>   {:hello, msg} -> msg
...>   {:world, _msg} -> "won't match"
...> end
"world"
```

Cuando un mensaje es enviado a un proceso, este es guardado en un "mailbox". El receive/1 revisa el mailbox del proceso buscando mensajes que matcheen con alguno de los patrones definidos.

```elixir
iex> parent = self()
#PID<0.41.0>
iex> spawn fn -> send(parent, {:hello, self()}) end
#PID<0.48.0>
iex> receive do
...>   {:hello, pid} -> "Got hello from #{inspect pid}"
...> end
"Got hello from #PID<0.48.0>"
```

### Links

La mayoria de las veces que spawneamos un proceso en Elixir, creamos un proceso linkeado. Antes de entrar en spawn_link/1, veamos que pasa cuando con los procesos creados con spawn/1 fallan.

```elixir
iex> spawn fn -> raise "ups" end
#PID<0.58.0>

[error] Process #PID<0.58.00> raised an exception
** (RuntimeError) ups
    (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6

```

Lanzo un error, pero el proceso padre sigue ejecutandose. Esto ocurre porque los procesos son aislados. Si queremos que el error se propague, tenemos que linkearlos. Esto se puede hacer con spawn_link/1

```elixir
iex> self()
#PID<0.41.0>
iex> spawn_link fn -> raise "ups" end

** (EXIT from #PID<0.41.0>) evaluator process exited with reason: an exception was raised:
    ** (RuntimeError) ups
        (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6

[error] Process #PID<0.289.0> raised an exception
** (RuntimeError) ups
    (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6

```

Como los procesos están linkeados, ahora vemos que el proceso padre, en este caso la consola, recibió una señal EXIT de otro proceso causando que esta termine su ejecución.

Los procesos y los links juegan un rol importante para poder crear sistemas tolerantes a fallas. Los procesos en Elixir son "aislados", es decir que por defecto no comparten estado. Por esto, una falla en un proceso nunca va romper otro proceso. Sin embargo, los links nos permiten establecer una relación entre procesos en el caso de una falla.

### Estado

Hasta ahora nombramos algo del estado, pero no mucho. Supongamos que estamos creando una aplicación que requiere de estado, por ejemplo, para guardar la configuración del sistema y administrarla dinamicamente en memoria. Donde ponemos ese estado?... Podemos escribir un proceso que esta siempre a la escucha (loopee indefinidamente), mantenga el estado.

```elixir
defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end
```

_Nota: Podemos decir que este proceso KV es un actor._

```elixir
iex> {:ok, pid} = KV.start_link
{:ok, #PID<0.132.0>}
iex> send pid, {:put, :hello, :world}
{:put, :hello, :world}
iex> send pid, {:get, :hello, self()}
{:get, :hello, #PID<0.41.0>}
iex> flush()
:world
:ok
```

_Nota: Esto es solo a modo de ejemplo, normalmente cuando hablamos guardar o mantener un estado vamos a estar pensando en un tipo particular de actor llamado Agent._

Cualquier proceso que conozca el PID del KV va a poder enviarle mensajes. Es posible registrar el PID del proceso bajo un nombre, permitiendo comunicarse con el proceso a través de ese nombre sin necesidad de saber el PID exacto.

```elixir
iex> Process.register(pid, :kv)
true
iex> send :kv, {:get, :hello, self()}
{:get, :hello, #PID<0.41.0>}
iex> flush()
:world
:ok
```

### OTP

OTP es un conjunto de middlewares, librerias y herramientas escritas en Erlang que ademas de muchas otras cosas más, encapsulan todo lo visto anteriormente para no estar re inventando la ruedo todo el tiempo.

Vamos a usar el modulo GenServer para modelar nuestro actor, definiendo un link con el mismo, registrando lo bajo un nombre, un estado inicial y funciones que interactúan con el mailbox según corresponda.

```elixir
defmodule Post do
  use GenServer

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
#Process.info(post)
```

**start_link** nos spawnea un actor linkeado, registrado bajo el nombre del modulo, en este caso Post.

**init** es la función que llama start_link para inicializar el estado del actor.

**handle_cast** es una función que maneja los mensajes de una forma asincronica, es un "fire and forget"

**handle_call** esta función implementa una llamada sincronica, en la que se bloquea el actor hasta que reciba la respuesta o se cumpla un timeout.
