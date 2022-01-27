
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

defmodule Peer do

  # add your code here, start(), next() and any other functions
  def start(id) do
    IO.puts "-> Peer at #{Helper.node_string()} with ID #{id}"
    receive do
      { :global_peers, global_peers} -> next(id, global_peers, 0)
    end
  end

  defp next(id, global_peers, hello_count) do
    receive do
      { :hello } ->
        if hello_count == 0 do
          forward(global_peers)
        end
        next(id, global_peers, hello_count + 1)

      after
        1_000 ->
          IO.puts "-> Peer #{id} PID #{inspect(self())} Messages seen = #{hello_count}"
          next(id, global_peers, hello_count)
    end
  end

  defp forward(global_peers) do
    Enum.each(global_peers, fn p -> send p, { :hello } end)
  end
end # Peer
