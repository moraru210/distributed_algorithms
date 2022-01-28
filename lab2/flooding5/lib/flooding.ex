
# distributed algorithms, n.dulay, 10 jan 22
# basic flooding, v1

# flood message through 1-hop (fully connected) network

defmodule Flooding do

def start do
  config = Helper.node_init()
  start(config, config.start_function)
end # start/0

defp start(_,      :cluster_wait), do: :skip
defp start(config, :cluster_start) do
  IO.puts "-> Flooding at #{Helper.node_string()}"

  # add your code here
  global_peers = spawn_peers(config, [], config.n_peers - 1)
  IO.puts "-> Peers = #{inspect(inspect(global_peers))}"

  # Bind peers according to network configuration
  bind(global_peers, 0, [1, 6])
  bind(global_peers, 1, [0, 2, 3])
  bind(global_peers, 2, [1, 3, 4])
  bind(global_peers, 3, [1, 2, 5])
  bind(global_peers, 4, [2])
  bind(global_peers, 5, [3])
  bind(global_peers, 6, [0, 7])
  bind(global_peers, 7, [6, 8, 9])
  bind(global_peers, 8, [7, 9])
  bind(global_peers, 9, [7, 8])

  send List.first(global_peers), { :hello , -1, self() }

  collect_children(List.first(global_peers),0,0)
  #collect_sum(0)

end # start/2

defp collect_children(first_peer, count, sum) do
  receive do
    { :child } ->
      collect_children(first_peer, count + 1, sum)
      send first_peer, { :sum_req }
    { :sum, output } -> collect_children(first_peer, count, output)
  after
    1_000 ->
      IO.puts "Root node children: #{count}"
      IO.puts "******* Root node sum: #{sum} *******"
  end
end

# defp collect_sum(sum) do
#   receive do
#     { :sum, output } -> collect_sum(output)
#   after
#     1_000 ->
#       IO.puts "******* Root node sum: #{sum} *******"
#   end
# end

defp spawn_peers(config, cur_peers, peers_left) do
  peer = Node.spawn(:'peer#{peers_left}_#{config.node_suffix}', Peer, :start, [peers_left])
  new_peers = [peer | cur_peers]
  if peers_left == 0 do
    new_peers
  else
    spawn_peers(config, new_peers, peers_left - 1)
  end
end

defp bind(peers, peer_id, neighbour_ids) do
  IO.puts '-> Neighbours for Peer#{peer_id} = #{inspect(neighbour_ids)}'
  neighbours = Enum.map(neighbour_ids, fn n -> Enum.at(peers, n) end)
  cur = Enum.at(peers, peer_id)
  send cur, { :peers_list, neighbours}
end

end # Flooding
