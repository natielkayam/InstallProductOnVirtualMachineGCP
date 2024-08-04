<#
.SYNOPSIS
    Script will deploy and configure POS1 level machine
.DESCRIPTION
    Script will deploy and configure POS1 level machine
#>

[CmdletBinding(HelpUri = 'https://github.com/ncr-swt-retail/emerald1', ConfirmImpact='Medium')]
PARAM (
    [Parameter(Mandatory = $true,
                Position = 1,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github user username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GithubUsername,

    [Parameter(Mandatory = $true,
                Position = 2,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github user Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GithubPAT,

    [Parameter(Mandatory = $true,
                Position = 3,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Name of target lab computer where is will be run. For example: LAB_ATU")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $LabName,

    [Parameter(Mandatory = $true,
                Position = 4,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Name of the test settings (.testsettings) file name")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TestSettingsFileName,

    # Please note that this is Base64 based string
    [Parameter(Mandatory = $true,
                Position = 5,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Actual tests that should run on this machine")]
    [string]
    $TestsBase64String,

    [Parameter(Mandatory = $true,
                Position = 6,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Address of remote computer. Eg: srraavc51.rwn.com")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerAddress,

    [Parameter(Mandatory = $true,
                Position = 7,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Username used for Powershell remoting to CCM computer")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerUsername,

    [Parameter(Mandatory = $true,
                Position = 8,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Password used for Powershell remoting to CCM computer")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerPass,

    # Please note that this parameter is BASE64 string
    [Parameter(Mandatory = $true,
                Position = 9,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Global configuration of application")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GlobalConfigurationBase64String,

    [Parameter(Mandatory = $true,
                Position = 10,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Name of release of UI Automation. For example: UI.Automation-f918cd1")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $UiAutomationReleaseName,

    [Parameter(Mandatory = $true,
                Position = 11,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Path to local folder where to copy TRX files at the end of execution")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TrxOutput,

    [Parameter(Mandatory = $true,
                Position = 12,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github release name of GPos Web Server installer. For example: GPosWebServer-14e39f6")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GPosWebServerReleaseName,

    [Parameter(Mandatory = $true,
                Position = 13,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github release name of POS Client installer. For example: POSClient-a34305c")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $POSClientReleaseName,

    [Parameter(Mandatory = $true,
                Position = 14,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Host address of STORE web server")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $StoreServerHost,

    [Parameter(Mandatory = $true,
                Position = 15,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github release name of Forecourt installer. For example: Forecourt-36f81af")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $ForecourtReleaseName,

    [Parameter(Mandatory = $true,
                Position = 16,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Name of release of Payment Emulators. For example: PaymentEmulators-e4c7df2")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PaymentEmulatorReleaseName,

    [Parameter(Mandatory = $true,
                Position = 17,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Name of release of R1Emulator. Currently it is released in GPosServer release. For example: PaymentEmulators-e4c7df2")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $R1EmulatorReleaseName
)

$startedTime = Get-Date

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Started script execution $(Get-Date -Format G)"

# Set ErrorAction variable to all command to 'Continue'
$ErrorActionPreference = "Continue"

$Tests = @()
$OrderedTests = @()

if ([string]::IsNullOrEmpty($TestsBase64String) -eq $false) {
    # Convert back serialized object
    $decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($TestsBase64String))
    $tmpStruct = $decoded | ConvertFrom-Json

    $tmpStruct.Tests | ForEach-Object {
        $ht2 = @{}
        $PSItem.psobject.properties | ForEach-Object { $ht2[$_.Name] = $_.Value }
        $Tests += $ht2
    }

    $tmpStruct.OrderTestFileName | ForEach-Object {
        $ht2 = @{}
        $PSItem.psobject.properties | ForEach-Object { $ht2[$_.Name] = $_.Value }
        $OrderedTests += $ht2
    }
}

$GlobalConfiguration = @{}

if ([string]::IsNullOrEmpty($GlobalConfigurationBase64String) -eq $false) {
    $decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($GlobalConfigurationBase64String))
    $GlobalConfiguration = $decoded | ConvertFrom-Json
}

$remoteDeploymentFolder = 'C:\Temp'

. "$($GlobalConfiguration.PathToUtilsFolder)\Open-RemoteSession.ps1"

$RemoteComputerCredentials = New-Object System.Management.Automation.PsCredential($RemoteComputerUsername, (ConvertTo-SecureString $RemoteComputerPass -AsPlainText -Force))

$sessionOutputsParams = Open-RemoteSession -RemoteComputerAddress $RemoteComputerAddress -RemoteComputerCredentials $RemoteComputerCredentials
$powershellSession = $sessionOutputsParams

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Created Remote Session to: $RemoteComputerAddress for user: $RemoteComputerUsername with password"

Invoke-Command -ErrorAction Stop -Session $powershellSession -ScriptBlock {

    if ((Test-Path -Path $using:remoteDeploymentFolder -PathType Container) -eq $false) {

        New-Item -Path $using:remoteDeploymentFolder -ItemType Directory -Force | Out-Null

        Write-Host "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Created target folder: $($using:remoteDeploymentFolder) on remote computer: $using:RemoteComputerAddress"
    } else {
        Write-Host "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Target folder: $($using:remoteDeploymentFolder) was already existing on remote computer: $using:RemoteComputerAddress"
    }

    Write-Host "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Target folder: $($using:remoteDeploymentFolder) Set access-rights to 'Everyone' on $($using:remoteDeploymentFolder) folder"
    Invoke-Expression "icacls.exe '$using:remoteDeploymentFolder' /grant Everyone:F /T"
    Write-Host "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Target folder: $($using:remoteDeploymentFolder) Done set access-rights to 'Everyone' on $($using:remoteDeploymentFolder) folder"
}

Copy-Item -Force -Recurse -ToSession $powershellSession -Path $PSScriptRoot\* -Destination $remoteDeploymentFolder
# & "robocopy.exe" $PSScriptRoot "\\$RemoteComputerAddress\C$\Temp"  /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1"             -Destination "$remoteDeploymentFolder\Download-File.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Download-File.ps1'                 /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\SystemEnvironment-Utils.ps1"   -Destination "$remoteDeploymentFolder\SystemEnvironment-Utils.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'SystemEnvironment-Utils.ps1'       /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-EnvironmentFile.ps1"     -Destination "$remoteDeploymentFolder\Parse-EnvironmentFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-EnvironmentFile.ps1'         /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-OrdertestsFile.ps1"      -Destination "$remoteDeploymentFolder\Parse-OrdertestsFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-OrdertestsFile.ps1'          /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-TestSettingsFile.ps1"    -Destination "$remoteDeploymentFolder\Parse-TestSettingsFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-TestSettingsFile.ps1'        /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\PSTools-v2.40.zip"             -Destination "$remoteDeploymentFolder\PSTools-v2.40.zip"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'PSTools-v2.40.zip'                 /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\RePackageTo-Payments.ps1"      -Destination "$remoteDeploymentFolder\RePackageTo-Payments.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'RePackageTo-Payments.ps1'          /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\RePackageTo-R1Emulator.ps1"    -Destination "$remoteDeploymentFolder\RePackageTo-R1Emulator.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'RePackageTo-R1Emulator.ps1'        /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Done copy scripts files from: $($GlobalConfiguration.PathToUtilsFolder) to remote computer: $RemoteComputerAddress"

# Path will be used to download artifacts from Github
$localDownloadFolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString("N"))

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Temporary download folder set to: $localDownloadFolder"

if ((Test-Path -Path $localDownloadFolder -PathType Container) -eq $true) {

    Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Removed temporary download folder because it was already exist"
}

New-Item -Path $localDownloadFolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Created temporary dowload folder: $localDownloadFolder"

$downloadArguments = @{
    GitHubUser      = $GithubUsername
    GitHubUserPersonalAccessToken = $GithubPAT
    RepoName        = $GlobalConfiguration.STSRepoName
    TargetFolder    = $localDownloadFolder
}

# Download GPOSWebServer installer and copy it to remote machine
# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Going to download file: $($GlobalConfiguration.GPosWebServerMSIFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.GPosWebServerMSIFileName
$downloadArguments.ReleaseTitle = $GPosWebServerReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.GPosWebServerMSIFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.GPosWebServerMSIFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.GPosWebServerMSIFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Copy downloaded file: $localDownloadFolder\$($GlobalConfiguration.GPosWebServerMSIFileName) to remote computer: $RemoteComputerAddress::$remoteDeploymentFolder"
# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.GPosWebServerMSIFileName)" -ErrorAction SilentlyContinue

# Download POS Client installer and copy it to remote machine
# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Going to download file: $($GlobalConfiguration.POSClientMSIFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.POSClientMSIFileName
$downloadArguments.ReleaseTitle = $POSClientReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.POSClientMSIFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.POSClientMSIFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.POSClientMSIFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Copy downloaded file: $localDownloadFolder\$($GlobalConfiguration.POSClientMSIFileName) to remote computer: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.POSClientMSIFileName)" -ErrorAction SilentlyContinue

# Download Forecourt installer and copy it to remote machine
# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Going to download file: $($GlobalConfiguration.ForecourtMSIFileName) from repo: $($GlobalConfiguration.STSRepoName) at release: $ForecourtReleaseName"
$downloadArguments.FileToDownload = $GlobalConfiguration.ForecourtMSIFileName
$downloadArguments.ReleaseTitle = $ForecourtReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.ForecourtMSIFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.ForecourtMSIFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.ForecourtMSIFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.ForecourtMSIFileName)" -ErrorAction SilentlyContinue

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Copy downloaded file: $localDownloadFolder\$($GlobalConfiguration.ForecourtMSIFileName) to remote computer: $RemoteComputerAddress::$remoteDeploymentFolder"

# Download tests file and copy it to remote machine
# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Going to download file: $($GlobalConfiguration.UIAutomationFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.UIAutomationFileName
$downloadArguments.ReleaseTitle = $UiAutomationReleaseName
$downloadArguments.RepoName = $GlobalConfiguration.STSRepoName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.UIAutomationFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.UIAutomationFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Copy downloaded file: $localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName) to remote computer: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName)" -ErrorAction SilentlyContinue

# Download Payment emulators file
# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Going to download file: $($GlobalConfiguration.PaymentEmulatorsFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.PaymentEmulatorsFileName
$downloadArguments.ReleaseTitle = $PaymentEmulatorReleaseName
$downloadArguments.RepoName = $GlobalConfiguration.STSRepoName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.PaymentEmulatorsFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.PaymentEmulatorsFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.PaymentEmulatorsFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Copy downloaded file: $localDownloadFolder\$($GlobalConfiguration.PaymentEmulatorsFileName) to remote computer: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.PaymentEmulatorsFileName)" -ErrorAction SilentlyContinue


# Download R1Emulator files
# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Going to download file: $($GlobalConfiguration.R1EmulatorFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.R1EmulatorFileName
$downloadArguments.ReleaseTitle = $R1EmulatorReleaseName
$downloadArguments.RepoName = $GlobalConfiguration.STSRepoName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.R1EmulatorFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.R1EmulatorFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.R1EmulatorFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Copy downloaded file: $localDownloadFolder\$($GlobalConfiguration.R1EmulatorFileName) to remote computer: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.R1EmulatorFileName)" -ErrorAction SilentlyContinue


# --------------------------------------------------------------------------------------------------------------------
Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Done copy all downloaded files to remote computer: $RemoteComputerAddress  to folder: $remoteDeploymentFolder"

#
# Delete the 'local download' folder
Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

Invoke-Command -ErrorAction Continue -Verbose -Session $powershellSession -ScriptBlock {

    $globalConfig = $using:GlobalConfiguration
    $currentLabName = $using:LabName
    $OrderedTestsArray = $using:OrderedTests

    $hostname = [System.Net.Dns]::GetHostName()
    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Current hostname is: $hostname"

    $mstestExe = 'C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\mstest.exe'
    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Path to MSTest.exe set to: $mstestExe"

    Set-Location $using:remoteDeploymentFolder

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Set current working folder to: $($using:remoteDeploymentFolder)"

    # Load to memory additional functions
    . .\SystemEnvironment-Utils.ps1

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Start extracting $($globalConfig.UIAutomationFileName) to $($using:remoteDeploymentFolder)"

    $performance = Measure-Command {
        # Extract UI Automation files
        # Usually it extracted to folder named \ui.automation
        Start-Process -Wait -NoNewWindow -FilePath 'tar.exe' -ArgumentList "-xvz", "-f $($globalConfig.UIAutomationFileName)", "-C $($using:remoteDeploymentFolder)"
    }

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done extracting $($globalConfig.UIAutomationFileName) to $($using:remoteDeploymentFolder). It tool: $( $performance.ToString() ) time"

    $gpdsimulatorFile = [System.IO.Path]::Combine( $($using:remoteDeploymentFolder), $($globalConfig.PaymentEmulatorsFileName) )

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to extract: $gpdsimulatorFile to: $($using:remoteDeploymentFolder)"

    $performance = Measure-Command {
        # Extract gpdsimulator.tar.gz
        # Usually it's extracted to \Payments folder
        Start-Process -Wait -NoNewWindow -FilePath 'tar.exe' -ArgumentList "-xvz", "-f $gpdsimulatorFile", "-C $($using:remoteDeploymentFolder)"
    }

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done to extract: $gpdsimulatorFile to: $($using:remoteDeploymentFolder) in $( $performance.ToString() ) time"

    $pathToCoinDispenserFolder = [System.IO.Path]::Combine( $($using:remoteDeploymentFolder), "Payments", "CoinDispenser" )
    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Path to CoinDispenser folder set to: $pathToCoinDispenserFolder"

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to repack $($globalConfig.PaymentEmulatorsFileName)"

    # Re-package PaymentEmulator for 'expected' MTX deployment
    .\RePackageTo-Payments.ps1 -PathToPaymentEmulatorReleaseFile $($globalConfig.PaymentEmulatorsFileName) -TargetFolder $using:remoteDeploymentFolder -OutputFileName $($globalConfig.PaymentEmulatorsFileNameAfterRepack)

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done to repack $($globalConfig.PaymentEmulatorsFileName) and save it to: $using:remoteDeploymentFolder"

    # Repackaged file name should be \GPDSimulator.zip as it created in .\RePackageTo-Payments.ps1 script
    $mtxFileLocation = [System.IO.Path]::Combine( $($using:remoteDeploymentFolder), $($globalConfig.PaymentEmulatorsFileNameAfterRepack) )
    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] MTX files location set to: $mtxFileLocation"

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to re-package $($globalConfig.R1EmulatorFileName)"

    # Re-package R1Emulator for 'expected' R1Emulator deployment
    .\RePackageTo-R1Emulator.ps1 -PathToR1EmulatorReleaseFile $($globalConfig.R1EmulatorFileName) -TargetFolder $using:remoteDeploymentFolder -OutputFileName $($globalConfig.R1EmulatorFileNameAfterRepack)

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done to re-package $($globalConfig.R1EmulatorFileName) and saved to folder: $using:remoteDeploymentFolder"

    $r1emulatorFileLocation = [System.IO.Path]::Combine( $($using:remoteDeploymentFolder), $($globalConfig.R1EmulatorFileNameAfterRepack) )

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] R1Emulator files location set to: $r1emulatorFileLocation"

    # Unzip PSTools
    $PSExecFolder = "$using:remoteDeploymentFolder\PSTools"
    if ((Test-Path -Path $PSExecFolder -PathType Container) -eq $false) {

        Expand-Archive "$using:remoteDeploymentFolder\PSTools-v2.40.zip" -DestinationPath $PSExecFolder

        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Extracted zip file: PSTools-v2.40.zip to folder: $PSExecFolder"
    } else {
        # Folder exist - may be it's already extracted ?
        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Folder: $PSExecFolder was already exist so zip file: PSTools-v2.40.zip was not extracted"
    }

    $labFolder = "$using:remoteDeploymentFolder\ui.automation\Labs\$currentLabName" | Resolve-Path

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] LAB folder set to: $labFolder"

    $testSettingFile = "$labFolder\$($using:TestSettingsFileName)" | Resolve-Path

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TestSettings file location set to: $testSettingFile"

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to parse TestSettings file: $testSettingFile"

    $fullPathToDllFiles = "$using:remoteDeploymentFolder\ui.automation" | Resolve-Path

    .\Parse-TestSettingsFile.ps1    -TestSettingFile $testSettingFile                       `
                                    -PathToMsiFolder $($using:remoteDeploymentFolder)       `
                                    -PathToLabFolder $labFolder                             `
                                    -PathToMtxFile $mtxFileLocation                         `
                                    -PathToR1EmulatorFile $r1emulatorFileLocation           `
                                    -PathToCoinDispenserFolder $pathToCoinDispenserFolder   `
                                    -PathToUiAutomationFolder $fullPathToDllFiles

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done parsing TestSettings file: $testSettingFile"

    # Currenty (25-June-2023) Environment.xml will be used at it is without modification with values hardcoded
    # .\Parse-EnvironmentFile.ps1 -PathToEnvironmentFile "$labFolder\Environment.xml" -PathToInstallersFolder "$($using:remoteDeploymentFolder)" -PathToLabFolder $labFolder

    # # DEBUG: Delete trx file if running multiple times on the same test
    # Remove-Item -Path $outputTrxFile -ErrorAction SilentlyContinue

    Set-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value ''

    # # Actually invoke installation as LocalSystem account on localhost
    # # Somehow invoking it as usual command with Invoke-Express or Start-Process did not succeeded - very strange error's was thrown
    # Write-Host "[Install-POS1.ps1] Raw command is:`tInvoke-Expression -Command `"$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt`""

    $performance = Measure-Command {

        $startDate = Get-Date -Format "HH:mm:ss"

        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Running test on lab: $currentLabName on host: $hostname started at: $startDate"

        try {
                # PSExec tutorial:  https://learn.microsoft.com/en-us/sysinternals/downloads/psexec
                #
                # 1. PSExec sometimes write to error stream but executes successfully: https://stackoverflow.com/a/22615314/1144952
                #    Actually the error is: C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\mstest.exe exited on SRRAALABATUCCM with error code 0.
                #    So here we redirect error stream to random file
                #    but to debug it - you need to remove the redirection
                # 2. In case you running PSExec directly you must use "-i <number>"" parameter but in case you running inside Start-Process you must remove this parameter
                #
                # # $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1  2>psexec.error.txt"

                $errorOccurred = $false

                $OrderedTestsArray | Where-Object { $errorOccurred -eq $false } | ForEach-Object{

                    $orderTestFile = "$using:remoteDeploymentFolder\ui.automation\$($PSItem.Filename)" | Resolve-Path

                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to run on OrderTest file: $orderTestFile"

                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to parse OrderTest file: $orderTestFile"

                    # Fix all paths in ordertests and testsettings file to local paths
                    .\Parse-OrdertestsFile.ps1 -PathToOrdertestFile $orderTestFile -PathToDllFiles $fullPathToDllFiles

                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done parsing $orderTestFile  file"

                    $outputTrxFile = [System.IO.Path]::GetFileName($orderTestFile)
                    $outputTrxFile = "$($using:remoteDeploymentFolder)\$currentLabName-POS1-$outputTrxFile.trx"

                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX file name set to: $outputTrxFile"

                    Add-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value $outputTrxFile

                    # DEBUG: Delete trx file if running multiple times on the same test
                    Remove-Item -Path $outputTrxFile -ErrorAction SilentlyContinue

                    $args1 = "`/testsettings:$testSettingFile `/resultsfile:$outputTrxFile `/testcontainer:$orderTestFile"

                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Command is: $PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt"  | Out-Default
                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Order file name: $orderTestFile"

                    $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt"  -ErrorAction Continue

                    $Error.Clear()

                    if ($Result -match 'RemoteException') {

                        $msg = "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder"
                        Write-Host $msg  | Out-Default

                    } elseif ($Result -match 'FullyQualifiedErrorId') {

                        # Other error occurred
                        $msg = "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder.`nAdditional information:`n$Result"
                        Write-Host $msg  | Out-Default
                    }

                    #
                    # Display TRX file summary
                    if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {

                        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Display TRX of $outputTrxFile"  | Out-Default

                        [xml] $trxFile = Get-Content -Path $outputTrxFile

                        $elem = $trxFile.TestRun.ResultSummary

                        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"  | Out-Default
                        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX: Additional data:"  | Out-Default

                        $elem.FirstChild.Attributes | ForEach-Object {
                            Write-Host "$($PSItem.Name)=$($PSItem.Value)"  | Out-Default
                        }

                        # If TRX global status is 'failed' then stop script execution
                        if ( $( $elem.Attributes[0].Value ) -eq 'Failed' ) {

                            $errorOccurred = $true

                            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1]  There was a failure in running of ordertest: $orderTestFile"

                        } else {
                            # all good
                            $errorOccurred = $false
                        }

                    } else {

                        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX file could not be found at: $outputTrxFile"  | Out-Default

                        $errorOccurred = $true
                    }

                }

                if ($errorOccurred -eq $false) {
                    # There was not errors in ordertest running
                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Starting to run actual tests"

                    $testsCollection = $using:Tests

                    if (($testsCollection -ne $null) -and ($testsCollection.Count -gt 0)) {

                        # There's some additional tests that should be run
                        $testsCollection | ForEach-Object {

                            $testDetails = [hashtable] $PSItem

                            $parts = $testDetails.Filename.Split(',')

                            $fileName = $parts[0]

                            $targetTestFileName = [System.IO.Path]::Combine($fullPathToDllFiles, $fileName)

                            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Test file is: $targetTestFileName"


                            $trxFileName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)

                            $trxFileName = "$trxFileName.trx"

                            $testTrxFileName = "$($using:remoteDeploymentFolder)\$currentLabName-POS1-$trxFileName"

                            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX file name was set to: $testTrxFileName"

                            Add-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value $testTrxFileName

                            $categoryName = $parts[1].Split(':')
                            $category = $categoryName[1].Trim()

                            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Test category is: $category"

                            $args2 = "`/testsettings:$testSettingFile `/resultsfile:$testTrxFileName `/testcontainer:$targetTestFileName"

                            if (($category -ne $null) -and ([string]::IsNullOrEmpty($category) -eq $false)) {
                                $args2 = "`/testsettings:$testSettingFile `/resultsfile:$testTrxFileName `/testcontainer:$targetTestFileName `/category:$category"
                            }

                            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Going to run test:`n$mstestExe  $args2"  | Out-Default
                            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Command is: $PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args2"  | Out-Default

                            $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args2 2>psexec.error.txt"  -ErrorAction Continue

                            $Error.Clear()

                            if ($Result -match 'RemoteException') {

                                $msg = "`n[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder"
                                Write-Host $msg  | Out-Default

                            } elseif ($Result -match 'FullyQualifiedErrorId') {

                                # Other error occurred
                                $msg = "`n[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder.`nAdditional information:`n$Result"
                                Write-Host $msg  | Out-Default
                            }

                            # Display TRX file summary
                            if ((Test-Path $testTrxFileName -PathType Leaf) -eq $true) {

                                Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Display TRX of $outputTrxFile"  | Out-Default

                                [xml] $trxFile = Get-Content -Path $testTrxFileName

                                $elem = $trxFile.TestRun.ResultSummary

                                Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"  | Out-Default
                                Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX: Additional data:"  | Out-Default

                                $elem.FirstChild.Attributes | ForEach-Object {

                                    Write-Host "$($PSItem.Name)=$($PSItem.Value)"  | Out-Default
                                }
                            } else {

                                Write-Host "`n[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] TRX file could not be found at: $testTrxFileName"  | Out-Default
                            }
                        }

                        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done running all tests in collection"

                    } else {
                        # No additional tests
                        Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] No actual tests was found. Noting to do"  | Out-Default
                    }
                } else {
                    # Error occurred - do not proceed with additional tests
                    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Did not run tests because of failure before that"
                }

        } catch {
            $msg = "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Exception occurred while trying run installation tests!`nAdditional details:`n$PSItem"
            Write-Host $msg  | Out-Default
            # throw $msg

            $msg = $PSItem | Out-String

            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] (catch) Error is: $msg"
        }

        if ($error.Count -ne 0) {

            $errMessage = $error[0] | Out-String

            $msg = "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Exception occurred while trying run installation tests!`nAdditional details:`n$errMessage"

            Write-Host $msg  | Out-Default
            # throw $msg

            Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] (logic) Error is: $($Error.Exception.ToString())"
        }
    }

    Write-Host "`n[$currentLabName::$hostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-POS1.ps1] Done running test in: $( $performance.ToString() ) time`n`n"  | Out-Default
}

#
# Delete the 'local download' folder
# Sometimes folder is busy so we try to delete it here again anyway even if it was deleted before
Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

$tmpName = [System.IO.Path]::GetTempFileName()

Copy-Item -FromSession $powershellSession -Path "$remoteDeploymentFolder\trx-file-name.txt" -Destination $tmpName

$trxFiles = Get-Content -Path $tmpName

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Log files that should be collected/copy locally: $trxFiles"

$trxFiles | ForEach-Object {

    if ([String]::IsNullOrEmpty($PSItem) -eq $false) {

        $localFile = $PSItem.Trim()

        $destinationFile = [System.IO.Path]::Combine( $TrxOutput,  $( [System.IO.Path]::GetFileName($localFile)))

        Copy-Item -FromSession $powershellSession -Path $localFile -Destination $destinationFile

        # # I hope that TRX files will be in at remote computer at folder C:\Temp
        # & "robocopy.exe" "\\$RemoteComputerAddress\C$\Temp"  $TrxOutput  $localFile   /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

        Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] TRX file $( [System.IO.Path]::GetFileName($localFile) ) copy locally to $destinationFile"
    } else {
        # There's an empty line in file
    }
}

Remove-Item -Path $tmpName -Force -ErrorAction SilentlyContinue

Write-Host "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-POS1.ps1] Done deploy process at: $(Get-Date -Format G)"