class Table
  def initialize(hash)
    @hash = hash
    @mutex = Mutex.new
  end

  def put(key, value)
    @mutex.synchronize do
      @hash[key] = value 
    end
  end

  def get(key)
     @mutex.synchronize do
       @hash[key]
     end
  end 

  def delete(key)
    @mutex.synchroinze do
      @hash.delete key
    end
  end
end


def concurrent_test
  table = Table.new({counter: 0})
  (1..100).map do |it|
    if it.even?
      Thread.new do 
        v = table.get(:counter)
        table.put(:counter, v+1)
      end
    else
      Thread.new do 
        v = table.get(:counter)
        table.put(:counter, v-1)
      end
    end
  end.each(&:join)
  table
end

