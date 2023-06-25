param (
    [parameter(Mandatory=$false)]
        [string]$dir = ".\"
)

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Invoke-WebRequest -OutFile "${dir}sonar-scanner.zip" -Uri "https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/5.13.0.66756/sonar-scanner-msbuild-5.13.0.66756-net5.0.zip"
if (!(Test-Path -Path "C:\sonar-scanner")) {
    Unzip "sonar-scanner.zip" "C:\sonar-scanner"
}

$testpath = "${dir}SonarQube.Analysis.xml" ;$path=Get-ChildItem $testpath -Recurse
$path.fullname | ForEach-Object {(Get-Content $_ -Raw).Replace('SONAR_URL', $Env:SONAR_URL)| Set-Content $_}
$path.fullname | ForEach-Object {(Get-Content $_ -Raw).Replace('SONAR_TOKEN', $Env:SONAR_TOKEN)| Set-Content $_}

Copy-Item "${dir}SonarQube.Analysis.xml" -Destination "C:\sonar-scanner\SonarQube.Analysis.xml" -force
if (!([Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) -like "*C:\sonar-scanner*")) { 
    [Environment]::SetEnvironmentVariable(
    "Path", 
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + "C:\sonar-scanner;", 
    [System.EnvironmentVariableTarget]::Machine)
}



