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