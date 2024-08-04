<#
.SYNOPSIS
    Script will deploy and configure STORE level machine
.DESCRIPTION
    Script will deploy and configure STORE level machine
#>

[CmdletBinding(HelpUri = 'https://github.com/ncr-swt-retail/emerald1', ConfirmImpact='Medium')]
PARAM (
    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
                HelpMessage = "Github user username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GithubUsername,

    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github user Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GithubPAT,

    [Parameter(Mandatory = $true, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of target lab computer where is will be run. For example: LAB_ATU")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $LabName,

    [Parameter(Mandatory = $true, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of the test settings (.testsettings) file name")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TestSettingsFileName,

    # Please note that this is Base64 based string
    [Parameter(Mandatory = $false, Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Actual tests that should run on this machine")]
    [string]
    $TestsBase64String,

    [Parameter(Mandatory = $true, Position = 5, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Address of remote computer. Eg: srraavc51.rwn.com")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerAddress,

    [Parameter(Mandatory = $true, Position = 6, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Username used for Powershell remoting to CCM computer")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerUsername,

    [Parameter(Mandatory = $true, Position = 7, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Password used for Powershell remoting to CCM computer")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemoteComputerPass,

    # Please note that this parameter is BASE64 string
    [Parameter(Mandatory = $true, Position = 8, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Global configuration of application")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GlobalConfigurationBase64String,

    [Parameter(Mandatory = $true, Position = 9, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of UI Automation. For example: UI.Automation-f918cd1")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $UiAutomationReleaseName,

    [Parameter(Mandatory = $true, Position = 10, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Path to local folder where to copy TRX files at the end of execution")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TrxOutput,

    [Parameter(Mandatory = $true, Position = 11, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of GposWebServer installer. For example: GPosWebServer-e969ef6")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $StoreGposReleaseName,

    [Parameter(Mandatory = $true, Position = 12, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of Office installer. For example: Office-ae2b7da")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $StoreOfficeReleaseName,

    [Parameter(Mandatory = $true, Position = 13, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Address of CCM server")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $CCMServerAddress
)

$startedTime = Get-Date

Write-Output "[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] Started script execution $(Get-Date -Format G)"

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

# All files on remote computer will be saved into this folder
$remoteDeploymentFolder = 'C:\Temp'

# Create folder on remote computer if it does not exist
Invoke-Command -ErrorAction Stop -Session $powershellSession -ScriptBlock {
    if ((Test-Path -Path $using:remoteDeploymentFolder -PathType Container) -eq $false) {
        New-Item -Path $using:remoteDeploymentFolder -ItemType Directory -Force | Out-Null
    }

    Write-Output "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Target folder: $($using:remoteDeploymentFolder) Set access-rights to 'Everyone' on $($using:remoteDeploymentFolder) folder"
    Invoke-Expression "icacls.exe '$using:remoteDeploymentFolder' /grant Everyone:F /T"
    Write-Output "`n[$using:LabName::$($env:COMPUTERNAME)] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Target folder: $($using:remoteDeploymentFolder) Done set access-rights to 'Everyone' on $($using:remoteDeploymentFolder) folder"
}

# Copy all script files to remote computer
Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$PSScriptRoot\*" -Destination $remoteDeploymentFolder
# & "robocopy.exe" $PSScriptRoot "\\$RemoteComputerAddress\C$\Temp"  /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" -Destination "$remoteDeploymentFolder\Download-File.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Download-File.ps1'                 /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\SystemEnvironment-Utils.ps1" -Destination "$remoteDeploymentFolder\SystemEnvironment-Utils.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'SystemEnvironment-Utils.ps1'       /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-EnvironmentFile.ps1" -Destination "$remoteDeploymentFolder\Parse-EnvironmentFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-EnvironmentFile.ps1'         /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-OrdertestsFile.ps1" -Destination "$remoteDeploymentFolder\Parse-OrdertestsFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-OrdertestsFile.ps1'          /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\Parse-TestSettingsFile.ps1" -Destination "$remoteDeploymentFolder\Parse-TestSettingsFile.ps1"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'Parse-TestSettingsFile.ps1'        /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

Copy-Item -Force -Recurse -ToSession $powershellSession -Path "$($GlobalConfiguration.PathToUtilsFolder)\PSTools-v2.40.zip" -Destination "$remoteDeploymentFolder\PSTools-v2.40.zip"
# & "robocopy.exe" $($GlobalConfiguration.PathToUtilsFolder) "\\$RemoteComputerAddress\C$\Temp"   'PSTools-v2.40.zip'                 /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

# Create folder locally to download files into it
$localDownloadFolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString("N"))

# Remove this folder if it exist
if ((Test-Path -Path $localDownloadFolder -PathType Container) -eq $true) {
    Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue
}

# Create this folder if it does not exist
New-Item -Path $localDownloadFolder -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# Prepare popular arguments for next commands
$downloadArguments = @{
    GitHubUser = $GithubUsername
    GitHubUserPersonalAccessToken = $GithubPAT
    RepoName = $GlobalConfiguration.STSRepoName
    TargetFolder = $localDownloadFolder
}

# Download GPOS installer
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))]  [Install-Store.ps1] Going to download file: $($GlobalConfiguration.StoreGPosWebServerMSIFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.StoreGPosWebServerMSIFileName
$downloadArguments.ReleaseTitle = $StoreGposReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.StoreGPosWebServerMSIFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.StoreGPosWebServerMSIFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.StoreGPosWebServerMSIFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.StoreOfficeMSIName)" -ErrorAction SilentlyContinue


# Download Office installer
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] Going to download file: $($GlobalConfiguration.StoreOfficeMSIName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.StoreOfficeMSIName
$downloadArguments.ReleaseTitle = $StoreOfficeReleaseName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.StoreOfficeMSIName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.StoreOfficeMSIName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.StoreOfficeMSIName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.StoreOfficeMSIName)" -ErrorAction SilentlyContinue

# Download 'UI Automation' package
Write-Output "`n[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] Going to download file: $($GlobalConfiguration.UIAutomationFileName) from repo: $($GlobalConfiguration.STSRepoName)"
$downloadArguments.FileToDownload = $GlobalConfiguration.UIAutomationFileName
$downloadArguments.ReleaseTitle = $UiAutomationReleaseName
$downloadArguments.RepoName = $GlobalConfiguration.STSRepoName
& "$($GlobalConfiguration.PathToUtilsFolder)\Download-File.ps1" @downloadArguments

Copy-Item -Force -ToSession $powershellSession -Path "$localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName)" -Destination "$remoteDeploymentFolder\$($GlobalConfiguration.UIAutomationFileName)"
# & "robocopy.exe" $localDownloadFolder "\\$RemoteComputerAddress\C$\Temp"   $($GlobalConfiguration.UIAutomationFileName)     /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

# Delete this file locally
Remove-Item -Force -Path "$localDownloadFolder\$($GlobalConfiguration.UIAutomationFileName)" -ErrorAction SilentlyContinue

Write-Output "[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] Done copy all scripts to remote computer: $RemoteComputerAddress    to folder: $remoteDeploymentFolder"

# Delete the folder
Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

# Run command on remote computer
Invoke-Command -ErrorAction Continue -Session $powershellSession -ScriptBlock {

    $globalConfig = $using:GlobalConfiguration
    $currentLabName = $using:LabName
    $OrderedTestsArray = $using:OrderedTests

    Set-Location $using:remoteDeploymentFolder
    . .\SystemEnvironment-Utils.ps1

    # Extract files
    # Usually it extracted to folder named \ui.automation
    Start-Process -Wait -NoNewWindow -FilePath 'tar.exe' -ArgumentList "-xvz", "-f $($globalConfig.UIAutomationFileName)", "-C $($using:remoteDeploymentFolder)"

    # Unzip PSTools
    $PSExecFolder = "$using:remoteDeploymentFolder\PSTools"
    if ((Test-Path -Path $PSExecFolder -PathType Container) -eq $false) {
        Expand-Archive "$using:remoteDeploymentFolder\PSTools-v2.40.zip" -DestinationPath $PSExecFolder
    } else {
        # Folder exist - may be it's already extracted ?
    }

    # Start tests that install applications
    # mstest /testsettings:.\ui.automation\Labs\LAB_ATU\SRRAALABATUCCM.testsettings /resultsfile:CCM.trx /testcontainer:.\ui.automation\StoreSolution\CCM.orderedtest

    $hostname = [System.Net.Dns]::GetHostName()
    $labFolder = "$using:remoteDeploymentFolder\ui.automation\Labs\$currentLabName" | Resolve-Path
    $testSettingFile = "$labFolder\$($using:TestSettingsFileName)" | Resolve-Path

     # Full path to folder where UI Automation files located
    $fullPathToDllFiles = "$($using:remoteDeploymentFolder)\ui.automation" | Resolve-Path
    Write-Output "`n[$currentLabName::$currentComputerHostname] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Path to \ui.automation folder set to: $fullPathToDllFiles"

    .\Parse-TestSettingsFile.ps1 -TestSettingFile $testSettingFile -PathToMsiFolder $($using:remoteDeploymentFolder) -PathToLabFolder $labFolder -PathToUiAutomationFolder $fullPathToDllFiles
    # .\Parse-EnvironmentFile.ps1 -PathToEnvironmentFile "$labFolder\Environment.xml" -PathToInstallersFolder "$($using:remoteDeploymentFolder)" -PathToLabFolder $labFolder

    # Remove-Item -Path $outputTrxFile -ErrorAction SilentlyContinue

    Set-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value ''

    # Actually invoke installation as LocalSystem account on localhost
    # Somehow invoking it as usual command with Invoke-Express or Start-Process did not succeeded - very strange error's was thrown
    # Write-Output "[Install-Store.ps1] Raw command is:`tInvoke-Expression -Command `"$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1  2>psexec.error.txt`""

    $performance = Measure-Command {

        $startDate = Get-Date -Format "HH:mm:ss"
        Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Running test on lab: $currentLabName on host: $hostname started at: $startDate" | Out-Default

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


            $OrderedTestsArray | ForEach-Object{

                if ($errorOccurred -eq $true) {
                    continue
                }

                $orderTestFile = "$($using:remoteDeploymentFolder)\ui.automation\$($PSItem.Filename)" | Resolve-Path
                .\Parse-OrdertestsFile.ps1 -PathToOrdertestFile $orderTestFile -PathToDllFiles $fullPathToDllFiles


                # Set parameters for MSTests.exe
                $outputTrxFile = [System.IO.Path]::GetFileName($orderTestFile)
                $outputTrxFile = "$($using:remoteDeploymentFolder)\$currentLabName-STORE-$outputTrxFile.trx"
                Add-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value $outputTrxFile

                # DEBUG: Delete trx file if running multiple times on the same test
                Remove-Item -Path $outputTrxFile -ErrorAction SilentlyContinue

                $mstestExe = 'C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\mstest.exe'
                $args1 = "`/testsettings:$testSettingFile `/resultsfile:$outputTrxFile `/testcontainer:$orderTestFile"

                Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] (1) Command is: $PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt" | Out-Default
                Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Order file name: $orderTestFile"

                $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args1 2>psexec.error.txt" -ErrorAction Continue

                $Error.Clear()

                if ($Result -match 'RemoteException') {

                    $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder"
                    Write-Output $msg | Out-Default

                } elseif ($Result -match 'FullyQualifiedErrorId') {
				    # $errorOccurred = $true

                    # Other error occurred
                    $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder.`nAdditional information:`n$Result"
                    Write-Output $msg | Out-Default
                }

                #
                # Display TRX file summary
                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {

                    Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Display TRX of $outputTrxFile" | Out-Default

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )" | Out-Default
                    Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] TRX: Additional data:" | Out-Default
                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                    }

                    # If TRX global status is 'failed' then stop script execution
                    if ( $( $elem.Attributes[0].Value ) -eq 'Failed' ) {
                        $errorOccurred = $true
                        Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1]  There was a failure in running of ordertest: $orderTestFile"
                        } else {
                            # all good
                    }

                } else {
                    Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] TRX file could not be found at: $outputTrxFile" | Out-Default
                    $errorOccurred = $true
                }
            }

            if ($errorOccurred -eq $false) {
                # There was not errors in ordertest running
                $testsCollection = $using:Tests

                if (($testsCollection -ne $null) -and ($testsCollection.Count -gt 0)) {
                    # There's some additional tests that should be run
                    $testsCollection | ForEach-Object {
                        $testDetails = [hashtable] $_
                        $targetTestFileName = [System.IO.Path]::Combine($fullPathToDllFiles, $($testDetails.Filename))

                        $testTrxFileName = "$( [System.IO.Path]::GetFileNameWithoutExtension($targetTestFileName) ).trx"
                        $testTrxFileName = "$($using:remoteDeploymentFolder)\$currentLabName-STORE-$testTrxFileName"
                        Add-Content -Path "$($using:remoteDeploymentFolder)\trx-file-name.txt" -Value $testTrxFileName

                        $category = $testDetails.Category
                        $args2 = "`/testsettings:$testSettingFile `/resultsfile:$testTrxFileName `/testcontainer:$targetTestFileName"

                        if (($category -ne $null) -and ([string]::IsNullOrEmpty($category) -eq $false)) {
                            $args2 = "`/testsettings:$testSettingFile `/resultsfile:$testTrxFileName `/testcontainer:$targetTestFileName `/category:$category"
                        }

                        Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Going to run test:`n$mstestExe  $args2" | Out-Default

                        Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] (3) Command is: $PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args2" | Out-Default
                        $Result = Invoke-Expression -Command "$PSExecFolder\PsExec.exe \\$hostname -accepteula -u 'rwn\s_raa_tfsbuild04' -p 'ALal1234!@' -i 1 -w '$using:remoteDeploymentFolder' '$mstestExe' $args2" -ErrorAction Continue

                        $Error.Clear()

                        if ($Result -match 'RemoteException') {

                            $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder"
                            Write-Output $msg | Out-Default

                        } elseif ($Result -match 'FullyQualifiedErrorId') {

                            # Other error occurred
                            $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Error occurred in remote session ! Please check the logs on $hostname  at $using:remoteDeploymentFolder.`nAdditional information:`n$Result"
                            Write-Output $msg | Out-Default

                        }

                        # Display TRX file summary
                        if ((Test-Path $testTrxFileName -PathType Leaf) -eq $true) {

                            Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Display TRX of $outputTrxFile" | Out-Default

                            [xml] $trxFile = Get-Content -Path $testTrxFileName

                            $elem = $trxFile.TestRun.ResultSummary

                            Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )" | Out-Default
                            Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] TRX: Additional data:" | Out-Default
                            $elem.FirstChild.Attributes | ForEach-Object {
                                Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                            }
                        } else {
                            Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] TRX file could not be found at: $testTrxFileName" | Out-Default
                        }
                    }
                } else {
                    # No additional tests
                    Write-Output "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] No additional tests was found" | Out-Default
                }
            } else {
                # Error occurred - do not proceed with additional tests
                $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Did not run tests because of failure before that"
            }

        } catch {
            $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Exception occurred while trying run installation tests!`nAdditional details:`n$PSItem"
            Write-Output $msg | Out-Default
            # throw $msg
        }

        if ($error.Count -ne 0) {
            $msg = "[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Exception occurred while trying run installation tests!`nAdditional details:`n $($error[0])"
            Write-Output $msg | Out-Default
            # throw $msg
        }
    }

    Write-Output "`n[$currentLabName] [$($(Get-Date).Subtract($using:startedTime))] [Install-Store.ps1] Done running test (installing) in: $($performance.TotalMinutes) minutes`n`n"
}

#
# Delete the 'local download' folder
# Sometimes folder is busy so we try to delete it here again anyway even if it was deleted before
Remove-Item -Path $localDownloadFolder -Recurse -Force -ErrorAction SilentlyContinue

$tmpName = [System.IO.Path]::GetTempFileName()

Copy-Item -FromSession $powershellSession -Path "$remoteDeploymentFolder\trx-file-name.txt" -Destination $tmpName

$trxFiles = Get-Content -Path $tmpName

Write-Output "[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] Log files that should be collected/copy locally: $trxFiles"

$trxFiles | ForEach-Object {

    if ([string]::IsNullOrEmpty($PSItem) -eq $false) {

        $localFile = $PSItem.Trim()

        $destinationFile = [System.IO.Path]::Combine( $TrxOutput,  $( [System.IO.Path]::GetFileName($localFile)))

        Copy-Item -FromSession $powershellSession -Path $localFile -Destination $destinationFile

        # # I hope that TRX files will be in at remote computer at folder C:\Temp
        # & "robocopy.exe" "\\$RemoteComputerAddress\C$\Temp"  $TrxOutput  $localFile   /COPY:D /dcopy:D /timfix /a+:T /a-:RSH /dst /V /FP /bytes /tee /ZB /MT:8 /R:4 /W:5 /NP "/LOG+:$TrxOutput\copy.to-$RemoteComputerAddress.log"

        Write-Output "[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] TRX file $( [System.IO.Path]::GetFileName($localFile) ) copy locally to $destinationFile"
    } else {
        # There's an empty line in file
    }
}

Remove-Item -Path $tmpName -Force -ErrorAction SilentlyContinue

Write-Output "[$LabName] [$($(Get-Date).Subtract($startedTime))] [Install-Store.ps1] Done deploy process at: $(Get-Date -Format G)"
