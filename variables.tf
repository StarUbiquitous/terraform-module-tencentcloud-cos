variable "region" {
  default     = "ap-chengdu"
  description = "The region to deploy in, e.g: ap-shanghai"
  type        = string
}

locals {
  iata = {
    ap-shanghai = "SHA"
    ap-chengdu  = "CTU"
  }
}
