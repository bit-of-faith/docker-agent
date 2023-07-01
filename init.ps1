param (
    [parameter(Mandatory=$false)]
    [string]$dir = ".\",
    [parameter(Mandatory=$true)]
    [string]$downloadUrl,
    [parameter(Mandatory=$false)]
    [string]$sonarUrl = "https://sonar.bitof.faith",
    [parameter(Mandatory=$false)]
    [string]$target = "sonar-scanner",
    [parameter(Mandatory=$true)]
    [string]$sonarToken
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Invoke-WebRequest -OutFile "${dir}${target}.zip" -Uri $downloadUrl
if (!(Test-Path -Path "C:\${target}")) {
    Unzip "${target}.zip" "C:\${target}"
}

$testpath = "${dir}\SonarQube.Analysis.xml" ;$path=Get-ChildItem $testpath -Recurse
$path.fullname | ForEach-Object {(Get-Content $_ -Raw).Replace('SONAR_URL', $sonarUrl)| Set-Content $_}
$path.fullname | ForEach-Object {(Get-Content $_ -Raw).Replace('SONAR_TOKEN', $sonarToken)| Set-Content $_}

Copy-Item "${dir}SonarQube.Analysis.xml" -Destination "C:\${target}\SonarQube.Analysis.xml" -force

$testpath = "${dir}\SonarQube.Analysis.xml" ;$path=Get-ChildItem $testpath -Recurse
$path.fullname | ForEach-Object {(Get-Content $_ -Raw).Replace($sonarUrl, "SONAR_URL")| Set-Content $_}
$path.fullname | ForEach-Object {(Get-Content $_ -Raw).Replace($sonarToken, "SONAR_TOKEN")| Set-Content $_}

if (!([Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) -like "`C:\${target};")) { 
    [Environment]::SetEnvironmentVariable(
    "Path", 
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + "C:\${target};", 
    [System.EnvironmentVariableTarget]::Machine)
}



