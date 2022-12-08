terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.83.0"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

# Создаем сервис-аккаунт SA
resource "yandex_iam_service_account" "sa2" {
  folder_id = var.folder_id
  name      = "sa2"
}

# Даем права на запись для этого SA
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa2.id}"
}

# Создаем ключи доступа Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa2.id
  description        = "static access key for object storage"
}

# Создаем хранилище
resource "yandex_storage_bucket" "b5-sf-sa" {
  bucket     = "b5-sf-sa"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}