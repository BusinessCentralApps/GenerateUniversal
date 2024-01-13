Write-Host "Calculate Packages"

. (Join-Path $PSScriptRoot "HelperFunctions.ps1")

$artifactType = $env:artifactType
if ($artifactType -eq '') { $artifactType = 'sandbox' }
$artifactVersion = $env:artifactVersion
if (([System.Version]$artifactVersion).Revision -eq -1) { throw "Invalid artifactVersion '$artifactVersion'" }

$artifactUrls = Get-BcArtifactUrl -type $artifactType -version $artifactVersion -select all
$packages = $artifactUrls+@('/////platform') | ForEach-Object { @{ "package" = "$_".Split('/')[5] } }

Write-Host "Packages:"
$packages | ForEach-Object { Write-Host "- $(ConvertTo-Json -InputObject $_ -Compress)" }

Add-Content -Path $ENV:GITHUB_OUTPUT -Value "Packages=$(ConvertTo-Json -InputObject @($packages) -Compress)" -Encoding UTF8
Add-Content -Path $ENV:GITHUB_OUTPUT -Value "PackagesCount=$($packages.Count)" -Encoding UTF8