variable "node_count" {
  description = "Number of nodes to create"
  type        = number
  default     = 3
  nullable    = false

  validation {
    condition     = var.node_count >= 1
    error_message = "At least 1 node must be specified"
  }
}

variable "base_image_url" {
  description = "Base ova image URL"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/20250207/jammy-server-cloudimg-amd64.ova"
}
