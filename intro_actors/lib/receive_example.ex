bloque = fn -> 
    receive do
      :vola -> IO.puts 'Pepita vuela'
      :come -> Io.puts 'Pepita come'
      _ -> IO.puts 'Default'
    end
    IO.puts 'La tarea de pepita ha terminado'
end 

#pid = spawn bloque