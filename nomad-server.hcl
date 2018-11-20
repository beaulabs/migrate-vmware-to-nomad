data_dir = "/opt/nomad/data"
bind_addr = "10.128.0.2"

# Enable the server
server {
  enabled = true
  bootstrap_expect = 1
}

name = "nomad@10.128.0.2"

consul {
  address = "127.0.0.1:8500"
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}