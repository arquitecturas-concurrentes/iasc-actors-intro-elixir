defmodule IASC.WriteHaiku do
  use Task

  @file_opts [:append, {:encoding, :utf8}]
  @file_name "haiku.txt"

  def start_link_run(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def start_link_read() do
    Task.start_link(__MODULE__, :read_haiku, [])
  end

  def run(content) do
    check_and_create
    write_haiku(content)
  end

  @doc """
    Escribe en el archivo
  """
  def write_haiku(content) do
    File.write(@file_name, "#{content}\n", @file_opts)
  end

  def read_haiku do
    case File.read(@file_name) do
      {:error, error_desc} -> IO.puts "Error leyendo #{@file_name}: #{error_desc}"
      {:ok, contenido} -> IO.puts("Contenido de #{@file_name}: #{contenido}")
    end
  end

  @doc """
  Chequea si el archivo existe y lo crea si no lo esta
  """
  def check_and_create do
    unless File.exists? @file_name do
      File.write(@file_name, "", [:write, {:encoding, :utf8}])
    end
  end

end

# {:ok, pid} = IASC.WriteHaiku.start_link_read()
#haiku= "Arbol sereno\nque en el bosque protege\na tantos seres"
#{:ok, pid} = IASC.WriteHaiku.start_link_run(haiku)