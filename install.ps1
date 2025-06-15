# 🚀 Picovis CLI Windows Installation Script
#
# This script automatically downloads the appropriate Picovis CLI binary
# for Windows and installs it to your system.
#
# Usage:
#   iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/scripts/install.ps1 | iex
#   iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/scripts/install.ps1 | iex; Install-Picovis -Version "v1.2.3"
#   iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/scripts/install.ps1 | iex; Install-Picovis -InstallPath "C:\Tools\Picovis"
#
# Parameters:
#   -Version        Install specific version (default: latest)
#   -InstallPath    Install to custom directory (default: C:\Program Files\Picovis)
#   -Force          Force reinstallation
#   -Help           Show help message
#
# Copyright (c) 2024 Picovis. All rights reserved.
# This software is proprietary and confidential.

param(
    [string]$Version = "latest",
    [string]$InstallPath = "$env:ProgramFiles\Picovis",
    [switch]$Force,
    [switch]$Help
)

# 🎨 Colors and formatting
$Colors = @{
    Red    = "Red"
    Green  = "Green"
    Yellow = "Yellow"
    Blue   = "Blue"
    Cyan   = "Cyan"
    White  = "White"
}

# 📦 Configuration
$Config = @{
    GitHubRepo     = "picovis/picovis-community"
    BinaryName     = "picovis.exe"
    TempDir        = "$env:TEMP\picovis-install-$(Get-Random)"
    Architecture   = "x64"
    Platform       = "windows"
}

# 🎯 Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor $Colors.Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $Colors.Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $Colors.Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $Colors.Red
}

function Write-Progress {
    param([string]$Message)
    Write-Host "🔄 $Message" -ForegroundColor "Magenta"
}

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "🚀 $Message" -ForegroundColor $Colors.Cyan
    Write-Host ("=" * ($Message.Length + 3)) -ForegroundColor $Colors.Cyan
    Write-Host ""
}

# 🆘 Help function
function Show-Help {
    $helpText = @"
Picovis CLI Windows Installation Script

USAGE:
    iwr -useb https://raw.githubusercontent.com/picovis/picovis/main/scripts/install.ps1 | iex
    iwr -useb https://raw.githubusercontent.com/picovis/picovis/main/scripts/install.ps1 | iex; Install-Picovis [OPTIONS]

PARAMETERS:
    -Version        Install specific version (e.g., -Version "v1.2.3")
                   Default: latest
    
    -InstallPath    Install to custom directory (e.g., -InstallPath "C:\Tools\Picovis")
                   Default: C:\Program Files\Picovis
                   Binary will be installed to InstallPath\bin\picovis.exe
    
    -Force          Force reinstallation even if already installed
    
    -Help           Show this help message

EXAMPLES:
    # Install latest version to default location
    Install-Picovis
    
    # Install specific version
    Install-Picovis -Version "v1.2.3"
    
    # Install to custom directory
    Install-Picovis -InstallPath "C:\Tools\Picovis"
    
    # Force reinstallation
    Install-Picovis -Force

REQUIREMENTS:
    • Windows 10 or later
    • PowerShell 5.1 or later
    • Internet connection

For more information, visit: https://github.com/picovis/picovis
"@
    Write-Host $helpText -ForegroundColor $Colors.White
}

