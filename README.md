<div align="center">

# 🚀 Picovis CLI

[![Latest Release](https://img.shields.io/github/v/release/picovis/picovis-community?style=for-the-badge&logo=github&color=blue)](https://github.com/picovis/picovis-community/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/picovis/picovis-community/total?style=for-the-badge&logo=download&color=green)](https://github.com/picovis/picovis-community/releases)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](LICENSE)
[![Community](https://img.shields.io/github/discussions/picovis/picovis-community?style=for-the-badge&logo=github&color=purple)](https://github.com/picovis/picovis-community/discussions)

**🤖 AI-Powered Database Analytics and Operations CLI Tool**

*Transform your database operations with intelligent insights, natural language queries, and automated analytics*

[📥 **Quick Install**](#-installation) • [📖 **Documentation**](#-documentation) • [💬 **Community**](#-community--discussions) • [🐛 **Report Issues**](#-bug-reports--issues)

</div>

---

## ✨ What is Picovis CLI?

Picovis CLI is a revolutionary database analytics tool that combines the power of AI with traditional database operations. Whether you're a database administrator, developer, or data analyst, Picovis CLI helps you:

- 🧠 **Get AI-powered insights** about your database performance and structure
- 🗣️ **Write natural language queries** that convert to SQL automatically
- 📊 **Monitor database health** in real-time with intelligent alerts
- 📋 **Manage schemas** with automated documentation and analysis
- 🔄 **Export and import data** with flexible, powerful tools

## 🎯 Key Features

<table>
<tr>
<td width="50%">

### 🤖 **AI-Powered Analytics**
- Intelligent performance insights
- Automated query optimization suggestions
- Anomaly detection and alerts
- Predictive capacity planning

</td>
<td width="50%">

### 🗄️ **Multi-Database Support**
- PostgreSQL, MySQL/MariaDB
- MongoDB, SQLite
- Microsoft SQL Server
- Oracle Database

</td>
</tr>
<tr>
<td width="50%">

### 🗣️ **Natural Language Interface**
- Convert plain English to SQL
- Smart query suggestions
- Context-aware completions
- Interactive query builder

</td>
<td width="50%">

### 📊 **Real-time Monitoring**
- Live performance metrics
- Custom dashboards
- Alert notifications
- Historical trend analysis

</td>
</tr>
</table>

## 📦 Installation

### 🚀 Quick Install (Recommended)

<details>
<summary><strong>🐧 Linux / 🍎 macOS</strong></summary>

```bash
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
```

**Advanced options:**
```bash
# Install specific version
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.3

# Install to custom location
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=/opt/picovis

# Force reinstall
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --force
```

</details>

<details>
<summary><strong>🪟 Windows (PowerShell)</strong></summary>

```powershell
iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex
```

**Advanced options:**
```powershell
# Install specific version
iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex; Install-Picovis -Version "v1.2.3"

# Install to custom location
iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex; Install-Picovis -InstallPath "C:\Tools\Picovis"

# Force reinstall
iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex; Install-Picovis -Force
```

</details>

### 📋 Alternative Installation Methods

<details>
<summary><strong>📦 Package Managers</strong></summary>

#### Ubuntu/Debian (.deb)
```bash
wget https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64.deb
sudo dpkg -i picovis-linux-x64.deb
```

#### Universal Linux (AppImage)
```bash
wget https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64.AppImage
chmod +x picovis-linux-x64.AppImage
./picovis-linux-x64.AppImage --version
```

#### Manual Binary Download
| Platform | Architecture | Download Link |
|----------|-------------|---------------|
| 🐧 Linux | x64 | [picovis-linux-x64](https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64) |
| 🍎 macOS | x64 (Intel) | [picovis-macos-x64](https://github.com/picovis/picovis-community/releases/latest/download/picovis-macos-x64) |
| 🍎 macOS | ARM64 (Apple Silicon) | [picovis-macos-arm64](https://github.com/picovis/picovis-community/releases/latest/download/picovis-macos-arm64) |
| 🪟 Windows | x64 | [picovis-win32-x64.exe](https://github.com/picovis/picovis-community/releases/latest/download/picovis-win32-x64.exe) |

</details>

## 🚀 Quick Start

Get up and running in minutes:

```bash
# 1️⃣ Verify installation
picovis --version

# 2️⃣ Initialize your workspace
picovis init

# 3️⃣ Add your first database connection
picovis db add --name mydb --type postgresql --host localhost --user myuser

# 4️⃣ Test the connection
picovis db test mydb

# 5️⃣ Start exploring your data
picovis db tables mydb
picovis query "Show me the top 10 users by activity" --db mydb
```

<div align="center">

### 🎉 **That's it! You're ready to explore your data with AI-powered insights.**

</div>

## 📚 Documentation

| Resource | Description | Link |
|----------|-------------|------|
| 📖 **Installation Guide** | Detailed installation instructions for all platforms | [docs/linux.md](docs/linux.md) |
| 🚀 **Quick Start Guide** | Get started in 5 minutes | [Wiki: Quick Start](https://github.com/picovis/picovis-community/wiki/Quick-Start) |
| 📋 **User Manual** | Complete feature documentation | [Wiki: User Manual](https://github.com/picovis/picovis-community/wiki/User-Manual) |
| ⚙️ **Configuration Reference** | All configuration options | [Wiki: Configuration](https://github.com/picovis/picovis-community/wiki/Configuration) |
| 🔧 **Troubleshooting** | Common issues and solutions | [Wiki: Troubleshooting](https://github.com/picovis/picovis-community/wiki/Troubleshooting) |

## 💬 Community & Discussions

<div align="center">

**Join our vibrant community of database professionals and AI enthusiasts!**

[![Join Discussions](https://img.shields.io/badge/Join-Community_Discussions-blue?style=for-the-badge&logo=github)](https://github.com/picovis/picovis-community/discussions)

</div>

### 🗣️ Discussion Categories

| Category | Purpose | When to Use |
|----------|---------|-------------|
| [📣 **Announcements**](https://github.com/picovis/picovis-community/discussions/categories/announcements) | Official updates & releases | Stay informed about new features |
| [🙏 **Q&A**](https://github.com/picovis/picovis-community/discussions/categories/q-a) | Technical support & help | Get help with installation, configuration, or usage |
| [💡 **Ideas**](https://github.com/picovis/picovis-community/discussions/categories/ideas) | Feature requests & suggestions | Share ideas for improvements or new features |
| [🙌 **Show and Tell**](https://github.com/picovis/picovis-community/discussions/categories/show-and-tell) | Project showcases & success stories | Share your projects and inspire others |
| [💬 **General**](https://github.com/picovis/picovis-community/discussions/categories/general) | Open discussions | General topics about databases, AI, or community |
| [🗳️ **Polls**](https://github.com/picovis/picovis-community/discussions/categories/polls) | Community feedback | Participate in feature prioritization |

### 🚀 Quick Community Links

<div align="center">

[🆕 **New to Picovis?**](https://github.com/picovis/picovis-community/discussions) • [❓ **Need Help?**](https://github.com/picovis/picovis-community/discussions/categories/q-a) • [💡 **Have an Idea?**](https://github.com/picovis/picovis-community/discussions/categories/ideas) • [🎨 **Show Your Work**](https://github.com/picovis/picovis-community/discussions/categories/show-and-tell)

</div>

## 🐛 Bug Reports & Issues

Found a bug? We want to hear about it!

<div align="center">

[![Report Bug](https://img.shields.io/badge/Report-Bug-red?style=for-the-badge&logo=github)](https://github.com/picovis/picovis-community/issues/new/choose)
[![Feature Request](https://img.shields.io/badge/Request-Feature-green?style=for-the-badge&logo=lightbulb)](https://github.com/picovis/picovis-community/discussions/categories/ideas)

</div>

### 🔒 Security Issues
For security vulnerabilities, please report privately via [GitHub Security Advisories](https://github.com/picovis/picovis-community/security/advisories).

## 🆘 Support

### ⚡ Quick Help Checklist

Before asking for help, please:

- [ ] Check our [troubleshooting guide](https://github.com/picovis/picovis-community/wiki/Troubleshooting)
- [ ] Search [existing discussions](https://github.com/picovis/picovis-community/discussions)
- [ ] Include your Picovis version (`picovis --version`) when reporting issues
- [ ] Provide your operating system and database type

### 📞 Support Channels

| Type | Channel | Response Time |
|------|---------|---------------|
| 🐛 **Bug Reports** | [GitHub Issues](https://github.com/picovis/picovis-community/issues) | 1-2 business days |
| ❓ **Questions** | [Q&A Discussions](https://github.com/picovis/picovis-community/discussions/categories/q-a) | Community-driven |
| 💡 **Feature Requests** | [Ideas Discussions](https://github.com/picovis/picovis-community/discussions/categories/ideas) | Reviewed weekly |
| 💬 **General Chat** | [General Discussions](https://github.com/picovis/picovis-community/discussions/categories/general) | Community-driven |

## 🔄 Release Notes

Stay up to date with the latest features and improvements:

[![Latest Release](https://img.shields.io/github/v/release/picovis/picovis-community?style=for-the-badge&logo=github)](https://github.com/picovis/picovis-community/releases/latest)

[📋 **View All Releases**](https://github.com/picovis/picovis-community/releases) • [📝 **Changelog**](https://github.com/picovis/picovis-community/releases)

---

<div align="center">

## 📄 License

**Proprietary Software** • All Rights Reserved

Copyright © 2024 Picovis. Unauthorized copying, distribution, or use is strictly prohibited.

---

**💡 Note**: This is the public releases and community repository. Source code is maintained in a separate private repository.

<br>

**Made with ❤️ by the Picovis Team**

</div>
