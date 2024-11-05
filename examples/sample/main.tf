module "monitor_autoscale_setting" {
  source              = "../../"
  name                = "example-mas"
  resource_group_name = "example-rg"
  location            = "southeastasia"
  target_resource_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Compute/virtualMachineScaleSets/example-vmss"
  enabled             = true
  profiles = {
    "profile1" = {
      name = "profile1"
      capacity = {
        default = 1
        maximum = 10
        minimum = 1
      }
      rules = {
        "rule1" = {
          metric_trigger = {
            metric_name      = "Percentage CPU"
            operator         = "GreaterThan"
            statistic        = "Average"
            time_aggregation = "Average"
            time_grain       = "PT1M"
            time_window      = "PT5M"
            threshold        = 75
            metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
            dimensions = {
              "name"     = "InstanceId"
              "operator" = "Include"
              "values"   = ["*"]
            }
            divide_by_instance_count = false
          }
          scale_action = {
            cooldown  = "PT5M"
            direction = "Increase"
            type      = "ChangeCount"
            value     = "1"
          }
        }
      }
    }
  }
  tags = {
    environment = "dev"
  }
}