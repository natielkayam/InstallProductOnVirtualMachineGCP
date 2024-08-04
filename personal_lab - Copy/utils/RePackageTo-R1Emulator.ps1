<#
.SYNOPSIS
    Script will extract files from R1Emulator release and zip it to special folder to later on it could be used in MSTest tests
.DESCRIPTION
    According to twisted logic in tests:
    https://github.com/ncr-swt-retail/emerald1/blob/e115b64b327b4eafcaf4e3c784811d4c8c4c0c6a/UIAutomation/Src/Ncr.UIAutomation.InstallTests/Simulator.cs#L121
    https://github.com/ncr-swt-retail/emerald1/blob/e115b64b327b4eafcaf4e3c784811d4c8c4c0c6a/UIAutomation/Src/Ncr.UIAutomation.Common/CodedUiEnviorment.cs#L671
    it expect to unzip files into \src\Output\Release\R1Emulator\...  folder
    So this script will unpack the source .tar.gz file and pack it again to crazy tests files could pick it up
#>

PARAM(
    [string]
    $PathToR1EmulatorReleaseFile,

    [string]
    $TargetFolder,

    [string]
    $OutputFileName = 'DataTransportationSimulator.zip'
)

Write-Host "[RePackageTo-R1Emulator.ps1] Started"

Push-Location

# Global work folder
$workFolder = [System.IO.Path]::Combine( [System.IO.Path]::GetTempPath(), "$(New-Guid)")

if ((Test-Path -Path $workFolder -PathType Container) -eq $true) {
    Remove-Item -Path $workFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

New-Item -Path $workFolder -ItemType Directory -Force | Out-Null

Write-Host "[RePackageTo-R1Emulator.ps1] Working folder set to: $workFolder"

# Copy release file tar.gz to working folder
Copy-Item -Path $PathToR1EmulatorReleaseFile -Destination $workFolder | Out-Null

Write-Host "[RePackageTo-R1Emulator.ps1] Copy: $PathToR1EmulatorReleaseFile to $workFolder"

# Extract it
# Usually it extracted to \R1Emulator folder
Start-Process -Wait -NoNewWindow -FilePath 'tar.exe' -ArgumentList "-xz", "-f $PathToR1EmulatorReleaseFile", "-C $workFolder"

Write-Host "[RePackageTo-R1Emulator.ps1] File $PathToR1EmulatorReleaseFile un-packed"

Set-Location $workFolder

# Create 'expected' folder
New-Item -Path '.\src\Output\Release\R1Emulator' -ItemType Directory -Force | Out-Null

# Copy MTX files to 'expected' location
Copy-Item .\R1Emulator\* -Destination '.\src\Output\Release\R1Emulator' -Recurse -Force | Out-Null

# Zip it to file with name: DataTransportationSimulator.zip
Compress-Archive -Path .\src -DestinationPath $workFolder\$OutputFileName

Move-Item -Path $workFolder\$OutputFileName -Destination $TargetFolder\$OutputFileName -Force

Write-Host "[RePackageTo-R1Emulator.ps1] R1Emulator files repacked to $TargetFolder\$OutputFileName"

Remove-Item -Path $workFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Pop-Location

Write-Host "[RePackageTo-R1Emulator.ps1] Done"