variable "pac_allowed_vpces"{
  default=["vpce-0baef689a9cb88928", "vpce-0aaed26a56b7fcd21"]
}


variable "pac_s3_bucket_name" {
  type        = string
  description = "Pac File S3 Bucket name"
  default="st-pac-test-129038u128947321849"
}

