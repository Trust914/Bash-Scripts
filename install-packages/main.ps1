# Specify the path to the file containing package names
$packageFile = ".\packages.txt"

# Read the package names from the file
$packages = Get-Content $packageFile

# Loop through each package and install it using Chocolatey
foreach ($package in $packages) {
    Write-Host "Installing package: $package"
    choco install $package -y
}

