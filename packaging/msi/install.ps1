$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# Switch to build folder
cd "$env:APPVEYOR_BUILD_FOLDER"

# Clean
@(
    'output'
    'temp'
) |
Where-Object { Test-Path $_ } |
ForEach-Object { Remove-Item $_ -Recurse -Force -ErrorAction Stop }

# Create output and temp dir
mkdir output
mkdir temp

# Get version of Consul
$packageJson = (Get-Content package.json) -join "`n" | ConvertFrom-Json
$env:CONSUL_VERSION = $packageJson.version

$WebClient = New-Object System.Net.WebClient

# Download consul.exe
Write-Host Downloading Consul
$WebClient.DownloadFile("https://releases.hashicorp.com/consul/$env:CONSUL_VERSION/consul_$($env:CONSUL_VERSION)_windows_amd64.zip", "$env:APPVEYOR_BUILD_FOLDER\temp\consul.zip")

# Download web-ui for consul.exe
Write-Host Downloading Consul Web UI
$WebClient.DownloadFile("https://releases.hashicorp.com/consul/$env:CONSUL_VERSION/consul_$($env:CONSUL_VERSION)_web_ui.zip", "$env:APPVEYOR_BUILD_FOLDER\temp\web_ui.zip")

# Unpack consul.zip
Unzip "$env:APPVEYOR_BUILD_FOLDER\temp\consul.zip" "$env:APPVEYOR_BUILD_FOLDER\temp\"

# Unpack web_ui.zip
Unzip "$env:APPVEYOR_BUILD_FOLDER\temp\web_ui.zip" "$env:APPVEYOR_BUILD_FOLDER\temp\"

# Download nssm.zip
Write-Host Downloading NSSM ZIP
$WebClient.DownloadFile("http://www.nssm.cc/ci/nssm-$env:NSSM_VERSION.zip", "$env:APPVEYOR_BUILD_FOLDER\temp\nssm.zip")

# Unpack nssm.zip
Unzip "$env:APPVEYOR_BUILD_FOLDER\temp\nssm.zip" "$env:APPVEYOR_BUILD_FOLDER\temp\"

# Download msiext.zip from GitHub
Write-Host Downloading MSI Extensions
$WebClient.DownloadFile("https://github.com/dblock/msiext/releases/download/1.5/msiext-1.5.zip", "$env:APPVEYOR_BUILD_FOLDER\temp\msiext-1.5.zip")

# Unpack msiext.zip
Unzip "$env:APPVEYOR_BUILD_FOLDER\temp\msiext-1.5.zip" "$env:APPVEYOR_BUILD_FOLDER\temp\"

ls temp
