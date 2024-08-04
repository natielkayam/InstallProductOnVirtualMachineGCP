[CmdletBinding(SupportsShouldProcess=$false,
                PositionalBinding=$false,
                HelpUri = 'https://github.com/ncr-swt-retail/emerald1',
                ConfirmImpact='Medium')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'GithubPassword')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'RemotePowershellPassword')]
PARAM (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path including file name to inventory file")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
	[string]	
	$PersonalLabName,
    $LabsConfigurationFile = "$PSScriptRoot\configPersonalLab\$PersonalLabName",


    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path including file name to configuration file")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    $GlobalConfigurationFile = "$PSScriptRoot\config\configuration.ps1",

    [Parameter(Mandatory = $true, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github user username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    $GithubUsername,

    [Parameter(Mandatory = $true, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github user Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    $GithubPAT,

    [Parameter(Mandatory = $true, Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Remote Powershell username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    $RemotePowershellUsername,

    [Parameter(Mandatory = $true, Position = 5, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Remote Powershell user password")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    $RemotePowershellPassword,

    [Parameter(Mandatory = $true, Position = 5, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of CCM GposWebServer installer. For example: CCM-GPosWebServer-e969ef6.")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $CCMGposReleaseName,

    [Parameter(Mandatory = $true, Position = 7, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of CCM Office installer. For example: CCM-Office-Client-ae2b7da")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $CCMOfficeReleaseName,

    [Parameter(Mandatory = $true, Position = 8, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of GPos Web Server installer. For example: GPosWebServer-14e39f6")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GPosWebServerReleaseName,

    [Parameter(Mandatory = $true, Position = 9, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of POS Client installer. For example: POSClient-a34305c")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $POSClientReleaseName,

    [Parameter(Mandatory = $true, Position = 10, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github release name of Forecourt installer. For example: Forecourt-36f81af")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $ForecourtReleaseName,

    [Parameter(Mandatory = $true, Position = 11, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github release name of Store GPos Server installer. For example: GPosWebServer-14e39f6")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $StoreGposReleaseName,

    [Parameter(Mandatory = $true, Position = 12, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github release name of Store Office installer. For example: Office-3bab28e")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $StoreOfficeReleaseName,

    [Parameter(Mandatory = $true, Position = 13, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of UI Automation. For example: UI.Automation-f918cd1")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $UiAutomationReleaseName,

    [Parameter(Mandatory = $true, Position = 14, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of release of Payment Emulators. For example: PaymentEmulators-e4c7df2")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PaymentEmulatorReleaseName
)
$parameters = @{
	PersonalLabName  = $PersonalLabName
    LabsConfigurationFile       = $LabConfigurationFilePath
    GlobalConfigurationFile     = $GlobalConfigurationFile
    GithubUsername              = $GitHubUser
    GithubPAT                   = $GitHubUserPersonalAccessToken
    RemotePowershellUsername    = 'XXXXXX'
    RemotePowershellPassword    = 'XXXXXX'
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

$startRunning = Get-Date

$exactTime = Get-Date -Format "yyyy-MM-ddTHH-mm-ss.ffff"
#fix it hereee
$globalDeploymentLogFile = "C:\TempPersonal\global.deployment.$exactTime.log"
Set-Content -Path $globalDeploymentLogFile -Value ''

$msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$exactTime] Start running UI Automation tests"
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

$msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($($(Get-Date).Subtract($startRunning)))] Log file for this run: $globalDeploymentLogFile"
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

$currentRunningUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($($(Get-Date).Subtract($startRunning)))] User that running this script is: $currentRunningUser"
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"


# Previous processes must be stopped otherwise Start-Process could stack for unknown reason
# TODO: Make a specific selector for Powershell process - don't kill not relevant
# $allPowershellProcesses = Get-Process -Name powershell -ErrorAction SilentlyContinue
# if ($null -ne $allPowershellProcesses) {
#     $allPowershellProcesses | Stop-Process -Force -Confirm:$false

#     $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($($(Get-Date).Subtract($startRunning)))] Warning: All Powershell based processes killed"
#     Write-Output $msg
#     Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"
# }


# Clear all previous errors (if any)
$Error.Clear()

# Load inventory file into memory
. $LabsConfigurationFile

# Load configuration file into memory
. $GlobalConfigurationFile

try {
    Import-Module VMware.PowerCLI
}
catch {
    if ($PSItem.ToString() -like 'VMware.VimAutomation.HA module is not currently supported on the Core edition of PowerShell.') {
        # This is known issue
        # we don't use it anyway
        $Error.Clear()
    } else {
        throw $PSItem
    }
}

# Configure PowerCLI just once
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -InvalidCertificateAction Ignore -Confirm:$false | Out-Null

#
# Collection of all available Jobs with deployment
$runningInstallations = @()

#
# Put all TRX files here for this run
$globalOutputTrxFolder = "C:\TempPersonal\$(Get-Date -Format "yyyy-MM-ddTHH-mm-ss")"

If ((Test-Path -Path $globalOutputTrxFolder -PathType Container) -eq $true) {
    Move-Item -Path $globalOutputTrxFolder -Destination "$globalOutputTrxFolder\old\$([System.Guid]::NewGuid())" -Force
}

New-Item -Path $globalOutputTrxFolder -ItemType Directory -Force | Out-Null

$msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] Folder where all TRX and logs will be saved is: $globalOutputTrxFolder"
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

Write-Output " "
$msg = "=============================================== "
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"
$msg = $parameters | Out-String
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"
Write-Output " "
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject " `n"
$msg = "=============================================== "
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

# Starting next section of output
Write-Output "`n"

Start-Sleep -Seconds 3
$msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] After sleep"
Write-Output $msg
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

#
# Start to enumerate on each lab in a list and deploy/configure on it
foreach ($labName in $LABS.Keys) {

    $lab = $LABS[$labName]

    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] Current lab is: $labName with settings $($lab | Out-String)"
    Write-Output $msg
    Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

    #
    # Start independent Powershell Job for each lab that will configure/setup it end-to-end
    $runningInstallations += Start-Job -Name $labName -Verbose -ErrorAction Continue -ScriptBlock {

        $currentLab = $using:lab
        $currentLabName = $using:LabName

        $Error.Clear()

        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Start working on the lab: $currentLabName"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        [VMware.VimAutomation.ViCore.Types.V1.VIServer] $ConnectedServer = $null

        # Set random sleep time to avoid race condition on vSphere
        Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

        try {
            # Connect to vCenter Server system
            $ConnectedServer = Connect-VIServer -Server $using:CONFIGURATION.VMWareManagementAddress -User $using:CONFIGURATION.VMWareManagementUsername -Password $using:CONFIGURATION.VMWareManagementPassword -ErrorAction Stop -Force -NotDefault
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Connected successfully to vCenter Server at $ConnectedServer with user: $($using:CONFIGURATION.VMWareManagementUsername) and password"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        } catch {
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Exception occurred while trying to connect to VMWare Management server at: $($using:CONFIGURATION.VMWareManagementAddress) `nAdditional details:`n $( $Error[0].ToString() )"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            throw $msg
        }

        # Set random sleep time to avoid race condition on vSphere
        Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

        $folder = Get-Folder $currentLabName -Server $ConnectedServer -ErrorAction Continue
        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] For lab: $currentLabName received a folder with name: $($folder.Name) and parent: $($folder.Parent.Name)"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        # Error:    Unable to find type [VMware.VimAutomation.ViCore.Types.V1.VIServer].
        # Is thrown here. I don't know why
        $Error.Clear()

        # Set random sleep time to avoid race condition on vSphere
        Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

        $vmMachines = $folder | Get-VM -Server $ConnectedServer -ErrorAction Continue
        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Received a list of  $($vmMachines.Count) VM's in folder: $($currentLabName): $($vmMachines.Name)"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        
        $Ips_vm = @{}
        foreach ($vmMachine in $vmMachines) {
                 $key = $vmMachine.Name
                 $value = $vmMachine.guest.IPAddress
                 $Ips_vm[$key] = $value
        }
        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Received a list of  $($vmMachines.Count) VM's in folder: $($currentLabName): $($vmMachines.Name)"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        
        # Error occurred in Get-VM cmdlet also - don't know why
        $Error.Clear()

        # Stop VM before revert snapshot
        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Stopping VM's"
        # Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        $vmMachines | Stop-VM -Server $ConnectedServer -RunAsync -Confirm:$false | Out-Null
        # Start-Sleep -Seconds 5

        $vmWithSnapshots =  $vmMachines | Select-Object -Property   @{Name = "VM"; Expression = {$_}},
                                                                    @{Name = "Snapshot"; Expression = { Get-Snapshot -Server $ConnectedServer -VM $_ | Where-Object {$_.Name -eq $using:CONFIGURATION.DefaultSnapshotName } | Select-Object -First 1 }}

        # $vmWithSnapshots | Set-VM -VM $($_.VM) -Snapshot $($_.Snapshot) -RunAsync -Confirm:$false

        foreach ($item in $vmWithSnapshots) {
            Set-VM -Server $ConnectedServer -VM $($item.VM) -Snapshot $($item.Snapshot) -RunAsync -Confirm:$false -ErrorAction Continue | Out-Null

            # Set random sleep time to avoid race condition on vSphere
            Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] VM: $($item.VM.Name) reverted to snapshot: $($item.Snapshot.Name)"
            # Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        foreach ($item in $vmWithSnapshots) {
            Start-VM -Server $ConnectedServer -RunAsync -Confirm:$false -VM $($item.VM) | Out-Null

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Starting VM: $($item.VM.Name)"
            # Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Set random sleep time to avoid race condition on vSphere
            Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

            $startingVM = Get-Vm -Name $($item.VM.Name) -Server $ConnectedServer

            while ( $($startingVM.ExtensionData.guest.guestOperationsReady) -eq $false){

                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Waiting for VM: $($startingVM.Name) to become available. Current state is: $($startingVM.ExtensionData.guest.guestState) and readyness is: $($startingVM.ExtensionData.guest.guestOperationsReady)"
                # Write-Output "$msg`n"
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Set random sleep time to avoid race condition on vSphere
                Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

                $startingVM = Get-Vm -Name $($item.VM.Name) -Server $ConnectedServer

                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] VM: $($startingVM.Name) state is: $($startingVM.ExtensionData.guest.guestState) and readyness is: $($startingVM.ExtensionData.guest.guestOperationsReady)"
                # Write-Output "$msg`n"
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
            }

            # Set random sleep time to avoid race condition on vSphere
            Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] VM: $($item.VM.Name) re-started"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        # Set random sleep time to avoid race condition on vSphere
        Start-Sleep -Seconds $(Get-Random -Minimum 0 -Maximum 20)

        Disconnect-VIServer -Server $ConnectedServer -Force -Confirm:$false
        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Disconnected from $($using:CONFIGURATION.VMWareManagementAddress) server"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        if ($currentLabName -eq 'SLA') {
            # Only SLA lab has a strange name. In vCenter it called SLA but local folder named \LAB_SLA
            $currentLabName = 'LAB_SLA'
        }

        Write-Output "`n"

        # Global flag to signal if "installation" error occurred in the lab
        # In case it is 'true' LAB should fail and do not continue to next installation step
        # for example if it fail in CCM -> it should stop and not isntall STORE and POS - because even CCM failed
        $installationErrorOccurred = $false

        if ($currentLab.ContainsKey('CCM') -eq $true) {

            # $($currentLab.CCM.Host) = 'SRRAALABATXCCM.RWN.Com'
            $check = ($($currentLab.CCM.Host) -Split "\.")[0]
            $ccmipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $ccmipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $ccmipAddress"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on CCM --------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performanceCCM = Measure-Command {

                # Path to Powershell script file
                $ccmInstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.CCM.InstallScript -Resolve
                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $ccmInstallScript  with parameters"
                Write-Output $msg
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
                Write-Output $($using:lab.CCM.TestSettingsFileName)
                Write-Host $($using:lab.CCM.TestSettingsFileName)
                # DEBUG
                # Write-Output "Running script with those parameters:
                # GithubUsername:`t$using:GithubUsername
                # GithubPAT:`t$using:GithubPAT
                # LabName:`t$currentLabName
                # TestSettingsFileName:`t$($using:lab.CCM.TestSettingsFileName)
                #RemoteComputerAddress:`t$($using:lab.CCM.Host)
                # RemoteComputerCredentials:`t$using:RemotePowershellCredentials
                # CCMGposReleaseName:`t$using:CCMGposReleaseName
                # CCMOfficeReleaseName:`t$using:CCMOfficeReleaseName
                # UiAutomationReleaseName:`t$using:UiAutomationReleaseName
                # `n"
                # DEBUG
                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.CCM | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.CCM.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string. In command line parameters it should look like ""
                }

                # Where the output will be written on this machine
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.ccm.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.ccm.err.txt"

                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                          `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $ccmInstallScript",                                          `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.CCM.TestSettingsFileName)",  `
                                                                "-RemoteComputerAddress     $ccmipAddress",               `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-CCMGposReleaseName        $using:CCMGposReleaseName",             `
                                                                "-CCMOfficeReleaseName      $using:CCMOfficeReleaseName",           `
                                                                "-TestsBase64String         $TestsBase64String"                     `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output "$msg`n"
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    $received = Receive-Job -Id $readOutputJob.Id

                    if (($received -ne $null) -and ([string]::IsNullOrEmpty($received) -eq $false)) {
                        Write-Output $received | Out-Default
                    } else {
                        # Nothing to print
                    }

                    # Wait a little bit before next read. Processes here is very slow :(
                    Start-Sleep -Seconds 10
                }

                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) has finished"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*ccm.trx" | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [CCM] Display TRX of $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [CCM] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [CCM] LAB installation outcome: $( $elem.Attributes[0].Value ) so installation error occurred"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    if ($elem.Attributes[0].Value -eq 'Failed') {
                        $installationErrorOccurred = $true
                    }

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [CCM] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [CCM] TRX file could not be found at: $outputTrxFile"
                    Write-Output "$msg`n" | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [CCM] TRX file is not found ! So LAB installation outcome: 'Failed' so installation error occurred"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $installationErrorOccurred = $true
                }

                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName)"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of CCM machine from $currentLabName took $($performanceCCM.ToString()) minutes"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        }

        if (($installationErrorOccurred -eq $false) -and ($currentLab.ContainsKey('Store') -eq $true)) {
            
            $check = $($currentLab.Store.Host -Split "\.")[0]
            $stsipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $stsipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $stsipAddress"
            }
            
            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] -------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on Store ------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performanceStore = Measure-Command {

                # Path to Powershell script file
                $storeInstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.Store.InstallScript -Resolve

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $storeInstallScript  with parameters"
                Write-Output $msg  | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.Store | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.Store.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string. In command line parameters it should look like ""
                }

                # Where to save the output
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.store.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.store.err.txt"

                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                    `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $storeInstallScript",                                        `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.Store.TestSettingsFileName)",     `
                                                                "-RemoteComputerAddress     $stsipAddress",             `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-StoreGposReleaseName      $using:StoreGposReleaseName",           `
                                                                "-StoreOfficeReleaseName    $using:StoreOfficeReleaseName",         `
                                                                "-CCMServerAddress          $($currentLab.CCM.Host)",               `
                                                                "-TestsBase64String         $TestsBase64String"                     `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    Start-Sleep -Seconds 3
                }

                # # # Remove-Job $readOutputJob -Force

                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*.trx" | Where-Object { $PSItem.Name -like "$currentLabName*STORE*" } | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE] Display TRX of $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE] LAB installation outcome: $( $elem.Attributes[0].Value ) so installation error occurred"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    if ($elem.Attributes[0].Value -eq 'Failed') {
                        $installationErrorOccurred = $true
                    }

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)"  | Out-Default
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] TRX file could not be found at: $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $installationErrorOccurred = $true
                }

                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName) `n"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg =  "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of STORE machine from $currentLabName took $($performanceStore.ToString()) time`n"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        if (($installationErrorOccurred -eq $false) -and ($currentLab.ContainsKey('Store1') -eq $true)) {
            
            $check = ($($currentLab.Store1.Host) -Split "\.")[0]
            $sts1ipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $sts1ipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $sts1ipAddress"
            }
            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] -------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on Store 1 ----"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performanceStore = Measure-Command {

                # Path to Powershell script file
                $store1InstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.Store1.InstallScript -Resolve

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $store1InstallScript  with parameters"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.Store1 | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.Store1.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string. In command line parameters it should look like ""
                }

                # Where to save output
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.store1.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.store1.err.txt"

                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                          `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $store1InstallScript",                                       `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.Store1.TestSettingsFileName)",    `
                                                                "-RemoteComputerAddress     $sts1ipAddress",            `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-StoreGposReleaseName      $using:StoreGposReleaseName",           `
                                                                "-StoreOfficeReleaseName    $using:StoreOfficeReleaseName",         `
                                                                "-CCMServerAddress          $($currentLab.CCM.Host)",               `
                                                                "-TestsBase64String         $TestsBase64String"                     `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output "$msg`n" | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    Start-Sleep -Seconds 10
                }

                # # # Remove-Job $readOutputJob -Force

                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*.trx" | Where-Object { $PSItem.Name -like "$currentLabName*store1*" } | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE1] Display TRX of $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE1] LAB installation outcome: $( $elem.Attributes[0].Value ) so installation error occurred"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    if ($elem.Attributes[0].Value -eq 'Failed') {
                        $installationErrorOccurred = $true
                    }

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE1] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)"  | Out-Default
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] TRX file could not be found at: $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $installationErrorOccurred = $true
                }

                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName) `n"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of STORE machine from $currentLabName took $($performanceStore.ToString()) time`n"
            Write-Output "$msg`n"  | Out-Default
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        if (($installationErrorOccurred -eq $false) -and ($currentLab.ContainsKey('Store2') -eq $true)) {
            
            $check = ($($currentLab.Store2.Host) -Split "\.")[0]
            $sts2ipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $sts2ipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $sts2ipAddress"
            }
            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] -------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on Store 2 ----"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performanceStore = Measure-Command {

                # Path to Powershell script file
                $store2InstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.Store2.InstallScript -Resolve

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $store2InstallScript  with parameters"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.Store2 | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.Store2.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string. In command line parameters it should look like ""
                }

                # Where to write the output
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.store2.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.store2.err.txt"


                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                          `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $store2InstallScript",                                       `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.Store2.TestSettingsFileName)",    `
                                                                "-RemoteComputerAddress     $sts2ipAddress",            `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-StoreGposReleaseName      $using:StoreGposReleaseName",           `
                                                                "-StoreOfficeReleaseName    $using:StoreOfficeReleaseName",         `
                                                                "-CCMServerAddress          $($currentLab.CCM.Host)",               `
                                                                "-TestsBase64String         $TestsBase64String"                     `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output "$msg`n" | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    Start-Sleep -Seconds 10
                }

                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*.trx" | Where-Object { $PSItem.Name -like "$currentLabName*store2*" } | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE2] Display TRX of $outputTrxFile" | Out-Default
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE2] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE2] LAB installation outcome: $( $elem.Attributes[0].Value ) so installation error occurred"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    if ($elem.Attributes[0].Value -eq 'Failed') {
                        $installationErrorOccurred = $true
                    }

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE2] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [STORE2] TRX file could not be found at: $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $installationErrorOccurred = $true
                }

                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName) `n"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of STORE machine from $currentLabName took $($performanceStore.ToString()) minutes"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        if (($installationErrorOccurred -eq $false) -and ($currentLab.ContainsKey('POS3') -eq $true)) {
            
            $check = ($($currentLab.POS3.Host) -Split "\.")[0]
            $pos3ipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $pos3ipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $pos3ipAddress"
            }
            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] -------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on POS3 -------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performancePOS3 = Measure-Command {

                # Path to Powershell script file
                $pos3InstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.POS3.InstallScript -Resolve

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $pos3InstallScript  with parameters"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.POS3 | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.POS3.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string
                }

                # Where the output should be written
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.pos3.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.pos3.err.txt"

                $StoreServerHost = $currentLab.Store.Host
                if ($StoreServerHost -eq $null) {
                    # Some labs has a 'Store1' or 'Store2' keys but not regular 'Store'
                    $StoreServerHost = $currentLab.Store1.Host
                }

                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                    `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $pos3InstallScript",                                         `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.POS3.TestSettingsFileName)",  `
                                                                "-RemoteComputerAddress     $pos3ipAddress",              `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-GPosWebServerReleaseName  $using:GPosWebServerReleaseName",       `
                                                                "-POSClientReleaseName      $using:POSClientReleaseName",           `
                                                                "-StoreServerHost           $StoreServerHost",                      `
                                                                "-ForecourtReleaseName      $using:ForecourtReleaseName",           `
                                                                "-TestsBase64String         $TestsBase64String",                    `
                                                                "-PaymentEmulatorReleaseName $using:PaymentEmulatorReleaseName",    `
                                                                "-R1EmulatorReleaseName     $using:GPosWebServerReleaseName"        `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output "$msg`n" | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    Start-Sleep -Seconds 10
                }

                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*.trx" | Where-Object { $PSItem.Name -like "$currentLabName*pos3*" } | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS3] Display TRX of $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS3] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS3] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS3] TRX file could not be found at: $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
                }

                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName) `n"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of POS3 machine from $currentLabName took $($performancePOS3.ToString()) time`n"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        if (($installationErrorOccurred -eq $false) -and ($currentLab.ContainsKey('POS2') -eq $true)) {
            
            $check = ($($currentLab.POS2.Host) -Split "\.")[0]
            $pos2ipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $pos2ipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $pos2ipAddress"
            }
            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] -------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on POS2 -------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performancePOS2 = Measure-Command {

                # Path to Powershell script file
                $pos2InstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.POS2.InstallScript -Resolve

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $pos2InstallScript  with parameters"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.POS2 | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.POS2.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string
                }

                # Where the output should be written
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.pos2.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.pos2.err.txt"

                $StoreServerHost = $currentLab.Store.Host
                if ($StoreServerHost -eq $null) {
                    # Some labs has a 'Store1' or 'Store2' keys but not regular 'Store'
                    $StoreServerHost = $currentLab.Store1.Host
                }

                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                    `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $pos2InstallScript",                                         `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.POS2.TestSettingsFileName)",  `
                                                                "-RemoteComputerAddress     $pos2ipAddress",              `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-GPosWebServerReleaseName  $using:GPosWebServerReleaseName",       `
                                                                "-POSClientReleaseName      $using:POSClientReleaseName",           `
                                                                "-StoreServerHost           $StoreServerHost",                      `
                                                                "-ForecourtReleaseName      $using:ForecourtReleaseName",           `
                                                                "-TestsBase64String         $TestsBase64String",                    `
                                                                "-PaymentEmulatorReleaseName $using:PaymentEmulatorReleaseName",    `
                                                                "-R1EmulatorReleaseName     $using:GPosWebServerReleaseName"        `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output "$msg`n" | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    Start-Sleep -Seconds 10
                }

                # # # Remove-Job $readOutputJob -Force


                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*.trx" | Where-Object { $PSItem.Name -like "$currentLabName*pos2*" } | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS2] Display TRX of $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS2] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS2] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)" | Out-Default
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS2] TRX file could not be found at: $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
                }


                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName) `n"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of POS2 machine from $currentLabName took $($performancePOS2.TotalMinutes) time`n"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        if (($installationErrorOccurred -eq $false) -and ($currentLab.ContainsKey('POS1') -eq $true)) {
            
            $check = ($($currentLab.POS1.Host) -Split "\.")[0]
            $pos1ipAddress = $null
            if ($Ips_vm.ContainsKey($check)) {
                $pos1ipAddress = $Ips_vm[$check]
                Write-Host "IP Address for $check is $pos1ipAddress"
            }
            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] -------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Started to run installation tests on POS1 -------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

            # Try to measure command run
            $performancePOS1 = Measure-Command {

                # Path to Powershell script file
                $pos1InstallScript = Join-Path -Path $using:CONFIGURATION.PathToInventoryFolder -ChildPath $currentLab.POS1.InstallScript -Resolve

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Running script: $pos1InstallScript  with parameters"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                # Some parameters (as AdditionalTest) could not be passed on command line and must be converted/serialized
                $additionalTestConverted = $currentLab.POS1 | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($additionalTestConverted)
                $TestsBase64String = [System.Convert]::ToBase64String($bytes)

                $configurationConverted = $using:CONFIGURATION | ConvertTo-Json -Compress
                $bytes = [System.Text.Encoding]::Unicode.GetBytes($configurationConverted)
                $ConfigurationBase64String = [System.Convert]::ToBase64String($bytes)

                $orderedTestFileName2 = $currentLab.POS1.OrderTest2FileName
                if ($orderedTestFileName2 -eq $null) {
                    $orderedTestFileName2 = "`"`""      # Empty string
                }

                # Where the output should be written
                $logFileName = "$using:globalOutputTrxFolder\$currentLabName.pos1.out.txt"
                $errorLogFileName = "$using:globalOutputTrxFolder\$currentLabName.pos1.err.txt"

                $StoreServerHost = $currentLab.Store.Host
                if ($StoreServerHost -eq $null) {
                    # Some labs has a 'Store1' or 'Store2' keys but not regular 'Store'
                    $StoreServerHost = $currentLab.Store1.Host
                }

                $runningScript = Start-Process -PassThru -NoNewWindow -FilePath 'pwsh.exe'                                    `
                                                -ArgumentList   "-NoLogo -NonInteractive -ExecutionPolicy Unrestricted ",           `
                                                                "-File $pos1InstallScript",                                         `
                                                                "-GithubUsername            $using:GithubUsername",                 `
                                                                "-GithubPAT                 $using:GithubPAT",                      `
                                                                "-LabName                   $currentLabName",                       `
                                                                "-TestSettingsFileName      $($currentLab.POS1.TestSettingsFileName)",  `
                                                                "-RemoteComputerAddress     $pos1ipAddress",              `
                                                                "-RemoteComputerUsername    $using:RemotePowershellUsername",       `
                                                                "-RemoteComputerPass        $using:RemotePowershellPassword",       `
                                                                "-GlobalConfiguration       $ConfigurationBase64String",            `
                                                                "-UiAutomationReleaseName   $using:UiAutomationReleaseName",        `
                                                                "-TrxOutput                 $using:globalOutputTrxFolder",          `
                                                                "-GPosWebServerReleaseName  $using:GPosWebServerReleaseName",       `
                                                                "-POSClientReleaseName      $using:POSClientReleaseName",           `
                                                                "-StoreServerHost           $StoreServerHost",                      `
                                                                "-ForecourtReleaseName      $using:ForecourtReleaseName",           `
                                                                "-TestsBase64String         $TestsBase64String",                    `
                                                                "-PaymentEmulatorReleaseName $using:PaymentEmulatorReleaseName",    `
                                                                "-R1EmulatorReleaseName     $using:GPosWebServerReleaseName"        `
                                                -RedirectStandardOutput $logFileName                                                `
                                                -RedirectStandardError $errorLogFileName

                # Diagnostic message
                $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Process with ID: $($runningScript.Id) and name: $($runningScript.Name) was started and saving output to: $logFileName"
                Write-Output "$msg`n"  | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

                # Read output until the process is still running
                while($runningScript.HasExited -eq $false) {

                    Start-Sleep -Seconds 10
                }

                # # # Remove-Job $readOutputJob -Force

                $outputTrxFile = Get-ChildItem "$using:globalOutputTrxFolder\*.trx" | Where-Object { $PSItem.Name -like "$currentLabName*pos1*" } | Select-Object -Last 1

                if ((Test-Path $outputTrxFile -PathType Leaf) -eq $true) {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS1] Display TRX of $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    [xml] $trxFile = Get-Content -Path $outputTrxFile

                    $elem = $trxFile.TestRun.ResultSummary

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS1] TRX: Running tests outcome: $( $elem.Attributes[0].Value )"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS1] TRX: Additional data:"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"

                    $elem.FirstChild.Attributes | ForEach-Object {
                        Write-Output "$($PSItem.Name)=$($PSItem.Value)"
                    }
                } else {
                    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] [POS1] TRX file could not be found at: $outputTrxFile"
                    Write-Output $msg | Out-Default
                    Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
                }


                # Diagnostic message
                $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Error is: $(Get-Content -Raw -Path $errorLogFileName) `n"
                Write-Output $msg | Out-Default
                Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject "$msg`n"
            }

            # Diagnostic message
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Deployment of POS1 machine from $currentLabName took $($performancePOS1.ToString()) time`n"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
        }

        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] ------------------------------------------------------------"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Finished to run installation test on the lab: $currentLabName"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg

        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($using:startRunning))] [$currentLabName] Output log files and TRX saved to: $using:globalOutputTrxFolder"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $using:globalDeploymentLogFile -InputObject $msg
    }

    # Diagnostic message
    $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$labName] [$($(Get-Date).Subtract($startRunning))] Started to run installation test on the lab: $labName"
    Write-Output $msg
    Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"
}

#
# If something was added at all
if (($null -ne $runningInstallations) -and ($runningInstallations.Count -gt 0)) {
    $stillRunning = $true
} else {
    $stillRunning = $false
}

#
# While there's any 'job' was added or any job that still running
while ($stillRunning) {

    # Get all states that still in state 'Running'
    $jobsThatRunning = $runningInstallations | Where-Object { $_.State -eq 'Running'}

    if (($null -ne $jobsThatRunning) -and ($jobsThatRunning.Count -gt 0)) {
        #
        # There still jobs that running
        $stillRunning = $true

        $msg = "-----------------------------------[Start]-----------------------------------------------------"
        Write-Output $msg
        Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

        $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] Receive a list of $($jobsThatRunning.Count) jobs that is still in state 'Running' -------"
        Write-Output "$msg`n"
        Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg

        # Get-Job

        $jobsThatRunning | ForEach-Object {
            # Write-Output  $PSItem
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] Job: $($PSItem.Name) -----------------------------------------------"
            Write-Output "$msg"
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

            $msg = "$(Receive-Job -InstanceId $($PSItem.InstanceId) -Keep -ErrorAction SilentlyContinue)"
            # $msg = "$(Receive-Job -InstanceId $($PSItem.InstanceId) -ErrorAction SilentlyContinue)"
            Write-Output "$msg"
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

        }

        $otherJobs = $runningInstallations | Where-Object { $_.State -ne 'Running'}
        if (($null -ne $otherJobs) -and ($otherJobs.Count -gt 0)) {
            $msg = "`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] List of jobs that in other state: Finished, Failed, Suspended, etc..."
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg

            $otherJobs | ForEach-Object {
                $msg = "$($PSItem.Name) $($PSItem.State)"
                Write-Output "$msg`n"
                Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg
            }
        }

        $msg = "------------------------------------[End]------------------------------------------------------"
        Write-Output $msg
        Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

        Start-Sleep -Seconds 20
    } else {
        # it is $null - that's mean that there's no job that in 'running' state
        $stillRunning = $false

        $msg = "[runtime.ps1] [$($(Get-Date).Subtract($startRunning))] All jobs finished. Status is:"
        Write-Output $msg
        Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

        $runningInstallations | ForEach-Object {
            $msg = "[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] Job: $($PSItem.Name) -----------------------------------------------"
            Write-Output $msg
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject "$msg`n"

            $msg = "$(Receive-Job -InstanceId $($PSItem.InstanceId) -ErrorAction SilentlyContinue)"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg

            $msg = "-----------------------------------------------------------------------------------------------"
            Write-Output "$msg`n"
            Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg
        }
    }
}

$msg = "`n`n[run-setup-personal-lab-DifferentDomain.ps1] [$($(Get-Date).Subtract($startRunning))] Done running. All VM's are deployed. Quit now"
Write-Output "$msg`n"
Out-File -Append -Encoding utf8 -FilePath $globalDeploymentLogFile -InputObject $msg
Write-Output $globalDeploymentLogFile
Write-Output $globalOutputTrxFolder
