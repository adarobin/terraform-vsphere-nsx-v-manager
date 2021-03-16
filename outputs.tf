output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "admin_enable_password" {
  value     = random_password.admin_enable_password.result
  sensitive = true
}