# 🔍 Check prerequisites
function Test-Prerequisites {
    Write-Progress "Checking prerequisites..."
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Error "PowerShell 5.1 or later is required. Current version: $($PSVersionTable.PSVersion)"
        return $false
    }
    
    # Check if running as administrator for system-wide installation
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    
    if ($InstallPath.StartsWith($env:ProgramFiles) -and -not $isAdmin) {
        Write-Warning "Installing to Program Files requires administrator privileges"
        Write-Info "Either run PowerShell as Administrator or choose a different install path"
        Write-Info "Example: Install-Picovis -InstallPath `"$env:LOCALAPPDATA\Picovis`""
        return $false
    }
    
    Write-Success "Prerequisites check passed"
    return $true
}

# 🔗 Get download URL
function Get-DownloadUrl {
    Write-Progress "Resolving download URL..."
    
    $binaryFilename = "picovis-$($Config.Platform)-$($Config.Architecture).exe"
    
    if ($Version -eq "latest") {
        Write-Info "Fetching latest release information..."
        try {
            $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/$($Config.GitHubRepo)/releases/latest" -UseBasicParsing
            $Version = $latestRelease.tag_name
            Write-Success "Latest version: $Version"
        }
        catch {
            Write-Error "Failed to fetch latest release information: $($_.Exception.Message)"
            Write-Info "Please specify a version manually with -Version parameter"
            return $null
        }
    }
    
    $downloadUrl = "https://github.com/$($Config.GitHubRepo)/releases/download/$Version/$binaryFilename"
    Write-Success "Download URL: $downloadUrl"
    return $downloadUrl
}

# 📥 Download binary
function Get-Binary {
    param([string]$DownloadUrl)
    
    Write-Progress "Downloading Picovis CLI binary..."
    
    # Create temporary directory
    if (Test-Path $Config.TempDir) {
        Remove-Item $Config.TempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $Config.TempDir -Force | Out-Null
    
    $tempBinary = Join-Path $Config.TempDir $Config.BinaryName
    
    try {
        # Download with progress
        $progressPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $tempBinary -UseBasicParsing
        
        $ProgressPreference = $progressPreference
        
        # Verify download
        if (-not (Test-Path $tempBinary) -or (Get-Item $tempBinary).Length -eq 0) {
            throw "Downloaded binary is empty or missing"
        }
        
        Write-Success "Binary downloaded successfully"
        return $tempBinary
    }
    catch {
        Write-Error "Failed to download binary: $($_.Exception.Message)"
        Write-Info "Please check if the version exists and try again"
        return $null
    }
}

# 🔧 Install binary
function Install-Binary {
    param([string]$TempBinary)
    
    $binDir = Join-Path $InstallPath "bin"
    $installPath = Join-Path $binDir $Config.BinaryName
    
    Write-Progress "Installing Picovis CLI to $installPath..."
    
    # Create install directory if it doesn't exist
    if (-not (Test-Path $binDir)) {
        Write-Info "Creating directory: $binDir"
        try {
            New-Item -ItemType Directory -Path $binDir -Force | Out-Null
        }
        catch {
            Write-Error "Failed to create install directory: $($_.Exception.Message)"
            return $false
        }
    }
    
    # Check if already installed and not forcing
    if ((Test-Path $installPath) -and -not $Force) {
        try {
            $currentVersion = & $installPath --version 2>$null | Select-Object -First 1
            Write-Warning "Picovis CLI is already installed: $currentVersion"
            Write-Info "Use -Force to reinstall"
            
            # Ask user if they want to continue
            $response = Read-Host "Do you want to continue with installation? [y/N]"
            if ($response -notmatch "^[Yy]$") {
                Write-Info "Installation cancelled"
                return $false
            }
        }
        catch {
            Write-Warning "Existing installation found but version check failed"
        }
    }
    
    # Install binary
    try {
        Copy-Item $TempBinary $installPath -Force
        Write-Success "Picovis CLI installed to $installPath"
        return $true
    }
    catch {
        Write-Error "Failed to install binary: $($_.Exception.Message)"
        return $false
    }
}

# ✅ Verify installation
function Test-Installation {
    $installPath = Join-Path (Join-Path $InstallPath "bin") $Config.BinaryName
    
    Write-Progress "Verifying installation..."
    
    # Check if binary exists
    if (-not (Test-Path $installPath)) {
        Write-Error "Binary not found at $installPath"
        return $false
    }
    
    # Test binary execution
    try {
        $versionOutput = & $installPath --version 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Binary execution failed with exit code $LASTEXITCODE"
        }
        
        Write-Success "Installation verified successfully"
        Write-Info "Version: $versionOutput"
        return $true
    }
    catch {
        Write-Error "Binary execution failed: $($_.Exception.Message)"
        return $false
    }
}

# 🛣️ Update PATH
function Update-Path {
    $binDir = Join-Path $InstallPath "bin"
    
    # Check if directory is already in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -split ";" -contains $binDir) {
        Write-Success "Install directory is already in your PATH"
        return
    }
    
    Write-Progress "Adding install directory to PATH..."
    
    try {
        # Add to user PATH
        $newPath = if ($currentPath) { "$currentPath;$binDir" } else { $binDir }
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        
        # Update current session PATH
        $env:PATH = "$env:PATH;$binDir"
        
        Write-Success "Install directory added to PATH"
        Write-Info "You may need to restart your terminal for PATH changes to take effect"
    }
    catch {
        Write-Warning "Failed to update PATH automatically: $($_.Exception.Message)"
        Write-Info "Please manually add the following directory to your PATH:"
        Write-Host $binDir -ForegroundColor $Colors.White
    }
}

# 🧹 Cleanup
function Remove-TempFiles {
    if (Test-Path $Config.TempDir) {
        try {
            Remove-Item $Config.TempDir -Recurse -Force
        }
        catch {
            Write-Warning "Failed to clean up temporary files: $($_.Exception.Message)"
        }
    }
}

# 🚀 Main installation function
function Install-Picovis {
    param(
        [string]$Version = "latest",
        [string]$InstallPath = "$env:ProgramFiles\Picovis",
        [switch]$Force,
        [switch]$Help
    )
    
    try {
        # Show help if requested
        if ($Help) {
            Show-Help
            return
        }
        
        # Show header
        Write-Header "Picovis CLI Installation"
        
        # Show installation info
        Write-Info "Installation version: $Version"
        Write-Info "Installation path: $InstallPath"
        Write-Host ""
        
        # Check prerequisites
        if (-not (Test-Prerequisites)) {
            return
        }
        
        # Get download URL
        $downloadUrl = Get-DownloadUrl
        if (-not $downloadUrl) {
            return
        }
        
        # Download binary
        $tempBinary = Get-Binary -DownloadUrl $downloadUrl
        if (-not $tempBinary) {
            return
        }
        
        # Install binary
        if (-not (Install-Binary -TempBinary $tempBinary)) {
            return
        }
        
        # Verify installation
        if (-not (Test-Installation)) {
            return
        }
        
        # Update PATH
        Update-Path
        
        # Success message
        Write-Host ""
        Write-Header "Installation Complete! 🎉"
        Write-Host ""
        Write-Success "Picovis CLI has been successfully installed"
        Write-Info "Run 'picovis --help' to get started"
        Write-Info "Visit https://github.com/picovis/picovis for documentation"
        Write-Host ""
    }
    finally {
        # Cleanup
        Remove-TempFiles
    }
}

# Auto-run if script is executed directly (not dot-sourced)
if ($MyInvocation.InvocationName -ne '.') {
    Install-Picovis -Version $Version -InstallPath $InstallPath -Force:$Force -Help:$Help
}
