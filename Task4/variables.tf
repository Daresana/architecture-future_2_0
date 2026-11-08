variable "zone" {
  description = "Зона для учебной ВМ"
  type        = string
  default     = "ru-central1-a"
}

variable "cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Оперативная память, ГБ"
  type        = number
  default     = 4
}

variable "disk_size" {
  description = "Размер загрузочного диска, ГБ"
  type        = number
  default     = 10
}

variable "admin_cidr" {
  description = "Внешний IPv4 для SSH-доступа с маской /32"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && can(regex("/32$", var.admin_cidr))
    error_message = "Укажите один IPv4-адрес администратора с маской /32."
  }
}

variable "ssh_public_key" {
  description = "Открытый SSH-ключ администратора"
  type        = string

  validation {
    condition     = can(regex("^ssh-(ed25519|rsa) [A-Za-z0-9+/=]+", var.ssh_public_key))
    error_message = "Укажите открытый SSH-ключ ed25519 или RSA."
  }
}
