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


# iex(5)> {:ok, pid} = KV.Agent.start_link
# {:ok, #PID<0.166.0>}
# iex(9)> KV.Agent.put(pid, :hello, 1)
# :ok
# iex(10)> KV.Agent.get(pid, :hello)   
# 1
