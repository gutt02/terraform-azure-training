variable "location" {
    type = string
    default = "westeurope"

    description = "Azure Region."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  description = "Default tags for resources, only applied to resource groups"
}
