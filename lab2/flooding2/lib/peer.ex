
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

defmodule Peer do

  # add your code here, start(), next() and any other functions
  def start(id) do
    IO.puts "-> Peer at #{Helper.node_string()} with ID #{id}"
    receive do
      { :peers_list, peers} -> next(id, peers, 0)
    end
  end

  defp next(id, peers, hello_count) do
    receive do
      { :hello } ->
        if hello_count == 0 do
          forward(peers)
        end
        next(id, peers, hello_count + 1)

      after
        1_000 ->
          IO.puts "-> Peer #{id} PID #{inspect(self())} Messages seen = #{hello_count}"
          next(id, peers, hello_count)
    end
  end

  defp forward(peers) do
    Enum.each(peers, fn p -> send p, { :hello } end)
  end
end # Peer
