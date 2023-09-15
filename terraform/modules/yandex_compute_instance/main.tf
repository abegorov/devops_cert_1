terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.98"
}

data "yandex_compute_image" "image" {
  family = var.instance_config.disk_image
}

data "yandex_vpc_subnet" "subnet" {
  name = var.instance_config.subnet
}

resource "yandex_compute_instance" "instance" {
  count    = var.instances_count

  name     = format("%s-%02d", var.hostname, count.index + 1)
  hostname = format("%s-%02d", var.hostname, count.index + 1)

  resources {
    cores  = var.instance_config.cores
    memory = var.instance_config.memory
    core_fraction = var.instance_config.core_fraction
  }

  scheduling_policy {
    preemptible = var.instance_config.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size     = var.instance_config.disk_size
      type     = var.instance_config.disk_type
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.subnet.subnet_id
    nat       = var.instance_config.nat
  }

  metadata = {
    install-unified-agent = 0
    ssh-keys = join(":", [
      var.ssh_username,
      file(format("%s.pub", var.ssh_key_file))
    ])
    user-data = <<-EOT
      #cloud-config
      datasource:
        Ec2:
          strict_id: false
      ssh_pwauth: no
      users:
        - name: ${var.ssh_username}
          sudo: ALL=(ALL) NOPASSWD:ALL
          shell: /bin/bash
          ssh_authorized_keys:
            - ${file(format("%s.pub", var.ssh_key_file))}
      runcmd: []
      EOT
  }

  # ожидание доступности SSH соединения:
  connection {
      type        = "ssh"
      user        = var.ssh_username
      host        = self.network_interface.0.nat_ip_address
      private_key = file(format("%s", var.ssh_key_file))
  }

  provisioner "remote-exec" {
    inline = [
      "echo Deploy of $(cat /etc/hostname) completed!"
    ]
  }
}

resource "local_file" "inventory" {
  filename = var.inventory_file
  content  = templatefile("${path.module}/inventory.tmpl", {
    inventory_group = var.inventory_group,
    instances = yandex_compute_instance.instance,
    ssh_username = var.ssh_username,
    ssh_private_key_file = format("%s", var.inventory_ssh_key_file)
  })
}
