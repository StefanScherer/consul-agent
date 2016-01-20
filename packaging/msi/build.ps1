$ErrorActionPreference = "Stop"

function CreateFirewallExceptionsWXS ($firewallExceptionsGuid, $firewallExceptionList) {
  $xmlContent =
@"
<?xml version="1.0" encoding="utf-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi"
     xmlns:fire="http://schemas.microsoft.com/wix/FirewallExtension"
     xmlns:util="http://schemas.microsoft.com/wix/UtilExtension">

  <Fragment>
    <ComponentGroup Id="firewallExceptionsGroup">
      %FIREWALLEXCEPTIONS%
    </ComponentGroup>
  </Fragment>
</Wix>
"@

  $replaceWith = ""
  foreach ($firewallException in $firewallExceptionList) {
    $id = $firewallException.name -Replace " ", ""
    $filename = $firewallException.filename
    $replaceWith = $replaceWith +
@"
          <fire:FirewallException Id="$id"
            Name="$($firewallException.name)"
            Protocol="$($firewallException.protocol)"
            Port="$($firewallException.port)"
            Scope="any"
            IgnoreFailure="yes"
            Profile="domain" />

"@
  }

  if ($replaceWith) {
    $replaceWith = @"
      <Component Id="firewallExecptions" Guid="$firewallExceptionsGuid" Directory="INSTALLDIR">
        <CreateFolder />
        $replaceWith
      </Component>

"@
  }

  $xmlContent | % { $_ -replace "%FIREWALLEXCEPTIONS%", $replaceWith } | set-content "temp/firewallExceptions.wxs"
  get-content "temp/firewallExceptions.wxs"
}

# Create a folder for files to package
$content_dir = "temp\content"
mkdir $content_dir

# Copy web-ui
robocopy temp\dist $content_dir\ui /COPYALL /S /NFL /NDL /NS /NC /NJH /NJS

# Extract values from package.json
$packageJson = (Get-Content package.json) -join "`n" | ConvertFrom-Json
$env:PACKAGE_VERSION = $packageJson.version
$env:PACKAGE_NAME = $packageJson.name
$env:PACKAGE_DESCRIPTION = $packageJson.description
$env:MSI_VERSION = "$env:PACKAGE_VERSION.$env:APPVEYOR_BUILD_NUMBER"
$env:UPGRADE_CODE = $packageJson.packaging.msi.upgradeCode
$env:AUTHOR_NAME = $packageJson.author.name
$env:COMPANY_FOLDER = $packageJson.author.name
$env:PRODUCT_FOLDER = "Consul"

# Create temp\firewallExceptions.wxs
CreateFirewallExceptionsWXS $packageJson.packaging.msi.firewallExceptionsGuid $packageJson.packaging.firewallExceptions

# Generate the installer
$msi_name="$($env:PACKAGE_NAME)-$($env:MSI_VERSION).msi"

. "$env:WIX\bin\heat.exe" dir $content_dir -srd -dr INSTALLDIR -cg MainComponentGroup -out temp\directory.wxs -ke -sfrag -gg -var var.SourceDir -sreg -scom
. "$env:WIX\bin\candle.exe" "-dSourceDir=$content_dir" -arch x64 packaging\msi\*.wxs temp\*.wxs -o temp\ -ext WiXUtilExtension -ext WixFirewallExtension -ext temp\msiext-1.5\WixExtensions\WixSystemToolsExtension.dll
. "$env:WIX\bin\light.exe" -o "output\$msi_name" temp\*.wixobj -cultures:en-US -ext WixUIExtension.dll -ext WiXUtilExtension -ext WixFirewallExtension -ext temp\msiext-1.5\WixExtensions\WixSystemToolsExtension.dll

# Remove the package folder
Remove-Item -Recurse -Force $content_dir
