<#
.SYNOPSIS
    Script will try to find the latest 'release' naem for provided parameters
.DESCRIPTION
    Script will get a collection of all 'releases' on Github in provided repository, find the latest 'release' and return it back
#>


[CmdletBinding(SupportsShouldProcess = $false,
                PositionalBinding = $false,
                HelpUri = 'https://github.com/ncr-swt-retail/emerald1',
                ConfirmImpact = 'Medium')]
PARAM(
    [Parameter(Mandatory = $true,
                Position = 1,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github credentials username")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GitHubUser,

    [Parameter(Mandatory = $true,
                Position = 2,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Github credentials Personal Access Token")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $GitHubUserPersonalAccessToken,

    [Parameter(Mandatory = $false,
                Position = 3,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Repository name")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RepoName = 'ncr-swt-retail/emerald1',

    [Parameter(Mandatory = $false,
                Position = 4,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Name of the Github 'release' name or part of it. For example: Forecourt-38c7cd3  (specific)  or just Forecourt  (take latest)")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $ReleaseTitle = $null
)

Write-Host "[$($MyInvocation.MyCommand.Name)] [$ReleaseTitle] Started to searching for latest release"

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

$Error.Clear()
$currentPage = 0
$pageDetected = $false

# Try to get list of 'releases'
# https://docs.github.com/en/rest/releases/releases#list-releases
while($pageDetected -eq $false) {

    $releases = "https://api.github.com/repos/$RepoName/releases?per_page=100&page=$currentPage"

    try {

        $result = Invoke-WebRequest -Uri $releases -Headers $Headers | ConvertFrom-Json

    } catch {

        $msg = "[$($MyInvocation.MyCommand.Name)] Release with title: $ReleaseTitle was not found at repository: $RepoName."

        $msg += "`nError is: $($PSItem.Exception.Message)"

        Write-Error $msg

        throw $msg
    }

    # Write-Host "[$($MyInvocation.MyCommand.Name)] [$ReleaseTitle] Received a list of $($result.Count) elements"

    # Not the 'draft' releases
    $result = $result | Where-Object { $PSItem.draft -ne $true }

    # Write-Host "[$($MyInvocation.MyCommand.Name)] [$ReleaseTitle] After removing all 'draft' releases left $($result.Count) elements"

    # Sort by created_at
    $release = $result | Sort-Object -Property 'created_at' -Descending

    # $release | Where-Object { $PSItem.name -match $ReleaseTitle} | Select-Object -Property name | Write-Host "Found item: $PSItem"

    $similarElements = $release | Where-Object { $PSItem.name -match $ReleaseTitle} | Select-Object -ExpandProperty name
    # if ($similarElements -ne $null) {
    #     Write-Host "[$($MyInvocation.MyCommand.Name)] [$ReleaseTitle] Similar elements: $similarElements"
    # }

    # Get the latest
    $release = $release | Where-Object { $PSItem.name -match $ReleaseTitle} | Select-Object -First 1

    if ($null -eq $release) {
        # Not found
        $currentPage++

        Write-Host "[$($MyInvocation.MyCommand.Name)] [$ReleaseTitle] Release is not found at this page so continue to next page at index: $currentPage"

    } else {
        # Found
        $pageDetected = $true
    }
}

Write-Host "[$($MyInvocation.MyCommand.Name)] [$ReleaseTitle] Found release: '$($release.name)' that was created at: '$($release.created_at)' "

# Return it to pipe-line
$release.name
