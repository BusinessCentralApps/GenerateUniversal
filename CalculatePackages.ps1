Write-Host "Calculate Packages"

. (Join-Path $PSScriptRoot "HelperFunctions.ps1")

$storageAccount = $env:storageAccount
$artifactType = $env:artifactType
$artifactVersion = $env:artifactVersion
$country = $env:country
if (([System.Version]$artifactVersion).Revision -eq -1) { throw "Invalid artifactVersion '$artifactVersion'" }

$artifactUrls = Get-BcArtifactUrl -storageAccount $storageAccount -type $artifactType -version $artifactVersion -select all -accept_insiderEula
$packages = $artifactUrls | Where-Object { "$_".Split('/')[5] -like $country } | ForEach-Object { @{ "package" = "$_".Split('/')[5] } }

Write-Host "Packages:"
ConvertTo-Json -InputObject @($packages) -Compress | Out-Host

Add-Content -Path $ENV:GITHUB_OUTPUT -Value "Packages=$(ConvertTo-Json -InputObject @($packages) -Compress)" -Encoding UTF8
Add-Content -Path $ENV:GITHUB_OUTPUT -Value "PackagesCount=$($packages.Count)" -Encoding UTF8
