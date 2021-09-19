require Integer

defmodule Table do
  def start(map) do
    spawn fn -> loop(map) end
  end

  def loop(map) do
    receive do

      {:get, key, ref} ->
          send ref, {:ok, Map.get(map, key)}
          loop(map)

      {:delete, key} ->
          loop(Map.delete(map, key))

      {:accum, key, delta} ->
          loop(Map.update!(map, key, fn it -> it + delta end))

    end
  end

   def concurrent_test(table, times) do
    Enum.each(1..times, fn it ->
      if Integer.is_even(it) do
        spawn fn ->
          send table, {:put, :counter, 1}
        end
      else
        spawn fn ->
          send table, {:put, :counter, 2}
        end
      end
    end)
  end


  def concurrent_test2(table, times) do
    Enum.each(1..times, fn it ->
      if Integer.is_even(it) do
        spawn fn ->
          send table, {:accum, :counter, 1}
        end
      else
        spawn fn ->
          send table, {:accum, :counter, -1}
        end
      end
    end)
  end

end
