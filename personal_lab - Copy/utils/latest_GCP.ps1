$githubDataUrl = 'https://github-data-yqog19b.nw.gateway.dev/api/v1/latest'
#$uiAutomationDataUrl = 'https://ui-automation-yqog19b.nw.gateway.dev/api/v1/set'

$branchName = "1.6.400"

# Get Google ID token from logged-in user at this computer
$googleIdToken = & 'gcloud.cmd' auth print-identity-token 

$headers = @{
    Authorization = "Bearer $googleIdToken"
    Accept = '*/*'
    Host = 'github-data-yqog19b.nw.gateway.dev'
} 

$sources = @()

$res = Invoke-WebRequest -Uri "$githubDataUrl/$branchName/CCM-GPosWebServer/1" -Method Get -Headers $headers
$CCMGPosReleaseName = $res.Content | ConvertFrom-Json
if ($CCMGPosReleaseName.Count -gt 0) { $sources += $CCMGPosReleaseName[0] }

Write-Host "Detected latest CCM GposWebserver: $($CCMGPosReleaseName[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/CCM-Office/1" -Method Get -Headers $headers
$CCMOfficeReleaseName = $res.Content | ConvertFrom-Json
if ($CCMOfficeReleaseName.Count -gt 0) { $sources += $CCMOfficeReleaseName[0] }

Write-Host "Detected latest CCM Office: $($CCMOfficeReleaseName[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/GPosWebServer/1" -Method Get -Headers $headers
$GPosWebServer = $res.Content | ConvertFrom-Json
if ($GPosWebServer.Count -gt 0) { $sources += $GPosWebServer[0] }

Write-Host "Detected latest GPosWebServer: $($GPosWebServer[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/POSClient/1" -Method Get -Headers $headers
$POSClient = $res.Content | ConvertFrom-Json
if ($POSClient.Count -gt 0) { $sources += $POSClient[0] }

Write-Host "Detected latest POS Client: $($POSClient[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/Forecourt/1" -Method Get -Headers $headers
$Forecourt = $res.Content | ConvertFrom-Json
if ($Forecourt.Count -gt 0) { $sources += $Forecourt[0] }

Write-Host "Detected latest Forecourt: $($Forecourt[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/Office/1" -Method Get -Headers $headers
$StoreOfficeReleaseName = $res.Content | ConvertFrom-Json
if ($StoreOfficeReleaseName.Count -gt 0) { $sources += $StoreOfficeReleaseName[0] }

Write-Host "Detected latest Office: $($StoreOfficeReleaseName[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/UI.Automation/1" -Method Get -Headers $headers
$UiAutomationReleaseName = $res.Content | ConvertFrom-Json
if ($UiAutomationReleaseName.Count -gt 0) { $sources += $UiAutomationReleaseName[0] }

Write-Host "Detected latest UI.Automation: $($UiAutomationReleaseName[0].tag_name)"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/PaymentEmulators/1" -Method Get -Headers $headers
$PaymentEmulatorReleaseName = $res.Content | ConvertFrom-Json
if ($PaymentEmulatorReleaseName.Count -gt 0) { $sources += $PaymentEmulatorReleaseName[0] }

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/PriceChecker/1" -Method Get -Headers $headers
$PriceCheckerReleaseName = $res.Content | ConvertFrom-Json
if ($PriceCheckerReleaseName.Count -gt 0) { $sources += $PriceCheckerReleaseName[0] }

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$branchName/EpsApi2/1" -Method Get -Headers $headers
$EpsApiReleaseName = $res.Content | ConvertFrom-Json
if ($EpsApiReleaseName.Count -gt 0) { $sources += $EpsApiReleaseName[0] }



Write-Host $sources 