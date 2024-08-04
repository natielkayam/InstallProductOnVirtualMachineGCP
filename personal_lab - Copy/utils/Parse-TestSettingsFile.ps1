<#
.SYNOPSIS
    Script fill replace path to DLL files in XML elements of provided file to correct one
.DESCRIPTION
    Script fill replace path to DLL files in XML elements of provided file to correct one
#>

PARAM(
    [Parameter(Mandatory = $true, 
                Position = 1, 
                ValueFromPipeline = $true, 
                ValueFromPipelineByPropertyName = $true, 
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to .testsettings file that should be fixed")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $TestSettingFile,

    [Parameter(Mandatory = $true, 
                Position = 2, 
                ValueFromPipeline = $true, 
                ValueFromPipelineByPropertyName = $true, 
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to folder where MSI files located")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToMsiFolder,

    [Parameter(Mandatory = $true, 
                Position = 3, 
                ValueFromPipeline = $true, 
                ValueFromPipelineByPropertyName = $true, 
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to Lab folder. For example: C:\<path>\<here>\UIAutomation\Labs\LAB_ATA")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToLabFolder,

    [Parameter(Mandatory = $false, # CCM installation for example does not use this parameter
                Position = 4, 
                ValueFromPipeline = $true, 
                ValueFromPipelineByPropertyName = $true, 
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to folder where MTX files are located")]
    [string]
    $PathToMtxFile = $null,

    [Parameter(Mandatory = $false, # CCM installation for example does not use this parameter
                Position = 5,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to folder where R1Emulator files are located")]
    [string]
    $PathToR1EmulatorFile = $null,

    [Parameter(Mandatory = $false,  # CCM installation for example does not use this parameter
                Position = 6,
                ValueFromPipeline = $true, 
                ValueFromPipelineByPropertyName = $true, 
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to folder where CoinDispenser files are located")]
    [string]
    $PathToCoinDispenserFolder = $null,

    [Parameter(Mandatory = $true,
                Position = 7,
                ValueFromPipeline = $true, 
                ValueFromPipelineByPropertyName = $true, 
                ValueFromRemainingArguments = $false,
                HelpMessage = "Full absolute path to folder where DLL files that might be referenced by test assembly's could be referenced like Common.Logging, etc..")]
    [string]
    $PathToUiAutomationFolder = $null
)

Write-Host "[Parse-TestSettingsFile.ps1] Started"

# Write-Host "[Parse-TestSettingsFile.ps1]                            `
#             `nTestSettingFile = $TestSettingFile                    `
#             `nPathToMsiFolder = $PathToMsiFolder                    `
#             `nPathToLabFolder = $PathToLabFolder                    `
#             `nPathToMtxFile = $PathToMtxFile                        `
#             `nPathToR1EmulatorFile = $PathToR1EmulatorFile          `
#             `nPathToCoinDispenserFolder = $PathToCoinDispenserFolder"

[xml] $xmlDoc = Get-Content -Path $TestSettingFile

Write-Host "[Parse-TestSettingsFile.ps1] Loaded file: $TestSettingFile"

$deploymentItems = $xmlDoc.DocumentElement.Deployment.Clone()

$xmlDoc.DocumentElement.RemoveChild($xmlDoc.DocumentElement.Deployment) | Out-Null

$deployment = $xmlDoc.CreateElement("Deployment", $xmlDoc.DocumentElement.NamespaceURI)

$deploymentItems.ChildNodes | ForEach-Object {

    # Trick to detect if this is a folder or file
    $rawFileName = [System.IO.Path]::GetExtension( $PSItem.filename )

    if ($rawFileName -eq '') {
        #
        # This is a folder defenition
        Write-Host "[Parse-TestSettingsFile.ps1] Going to analyze/replace defined path [ $($PSItem.filename) ]"

        # This is not a file - this is folder
        if ($PSItem.filename -like '*Output\Install\MTX*') {
            
            $rawFileName = "$PathToMtxFile"
        } elseif ($PSItem.filename -match 'MTX') {
        
            $rawFileName = "$PathToMtxFile"
        } elseif ($PSItem.filename -like '*Output\Install\R1Emulator*') {
            
            $rawFileName = "$PathToR1EmulatorFile"
        } elseif ($PSItem.filename -match 'R1Emulator') {
            
            $rawFileName = "$PathToR1EmulatorFile"
        } elseif ($PSItem.filename -like '*CoinDispenser*') {
            
            $rawFileName = "$PathToCoinDispenserFolder"

        } elseif ($PSItem.filename -like '*RTI\CCM\Basic*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L407
            # RTI folder is: .\UIAutomation\Labs\RTI\CCM   + \Basic  + \Catalog

            $pathToCCMRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToCCMRtiFiles = [System.IO.Path]::Combine($pathToCCMRtiFiles, "RTI\CCM\Basic")

            $rawFileName = "$pathToCCMRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\CCM\Catalog*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L407
            # RTI folder is: .\UIAutomation\Labs\RTI\CCM   + \Basic  + \Catalog

            $pathToCCMRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToCCMRtiFiles = [System.IO.Path]::Combine($pathToCCMRtiFiles, "RTI\CCM\Catalog")

            $rawFileName = "$pathToCCMRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\STS\Default*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\STS\Default")

            $rawFileName = "$pathToSTSRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\STS\Catalog*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\STS\Catalog")

            $rawFileName = "$pathToSTSRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\STS\Basic*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\STS\Basic")

            $rawFileName = "$pathToSTSRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\CCM\BaseData*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\CCM\BaseData")

            $rawFileName = "$pathToSTSRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\STS\BaseData*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\STS\BaseData")

            $rawFileName = "$pathToSTSRtiFiles"

        } elseif ($PSItem.filename -like '*RTI\STS\Fuel*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\STS\Fuel")

            $rawFileName = "$pathToSTSRtiFiles"
        } elseif ($PSItem.filename -like '*RTI\CCM\WIC-EBT*') {

            # According to code here:
            # https://github.com/ncr-swt-retail/emerald1/blob/c4730a173302386ecfbf19e85013da3edac9ae48/.github/workflows/build.ui.automation.g.yaml#L403
            # RTI folder is: .\UIAutomation\Labs\RTI\STS   + \Default  + \Catalog

            $pathToSTSRtiFiles = [System.IO.Directory]::GetParent($PathToLabFolder)
            $pathToSTSRtiFiles = [System.IO.Path]::Combine($pathToSTSRtiFiles, "RTI\CCM\WIC-EBT")

            $rawFileName = "$pathToSTSRtiFiles"

        }
		else {
            # Don't know what is it
            $rawFileName = $PSItem.filename
            
            Write-Host "[Parse-TestSettingsFile.ps1] WARNING: File/Directory name: $($PSItem.filename) is unknown and won't be fixed"
        }

    } else {

        #
        # This is a file defenition
        Write-Host "[Parse-TestSettingsFile.ps1] Going to analyze/replace defined path to file [ $($PSItem.filename) ]"

        $rawFileName = [System.IO.Path]::GetFileName($PSItem.filename)

        if ([System.IO.Path]::GetExtension($rawFileName) -eq ".msi") {

            $detectedFile = Get-ChildItem -Path $PathToMsiFolder | Where-Object { $PSItem.Name -match  $rawFileName} | Select-Object -First 1

            if ([string]::IsNullOrEmpty($detectedFile) -eq $true) {
                Write-Host "[Parse-TestSettingsFile.ps1] Error: File $($PSItem.filename) was defined in testsettings file but was not found at: $PathToLabFolder folder"
                throw "[Parse-TestSettingsFile.ps1] Error: File $($PSItem.filename) was defined in testsettings file but was not found at: $PathToLabFolder folder"
            }

            $rawFileName = $detectedFile.FullName

        } elseif ([System.IO.Path]::GetExtension($rawFileName) -eq ".cmd") {

            $detectedFile = Get-ChildItem -Path $PathToLabFolder -Recurse | Where-Object { $PSItem.Name -match  $rawFileName} | Select-Object -First 1
            
            if ([string]::IsNullOrEmpty($detectedFile) -eq $true) {
                Write-Host "[Parse-TestSettingsFile.ps1] Error: File $($PSItem.filename) was defined in testsettings file but was not found at: $PathToLabFolder folder"
                throw "[Parse-TestSettingsFile.ps1] Error: File $($PSItem.filename) was defined in testsettings file but was not found at: $PathToLabFolder folder"
            }

            $rawFileName = $detectedFile.FullName
            
        } elseif ($rawFileName -eq 'Environment.xml') {

            # Usually this is Environment.xml or other file that reside in \Labs folder
            $detectedFile = Get-ChildItem -Path $PathToLabFolder -Recurse | Where-Object { $PSItem.Name -match  $rawFileName} | Select-Object -First 1

            if ($detectedFile -eq $null) {

                Write-Host "[Parse-TestSettingsFile.ps1] Environment.xml is not found at: $PathToLabFolder"

            } else {

                $rawFileName = $detectedFile.FullName

                Write-Host "[Parse-TestSettingsFile.ps1] Path to Environment.xml set to: $rawFileName"
            }

        } else {
            # Usually this is Environment.xml or other file that reside in \Labs folder
            $detectedFile = Get-ChildItem -Path $PathToLabFolder -Recurse | Where-Object { $PSItem.Name -match  $rawFileName} | Select-Object -First 1
            
            if ($detectedFile -eq $null) {
                # Don't know where to search for this file
                # so file name will stay the same
            } else {
                $rawFileName = $detectedFile.FullName
            }
        }
    }

    $PSItem.SetAttribute("filename", $rawFileName)

    Write-Host "[Parse-TestSettingsFile.ps1] New element value is: [ $rawFileName ]"

    $deployment.AppendChild($PSItem.Clone()) | Out-Null
}

$assemblyResolutionNode = $xmlDoc.DocumentElement.Execution.TestTypeSpecific.UnitTestRunConfig.AssemblyResolution

$assemblyResolutionNode.SetAttribute("applicationBaseDirectory", $PathToUiAutomationFolder)

$xmlDoc.DocumentElement.AppendChild($deployment) | Out-Null

$xmlDoc.Save($TestSettingFile)

Write-Host "[Parse-TestSettingsFile.ps1] Done parsing file. Changed file saved to: $TestSettingFile"