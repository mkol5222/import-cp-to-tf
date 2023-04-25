



# POST {{server}}/login
# Content-Type: application/json

# {
#   "api-key" : "FFl8+KF1AJ2Tisac6d0K+w=="
# }

$login = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/login" -Method Post -ContentType "application/json" -Body "{`"api-key`":`"$api_key`"}" -UseBasicParsing
$sid = $login.sid

# POST {{server}}/show-access-layers
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "limit" : 50,
#   "offset" : 0,
#   "details-level" : "standard"
# }
$layes = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-access-layers" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"limit`":50,`"offset`":0,`"details-level`":`"standard`"}" `
    -UseBasicParsing
$layes."access-layers"| ft

# POST {{server}}/show-access-layer
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "uid" : "6a5b4108-a94e-4f5d-974b-8d8c431fdd5f"
# }
$layer = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-access-layer" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"uid`":`"$($layes."access-layers"[0].uid)`"}" `
    -UseBasicParsing

$layer

# POST {{server}}/show-access-rulebase
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "offset" : 0,
#   "limit" : 20,
#   "name" : "Network",
#   "details-level" : "standard",
#   "use-object-dictionary" : true
# }

$rulebase = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-access-rulebase" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"offset`":0,`"limit`":20,`"name`":`"Network`",`"details-level`":`"standard`",`"use-object-dictionary`":true}" `
    -UseBasicParsing

$rulebase

$rulebase.rulebase

$rulebase.'objects-dictionary'