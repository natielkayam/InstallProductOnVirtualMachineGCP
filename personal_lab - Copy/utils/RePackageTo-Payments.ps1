<#
.SYNOPSIS
    Script will extract files from PaymentEmulator release and zip it to special folder to later on it could be used in MSTest tests
.DESCRIPTION
    According to twisted logic in tests: https://github.com/ncr-swt-retail/emerald1/blob/316085c2e0a98e60b3812a1a907095b0fdab7219/UIAutomation/Src/Ncr.UIAutomation.InstallTests/Default/InstallPos1Default.cs#L82
    it expect to unzip files into \src\App\Src\Simulators\...  folder
    So this script will unpack the source .tar.gz file and pack it again to crazy tests files could pick it up
#>

PARAM(
    [string]
    $PathToPaymentEmulatorReleaseFile,

    [string]
    $TargetFolder,

    [string]
    $OutputFileName = 'GPDSimulator.zip'
)

Write-Host "[RePackageTo-Payments.ps1] Started"

Push-Location

# Global work folder
$workFolder = [System.IO.Path]::Combine( [System.IO.Path]::GetTempPath(), "$(New-Guid)")

if ((Test-Path -Path $workFolder -PathType Container) -eq $true) {
    Remove-Item -Path $workFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
}

New-Item -Path $workFolder -ItemType Directory -Force | Out-Null

Write-Host "[RePackageTo-Payments.ps1] Working folder set to: $workFolder"

# Copy release file tar.gz to working folder
Copy-Item -Path $PathToPaymentEmulatorReleaseFile -Destination $workFolder | Out-Null

Write-Host "[RePackageTo-Payments.ps1] Copy $PathToPaymentEmulatorReleaseFile to $workFolder"

# Extract it
# Usually it extracted to \Payments folder
# Inside \Payments folder we have \mtx, \epsilon and \fipay folders
Start-Process -Wait -NoNewWindow -FilePath 'tar.exe' -ArgumentList "-xz", "-f $PathToPaymentEmulatorReleaseFile", "-C $workFolder"
Write-Host "[RePackageTo-Payments.ps1] File $PathToPaymentEmulatorReleaseFile un-packed"

Set-Location $workFolder

# Create 'expected' folder
New-Item -Path '.\src\App\Src\Simulators\GPDsimulator\src\Release\mtx' -ItemType Directory -Force | Out-Null

# Copy MTX files to 'expected' location
Copy-Item .\Payments\mtx\* -Destination '.\src\App\Src\Simulators\GPDsimulator\src\Release\mtx' -Recurse -Force | Out-Null

# Create 'expected' folder
New-Item -Path '.\src\App\Src\Simulators\GPDsimulator\src\Release\Epsilon' -ItemType Directory -Force | Out-Null

# Copy Epsilon files to 'expected' location
Copy-Item .\Payments\epsilon\* -Destination '.\src\App\Src\Simulators\GPDsimulator\src\Release\Epsilon' -Recurse -Force | Out-Null

# Create 'expected' folder
New-Item -Path '.\src\App\Src\Simulators\GPDsimulator\src\Release\fipay' -ItemType Directory -Force | Out-Null

# Copy fipay files to 'expected' location
Copy-Item .\Payments\fipay\* -Destination '.\src\App\Src\Simulators\GPDsimulator\src\Release\fipay' -Recurse -Force | Out-Null


# Zip it to file with name: GPDSimulator.zip
Compress-Archive -Path .\src -DestinationPath $workFolder\$OutputFileName

Move-Item -Path $workFolder\$OutputFileName -Destination $TargetFolder\$OutputFileName -Force | Out-Null

Write-Host "[RePackageTo-Payments.ps1] MTX files repacked and saved to $TargetFolder\$OutputFileName"

Remove-Item -Path $workFolder -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Pop-Location

Write-Host "[RePackageTo-Payments.ps1] Done"