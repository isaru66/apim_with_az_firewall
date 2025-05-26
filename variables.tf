variable "resource_prefix" {
  type = string
}

variable "publisher_name" {
  default     = "publisher"
  description = "The name of the owner of the service"
  type        = string
  validation {
    condition     = length(var.publisher_name) > 0
    error_message = "The publisher_name must contain at least one character."
  }
}

variable "publisher_email" {
  default     = "test@contoso.com"
  description = "The email address of the owner of the service"
  type        = string
  validation {
    condition     = length(var.publisher_email) > 0
    error_message = "The publisher_email must contain at least one character."
  }
}

variable "apim_sku" {
  description = "The pricing tier of this API Management service"
  default     = "Developer"
  type        = string
  validation {
    condition     = contains(["Developer", "Standard", "Premium"], var.apim_sku)
    error_message = "The sku must be one of the following: Developer, Standard, Premium."
  }
}

variable "apim_instance_count" {
  default = 1
  type    = number
  validation {
    condition     = contains([1, 2], var.apim_instance_count)
    error_message = "The sku_count must be one of the following: 1, 2."
  }
}