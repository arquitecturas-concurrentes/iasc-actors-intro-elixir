defmodule KV.Agent do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  # agent es el pid del Agent -> KV.Agent
  # Agent.get(agent, fn content -> Map.get(content, key) end)
  def get(agent, key) do
    Agent.get(agent, &Map.get(&1, key))
  end

  # fn map -> Map.put(map, key, value) end
  def put(agent, key, value) do
    Agent.update(agent, &Map.put(&1, key, value))
  end
end


# {:ok, pid} = KV.Agent.start_link
# 
# send pid, {:get, :hello, self()}
# flush()

# Process.register(pid, :kv)
# send :kv, {:get, :hello, self()}
