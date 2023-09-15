terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.98"
}

provider "yandex" {
  service_account_key_file = var.yc_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "yandex_compute_instance" {
  source = "../modules/yandex_compute_instance"

  hostname        = "puzzle15-stage"
  ssh_username    = "puzzle15"
  ssh_key_file    = var.ssh_key_file

  inventory_group = "puzzle15_stage"
  inventory_file  = "../../ansible/puzzle15-stage"
  inventory_ssh_key_file = "{{ ssh_puzzle15_stage_key_file }}"

  instances_count = 2
  instance_config = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    preemptible   = true
    disk_image    = "ubuntu-2004-lts"
    disk_size     = 20
    disk_type     = "network-hdd"
    subnet        = var.subnet
    nat           = true
  }
}
