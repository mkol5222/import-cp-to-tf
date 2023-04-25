terraform {
  required_providers {
    checkpoint = {
      source  = "CheckPointSW/checkpoint"
      version = "2.3.0"
    }
  }
}

provider "checkpoint" {
  server        = var.cp_mgmt_server
  api_key       = var.cp_mgmt_api_key
  context       = var.cp_mgmt_context
  cloud_mgmt_id = var.cp_mgmt_cloud_mgmt_id

}

