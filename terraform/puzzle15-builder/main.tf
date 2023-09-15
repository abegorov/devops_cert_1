terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.98"
}

provider "yandex" {
  service_account_key_file = "../../secrets/key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "yandex_compute_instance" {
  source = "../modules/yandex_compute_instance"

  hostname        = "puzzle15-builder"
  ssh_username    = "builder"
  ssh_key_file    = var.ssh_key_file

  inventory_group = "puzzle15_builder"
  inventory_file  = "../../ansible/puzzle15-builder"
  inventory_ssh_key_file = "{{ ssh_puzzle15_builder_key_file }}"

  instances_count = 1
  instance_config = {
    cores         = 4
    memory        = 4
    core_fraction = 20
    preemptible   = true
    disk_image    = "ubuntu-2004-lts"
    disk_size     = 20
    disk_type     = "network-hdd"
    subnet        = var.subnet
    nat           = true
  }
}
