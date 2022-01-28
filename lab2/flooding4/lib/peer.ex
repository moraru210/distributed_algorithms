
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

defmodule Peer do

  # add your code here, start(), next() and any other functions
  def start(id) do
    IO.puts "-> Peer at #{Helper.node_string()} with ID #{id}"
    receive do
      { :peers_list, peers} -> next(id, peers, 0, nil, nil, 0)
    end
  end

  defp next(id, peers, hello_count, parent_id, parent_pid, children_count) do
    receive do
      { :hello, from_id, from_pid } ->
        if hello_count == 0 do
          send from_pid, { :child }
          forward(peers, id)
          next(id, peers, hello_count + 1, from_id, from_pid, children_count)
        else
          next(id, peers, hello_count + 1, parent_id, parent_pid, children_count)
        end
      { :child } ->
        send parent_pid, { :child }
        next(id, peers, hello_count + 1, parent_id, parent_pid, children_count + 1)
      after
        1_000 ->
          IO.puts "-> Peer#{id}: Self PID  = #{inspect(self())}, Parent ID = #{inspect(parent_id)}, Messages seen = #{hello_count}"
          IO.puts "------> Children count for Peer#{id}: #{children_count}"
    end
  end

  defp forward(peers, id) do
    Enum.each(peers, fn p -> send p, { :hello, id, self() } end)
  end
end # Peer
