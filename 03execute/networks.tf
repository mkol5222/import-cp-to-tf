resource "checkpoint_management_network" "bud" {
    broadcast    = "allow"
    color        = "black"
    comments     = "comment - no Internet"
   
    mask_length4 = 24
    name         = "network-spot"
    nat_settings = {
        "auto_rule"   = "true"
        "hide_behind" = "gateway"
        "install_on"  = "All"
        "method"      = "hide"
    }
    subnet4      = "10.70.80.0"
    tags         = []
}

# resource "checkpoint_management_network" "athens1" {
#     broadcast    = "allow"
#     color        = "black"
#     #id           = "net-athens-day1"
#     mask_length4 = 16
#     name         = "net-athens-day1"
#     nat_settings = {
#         "auto_rule"   = "true"
#         "hide_behind" = "gateway"
#         "install_on"  = "All"
#         "method"      = "hide"
#     }
#     subnet4      = "172.1.0.0"
#     tags         = ["athens1"]
# }