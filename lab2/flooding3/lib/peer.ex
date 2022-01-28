
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

defmodule Peer do

  # add your code here, start(), next() and any other functions
  def start(id) do
    IO.puts "-> Peer at #{Helper.node_string()} with ID #{id}"
    receive do
      { :peers_list, peers} -> next(id, peers, 0, nil)
    end
  end

  defp next(id, peers, hello_count, parent) do
    receive do
      { :hello, from_id } ->
        if hello_count == 0 do
          forward(peers, id)
          next(id, peers, hello_count + 1, from_id)
        else
          next(id, peers, hello_count + 1, parent)
        end


      after
        1_000 ->
          IO.puts "-> Peer#{id}: Self PID  = #{inspect(self())}, Parent PID = #{inspect(parent)}, Messages seen = #{hello_count}"
    end
  end

  defp forward(peers, id) do
    Enum.each(peers, fn p -> send p, { :hello, id } end)
  end
end # Peer
