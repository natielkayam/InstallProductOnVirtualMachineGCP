<#
.SYNOPSIS
    Script will download specific file from specific 'release'
.DESCRIPTION
    Script will get a collection of all 'releases' on Github in provided repository, select the relevant 'release' and then download published file
#>
[CmdletBinding(SupportsShouldProcess = $false,
                PositionalBinding = $false,
                HelpUri = 'https://github.com/ncr-swt-retail/emerald1',
                ConfirmImpact = 'Medium')]
PARAM(
    [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github credentials username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GitHubUser,

    [Parameter(Mandatory = $true, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Github credentials Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GitHubUserPersonalAccessToken,

    [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Target folder where to download the file")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TargetFolder = $(Get-Location),

    [Parameter(Mandatory = $true, Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of the file to download. For example: server.msi")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $FileToDownload,

    [Parameter(Mandatory = $false, Position = 5, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Partial repository name. For example: ncr-swt-retail/emerald1-ccm")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RepoName = "ncr-swt-retail/emerald1",

    [Parameter(Mandatory = $true, Position = 6, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Name of the Github 'release' name. For example: trunk/Office-255.0.0.2")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $ReleaseTitle
)

#
# Help at: https://docs.github.com/en/rest/releases/releases#list-releases

# Create credentials
$pair = "$($GitHubUser):$($GitHubUserPersonalAccessToken)"

$encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCredentials"

$Headers = @{
    Authorization = $basicAuthValue
    Accept = "application/vnd.github.v3+json"
}

# Write-Host "[$($MyInvocation.MyCommand.Name)] Created authentication header: $basicAuthValue"

$Error.Clear()
$currentPage = 1
$pageDetected = $false
[int] $retryCount = 0


Write-Host "[$($MyInvocation.MyCommand.Name)] Starting pagination"

# Try to get list of 'releases'
# https://docs.github.com/en/rest/releases/releases#list-releases
while($pageDetected -eq $false) {

    $hasErrorInGettingResult = $true

    while($hasErrorInGettingResult) {

        $releases = "https://api.github.com/repos/$RepoName/releases?per_page=100&page=$currentPage"

        try {

            $result = Invoke-WebRequest -Uri $releases -Headers $Headers | ConvertFrom-Json

            $hasErrorInGettingResult = $false

        } catch {

            if ($retryCount -le 4) {
                # Try again
                $msg = "[$($MyInvocation.MyCommand.Name)] [Retry:$retryCount] Error occurred while trying to get list of releases from repository !"
                $msg += "`nError is: $($PSItem.Exception.ToString())"
                Write-Host $msg

                $retryCount++

            } else {
                $msg = "[$($MyInvocation.MyCommand.Name)] Release with title: $ReleaseTitle was not found at repository: $RepoName."
                $msg += "`nError is: $($PSItem.Exception.ToString())"
                Write-Error $msg

                throw $msg
            }
        }
    }

    $noDraftReleases = $result | Where-Object { $PSItem.draft -ne $true }

    $sortedByDate = $noDraftReleases | Sort-Object -Property 'published_at' -Descending

    $detectedRelease = $sortedByDate | Where-Object { $_.name -match $ReleaseTitle} | Select-Object -First 1

    if ($null -eq $detectedRelease) {
        # Not found

        # Write-Host "[$($MyInvocation.MyCommand.Name)] Release with title: '$ReleaseTitle' is not found at releases of repository: '$RepoName' at page: $currentPage. Will try to search at the next page"

        $currentPage++

    } else {

        # Found
        $pageDetected = $true
    }
}

if ($pageDetected -eq $false) {
    $msg =  "[$($MyInvocation.MyCommand.Name)] Release with title: '$ReleaseTitle' is not found at releases of repository: '$RepoName'"
    Write-Error $msg
    throw $msg
}

# Write-Host "[$($MyInvocation.MyCommand.Name)] Received a collection of $($release.Count) releases"

Write-Host "[$($MyInvocation.MyCommand.Name)] Found release: '$($detectedRelease.name)' at repository: [$RepoName] that was created at: '$($detectedRelease.created_at)', going to search in $($detectedRelease.assets.Count) assets for file: $FileToDownload"

$databasesFilesArtifact = $detectedRelease.assets | Where-Object { $_.name -eq  "$FileToDownload" } | Select-Object -First 1

if ($null -eq $databasesFilesArtifact) {
    $assets_names = $detectedRelease.assets | Select-Object -Property "name"

    $msg = "[$($MyInvocation.MyCommand.Name)] Did not found [$FileToDownload] inside this release [$($detectedRelease.name)] assets [$($assets_names.name)] at repository: [$RepoName]"

    Write-Error $msg

    throw $msg
}

$databasesFilesArtifactName = $databasesFilesArtifact.name
$databasesFilesArtifactUrl = $databasesFilesArtifact.url
# $databasesFilesArtifact.browser_download_url # Somehow this URL does not work in Powershell with any cmdlet that I try - always "Not Found" error

# Write-Host "[$($MyInvocation.MyCommand.Name)] Going to download file: $databasesFilesArtifactName  from  $databasesFilesArtifactUrl"

# # # Speed up downloading because we don't show progress bar
# # $ProgressPreference = 'SilentlyContinue'

$Error.clear()

$Headers = @{
    Authorization = $basicAuthValue
    Accept = "application/octet-stream"
}

# Create temp folder
$tempFolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "$databasesFilesArtifactName.tmp.1", "$(New-Guid)")

if (Test-Path -Path $tempFolder -PathType Container) {
    Remove-Item $tempFolder -Recurse -Force -Confirm:$false

    Write-Host "[$($MyInvocation.MyCommand.Name)] Target folder: '$tempFolder' was already existing - so deleted it"
}

New-Item -Path $tempFolder -ItemType Directory -Force | Out-Null

Write-Host "[$($MyInvocation.MyCommand.Name)] Created target folder: $tempFolder"

Push-Location

Set-Location $tempFolder

$retryCount = 0

$timeToDownload = Measure-Command {
    Write-Host "[Download-File.ps1] Started to download"

    $hasError = $true

    while($hasError) {
        try
        {
            Invoke-WebRequest -Method Get -Out $FileToDownload -Headers $Headers -Uri $databasesFilesArtifactUrl

            $hasError = $false

        } catch {

            if ($retryCount -le 4) {
                # Try again
                $retryCount++
            } else {
                $msg = "[$($MyInvocation.MyCommand.Name)] [Retry:$retryCount] Error occurred while trying to download file: " +  $FileToDownload + " !"
                $msg += "`nError is: $($PSItem.Exception.ToString())"
                Write-Error $msg
            }
        }
    }
}

Write-Host "[$($MyInvocation.MyCommand.Name)] File downloaded successfully to temporary location at: '$tempFolder\$FileToDownload' at $($timeToDownload.TotalSeconds) total seconds"

Get-Item $databasesFilesArtifactName | Unblock-File

$targetFile = [System.IO.Path]::Combine($TargetFolder, [System.IO.Path]::GetFileName($FileToDownload))

Copy-Item -Path .\$FileToDownload -Destination $targetFile

Write-Host "[$($MyInvocation.MyCommand.Name)] Downloaded file copied to: $targetFile"

# Remove local file
Remove-Item -Path .\$FileToDownload -Force -ErrorAction SilentlyContinue

# Remove temporary folder
Remove-Item -Path $tempFolder -Recurse -Force -ErrorAction SilentlyContinue

# Set this file as 'temporary'
$fileAttributes = Get-Item -Path $targetFile
$fileAttributes.Attributes = $fileAttributes.Attributes -bor [System.IO.FileAttributes]::Temporary

Write-Host "[$($MyInvocation.MyCommand.Name)] File downloaded successfully to $targetFile. Time to download $($timeToDownload.TotalSeconds) seconds. Size: $( $(Get-Item -Path $targetFile).Length / 1024 /1024 ) Mb"

Pop-Location