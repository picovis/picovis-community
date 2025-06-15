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

Join our vibrant community of database professionals and AI enthusiasts! Our discussions are the heart of the Picovis community.

### 🗣️ Discussion Categories

| Category | Purpose | When to Use |
|----------|---------|-------------|
| [📣 Announcements](https://github.com/picovis/picovis-community/discussions/categories/announcements) | Official updates & releases | Stay informed about new features |
| [🙏 Q&A](https://github.com/picovis/picovis-community/discussions/categories/q-a) | Technical support & help | Get help with installation, configuration, or usage |
| [💡 Ideas](https://github.com/picovis/picovis-community/discussions/categories/ideas) | Feature requests & suggestions | Share ideas for improvements or new features |
| [🙌 Show and Tell](https://github.com/picovis/picovis-community/discussions/categories/show-and-tell) | Project showcases & success stories | Share your projects and inspire others |
| [💬 General](https://github.com/picovis/picovis-community/discussions/categories/general) | Open discussions | General topics about databases, AI, or community |
| [🗳️ Polls](https://github.com/picovis/picovis-community/discussions/categories/polls) | Community feedback | Participate in feature prioritization |

### 🚀 Quick Links
- **New to Picovis?** Start with our [Welcome Discussion](https://github.com/picovis/picovis-community/discussions)
- **Need Help?** Check [Q&A](https://github.com/picovis/picovis-community/discussions/categories/q-a) or ask a new question
- **Have an Idea?** Share it in [Ideas](https://github.com/picovis/picovis-community/discussions/categories/ideas)
- **Built Something Cool?** Show it off in [Show and Tell](https://github.com/picovis/picovis-community/discussions/categories/show-and-tell)

### 📋 Community Guidelines
Please read our [Community Guidelines](COMMUNITY_GUIDELINES.md) to ensure a welcoming and productive environment for everyone.

## 🔄 Release Notes

See our [releases page](https://github.com/picovis/picovis-community/releases) for detailed release notes and changelogs.

## 🆘 Support

### 📚 **Documentation & Resources**
- **Installation Guide**: [Getting Started](https://github.com/picovis/picovis-community#-installation)
- **User Manual**: [Wiki Documentation](https://github.com/picovis/picovis-community/wiki)
- **Troubleshooting**: [Common Issues & Solutions](https://github.com/picovis/picovis-community/wiki/Troubleshooting)

### 🐛 **Issues & Bugs**
- **Bug Reports**: [Create an Issue](https://github.com/picovis/picovis-community/issues/new/choose)
- **Security Issues**: Report privately via GitHub Security Advisories

### 💬 **Community Support**
- **Questions & Help**: [Q&A Discussions](https://github.com/picovis/picovis-community/discussions/categories/q-a)
- **Feature Requests**: [Ideas Discussions](https://github.com/picovis/picovis-community/discussions/categories/ideas)
- **General Discussion**: [Community Discussions](https://github.com/picovis/picovis-community/discussions)

### ⚡ **Quick Help**
Before asking for help, please:
1. Check our [troubleshooting guide](https://github.com/picovis/picovis-community/wiki/Troubleshooting)
2. Search [existing discussions](https://github.com/picovis/picovis-community/discussions)
3. Include your Picovis version (`picovis --version`) when reporting issues

## 📄 License

This software is proprietary and confidential. All rights reserved.

Copyright (c) 2024 Picovis. Unauthorized copying, distribution, or use is strictly prohibited.

---

**Note**: This is the public releases and community repository. Source code is maintained in a separate private repository.
