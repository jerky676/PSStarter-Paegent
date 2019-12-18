$sshdir="$env:USERPROFILE\.ssh"
$regex="^\s*$"
$fullkeys=@()
$keysfile="$PSScriptRoot\keys"
$plink="PuTTY\plink.exe"
$x86="$Env:Programfiles\$plink"
$x64="${env:ProgramFiles(x86)}\$plink"

if (-not ([Environment]::GetEnvironmentVariable('GIT_SSH','User'))) { 

    if ( Test-path "$x86"){
        [Environment]::SetEnvironmentVariable('GIT_SSH', "$x86", 'User')
        write-host "Created GIT_SSH env key $x86"
    } elseif ( Test-path "$x64" ){
        [Environment]::SetEnvironmentVariable('GIT_SSH', "$x64", 'User')
        write-host "Create GIT_SSH env key $x64"
    } else {
        write-host "Plink does not exists"
    }
}


if (! $(Test-Path -Path $keysfile)){
    new-item -path $keysfile -force
}


$lines=$(Get-Content "$PSScriptRoot\keys")

foreach($line in $lines) {
    if(! $($line -match $regex)){
        if ($line -match '(\/|\\)'){
            if (!(Test-Path $line)) { 
                write-host "path $line does not exists"
             } else {
                $fullkeys+="""$(Resolve-Path -path $line)"""
             }
        } else {
            $fullkeys+="""$line"""
        }      
    }
}

if ($fullkeys){
    Start-Process "C:\Program Files\PuTTY\pageant.exe" -WorkingDirectory "$sshdir" -ArgumentList $fullkeys
} else {
    write-host "no keys loaded"
}