# Smart-1 Cloud mtets2 credetials
. ../.env-mtest2.ps1
$batchTag = "athens1"

# POST {{server}}/login
# Content-Type: application/json

# {
#   "api-key" : "CHANGEME"
# }

$login = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/login" `
    -Method Post `
    -ContentType "application/json" `
    -Body "{`"api-key`":`"$api_key`"}" `
    -UseBasicParsing

$sid = $login.sid

# POST {{server}}/add-host
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "name" : "New Host 1",
#   "ip-address" : "192.0.2.1"
# }


# for loop for n between A and B
for ($i=61; $i -le 70; $i++) {
    $hostPayload = @{
        name = "Internal_Host_$i"
        'ip-address' = "10.10.70.$i"
        "set-if-exists" = "true"
        'tags' = @($batchTag)
    } | ConvertTo-Json
    
    $newHost = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/add-host" `
        -Method Post -ContentType "application/json" `
        -Headers @{"X-chkp-sid" = $sid} `
        -Body $hostPayload
    
    $newHost
}

# POST {{server}}/publish
# Content-Type: application/json
# X-chkp-sid: {{session}}

# { }

$publishTask = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/publish" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{}"

$publishTask

# show hosts
# POST {{server}}/show-hosts
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "filter" : "host_"
# }

$listedHosts = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-hosts" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"filter`":`"$batchTag`"}"
$listedHosts.objects | select name, 'ipv4-address', tags | ft

# POST {{server}}/show-networks
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "limit" : 50,
#   "offset" : 0,
#   "details-level" : "standard"
# }

$networks = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-networks" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"limit`":`"50`",`"offset`":`"0`",`"details-level`":`"standard`"}"


#     POST {{server}}/show-access-rulebase
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
    -Body "{`"offset`":`"0`",`"limit`":`"20`",`"name`":`"Network`",`"details-level`":`"standard`",`"use-object-dictionary`":`"true`"}"

$rulebase.rulebase | select name, action, source, destination, service, track | ft
$rulebase."objects-dictionary" | select name, type, 'ipv4-address', tags | ft