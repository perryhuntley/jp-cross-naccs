variable "application" {
  type = string
}

variable "topic" {
  type = string
}

variable "heritage" {
  type = string
}

variable "contact" {
  type = string
}

variable "costcenter" {
  type = string
}

variable "executionitem" {
  type = string
}

variable "stage" {
  type = string
}

variable "operatedby" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_sizes" {
  type        = map(string)
  description = "Mapping of service catalogue vm sizes to azure vm"

  default = {
    "2vCPU-8GB"    = "Standard_D2s_v3",
    "4vCPU-16GB"   = "Standard_D4s_v3",
    "8vCPU-32GB"   = "Standard_D8s_v3",
    "16vCPU-64GB"  = "Standard_D16s_v3",
    "32vCPU-128GB" = "Standard_D32s_v3",
    "2vCPU-16GB"   = "Standard_E2as_v4",
    "4vCPU-32GB"   = "Standard_E4as_v4",
    "8vCPU-64GB"   = "Standard_E8as_v4"
  }
}

variable "backup_plans" {
  type        = map(string)
  description = "Mapping of service catalogue backup time to backup plan"

  default = {
    "none"   = "NONE",
    "ShortTerm(1month)-00:00-03:00" = "Short-12AM",
    "ShortTerm(1month)-03:00-06:00" = "Short-3AM",
    "ShortTerm(1month)-06:00-09:00" = "Short-6AM",
    "ShortTerm(1month)-09:00-12:00" = "Short-9AM",
    "ShortTerm(1month)-12:00-15:00" = "Short-12PM",
    "ShortTerm(1month)-15:00-18:00" = "Short-3PM",
    "ShortTerm(1month)-18:00-21:00" = "Short-6PM",
    "ShortTerm(1month)-21:00-24:00" = "Short-9PM",
    "LongTerm(1year)-00:00-03:00"   = "Long-12AM",
    "LongTerm(1year)-03:00-06:00"   = "Long-3AM",
    "LongTerm(1year)-06:00-09:00"   = "Long-6AM",
    "LongTerm(1year)-09:00-12:00"   = "Long-9AM",
    "LongTerm(1year)-12:00-15:00"   = "Long-12PM",
    "LongTerm(1year)-15:00-18:00"   = "Long-3PM",
    "LongTerm(1year)-18:00-21:00"   = "Long-6PM",
    "LongTerm(1year)-21:00-24:00"   = "Long-9PM"
  }
}
