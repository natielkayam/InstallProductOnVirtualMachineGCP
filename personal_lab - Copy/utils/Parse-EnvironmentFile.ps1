<#
.SYNOPSIS
    Script will fix path's in XML elements of provided file to correct ones
.DESCRIPTION
    Script will fix path's in XML elements of provided file to correct ones
#>

PARAM (
    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path to Environment.xml file that should be fixed")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToEnvironmentFile,

    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path to folder where installer files are located")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToInstallersFolder,

    [Parameter(Mandatory = $false, Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $false,
        HelpMessage = "Full absolute path to folder where this lab files are located")]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string]
    $PathToLabFolder
)

Write-Host  "[Parse-EnvironmentFile.ps1] Started to work on file: $PathToEnvironmentFile"

[xml] $environmentFile = Get-Content -Path $PathToEnvironmentFile
# Write-Host  "[Parse-EnvironmentFile.ps1] File loaded successfully"


# # #
# # # BasicCCMRtiFolderPath
# # $exist = $environmentFile.environment.BasicCCMRtiFolderPath
# # if ($null -ne $exist) {
# #     $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.BasicCCMRtiFolderPath)
# #     $environmentFile.environment.BasicCCMRtiFolderPath = 'C:\Retalix\Rti\CCM'
# # } else {
# #     # This XML Element with name 'BasicCCMRtiFolderPath' does not exist so it won't be changed
# # }

# # #
# # # BasicSTSRtiFolderPath
# # $exist = $environmentFile.environment.BasicSTSRtiFolderPath
# # if ($null -ne $exist) {
# #     $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.BasicSTSRtiFolderPath)
# #     $environmentFile.environment.BasicSTSRtiFolderPath = 'C:\Retalix\Rti\STS'
# # } else {
# #     # This XML Element with name 'BasicSTSRtiFolderPath' does not exist so it won't be changed
# # }

$setCommand = 'set CURR'
$textToReplace= "$setCommand=%~dp0"

#
# Manually replace %COMPUTERNAME% to current computer name and '%userdnsdomain%' to current domain (RWN.COM usually)
$computerNameSource1 = '%COMPUTERNAME%'
$computerNameSource2 = '%COMPUTERNAME%'
$domainNameSource = '%userdnsdomain%'
$domainManagmentObject = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Name, Domain

Write-Host  "[Parse-EnvironmentFile.ps1] Computer name is: $($domainManagmentObject.Name) and domain is: $($domainManagmentObject.Domain)"

#
# ServerMsiPath
$exist = $environmentFile.environment.ServerMsiPath
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.ServerMsiPath)
    $environmentFile.environment.ServerMsiPath = [System.IO.Path]::Combine($PathToInstallersFolder, $fileName)

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'ServerMsiPath' element to: $([System.IO.Path]::Combine($PathToInstallersFolder, $fileName))"
} else {
    # This XML Element with name 'ServerMsiPath' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'ServerMsiPath' does not exist"
}

#
# OfficeMsiPath
$exist = $environmentFile.environment.OfficeMsiPath
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.OfficeMsiPath)
    $environmentFile.environment.OfficeMsiPath = [System.IO.Path]::Combine($PathToInstallersFolder, $fileName)

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'OfficeMsiPath' element to: $([System.IO.Path]::Combine($PathToInstallersFolder, $fileName))"

} else {
    # This XML Element with name 'OfficeMsiPath' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'OfficeMsiPath' does not exist"
}

#
# ServerScriptPathHq
$exist = $environmentFile.environment.ServerScriptPathHq
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.ServerScriptPathHq)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'ServerInstallation', $fileName)
    $environmentFile.environment.ServerScriptPathHq = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'ServerScriptPathHq' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Raw -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData 

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'ServerScriptPathHq' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'ServerScriptPathHq' does not exist"
}

#
# OfficeScripPath
$exist = $environmentFile.environment.OfficeScripPath
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.OfficeScripPath)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'OfficeInstallation', $fileName)
    $environmentFile.environment.OfficeScripPath = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'OfficeScripPath' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Raw -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'OfficeScripPath' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'OfficeScripPath' does not exist"
}

