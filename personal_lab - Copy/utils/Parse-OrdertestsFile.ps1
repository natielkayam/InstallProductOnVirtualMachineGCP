<#
.SYNOPSIS
    Script will fix path's in XML elements of provided file to correct ones
.DESCRIPTION
    Script will fix path's in XML elements of provided file to correct ones
#>

PARAM (
    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path to .orderedtest file that should be fixed")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToOrdertestFile,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path to folder where actual files are located")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToDllFiles
)

[xml] $xmlDoc = Get-Content -Path $PathToOrdertestFile
Write-Host "[Parse-OrdertestsFile.ps1] Loaded file: $PathToOrdertestFile"

$testLinkCollection = $xmlDoc.OrderedTest.TestLinks.Clone()

# Change 'storage' in OrderTests element
$orderTestElement = $xmlDoc.OrderedTest.Clone()

$rawFileName = [System.IO.Path]::GetFileName( $orderTestElement.storage )

Write-Host "[Parse-OrdertestsFile.ps1] Found storage attribute: $rawFileName"

$rawFileName = [System.IO.Path]::Combine($PathToDllFiles, $rawFileName)

$orderTestElement.SetAttribute("storage", $rawFileName)

Write-Host "[Parse-OrdertestsFile.ps1] Changed storage attribute to: $rawFileName"

$orderTestElement.ChildNodes.RemoveAll()

$xmlDoc.OrderedTest.RemoveChild($xmlDoc.OrderedTest.TestLinks) | Out-Null

$testLinksElement = $xmlDoc.CreateElement("TestLinks", $xmlDoc.DocumentElement.NamespaceURI)
# Write-Host "[Parse-OrdertestsFile.ps1] Created element 'TestLinks'"

# Change 'storage' in all ChildNodes
$testLinkCollection.ChildNodes | ForEach-Object { 

    $originalPath = [System.IO.Path]::GetFileName( $PSItem.storage )

    $rawFileName = [System.IO.Path]::Combine($PathToDllFiles, $originalPath)
    
    $PSItem.SetAttribute("storage", $rawFileName)

    Write-Host "[Parse-OrdertestsFile.ps1] Changed 'storage' attribute from: $originalPath to $rawFileName"

    $testLinksElement.AppendChild($PSItem.Clone()) | Out-Null
    
    # Write-Host "[Parse-OrdertestsFile.ps1] At node: $($_.Name) changed 'storage' attribute to: $rawFileName"
}

$orderTestElement.ChildNodes | ForEach-Object {  $orderTestElement.RemoveChild($_) }  | Out-Null

$orderTestElement.AppendChild($testLinksElement) | Out-Null

$xmlDoc.ReplaceChild($orderTestElement, $xmlDoc.DocumentElement) | Out-Null

$xmlDoc.Save($PathToOrdertestFile)

Write-Host "[Parse-OrdertestsFile.ps1] Done. File saved to: $PathToOrdertestFile"