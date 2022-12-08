variable "cloud_id" {
  default = "b1g54521qm46mkhhpbmr"
}
variable "folder_id" {
  default = "b1g1l3j3k0909cn94se2"
}
variable "sa_id" {
  default     = "aje6hknjos2la3ldv6at"
  description = "ID сервисного аккаунта"
}
variable "sa_auth_key" {
  default     = "ajepnirvvfthur3diq38"
  description = "авторизованный ключ для запроса IAM токена"
}
variable "token" {
  default     = "y0_AgAAAABmyZvjAATuwQAAAADV_2bBnUhicQSjSrG877uhNHXMMpO45eU"
  description = ""
}
variable "zone" {
  description = "Use specific availability zone"
  type        = string
  default     = "ru-central1-a"
}