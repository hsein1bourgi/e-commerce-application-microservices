terraform{
    backend "s3" {
        bucket = "ecommeerce-terraform-state-bucket-2025"
        key    = "prod/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "ecommeerce-terraform-lock-table"
        encrypt = true
      name = "value"
    }
    
}