#
# ServerScriptPathPos1
$exist = $environmentFile.environment.ServerScriptPathPos1
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.ServerScriptPathPos1)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'ServerInstallation', $fileName)
    $environmentFile.environment.ServerScriptPathPos1 = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'ServerScriptPathPos1' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Raw -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'ServerScriptPathPos1' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'ServerScriptPathPos1' does not exist"
}

#
# ServerScriptPathPos2
$exist = $environmentFile.environment.ServerScriptPathPos2
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.ServerScriptPathPos2)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'ServerInstallation', $fileName)
    $environmentFile.environment.ServerScriptPathPos2 = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'ServerScriptPathPos2' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'ServerScriptPathPos2' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'ServerScriptPathPos2' does not exist"
}


# 
# ServerScriptPathPos3
$exist = $environmentFile.environment.ServerScriptPathPos3
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.ServerScriptPathPos3)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'ServerInstallation', $fileName)
    $environmentFile.environment.ServerScriptPathPos3 = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'ServerScriptPathPos3' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'ServerScriptPathPos3' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'ServerScriptPathPos3' does not exist"
}


#
# PosClientScriptPathPos1
$exist = $environmentFile.environment.PosClientScriptPathPos1
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.PosClientScriptPathPos1)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'PosInstallation', $fileName)
    $environmentFile.environment.PosClientScriptPathPos1 = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'PosClientScriptPathPos1' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {

        # Fix path inside cmd/bat file
        $fileData = Get-Content -Raw -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'PosClientScriptPathPos1' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'PosClientScriptPathPos1' does not exist"
}

# 
# PosClientScriptPathPos2
$exist = $environmentFile.environment.PosClientScriptPathPos2
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.PosClientScriptPathPos2)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'PosInstallation', $fileName)
    $environmentFile.environment.PosClientScriptPathPos2 = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'PosClientScriptPathPos2' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Raw -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'PosClientScriptPathPos2' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'PosClientScriptPathPos2' does not exist"
}


#
# ServerScriptPathStore2
$exist = $environmentFile.environment.ServerScriptPathStore2
if ($null -ne $exist) {
    $fileName = [System.IO.Path]::GetFileName($environmentFile.environment.ServerScriptPathStore2)
    $correctFileNamePath = [System.IO.Path]::Combine($PathToLabFolder, 'PosInstallation', $fileName)
    $environmentFile.environment.ServerScriptPathStore2 = $correctFileNamePath

    # Write-Host "[Parse-EnvironmentFile.ps1] Fixed value in 'ServerScriptPathStore2' element to: $correctFileNamePath"

    if ((Test-Path -Path $correctFileNamePath -PathType Leaf) -eq $true) {
        # Fix path inside cmd/bat file
        $fileData = Get-Content -Raw -Path $correctFileNamePath

        $correctCommand = "$setCommand=$PathToInstallersFolder"

        $fileData = $fileData.Replace($textToReplace, $correctCommand)

        $fileData = $fileData.Replace($computerNameSource1, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($computerNameSource2, $($domainManagmentObject.Name))

        $fileData = $fileData.Replace($domainNameSource, $($domainManagmentObject.Domain))

        Set-Content -Path $correctFileNamePath -Value $fileData | Out-Null

        # Write-Host "[Parse-EnvironmentFile.ps1] Set CURR element to: $correctCommand  in $correctFileNamePath file"
    } else {
        Write-Host "[Parse-EnvironmentFile.ps1] File: $correctFileNamePath does not exist. May be it should not exist on this machine ?"
    }

} else {
    # This XML Element with name 'ServerScriptPathStore2' does not exist so it won't be changed
    Write-Host "[Parse-EnvironmentFile.ps1] Element 'ServerScriptPathStore2' does not exist"
}

$environmentFile.Save($PathToEnvironmentFile)
Write-Host "[Parse-EnvironmentFile.ps1] Fixed Environment.xml saved to: $PathToEnvironmentFile"