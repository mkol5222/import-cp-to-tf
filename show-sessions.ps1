
# Smart-1 Cloud mtets2 credetials
& ./.env-mtest2.ps1

# POST {{server}}/login
# Content-Type: application/json

# {
#   "api-key" : "FFl8+KF1AJ2Tisac6d0K+w=="
# }

$login = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/login" -Method Post -ContentType "application/json" -Body "{`"api-key`":`"$api_key`"}" -UseBasicParsing
$sid = $login.sid

# POST {{server}}/show-sessions
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "limit" : 50,
#   "offset" : 0,
#   "details-level" : "full"
# }

$sessions = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-sessions" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"limit`":50,`"offset`":0,`"details-level`":`"full`"}" `
    -UseBasicParsing

$sessions.objects 