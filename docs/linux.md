# Linux Installation Guide

This guide covers all available methods to install Picovis CLI on Linux distributions.

## Quick Install (Recommended)

### Universal Installation Script

The easiest way to install Picovis CLI on any Linux distribution:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/scripts/install.sh | bash
```

This script automatically detects your system and installs the appropriate binary.

### Custom Installation

```bash
# Install to custom directory
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/scripts/install.sh | bash -s -- --prefix=$HOME/.local

# Install specific version
curl -fsSL https://raw.githubusercontent.com/picovis/picovis/main/scripts/install.sh | bash -s -- --version=v1.1.0
```

## Package Manager Installation

### Ubuntu/Debian (.deb packages)

```bash
# Download and install .deb package
wget https://github.com/picovis/picovis/releases/latest/download/picovis-linux-x64.deb
sudo apt install ./picovis-linux-x64.deb

# Or using dpkg
sudo dpkg -i picovis-linux-x64.deb
sudo apt-get install -f  # Fix dependencies if needed
```

### Red Hat/Fedora/CentOS (.rpm packages)

```bash
# Download and install .rpm package
wget https://github.com/picovis/picovis/releases/latest/download/picovis-linux-x64.rpm
sudo dnf install ./picovis-linux-x64.rpm

# Or using rpm
sudo rpm -i picovis-linux-x64.rpm
```

### Arch Linux (AUR)

```bash
# Using yay
yay -S picovis

# Using paru
paru -S picovis

# Manual installation
git clone https://aur.archlinux.org/picovis.git
cd picovis
makepkg -si
```

## Universal Linux Packages

### AppImage (Recommended for compatibility)

AppImage works on all Linux distributions without installation:

```bash
# Download AppImage
wget https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64.AppImage

# Make executable and run
chmod +x picovis-linux-x64.AppImage
./picovis-linux-x64.AppImage --version

# Optional: Add to PATH
mkdir -p ~/.local/bin
mv picovis-linux-x64.AppImage ~/.local/bin/picovis
```

### Snap Package

```bash
# Install from Snap Store
sudo snap install picovis

# Install from edge channel (latest development)
sudo snap install picovis --edge
```

### Flatpak

```bash
# Add Flathub repository (if not already added)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Picovis
flatpak install flathub com.picovis.picovis

# Run Picovis
flatpak run com.picovis.picovis
```

## Manual Binary Installation

### Download and Install Binary

```bash
# Download latest binary
wget https://github.com/picovis/picovis/releases/latest/download/picovis-linux-x64

# Make executable
chmod +x picovis-linux-x64

# Move to PATH
sudo mv picovis-linux-x64 /usr/local/bin/picovis

# Verify installation
picovis --version
```

### ARM64 Support

For ARM64 Linux systems:

```bash
# Download ARM64 binary
wget https://github.com/picovis/picovis/releases/latest/download/picovis-linux-arm64

# Install
chmod +x picovis-linux-arm64
sudo mv picovis-linux-arm64 /usr/local/bin/picovis
```

## Verification

After installation, verify that Picovis CLI is working:

```bash
# Check version
picovis --version

# Check help
picovis --help

# Test basic functionality
picovis getting-started
```

## Automatic Updates

Picovis CLI includes an automatic update system for binary installations:

```bash
# Check for updates
picovis update check

# Update to latest version
picovis update install

# Update to specific version
picovis update install --version=v1.2.0

# Enable automatic update checks
picovis settings set auto-update-check true
```

**Note**: Automatic updates are not available for package manager installations. Use your package manager to update:

- **apt**: `sudo apt update && sudo apt upgrade picovis`
- **dnf**: `sudo dnf upgrade picovis`
- **snap**: `sudo snap refresh picovis`
- **flatpak**: `flatpak update com.picovis.picovis`

## Troubleshooting

### Permission Issues

If you encounter permission errors:

```bash
# For binary installations
sudo chown $USER:$USER /usr/local/bin/picovis
sudo chmod +x /usr/local/bin/picovis

# For package installations
sudo apt-get install --reinstall picovis  # Debian/Ubuntu
sudo dnf reinstall picovis                # Red Hat/Fedora
```

### PATH Issues

If `picovis` command is not found:

```bash
# Check if binary exists
which picovis

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="/usr/local/bin:$PATH"

# Reload shell
source ~/.bashrc
```

### Dependencies

Picovis CLI is a self-contained binary, but some systems may need:

```bash
# Ubuntu/Debian
sudo apt-get install libc6

# Red Hat/Fedora
sudo dnf install glibc

# Arch Linux
sudo pacman -S glibc
```

## Uninstallation

### Binary Installation

```bash
# Remove binary
sudo rm /usr/local/bin/picovis

# Remove configuration (optional)
rm -rf ~/.config/picovis
```

### Package Manager

```bash
# Debian/Ubuntu
sudo apt remove picovis

# Red Hat/Fedora
sudo dnf remove picovis

# Snap
sudo snap remove picovis

# Flatpak
flatpak uninstall com.picovis.picovis

# AppImage
rm ~/.local/bin/picovis  # or wherever you placed it
```

## Next Steps

After installation:

1. **Login**: `picovis login`
2. **Create workspace**: `picovis workspace init`
3. **Connect database**: `picovis db connect`
4. **Explore features**: `picovis --help`

For more information, see the [Getting Started Guide](../README.md).
