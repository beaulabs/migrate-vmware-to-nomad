job "webapp-large-0" {
  datacenters = ["dc1"]
  
  # Jobs can have groups which contain tasks.
  group "vmdk" {
    # We're keeping it simple, one Virtual machine per task/group/job
    task "server" {
      resources {
        memory = 4096
        cpu    = 2048

        # Nomad will automatically expose ports for these services for us!
        network {
          port "http"{}
          port "ssh"{}
        }
      }

      # Create a Consul service and health check for our load balancer
      service {
        tags = ["webapp","urlprefix-catapp.hashidemos.io:9999/"]

        port = "http"
        
        check {
          type     = "http"
          port     = "http"
          path     = "/index.html"
          interval = "10s"
          timeout  = "2s"
        }
      }

      driver = "qemu"

      # Here we configure our image path, virtual hardware acceleration, and Qemu arguments.
      config {
        image_path  = "/opt/nomad/data/alloc/${NOMAD_ALLOC_ID}/${NOMAD_TASK_NAME}/local/centos7.vmdk"
        accelerator = "kvm"
        args        = ["-device", "e1000,netdev=user.0", "-netdev", "user,id=user.0,hostfwd=tcp::${NOMAD_PORT_http}-:80,hostfwd=tcp::${NOMAD_PORT_ssh}-:22"]
      }

      # This is where we fetch our VMDK file from. You can build and update your VMDKs with Packer.
      artifact {
        source = "http://10.128.0.2/centos7.vmdk"

        options {
          checksum = "md5:008893017f112653c06ca99469d9f984"
        }
      }
    }
  }
}