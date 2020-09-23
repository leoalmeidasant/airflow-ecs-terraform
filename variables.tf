variable "aws-profile" {
    type        = string
    default     = "default"
    description = "AWS Profile"
}

variable "aws-region" {
    type    = string
    default = "us-east-1"
}

variable "efs_subnet_id" {
    type = string
}

variable "sg_tags" {
    type = map
}

variable "airflow_database_password" {
    type = string
}