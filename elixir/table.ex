require Integer

defmodule Table do
  def start(map) do
    spawn fn -> loop(map) end
  end

  def loop(map) do
    receive do

      {:put, key, value} ->
          loop(Map.put(map, key, value))

      {:get, key, ref} ->
          send ref, {:ok, Map.get(map, key)}
          loop(map)

      {:delete, key} ->
          loop(Map.delete(map, key))

    end
  end

  def concurrent_test(table, times) do
    Enum.each(1..times, fn it ->
      if Integer.is_even(it) do
        spawn fn ->
          send table, {:get, :counter, self()}
          v = receive do
            {:ok, r} -> r
          end
          send table, {:put, :counter, v+1}
        end
      else
        spawn fn ->
          send table, {:get, :counter, self()}
          v = receive do
           {:ok, r} -> r
          end
          send table, {:put, :counter, v-1}
        end
      end
    end)
  end

end


