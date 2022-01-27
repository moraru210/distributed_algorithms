
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

  for peer <- global_peers do
    send peer, { :global_peers, global_peers}
  end

  send List.first(global_peers), { :hello }
end # start/2

defp spawn_peers(config, cur_peers, peers_left) do
  peer = Node.spawn(:'peer#{peers_left}_#{config.node_suffix}', Peer, :start, [peers_left])
  new_peers = [peer | cur_peers]
  if peers_left == 0 do
    new_peers
  else
    spawn_peers(config, new_peers, peers_left - 1)
  end
end

end # Flooding
