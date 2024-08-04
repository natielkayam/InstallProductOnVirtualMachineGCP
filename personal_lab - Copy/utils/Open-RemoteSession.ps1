<#
.SYNOPSIS
    Function will try to open session to remote computer and return 'session' object
.NOTES
    WinRM must be configured on remote computer like this:

    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*' -Force
    Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
    Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
    Set-Item -Path WSMan:\localhost\Client\AllowUnencrypted -Value $true
    Restart-Service WinRM

    Default http port: 5985 must be open

.LINK
    https://github.com/ncr-swt-retail/emerald1-ccm
#>
function Open-RemoteSession {
    [CmdletBinding(HelpUri = 'https://github.com/ncr-swt-retail/emerald1', ConfirmImpact='Medium')]
    PARAM (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
            HelpMessage = "Address of remote computer. Eg: srraavc51.rwn.com")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $RemoteComputerAddress,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
            HelpMessage = "Credentials for Powershell to connect to remote computer")]
        [System.Management.Automation.PSCredential]
        $RemoteComputerCredentials
    )


    $SESSION_CONFIG = @{
        "ComputerName"  = $RemoteComputerAddress
        "Port"          = 5985
        "SessionOption" = (New-PSSessionOption -SkipCACheck -SkipCNCheck -CancelTimeout 0 -IdleTimeout 2147483647  -OpenTimeout 0)
        "Credential"    =  $RemoteComputerCredentials
        "ErrorAction"   = "Stop"
    }
    # "Authentication"= "Basic"
    Write-Host "testttt - "$RemoteComputerCredentials
    $tryCounter = 0;
    $Error.Clear()

    while ($tryCounter -le 8)
    {
        try {
            Write-Host "[$($MyInvocation.MyCommand.Name)] Trying to connect to remote computer at: $RemoteComputerAddress at port: $($SESSION_CONFIG.Port) with user: $($RemoteComputerCredentials.UserName) and password"

            $session = New-PSSession @SESSION_CONFIG

            $tryCounter = 100

            $Error.Clear()

            Write-Host "[$($MyInvocation.MyCommand.Name)] Successfully connected to remote computer at: $RemoteComputerAddress"

            
        }
        catch {

            $tryCounter += 1

            $Error.Clear()

            Start-Sleep -Seconds 3
        }
    }

    if ($tryCounter -ne 100) {
        $msg = "[$($MyInvocation.MyCommand.Name)] Tried $tryCounter and could not connect to remote computer at: $($SESSION_CONFIG.ComputerName):$($SESSION_CONFIG.Port).with user: $($RemoteComputerCredentials.UserName) and password"
        Write-Host $msg

        Write-Host "Current status of connection to $($SESSION_CONFIG.ComputerName):$($SESSION_CONFIG.Port)"

        Write-Host $(Test-NetConnection -ComputerName $($SESSION_CONFIG.ComputerName) -Port $($SESSION_CONFIG.Port))

        throw $msg
    }

    $session
}