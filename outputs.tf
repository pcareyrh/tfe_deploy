# General
# -------
output "resource_group_name" {
  value = var.resource_group_name
}

# Database
# -------
output "database_server_name" {
  value = azurerm_postgresql_server.pcarey-ptfe-psql.name
}

output "database_server_fqdn" {
  value = azurerm_postgresql_server.pcarey-ptfe-psql.fqdn
}

output "database_user" {
  value = var.db_user
}

output "database_password" {
  value = random_string.tfe_pg_password.result
}

output "database_name" {
  value = var.db_name
}

output "load_balancer_ip" {
  value = azurerm_public_ip.pcarey-publicip.ip_address
}

# VM
# --
output "instance_user_name" {
  value = var.vm_admin_username
}

# Redis
# -- 
output "redis_hostname" {
  value = azurerm_redis_cache.pcarey-redis-tfe.hostname
}

output "redis_ssl_port" {
  value = azurerm_redis_cache.pcarey-redis-tfe.ssl_port
}

output "redis_pass" {
  value = azurerm_redis_cache.pcarey-redis-tfe.primary_access_key
  sensitive = false
}
