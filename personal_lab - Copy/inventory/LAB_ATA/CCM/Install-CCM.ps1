<#
.SYNOPSIS
    Script will deploy and configure CCM level machine
.DESCRIPTION
    Script will deploy and configure CCM level machine
#>

[CmdletBinding(HelpUri = 'https://github.com/ncr-swt-retail/emerald1', ConfirmImpact='Medium')]
PARAM (
    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
                HelpMessage = "Github user username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GithubUsername,

    [Parameter(Mandatory = $true, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github user Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GithubPAT,

    [Parameter(Mandatory = $true, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of target lab computer where is will be run. For example: LAB_ATU")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $LabName,

    [Parameter(Mandatory = $true, Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
            HelpMessage = "Name of the test settings (.testsettings) file name")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TestSettingsFileName,

    # Please note that this is Base64 based string
    [Parameter(Mandatory = $false, Position = 5, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Actual tests that should run on this machine")]
    [string]
    $TestsBase64String,

    [Parameter(Mandatory = $true, Position = 6, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Address of remote computer. Eg: srraavc51.rwn.com")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerAddress,

    [Parameter(Mandatory = $true, Position = 7, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Username used for Powershell remoting to CCM computer")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerUsername,

    [Parameter(Mandatory = $true, Position = 8, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Password used for Powershell remoting to CCM computer")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerPass,

    # Please note that this parameter is BASE64 string
    [Parameter(Mandatory = $true, Position = 9, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Global configuration of application")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GlobalConfigurationBase64String,

    [Parameter(Mandatory = $true, Position = 10, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of UI Automation. For example: UI.Automation-f918cd1")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $UiAutomationReleaseName,

    [Parameter(Mandatory = $true, Position = 11, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Path to local folder where to copy TRX files at the end of execution")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TrxOutput,

    [Parameter(Mandatory = $true, Position = 12, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of CCM GposWebServer installer. For example: CCM-GPosWebServer-e969ef6")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $CCMGposReleaseName,

    [Parameter(Mandatory = $true, Position = 13, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of CCM Office installer. For example: CCM-Office-Client-ae2b7da")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $CCMOfficeReleaseName
)

# Mark start tim of the script. All calculation will be done relative to this time
$startedTime = Get-Date
Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Started script execution $(Get-Date -Format G)"

# Set ErrorAction variable to all command to 'Continue'
$ErrorActionPreference = "Continue"

#
# De-serialize some parameters
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

#
# De-serialize some parameters
$GlobalConfiguration = @{}

if ([string]::IsNullOrEmpty($GlobalConfigurationBase64String) -eq $false) {
    $decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($GlobalConfigurationBase64String))
    $GlobalConfiguration = $decoded | ConvertFrom-Json
}


# Load script for remote connection
. "$($GlobalConfiguration.PathToUtilsFolder)\Open-RemoteSession.ps1"

# Create credentials to connect with
$RemoteComputerCredentials = New-Object System.Management.Automation.PsCredential($RemoteComputerUsername, (ConvertTo-SecureString $RemoteComputerPass -AsPlainText -Force))

# Connect to remote computer
$sessionOutputsParams = Open-RemoteSession -RemoteComputerAddress $RemoteComputerAddress -RemoteComputerCredentials $RemoteComputerCredentials
$powershellSession = $sessionOutputsParams

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Remote Session object created for: $RemoteComputerAddress with username: $RemoteComputerUsername and password"

# All files on remote computer will be saved into this folder
$remoteDeploymentFolder = 'C:\Temp'

# Create folder on remote computer if it does not exist
Invoke-Command -ErrorAction Stop -Session $powershellSession -ScriptBlock {

    if ((Test-Path -Path $using:remoteDeploymentFolder -PathType Container) -eq $false) {

        New-Item -Path $using:remoteDeploymentFolder -ItemType Directory -Force | Out-Null

        Write-Output "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Target folder: $($using:remoteDeploymentFolder) created on remote machine: $using:RemoteComputerAddress"
    } else {
        Write-Output "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Target folder: $($using:remoteDeploymentFolder) was already exist at remote machine: $using:RemoteComputerAddress"
    }

    Write-Output "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Target folder: $($using:remoteDeploymentFolder) Set access-rights to 'Everyone' on $($using:remoteDeploymentFolder) folder"
    Invoke-Expression "icacls.exe '$using:remoteDeploymentFolder' /grant Everyone:F /T"
    Write-Output "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Target folder: $($using:remoteDeploymentFolder) Done set access-rights to 'Everyone' on $($using:remoteDeploymentFolder) folder"
}

# Copy all script files to remote computer
Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$PSScriptRoot\*" -Destination $remoteDeploymentFolder
# & "robocopy.exe" $PSScriptRoot "\\$RemoteComputerAddress\C$\Temp" /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

# & "Robocopy.exe" $PSScriptRoot "\\$RemoteComputerAddress\C$\Temp"  global.deployment.2023-07-19T16-15-49.1412.log /ZB /MT:8 /R:4 /W:5 /NP /LOG+:copy.to-SRRAALABATDHQ.rwn.com.log

# Robocopy is a folder-copy app
# So - to define a single file you should use this form:
# robocopy.exe   C:\source\folder  E:\destination\folder  file1.txt  <other paramneters>

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1"             -Destination "$remoteDeploymentFolder\Download-File.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Download-File.ps1'             /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\SystemEnvironment-Utils.ps1"   -Destination "$remoteDeploymentFolder\SystemEnvironment-Utils.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-EnvironmentFile.ps1'     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-EnvironmentFile.ps1"     -Destination "$remoteDeploymentFolder\Parse-EnvironmentFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-EnvironmentFile.ps1'     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-OrdertestsFile.ps1"      -Destination "$remoteDeploymentFolder\Parse-OrdertestsFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-OrdertestsFile.ps1'      /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-TestSettingsFile.ps1"    -Destination "$remoteDeploymentFolder\Parse-TestSettingsFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-TestSettingsFile.ps1'     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\PSTools-v2.40.zip"             -Destination "$remoteDeploymentFolder\PSTools-v2.40.zip"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'PSTools-v2.40.zip'             /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Done copy files from $($GlobalConfiguration.PathToUtilsFolder) to target folder: $RemoteComputerAddress::$remoteDeploymentFolder"

# Create folder locally to download files into it
$localDownloadFolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString("N"))

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Local temporary folder set to: $localDownloadFolder"

# Remove this folder if it exist
if ((Test-Path -Path $localDownloadFolder -PathType Container) -eq $true) {

    Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

    Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Local temporary folder at: $localDownloadFolder  was already exist - so deleted"
}

# Create this folder if it does not exist
New-Item -Path $localDownloadFolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Local temporary folder at: $localDownloadFolder created"

# Prepare popular arguments for next commands
$downloadArguments = @{
    GitHubUser = $GithubUsername
    GitHubUserPersonalAccessToken = $GithubPAT
    RepoName = $GlobalConfiguration.CCMRepoName
    TargetFolder = $localDownloadFolder
}

# Download CCM GPOS installer
# ---------------------------------------------------------------------------------------------------------------------------------------------
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Going to download file: $($GlobalConfiguration.CCMServerMSIFileName) from repo: $($GlobalConfiguration.CCMRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.CCMServerMSIFileName
$downloadArguments.ReleaseTitle = $CCMGposReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.CCMServerMSIFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.CCMServerMSIFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.CCMServerMSIFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Downloaded file: $localDownloadFolder\$($GlobalConfiguration.CCMServerMSIFileName) copy to destination: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.CCMServerMSIFileName)" -ErrorAction SilentlyContinue

# Download Office Client installer
# ---------------------------------------------------------------------------------------------------------------------------------------------
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Going to download file: $($GlobalConfiguration.CCMOfficeMSIFileName) from repo: $($GlobalConfiguration.CCMRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.CCMOfficeMSIFileName
$downloadArguments.ReleaseTitle = $CCMOfficeReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.CCMOfficeMSIFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.CCMOfficeMSIFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.CCMOfficeMSIFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Downloaded file: $localDownloadFolder\$($GlobalConfiguration.CCMOfficeMSIFileName) copy to destination: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.CCMOfficeMSIFileName)" -ErrorAction SilentlyContinue

# Download 'UI Automation' package
# ---------------------------------------------------------------------------------------------------------------------------------------------
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Going to download file: $($GlobalConfiguration.UIAutomationFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.UIAutomationFileName
$downloadArguments.ReleaseTitle = $UiAutomationReleaseName
$downloadArguments.RepoName = $GlobalConfiguration.STSRepoName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

# Copy it to remote computer
Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.UIAutomationFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.UIAutomationFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Write-Output "`n[$LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Downloaded file: $localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName) copy to destination: $RemoteComputerAddress::$remoteDeploymentFolder"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName)" -ErrorAction SilentlyContinue

# ---------------------------------------------------------------------------------------------------------------------------------------------
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Done copy all downloaded files to remote computer: $RemoteComputerAddress   to folder: $remoteDeploymentFolder`n"

#
# Delete the 'local download' folder
Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Local temporary folder at: $localDownloadFolder was deleted"

# Run command on remote computer
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Starting to run script on remote computer: $RemoteComputerAddress"

Invoke-Command -ErrorAction Continue -Session $powershellSession -ScriptBlock {

    # Add this variable into the scope
    $globalConfig = $using:GlobalConfiguration
    $currentLabName = $using:LabName
    $OrderedTestsArray = $using:OrderedTests

    # Remote computer host name
    $currentComputerHostname = [System.Net.Dns]::GetHostName()
    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] This computer hostname detected as: $currentComputerHostname"

    # Switch to default location
    Set-Location $using:remoteDeploymentFolder

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Set current folder to: $($using:remoteDeploymentFolder)"

    # Load some functions from script
    . .\SystemEnvironment-Utils.ps1

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Starting to extract: $($globalConfig.UIAutomationFileName) from: $(Get-Location)"

    $performance = Measure-Command {
        # Extract files
        # Usually it extracted to folder named \ui.automation
        Start-Process -Wait -NoNewWindow -FilePath 'tar.exe' -ArgumentList "-xvz", "-f $($globalConfig.UIAutomationFileName)", "-C $($using:remoteDeploymentFolder)"
    }

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Done extracting from: $($globalConfig.UIAutomationFileName) to $($using:remoteDeploymentFolder) in $( $performance.ToString() ) total time"

    # Unzip PSTools
    $PSExecFolder = "$using:remoteDeploymentFolder\PSTools"
    if ((Test-Path -Path $PSExecFolder -PathType Container) -eq $false) {

        Expand-Archive "$using:remoteDeploymentFolder\PSTools-v2.40.zip" -DestinationPath $PSExecFolder

        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] $($using:remoteDeploymentFolder)\PSTools-v2.40.zip extracted to: $PSExecFolder"
    } else {
        # Folder exist - may be it's already extracted ?
        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Folder: $PSExecFolder is alredy exist so zip file won't be extracted"
    }

    # Start tests that install applications
    # mstest /testsettings:.\ui.automation\Labs\LAB_ATU\SRRAALABATUCCM.testsettings /resultsfile:CCM.trx /testcontainer:.\ui.automation\StoreSolution\CCM.orderedtest

    # Full path to MSTest.exe file that will run the tests
    $mstestExe = 'C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\mstest.exe'
    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Path to MSTest.exe set to: $mstestExe"

    # Full path to \Labs folder
    $labFolder = "$($using:remoteDeploymentFolder)\ui.automation\Labs\$currentLabName" | Resolve-Path
    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Path to LAB folder set to: $labFolder"

    # Full path to testsettings file
    $testSettingFile = "$labFolder\$($using:TestSettingsFileName)" | Resolve-Path
    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Path to .testSettings file set to: $testSettingFile"

    # Full path to folder where UI Automation files located
    $fullPathToDllFiles = "$($using:remoteDeploymentFolder)\ui.automation" | Resolve-Path
    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Path to \ui.automation folder set to: $fullPathToDllFiles"

    # Full path to TRX file that will be created
    $outputTrxFile = "$($using:remoteDeploymentFolder)\$currentLabName-CCM.trx"

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX file name set to: $outputTrxFile"

    # Remove TRX file because MSTest could not run if it exist
    Remove-Item -Path $outputTrxFile -ErrorAction SilentlyContinue

    # Add TRX file name to 'trx-file-name.txt' so it could be pulled later on to local computer
    Set-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value $outputTrxFile

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Start parsing file at: $testSettingFile"

    .\Parse-TestSettingsFile.ps1 -TestSettingFile $testSettingFile -PathToMsiFolder $($using:remoteDeploymentFolder) -PathToLabFolder $labFolder -PathToUiAutomationFolder $fullPathToDllFiles

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Done parsing file at: $testSettingFile"

    # Currently (25-June-2023) the environment.xml won't be changed because not needed
    # It will be used with hardcoded values
    # .\Parse-EnvironmentFile.ps1 -PathToEnvironmentFile "$labFolder\Environment.xml" -PathToInstallersFolder "$($using:remoteDeploymentFolder)" -PathToLabFolder $labFolder

    # # Actually invoke installation as LocalSystem account on localhost
    # # Somehow invoking it as usual command with Invoke-Express or Start-Process did not succeeded - very strange error's was thrown
    # Write-Output "`n[Install-CCM.ps1] Raw command is:`tInvoke-Expression -Command `"$PSExecFolder\PsExec.exe \\$currentComputerHostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt `" "

    # Measure this command execution runtime
    $performance = Measure-Command {

        $startDate = Get-Date -Format "HH:mm:ss"
        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Running test on lab: $currentLabName on host: $currentComputerHostname started at: $startDate"

        try {
                $errorOccurred = $false

                #
                # Running OrderTest files
                # ---------------------------------------------------------------------------------------------------------------------------------------
                $OrderedTestsArray | Where-Object { $errorOccurred -eq $false } | ForEach-Object {

                    $orderTestFile = "$($using:remoteDeploymentFolder)\ui.automation\$($PSItem.Filename)" | Resolve-Path

                    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Starting to work on OrderTest file: $orderTestFile"

                    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Starting to parse OrderTest file at: $orderTestFile"
                    # Fix path's in configuration files
                    .\Parse-OrdertestsFile.ps1 -PathToOrdertestFile $orderTestFile -PathToDllFiles $fullPathToDllFiles

                    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Done parsing OrderTest file at: $orderTestFile"

                    # Arguments to pass to MSTest.exe
                    $args1 = "`/testsettings:$testSettingFile `/resultsfile:$outputTrxFile `/testcontainer:$orderTestFile"

                    # PSExec tutorial:  https://learn.microsoft.com/en-us/sysinternals/downloads/psexec
                    #
                    # 1. PSExec sometimes write to error stream but executes successfully: https://stackoverflow.com/a/22615314/1144952
                    #    Actually the error is: C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\mstest.exe exited on SRRAALABATUCCM with error code 0.
                    #    So here we redirect error stream to random file
                    #    but to debug it - you need to remove the redirection
                    # 2. In case you running PSExec directly you must use "-i <number>"" parameter but in case you running inside Start-Process you must remove this parameter
                    #
                    # # $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$currentComputerHostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1  2>psexec.error.txt"

                    # Actually run the MSTest.exe with parameters with SYSTEM privileges
                    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] (1) Command is: $PSExecFolder\PsExec.exe \\$currentComputerHostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt" | Out-Default

                    $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$currentComputerHostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt"  -ErrorAction Continue

                    $Error.Clear()

                    # Try to detect if error occurred
                    # Do not throw because we must read TRX file output anyway !
                    if ($Result -match 'RemoteException') {
                        # $errorOccurred = $true

                        $msg = "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred in remote session ! Please check the logs on $currentComputerHostname  at $using:remoteDeploymentFolder"
                        Write-Output $msg | Out-Default

                    } elseif ($Result -match 'FullyQualifiedErrorId') {
                        # $errorOccurred = $true

                        # Other error occurred
                        $msg = "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred in remote session ! Please check the logs on $currentComputerHostname  at $using:remoteDeploymentFolder.`nAdditional information:`n$Result"
                        Write-Output $msg | Out-Default
                    }

                    # # # $proc = Start-Process -PassThru -FilePath "$PSExecFolder\PsExec.exe"                `
                    # # #                 -ArgumentList   "-accepteula",                                      `
                    # # #                                 "-s",                                               `
                    # # #                                 "-i 1",                                             `
                    # # #                                 "-w `"$using:remoteDeploymentFolder`"",             `
                    # # #                                 "`"$mstestExe`" $args1"                             `
                    # # #                 -RedirectStandardOutput $outFileName                                `
                    # # #                 -RedirectStandardError  $errorFileName

                    # # # while($proc.HasExited -eq $false) {
                    # # #     Write-Output "[Install-CCM.ps1] Process mstest.exe is still running"
                    # # #     Start-Sleep -Seconds 10
                    # # # }

                    # # # #
                    # # # # Correct exit text example:    C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\mstest.exe exited on SRRAALABATUCCM with error code 0.
                    # # # # Somehow even the correct exit code 0 is still written to error stream - so we read it from there
                    # # # $result = Get-Content -Path $errorFileName | Select-String -Pattern 'mstest.exe exited on ' | Select-Object -Last 1

                    # # # if ($result -like '*error code 0*') {
                    # # #     # Success - no error
                    # # #     Write-Output "[Install-CCM.ps1] MSTest process finished successfully. Output is:"
                    # # #     Write-Output $( Get-Content $outFileName -Raw)
                    # # #     Write-Output "`n"
                    # # # } else {
                    # # #     # The string is:  'error code <whatever>' - so it finish with error

                    # # #     $errorOccurred = $true

                    # # #     $msg = "[Install-CCM.ps1] Error occurred in remote session ! Please check the logs on $currentComputerHostname  at $using:remoteDeploymentFolder"
                    # # #     $msg += "`n`nError is:"
                    # # #     $msg += $( $(Get-Content $errorFileName) -join "`n" )
                    # # #     $msg += "`n`nMSTest output is:"
                    # # #     $msg += $( $(Get-Content $outFileName) -join "`n" )

                    # # #     Write-Output $msg    # This is not terminating error - won't be thrown from here
                    # # # }

                    # Finished first part --------------------------------------

                    #
                    # Display TRX file summary
                    if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {

                        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Display TRX of $outputTrxFile" | Out-Default

                        [xml] $trxFile = Get-Content -Path $outputTrxFile

                        $elem = $trxFile.TestRun.ResultSummary

                        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )" | Out-Default
                        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX: Additional data:" | Out-Default
                        $elem.FirstChild.Attributes | ForEach-Object {
                            Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                        }

                        # If TRX global status is 'failed' then stop script execution
                        if ( $( $elem.Attributes[0].Value ) -eq 'Failed' ) {
                            $errorOccurred = $true

                            Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred while running OrderTest file: $orderTestFile"
                        }

                    } else {
                        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX file could not be found at: $outputTrxFile" | Out-Default

                        $errorOccurred = $true

                        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred while running OrderTest file: $orderTestFile"
                    }
                }

                #
                # Running actual tests
                # ---------------------------------------------------------------------------------------------------------------------------------------

                # In case error occurred above this line there's no point to continue running
                if ($errorOccurred -eq $false) {

                    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Going to run actual tests"

                    $actualTests = $using:Tests

                    if (($actualTests -ne $null) -and ($actualTests.Count -gt 0)) {

                        # There's some additional tests that should be run
                        $actualTests | ForEach-Object {

                            # Read additional test item from parameter
                            $testDetails = [hashtable] $_


                            # Additional test record look like this:
                            # {Filename = 'Ncr.UIAutomation.Office1.dll'; Category = '!TestDefaultConfiguration'}
                            #
                            # 'Category' parameter could be empty

                            $targetTestFileName = [System.IO.Path]::Combine($fullPathToDllFiles, $($testDetails.Filename))

                            # Create TRX file path for this test
                            $testTrxFileName = "$( [System.IO.Path]::GetFileNameWithoutExtension($targetTestFileName) ).trx"
                            $testTrxFileName = "$($using:remoteDeploymentFolder)\$currentLabName-CCM-$testTrxFileName"

                            # Add this path to trx-file-name.txt file so later on it could be pulled to local computer
                            Add-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value $testTrxFileName

                            # Create parameters for MSTest.exe execution
                            $category = $testDetails.Category
                            $args2 = "`/testsettings:$testSettingFile `/resultsfile:$testTrxFileName `/testcontainer:$targetTestFileName"

                            if (($category -ne $null) -and ([string]::IsNullOrEmpty($category) -eq $false)) {
                                $args2 = "`/testsettings:$testSettingFile `/resultsfile:$testTrxFileName `/testcontainer:$targetTestFileName `/category:$category"
                            }

                            Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Going to run test:`n$mstestExe  $args2" | Out-Default

                            # Actually run the MSTest.exe with parameters
                            Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] (3) Command is: $PSExecFolder\PsExec.exe \\$currentComputerHostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args2" | Out-Default
                            $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$currentComputerHostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args2"  -ErrorAction Continue

                            $Error.Clear()

                            # Try to detect if error occurred
                            # Do not throw because we must read TRX file output anyway !
                            if ($Result -match 'RemoteException') {

                                $msg = "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred in remote session ! Please check the logs on $currentComputerHostname  at $using:remoteDeploymentFolder"
                                Write-Output $msg | Out-Default
                                # throw $msg

                            } elseif ($Result -match 'FullyQualifiedErrorId') {

                                # Other error occurred
                                $msg = "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred in remote session ! Please check the logs on $currentComputerHostname  at $using:remoteDeploymentFolder.`nAdditional information:`n$Result"
                                Write-Output $msg | Out-Default
                            }

                            # Display TRX file summary
                            if ((Test-Path $testTrxFileName -PathType Leaf) -eq $true) {
                                [xml] $trxFile = Get-Content -Path $testTrxFileName

                                $elem = $trxFile.TestRun.ResultSummary

                                Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )" | Out-Default
                                Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX: Additional data:" | Out-Default
                                $elem.FirstChild.Attributes | ForEach-Object {
                                    Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                                }
                            } else {
                                Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] TRX file could not be found at: $testTrxFileName" | Out-Default
                            }
                        }
                    } else {
                        # No additional tests - so noting to do anymore
                        Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] No additional tests was found. Nothing to do" | Out-Default
                    }
                } else {
                    # Error occurred - do not proceed with additional tests
                    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Error occurred in processing OrderTest files - could not run actual tests now"
                }

            } catch {
                $msg = "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Exception occurred while trying run installation tests!`nAdditional details:`n$PSItem"
                Write-Output $msg | Out-Default
                # throw $msg
            }
    }

    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-CCM.ps1] Done running all in: $($performance.TotalMinutes) minutes`n`n" | Out-Default
}

Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Done running script on remote computer: $RemoteComputerAddress. Now running on $($env:COMPUTERNAME)"

#
# Delete the 'local download' folder
# Sometimes folder is busy so we try to delete it here again anyway even if it was deleted before
Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Try to copy TRX and log files" | Out-Default

#
# Try to copy all the files listed in trx-file-name.txt file to local computer
$tmpName = [System.IO.Path]::GetTempFileName()

Copy-Item -FromSession $powershellSession -Path "$remoteDeploymentFolder\trx-file-name.txt" -Destination $tmpName

$trxFiles = Get-Content -Path $tmpName

Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Log files that should be collected/copy locally: $trxFiles"

$trxFiles | ForEach-Object {

    if ([string]::IsNullOrEmpty($PSItem) -eq $false) {

        $localFile = $PSItem.Trim()

        $destinationFile = [System.IO.Path]::Combine( $TrxOutput,  $( [System.IO.Path]::GetFileName($localFile) ) )

        Copy-Item -FromSession $powershellSession -Path $localFile -Destination $destinationFile

        # # I hope that TRX files will be in at remote computer at folder C:\Temp
        # & "robocopy.exe" "\\$RemoteComputerAddress\C$\Temp"  $TrxOutput  $localFile   /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

        Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] TRX file $( [System.IO.Path]::GetFileName($localFile) ) copy locally to $destinationFile"
    } else {
        # There's an empty line in file
    }
}
Remove-Item -Path $tmpName -Force -ErrorAction SilentlyContinue

Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-CCM.ps1] Done deploy process at: $(Get-Date -Format G)"