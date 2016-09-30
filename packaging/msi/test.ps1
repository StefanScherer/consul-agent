$ErrorActionPreference = "Stop"

# get first msi file name from output directory
$msi_file = (get-childitem -path output -filter *.msi).name

Write-Host "Installing $msi_file"
Write-Host "msiexec.exe /q /i output\$msi_file ..."
msiexec.exe /q /i output\$msi_file | Out-Null

cd packaging\msi\test
bundle config --local path vendor/bundle
bundle install

Write-Host "Patching specinfra for AppVeyor"
(Get-Content vendor\bundle\ruby\2.2.0\gems\specinfra-2.63.1\lib\specinfra\backend\cmd.rb) |
  Foreach-Object {$_ -replace '-encodedCommand', '-NoProfile -encodedCommand'} |
  Out-File -Encoding ascii vendor\bundle\ruby\2.2.0\gems\specinfra-2.63.1\lib\specinfra\backend\cmd.rb

Write-Host "Running MSI serverspec tests ..."
bundle exec rspec --color --format documentation spec/*_spec.rb
if ($lastExitCode) {
  throw "Serverspec test failed."
}

# Return to root directory
cd ..\..\..
