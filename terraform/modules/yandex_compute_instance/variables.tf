variable "hostname" {
  type = string
}
variable "ssh_username" {
  type = string
}
variable "ssh_key_file" {
  type = string
}
variable "inventory_file" {
  type = string
}
variable "inventory_group" {
  type = string
}
variable "instances_count" {
  type = number
}
variable "instance_config" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    disk_image    = string
    disk_size     = number
    disk_type     = string
    subnet        = string
    nat           = bool
  })
}
