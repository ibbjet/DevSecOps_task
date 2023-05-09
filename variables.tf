variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "parsley"
}

variable "access_key" {
  type        = string
  default     = ""
  description = "The AWS access_key to use for authentication"
}


variable "secret_key" {
  type        = string
  default     = ""
  description = "The AWS secret key to use for authentication"
}


variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where resources will be provisioned"
}


variable "hash_key" {
  description = "The hash key for the DynamoDB table"
  type        = string
  default     = "Parsley-1"
}

variable "range_key" {
  description = "The range key for the DynamoDB table"
  type        = string
  default     = "Parsley-2"
}

variable "readonly_group_name" {
  description = "The name of the read-only IAM group for the DynamoDB table"
  type        = string
  default     = "product_managers"
}

variable "readwrite_group_name" {
  description = "The name of the read-write IAM group for the DynamoDB table"
  type        = string
  default     = "developers"
}


