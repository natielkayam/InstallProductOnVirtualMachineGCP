<#
.SYNOPSIS
    Script will read parameters from provided env file and set/remove it as Operating System environment variables.
.DESCRIPTION
    Script will read parameters from provided env file and set/remove it as Operating System environment variables. Some values changed in this script to actual values like COMPUTER_NAME
#>

function SetEnvironment-FromFile {
    [CmdletBinding(HelpUri = 'https://github.com/ncr-swt-retail/emerald1', ConfirmImpact='Medium')]
    PARAM (
        [Parameter(Mandatory=$true,
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage = "Full path including file name to file that contain environment variable")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $EnvironmentFilePath
    )

    $inputDataRaw = Get-Content -Raw -Path $EnvironmentFilePath
    #Write-Host "Done reading raw data from $EnvironmentFilePath file"

    $inputData = ConvertFrom-StringData -StringData $inputDataRaw
    #Write-Host "Build hashtable with $($inputData.Count) rows"

    # Set it to process environment
    foreach($pair in $inputData.GetEnumerator())
    {
        Set-Item "env:$($pair.Key)" $($pair.Value)
    }

    Write-Host "Done settings $($inputData.Count) parameters as environment variables"
}

function RemoveEnvironment-FromFile {
    [CmdletBinding(HelpUri = 'https://github.com/ncr-swt-retail/emerald1', ConfirmImpact='Medium')]
    PARAM (
        [Parameter(Mandatory=$true,
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            HelpMessage = "Full path including file name to file that contain environment variable")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]
        $EnvironmentFilePath
    )

    $inputDataRaw = Get-Content -Raw -Path $EnvironmentFilePath

    $inputData = ConvertFrom-StringData -StringData $inputDataRaw

    # Set it to process environment
    foreach($pair in $inputData.GetEnumerator())
    {
        Remove-Item "env:$($pair.Key)" -ErrorAction SilentlyContinue
    }

    Write-Host "Done removing $($inputData.Count) parameters as environment variables"
}