Connect-AzureAD
$tenant  = (Get-AzureADDomain).name
$subscr2  = Get-AzSubscription
$wloc = Read-host ('Are you want to use WestUs2 location? Enter: y/n')
if($wloc -eq 'n'){$location = Read-host ('Enter location. (etc. WestUS2, CentralUS)')} else {$location = 'WestUS2'}
$rgname = Read-host ('Are you want to use standard Resource Group name "Processica-Newsletter-Distribution"? Enter: y/n')
if($rgname -eq 'n'){$grname = Read-host ('Enter Resource Groupe name')} else {$grname = 'Processica-Newsletter-Distribution'}
$usern2   = Read-host ('Enter User name in format (AccountName@mycompany.com)')
New-AzResourceGroup -Name $grname -Location $location
Start-Sleep -Seconds 1
$find = '$subscr'
$replace = $subscr2
$find1 = '$location'
$replace1 = $location
$newusername = '$usern'
$username = $usern2
(Get-Content -Path ./template_v2.json).replace("'$find'", "$replace") | Set-Content -Path ./template_v2.json
(Get-Content -Path ./template_v2.json).replace("'$find1'", "$replace1") | Set-Content -Path ./template_v2.json
(Get-Content -Path ./template_v2.json).replace("'$newusername'", "$username") | Set-Content -Path ./template_v2.json
New-AzResourceGroupDeployment -ResourceGroupName $grname -TemplateFile ./template_v2.json
$apiurl = "https://portal.azure.com\#@"+$tenant
$apiurl2 = "/resource/subscriptions/"+$subscr2
$apiurl3 = "/resourceGroups/"+$grname
$apiurl4 = "/providers/Microsoft.Web/connections/office365/connection"
$o365 = $apiurl+$apiurl2+$apiurl3+$apiurl4
Write-Host ("Using these three links please authorize your Azure Logic Apps Connectors:")
Write-Host ($o365)
Start-Sleep -Seconds 1