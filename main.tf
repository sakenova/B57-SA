//Указать версию ппровайдера YC
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.83.0"
    }
  }
}
//Установить провайдер YC
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  zone           = var.zone #zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  boot_disk {
    initialize_params {
      image_id = "fd85sedv7393pqkp86e6"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  resources {
    cores  = 2
    memory = 2
  }
  //Отправка открытого ключа на сервер
  metadata = {
    #ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "${file("./meta.txt")}"
  }

}

//Вывод внутреннего ip-адреса созданной ВМ 
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

//Вывод внешнего ip-адреса созданной ВМ
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

module "bucket" {
  source = "./modules/bucket"
}