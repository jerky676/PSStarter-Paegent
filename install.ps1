param(
    [string]$startUpDir="$env:USERPROFILE\.startup"
)

$filename="pageant.ps1"
$installfile="$env:USERPROFILE\.startup\$filename"
$installer="$PSScriptRoot\.installer"
$moduleName='PSStartUp'

Copy-Item -path "$PSScriptRoot\$filename" -Destination "$installfile" -Force

if ( Test-Path "$installer"){
    Remove-Item -Path "$installer" -force -recurse
}

New-Item -path "$installer" -ItemType 'Directory'


Find-Module -Name "$moduleName" | Save-Module -Path "$installer"

Import-Module -Name "$installer/$moduleName" -Verbose 

Add-StartUpScript "$installfile" "PageantStartUp"