﻿#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one
# REMOVE ANYTHING BELOW THAT IS NOT NEEDED

$ErrorActionPreference = 'Stop'; # stop on all errors


$packageName = 'hp-oa-cmdlets' # arbitrary name for the package, used in messages
$url = 'http://whp-aus2.cold.extweb.hp.com/pub/softlib2/software1/pubsw-windows/p157797746/v107380/HPOACmdlets-x86.exe'
$url64 = 'http://whp-aus2.cold.extweb.hp.com/pub/softlib2/software1/pubsw-windows/p667675183/v107379/HPOACmdlets-x64.exe'
$fileType = 'msi'
$silentArgs = '/quiet'
$filePath = "$env:TEMP\chocolatey\$packageName"
$fileFullPath = "$filePath\$packageName_Install.exe"

try {
    if (-not (Test-Path $filePath)) {
        New-Item -ItemType directory -Path $filePath
    }

    Get-ChocolateyWebFile $packageName $fileFullPath $url $url64
	
	Add-Type -assembly "system.io.compression.filesystem"
	[io.compression.zipfile]::ExtractToDirectory($fileFullPath, $filePath)

    $processor = Get-WmiObject Win32_Processor
    $is64bit = $processor.AddressWidth -eq 64

	if ($is64bit) {
	$file = "$filePath\HPOACmdlets-x64.msi"
	} else {
	$file = "$filePath\HPOACmdlets-x86.msi"
	}
    
    Install-ChocolateyInstallPackage $packageName $fileType $silentArgs $file

} catch {
    throw
}

Remove-Item $filePath\* -recurse -force -exclude .exe