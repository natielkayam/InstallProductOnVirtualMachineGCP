<#
.SYNOPSIS
    Script will detect start run-setup.ps1 script with all the required parameters
.LINK
    https://github.com/ncr-swt-retail/emerald1
#>

PARAM(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Github credentials username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GitHubUser,

    [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Github credentials Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GitHubUserPersonalAccessToken,

    [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Branch name prefix to run tests on. For example 1.8.100 or 1.2.x, etc..")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $BranchName,
	[string]	
	$PersonalLabName,
    [Parameter(Mandatory = $false, Position = 3, HelpMessage = "Full absolute path to configuration file (labs.ps1)")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $LabConfigurationFilePath = $("$PSScriptRoot\configPersonalLab\$PersonalLabName" | Resolve-Path),

    [Parameter(Mandatory = $false, Position = 4, HelpMessage = "Full absolute path including file name to configuration file")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GlobalConfigurationFile = $("$PSScriptRoot\config\configuration.ps1" | Resolve-Path)
)


$utilsFolder = "$PSScriptRoot\utils" | Resolve-Path

$STSRepoName = 'ncr-swt-retail/emerald1'
$CCMRepoName = 'ncr-swt-retail/emerald1-ccm'

$githubDataUrl = 'XXXXXX'
# Get Google ID token from logged-in user at this computer
$googleIdToken = & 'gcloud.cmd' auth print-identity-token 

$headers = @{
    Authorization = "Bearer $googleIdToken"
    Accept = '*/*'
    Host = 'XXXXXX'
} 

$res = Invoke-WebRequest -Uri "$githubDataUrl/$BranchName/CCM-GPosWebServer/1" -Method Get -Headers $headers
$CCMGPosReleaseName = $res.Content | ConvertFrom-Json
$CCMGPosReleaseName = $CCMGPosReleaseName[0].tag_name
Write-Host "CCMGposReleaseName = $CCMGposReleaseName"

$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/CCM-Office/1" -Method Get -Headers $headers
$CCMOfficeReleaseName = $res.Content | ConvertFrom-Json
$CCMOfficeReleaseName = $CCMOfficeReleaseName[0].tag_name
Write-Host "CCMOfficeReleaseName = $CCMOfficeReleaseName"


$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/GPosWebServer/1" -Method Get -Headers $headers
$GPosWebServerReleaseName = $res.Content | ConvertFrom-Json
$GPosWebServerReleaseName = $GPosWebServerReleaseName[0].tag_name
Write-Host "GPosWebServerReleaseName = $GPosWebServerReleaseName"


$StoreGposReleaseName = $GPosWebServerReleaseName
Write-Host "StoreGposReleaseName = $StoreGposReleaseName"



$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/POSClient/1" -Method Get -Headers $headers
$POSClientReleaseName = $res.Content | ConvertFrom-Json
$POSClientReleaseName = $POSClientReleaseName[0].tag_name
Write-Host "POSClientReleaseName = $POSClientReleaseName"


$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/Forecourt/1" -Method Get -Headers $headers
$ForecourtReleaseName = $res.Content | ConvertFrom-Json
$ForecourtReleaseName = $ForecourtReleaseName[0].tag_name
Write-Host "ForecourtReleaseName = $ForecourtReleaseName"


$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/Office/1" -Method Get -Headers $headers
$StoreOfficeReleaseName = $res.Content | ConvertFrom-Json
$StoreOfficeReleaseName = $StoreOfficeReleaseName[0].tag_name
Write-Host "StoreOfficeReleaseName = $StoreOfficeReleaseName"


$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/UI.Automation/1" -Method Get -Headers $headers
$UiAutomationReleaseName = $res.Content | ConvertFrom-Json
$UiAutomationReleaseName = $UiAutomationReleaseName[0].tag_name
Write-Host "UIAutomationReleaseName = $UIAutomationReleaseName"


$res = Invoke-WebRequest  -Uri "$githubDataUrl/$BranchName/PaymentEmulators/1" -Method Get -Headers $headers
$PaymentEmulatorsReleaseName = $res.Content | ConvertFrom-Json
$PaymentEmulatorsReleaseName = $PaymentEmulatorsReleaseName[0].tag_name
Write-Host "PaymentEmulatorsReleaseName = $PaymentEmulatorsReleaseName"


$parameters = @{
	PersonalLabName  = $PersonalLabName
    LabsConfigurationFile       = $LabConfigurationFilePath
    GlobalConfigurationFile     = $GlobalConfigurationFile
    GithubUsername              = $GitHubUser
    GithubPAT                   = $GitHubUserPersonalAccessToken
    RemotePowershellUsername    = 'XXXXXX'
    RemotePowershellPassword    = 'XXXXX'
    CCMGposReleaseName          = $CCMGposReleaseName
    CCMOfficeReleaseName        = $CCMOfficeReleaseName
    GPosWebServerReleaseName    = $GPosWebServerReleaseName
    POSClientReleaseName        = $POSClientReleaseName
    ForecourtReleaseName        = $ForecourtReleaseName
    StoreGposReleaseName        = $StoreGposReleaseName
    StoreOfficeReleaseName      = $StoreOfficeReleaseName
    UiAutomationReleaseName     = $UIAutomationReleaseName
    PaymentEmulatorReleaseName  = $PaymentEmulatorsReleaseName
}
Write-Host " "
Write-Host "=============================================== "
Write-Host $parameters
Write-Host " "
Write-Host "=============================================== "
& ".\run-setup-personal-lab-DifferentDomain.ps1" @parameters
