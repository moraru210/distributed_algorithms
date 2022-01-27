
# distributed algorithms, n.dulay, 10 jan 22
# simple client-server, v1

defmodule Client do

def start(server, id) do
  IO.puts "-> Client at #{Helper.node_string()}"
  next(server, id)
end # start

defp next(server, id) do
  send server, { :circle, self(), 1.0 }
  receive do
    { :result, area } -> IO.puts "Client #{inspect(self())}: Area is #{area}"
  end # receive
  Process.sleep(1000)
  next(server, id)
end # next

end # Client
