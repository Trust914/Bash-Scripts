$packagesFile = "packages.txt"

# Read the package names from the file
$packageNames = Get-Content $packagesFile

# Loop through each package name
foreach ($packageName in $packageNames) {
    # Check if the package is already installed
    $isInstalled = choco list --local-only --exact $packageName | Select-String -Pattern "^$packageName\s"

    if ($isInstalled) {
        Write-Host "Package '$packageName' is already installed."
    }
    else {
        # Install the package using Chocolatey
        Write-Host "Installing package '$packageName'..."
        choco install $packageName -y
    }
}

