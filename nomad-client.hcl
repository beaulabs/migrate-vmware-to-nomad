data_dir = "/opt/nomad/data"
bind_addr = "10.128.0.4"
name = "nomad@10.128.0.4"

# Enable the client
client {
  enabled = true
  options = {
    driver.java.enable = "1"
    driver.qemu.enable = "1"
    docker.cleanup.image = false
  }
  servers = ["10.128.0.2"]
}

consul {
  address = "127.0.0.1:8500"
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}