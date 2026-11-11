terraform {
  required_version = ">= 1.6, < 2.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.243.0"
    }
  }
}

provider "yandex" {
  zone = var.zone
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "pilot" {
  name = "future-pilot-network"
}

resource "yandex_vpc_subnet" "pilot" {
  name           = "future-pilot-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.pilot.id
  v4_cidr_blocks = ["10.11.0.0/24"]
}

# Доступ по SSH только с адреса администратора.
resource "yandex_vpc_security_group" "pilot" {
  name       = "future-pilot-sg"
  network_id = yandex_vpc_network.pilot.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.admin_cidr]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_disk" "boot" {
  name     = "future-pilot-boot"
  zone     = var.zone
  type     = "network-ssd"
  size     = var.disk_size
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_instance" "pilot" {
  name        = "future-pilot-vm"
  zone        = var.zone
  platform_id = "standard-v3"

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.pilot.id
    security_group_ids = [yandex_vpc_security_group.pilot.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
