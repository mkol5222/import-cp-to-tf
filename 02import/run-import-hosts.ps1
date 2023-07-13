# Smart-1 Cloud mtets2 credetials
. ../.env-mtest2.ps1

# to filter hosts by tag
$batchTag = "athens1"

# POST {{server}}/login
# Content-Type: application/json

# {
#   "api-key" : "CHANGEME"
# }

$login = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/login" -Method Post -ContentType "application/json" -Body "{`"api-key`":`"$api_key`"}" -UseBasicParsing
$sid = $login.sid

# POST {{server}}/show-hosts
# Content-Type: application/json
# X-chkp-sid: {{session}}

# {
#   "limit" : 50,
#   "offset" : 0,
#   "details-level" : "standard"
# }

$hosts = Invoke-RestMethod -Uri "https://$server/$cloud_mgmt_id/$context/show-hosts" `
    -Method Post -ContentType "application/json" `
    -Headers @{"X-chkp-sid" = $sid} `
    -Body "{`"filter`":`"$batchTag`",`"limit`":50,`"offset`":0,`"details-level`":`"standard`"}" `
    -UseBasicParsing

$hostsToImport = $hosts.objects | ? { $_.name.StartsWith("Internal_Host_")} 

$hostsToImport | ft

# empty TF resources - referenced in "terraform import" commands
$hostsToImport  | % {$counter = 1} {
    $resName = $_.name # "host_$counter" # $_.name
    $counter++
    "resource `"checkpoint_management_host`" `"$resName`" {}";
} | Out-File -FilePath "import-hosts.tf" -Encoding ascii

# commands to import to TF state to resoucers above using ID/name in  CP management
$hostsToImport | % {$counter = 1} {
    $resName = $_.name # "host_$counter" # $_.name
    $counter++
    "terraform import checkpoint_management_host.`"$resName`" `"$($_.name)`"";
} | Out-File -FilePath "import-hosts.ps1" -Encoding ascii

# commands to show TF state as full records
$hostsToImport  | % {$counter = 1} {
    $resName = $_.name #  "host_$counter" # $_.name
    $counter++
    "terraform state show -no-color checkpoint_management_host.`"$resName`"";
} | Out-File -FilePath "show-hosts.ps1" -Encoding ascii

Write-Host "Run ./import-hosts.ps1 to import hosts from CP to terraform state"
# ./import-hosts.ps1
Write-Host "Run >>> ./show-hosts.ps1 | sls -NotMatch "id +=" | Out-File ./import-hosts.tf -Encoding ascii <<< to produce full TF resources code"
# ./show-hosts.ps1 | sls -NotMatch "id +=" | Out-File ./import-hosts.tf -Encoding ascii
Write-Host "Next step we will create hosts in new management from TF code in generated hosts.tf"
# cp ./import-hosts.tf ../03execute/hosts.tf
Write-Host "continue with: cd ../03execute/"