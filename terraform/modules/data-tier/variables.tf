variable "project_name" {
  description = "Your project name"
}

variable "db_username" {
  description = "Your database username"
}

variable "db_password" {
  description = "Your database password"
}

variable "db_subnet_ids" {
  description = "The DB Tier Subnets"
  type        = list(string)
}

variable "db_sg_id" {
  description = "The DB Security Group ID"
}