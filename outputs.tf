# Output Public IP addresses

output "publicip2019_1" {
  value = module.publicip2019[0].publicip_address
}
output "publicip2019_2" {
  value = module.publicip2019[1].publicip_address
}
output "publicip2016" {
  value = module.publicip2016.publicip_address
}
output "publiciprhel" {
  value = module.publiciprhel.publicip_address
}