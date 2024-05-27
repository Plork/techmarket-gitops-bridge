variable "enable_techmarket" {
  description = "Enable Techmarket application"
  type        = bool
  default     = false
}

variable "techmarket" {
  type        = any
  default     = {}
  description = "Techmarket application configuration"
}
