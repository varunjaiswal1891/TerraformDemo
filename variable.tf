/*
variable "image_id" {
  type        = string
  description = "ID of the machine image(AMI) to use for the server"
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "Must be a valid AMI ID ,starting with ami-"
  }
}
*/

//valid image_id = "ami-05b247977c95afe42"
// this is a input variable
variable "tag_name" {
  //default = "app"
  type        = string
  description = "Enter tag name for all resoucres"
}

variable "port_number" {
  description = "List of Ports where server runs"
  //type = list(number)
  type = number
  //default = [ 8080,8081,8082 ]

}
//var.port_numbers[0]