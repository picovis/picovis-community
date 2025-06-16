# 🚀 Picovis CLI Installation Guide (Enhanced)

This comprehensive guide covers all installation methods for Picovis CLI with enterprise-grade features and security best practices.

## 📋 Table of Contents

- [Quick Installation](#-quick-installation)
- [Advanced Installation Options](#-advanced-installation-options)
- [Security Features](#-security-features)
- [Enterprise Features](#-enterprise-features)
- [Troubleshooting](#-troubleshooting)
- [Uninstallation](#-uninstallation)

## 🚀 Quick Installation

### Standard Installation

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
```

### With Version Specification

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.4
```

### Custom Installation Directory

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=/opt/picovis
```

## 🔧 Advanced Installation Options

### Dry Run Mode

Preview what the installation would do without making changes:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --dry-run
```

### Verbose Installation

Get detailed logging and debugging information:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --verbose
```

### Force Reinstallation

Reinstall even if already installed:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --force
```

### Combined Options

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --version=v1.2.4 \
  --prefix=/opt/picovis \
  --verbose \
  --force
```

## 🔒 Security Features

### Checksum Verification

The script automatically verifies SHA256 checksums when available:

```bash
# Checksum verification is automatic
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
```

### GPG Signature Verification

For maximum security, verify GPG signatures (requires `gpg`):

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --verify-signature
```

### Input Validation

All user inputs are validated and sanitized:
- Version strings must match semantic versioning patterns
- Paths are checked for malicious characters
- URLs must use HTTPS protocol

### Secure File Handling

- Temporary files use secure permissions (umask 077)
- Downloads are verified before execution
- Cleanup is guaranteed via trap handlers

## 🏢 Enterprise Features

### Proxy Support

Install through corporate proxies:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --proxy=http://proxy.company.com:8080
```

### Offline Installation

Install from local binary files:

```bash
# Download binary manually first
wget https://github.com/picovis/picovis-community/releases/download/v1.2.4/picovis-linux-x64-v1.2.4

# Install from local file
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --offline=./picovis-linux-x64-v1.2.4
```

### Automated Deployment

For CI/CD and automated deployments:

```bash
# Non-interactive installation
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --version=v1.2.4 \
  --prefix=/usr/local \
  --force \
  < /dev/null
```

### Configuration Management

Use environment variables for configuration:

```bash
export PICOVIS_VERSION="v1.2.4"
export PICOVIS_PREFIX="/opt/picovis"
export PICOVIS_PROXY="http://proxy.company.com:8080"

curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
```

## 🔍 Troubleshooting

### Common Issues

#### Network Connectivity

```bash
# Test with verbose output
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --verbose

# Use specific version if API fails
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.4
```

#### Permission Issues

```bash
# Install to user directory
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=$HOME/.local

# Or use sudo for system installation
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | sudo bash
```

#### Corporate Firewalls

```bash
# Use proxy
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --proxy=http://proxy.company.com:8080

# Or download manually and use offline mode
wget https://github.com/picovis/picovis-community/releases/download/v1.2.4/picovis-linux-x64-v1.2.4
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --offline=./picovis-linux-x64-v1.2.4
```

### Debug Mode

Enable maximum verbosity for troubleshooting:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --verbose \
  --dry-run
```

### Log Files

When using `--verbose`, installation logs are saved to temporary directory:

```bash
# Check log location in verbose output
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --verbose
# Look for: "Installation log saved to: /tmp/picovis-install-*/install.log"
```

## 🗑️ Uninstallation

### Standard Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --uninstall
```

### Uninstall from Custom Location

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --uninstall \
  --prefix=/opt/picovis
```

### Force Uninstall (Non-interactive)

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --uninstall \
  --force
```

### Dry Run Uninstall

Preview what would be removed:

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- \
  --uninstall \
  --dry-run
```

## 📊 System Requirements

### Minimum Requirements

- **Operating System**: Linux or macOS
- **Architecture**: x86_64 (ARM64 supported on macOS)
- **curl**: Version 7.50.0 or later
- **Disk Space**: 100MB free space
- **Network**: Internet connection (unless using offline mode)

### Optional Dependencies

- **gpg**: For signature verification (`--verify-signature`)
- **sha256sum** or **shasum**: For checksum verification (automatic)
- **shellcheck**: For development and testing

### Supported Platforms

| Platform | Architecture | Status |
|----------|-------------|--------|
| Linux | x86_64 | ✅ Fully Supported |
| Linux | ARM64 | ❌ Not Supported |
| macOS | x86_64 | ✅ Fully Supported |
| macOS | ARM64 (Apple Silicon) | ✅ Fully Supported |
| Windows | x86_64 | ✅ Use PowerShell script |

## 🆘 Support

### Getting Help

- **Documentation**: [GitHub Wiki](https://github.com/picovis/picovis-community/wiki)
- **Issues**: [GitHub Issues](https://github.com/picovis/picovis-community/issues)
- **Discussions**: [GitHub Discussions](https://github.com/picovis/picovis-community/discussions)

### Reporting Issues

When reporting installation issues, please include:

1. Operating system and version
2. Architecture (x86_64, ARM64)
3. Installation command used
4. Complete error output
5. Output of `curl --version`

### Contributing

Contributions to improve the installation script are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

---

**Note**: This installation script follows industry best practices for security, reliability, and user experience. It includes comprehensive error handling, input validation, and enterprise features suitable for production deployments.
