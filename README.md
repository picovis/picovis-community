# 🚀 Picovis CLI - Public Releases & Community

**AI-Powered Database Analytics and Operations CLI Tool**

This repository provides public releases, documentation, and community support for Picovis CLI.

## 📦 Installation

### Quick Install (Recommended)

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex
```

### Pop!_OS / Ubuntu / Debian

#### Manual .deb Package
```bash
# Download latest .deb package
wget https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64.deb

# Install
sudo dpkg -i picovis-linux-x64.deb
```

#### AppImage (Universal)
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

### Manual Binary Download

Download the appropriate binary for your platform from our [releases page](https://github.com/picovis/picovis-community/releases):

| Platform | Architecture | Download |
|----------|-------------|----------|
| Linux | x64 | [picovis-linux-x64](https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64) |
| macOS | x64 (Intel) | [picovis-macos-x64](https://github.com/picovis/picovis-community/releases/latest/download/picovis-macos-x64) |
| macOS | ARM64 (Apple Silicon) | [picovis-macos-arm64](https://github.com/picovis/picovis-community/releases/latest/download/picovis-macos-arm64) |
| Windows | x64 | [picovis-win32-x64.exe](https://github.com/picovis/picovis-community/releases/latest/download/picovis-win32-x64.exe) |

## 🚀 Quick Start

After installation:

```bash
# Verify installation
picovis --version

# Get help
picovis --help

# Initialize your first project
picovis init

# Add a database connection
picovis db add --name mydb --type postgresql --host localhost

# Test the connection
picovis db test mydb

# Start exploring your data
picovis db tables mydb
```

## ✨ Features

- **AI-Powered Analytics**: Get intelligent insights about your database performance and structure
- **Multi-Database Support**: Works with PostgreSQL, MySQL, MongoDB, SQLite, SQL Server, and more
- **Natural Language Queries**: Convert plain English to SQL with AI assistance
- **Performance Monitoring**: Real-time database performance analysis
- **Schema Management**: Automated schema documentation and analysis
- **Data Export/Import**: Flexible data migration and backup tools

## 🗄️ Supported Databases

- PostgreSQL
- MySQL/MariaDB
- MongoDB
- SQLite
- Microsoft SQL Server
- Oracle Database

## 📚 Documentation

- [Installation Guide](docs/linux.md)
- [Quick Start Guide](https://github.com/picovis/picovis-community/wiki/Quick-Start)
- [User Manual](https://github.com/picovis/picovis-community/wiki/User-Manual)
- [Configuration Reference](https://github.com/picovis/picovis-community/wiki/Configuration)
- [Troubleshooting](https://github.com/picovis/picovis-community/wiki/Troubleshooting)

## 🐛 Bug Reports & Issues

Found a bug or have a feature request? Please [open an issue](https://github.com/picovis/picovis-community/issues/new/choose).

## 💬 Community & Discussions

Join our community discussions for:
- Questions and help
- Feature requests
- General feedback
- Tips and tricks

[Start a discussion](https://github.com/picovis/picovis-community/discussions)

## 🔄 Release Notes

See our [releases page](https://github.com/picovis/picovis-community/releases) for detailed release notes and changelogs.

## 🆘 Support

- **Documentation**: This repository and our [wiki](https://github.com/picovis/picovis-community/wiki)
- **Bug Reports**: [GitHub Issues](https://github.com/picovis/picovis-community/issues)
- **Community Help**: [GitHub Discussions](https://github.com/picovis/picovis-community/discussions)
- **Feature Requests**: [GitHub Issues](https://github.com/picovis/picovis-community/issues/new?template=feature_request.md)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Note**: This is the public releases and community repository. Source code is maintained in a separate private repository.
