<div align="center">

# 🔧 Picovis CLI Troubleshooting Guide

**Quick solutions to common issues and problems**

[![Support](https://img.shields.io/badge/Get-Support-blue?style=for-the-badge&logo=github)](https://github.com/picovis/picovis-community/discussions/categories/q-a)
[![Report Bug](https://img.shields.io/badge/Report-Bug-red?style=for-the-badge&logo=bug)](https://github.com/picovis/picovis-community/issues/new/choose)

*Can't find your issue? [Ask the community](https://github.com/picovis/picovis-community/discussions/categories/q-a) for help!*

</div>

---

## 🚨 Quick Diagnostic

**Start here if you're experiencing issues:**

<details>
<summary><strong>🔍 Run Diagnostic Commands</strong></summary>

```bash
# Check Picovis version and basic info
picovis --version
picovis --help

# Check system information
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Shell: $SHELL"

# Check installation path
which picovis
ls -la $(which picovis)

# Test basic functionality
picovis config show
```

</details>

---

## 📦 Installation Issues

### 🐧 **Linux/macOS Installation Problems**

<details>
<summary><strong>❌ "Permission denied" during installation</strong></summary>

**Problem**: Installation script fails with permission errors

**Solutions**:
```bash
# Option 1: Install to user directory
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=$HOME/.local

# Option 2: Use sudo (system-wide installation)
curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | sudo bash

# Option 3: Manual installation
wget https://github.com/picovis/picovis-community/releases/latest/download/picovis-linux-x64
chmod +x picovis-linux-x64
mkdir -p ~/.local/bin
mv picovis-linux-x64 ~/.local/bin/picovis
```

**Prevention**: Always check write permissions to the target directory

</details>

<details>
<summary><strong>❌ "Command not found" after installation</strong></summary>

**Problem**: `picovis` command not found after successful installation

**Solutions**:
```bash
# Check if binary exists
ls -la /usr/local/bin/picovis
# or
ls -la ~/.local/bin/picovis

# Add to PATH (choose your shell)
# For bash:
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh:
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For fish:
set -U fish_user_paths /usr/local/bin $fish_user_paths
```

**Prevention**: The installer should handle PATH automatically, but manual setup may be needed

</details>

<details>
<summary><strong>❌ "curl: command not found"</strong></summary>

**Problem**: curl is not installed on the system

**Solutions**:
```bash
# Ubuntu/Debian:
sudo apt update && sudo apt install curl

# CentOS/RHEL/Fedora:
sudo yum install curl
# or
sudo dnf install curl

# macOS (using Homebrew):
brew install curl

# Alternative: Use wget
wget -O- https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
```

</details>

### 🪟 **Windows Installation Problems**

<details>
<summary><strong>❌ "Execution policy" error in PowerShell</strong></summary>

**Problem**: PowerShell blocks script execution

**Solutions**:
```powershell
# Option 1: Temporarily allow execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Option 2: Bypass for single command
powershell -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex"

# Option 3: Manual download
# Download from: https://github.com/picovis/picovis-community/releases/latest
# Extract to C:\Program Files\Picovis\bin\
# Add to PATH manually
```

</details>

<details>
<summary><strong>❌ "Access denied" during Windows installation</strong></summary>

**Problem**: Insufficient permissions to install to Program Files

**Solutions**:
```powershell
# Option 1: Run PowerShell as Administrator
# Right-click PowerShell → "Run as Administrator"

# Option 2: Install to user directory
iwr -useb https://raw.githubusercontent.com/picovis/picovis-community/main/install.ps1 | iex; Install-Picovis -InstallPath "$env:USERPROFILE\Picovis"

# Option 3: Use Windows Package Manager (if available)
winget install Picovis.CLI
```

</details>

---

## 🔌 Connection Issues

### 🗄️ **Database Connection Problems**

<details>
<summary><strong>❌ "Connection refused" or "Connection timeout"</strong></summary>

**Problem**: Cannot connect to database server

**Diagnostic Steps**:
```bash
# Test network connectivity
ping your-database-host
telnet your-database-host 5432  # PostgreSQL
telnet your-database-host 3306  # MySQL

# Check if database is running
# PostgreSQL:
sudo systemctl status postgresql
# MySQL:
sudo systemctl status mysql
```

**Solutions**:
1. **Check database server status** - Ensure the database service is running
2. **Verify connection details** - Host, port, username, database name
3. **Check firewall settings** - Ensure the database port is open
4. **Test with other tools** - Use `psql`, `mysql`, or GUI clients to verify

</details>

<details>
<summary><strong>❌ "Authentication failed" or "Access denied"</strong></summary>

**Problem**: Invalid credentials or insufficient permissions

**Solutions**:
```bash
# Test credentials manually
# PostgreSQL:
psql -h hostname -U username -d database_name

# MySQL:
mysql -h hostname -u username -p database_name

# Check user permissions
# PostgreSQL:
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;

# MySQL:
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'%';
FLUSH PRIVILEGES;
```

</details>

<details>
<summary><strong>❌ "SSL/TLS connection errors"</strong></summary>

**Problem**: SSL certificate or encryption issues

**Solutions**:
```bash
# Disable SSL for testing (not recommended for production)
picovis db add --name testdb --host localhost --ssl-mode disable

# Use specific SSL mode
picovis db add --name testdb --host localhost --ssl-mode require

# Specify SSL certificate
picovis db add --name testdb --host localhost --ssl-cert /path/to/cert.pem
```

</details>

---

## ⚡ Performance Issues

### 🐌 **Slow Query Execution**

<details>
<summary><strong>❌ Queries taking too long to execute</strong></summary>

**Diagnostic Steps**:
```bash
# Enable verbose logging
picovis --verbose query "SELECT COUNT(*) FROM large_table" --db mydb

# Check database performance
picovis db stats mydb

# Monitor system resources
top
htop
```

**Solutions**:
1. **Add database indexes** for frequently queried columns
2. **Optimize query structure** - Use EXPLAIN to analyze query plans
3. **Increase connection timeout** in configuration
4. **Check database server resources** - CPU, memory, disk I/O

</details>

<details>
<summary><strong>❌ High memory usage</strong></summary>

**Problem**: Picovis consuming excessive memory

**Solutions**:
```bash
# Limit result set size
picovis query "SELECT * FROM table LIMIT 1000" --db mydb

# Use streaming for large datasets
picovis export --stream --batch-size 1000 table.csv --db mydb

# Check for memory leaks
picovis --debug query "your-query" --db mydb
```

</details>

---

## 🔧 Configuration Issues

### ⚙️ **Configuration Problems**

<details>
<summary><strong>❌ "Configuration file not found"</strong></summary>

**Problem**: Picovis cannot find or read configuration

**Solutions**:
```bash
# Check configuration file location
picovis config path

# Create default configuration
picovis config init

# Specify custom config file
picovis --config /path/to/config.yml command

# Reset to defaults
picovis config reset
```

</details>

<details>
<summary><strong>❌ "Invalid configuration format"</strong></summary>

**Problem**: Configuration file has syntax errors

**Solutions**:
```bash
# Validate configuration
picovis config validate

# Show current configuration
picovis config show

# Edit configuration safely
picovis config edit

# Backup and restore
cp ~/.picovis/config.yml ~/.picovis/config.yml.backup
picovis config reset
```

</details>

---

## 🚨 Error Messages

### 📋 **Common Error Codes**

| Error Code | Meaning | Solution |
|------------|---------|----------|
| `E001` | Database connection failed | Check connection details and network |
| `E002` | Authentication failed | Verify username and password |
| `E003` | Permission denied | Check user permissions on database |
| `E004` | Query syntax error | Review SQL syntax |
| `E005` | Configuration error | Validate configuration file |
| `E006` | File not found | Check file paths and permissions |
| `E007` | Network timeout | Increase timeout or check network |
| `E008` | Insufficient memory | Reduce query size or increase system memory |

### 🔍 **Debugging Steps**

<details>
<summary><strong>🐛 Enable Debug Mode</strong></summary>

```bash
# Enable verbose logging
picovis --verbose command

# Enable debug mode
picovis --debug command

# Save logs to file
picovis --verbose command 2>&1 | tee picovis-debug.log

# Check log files
cat ~/.picovis/logs/picovis.log
```

</details>

---

## 🆘 Getting Help

### 📞 **Support Channels**

| Issue Type | Best Channel | Response Time |
|------------|-------------|---------------|
| 🐛 **Bugs** | [GitHub Issues](https://github.com/picovis/picovis-community/issues) | 1-2 business days |
| ❓ **Questions** | [Q&A Discussions](https://github.com/picovis/picovis-community/discussions/categories/q-a) | 2-8 hours |
| 💡 **Feature Requests** | [Ideas Discussions](https://github.com/picovis/picovis-community/discussions/categories/ideas) | 1-2 weeks |
| 🆘 **Urgent Issues** | [Support Issues](https://github.com/picovis/picovis-community/issues/new?template=support.yml) | 4-24 hours |

### 📋 **Information to Include**

When asking for help, please include:

- [ ] **Picovis version** (`picovis --version`)
- [ ] **Operating system** and version
- [ ] **Database type** and version
- [ ] **Complete error message** (with sensitive data removed)
- [ ] **Steps to reproduce** the issue
- [ ] **Expected vs actual behavior**
- [ ] **Configuration details** (sanitized)

### 🔧 **Self-Help Resources**

- 📖 [Documentation](https://github.com/picovis/picovis-community/wiki)
- 💬 [Community Discussions](https://github.com/picovis/picovis-community/discussions)
- 📊 [Status Dashboard](docs/STATUS_DASHBOARD.md)
- 🎯 [Quick Start Guide](https://github.com/picovis/picovis-community/wiki/Quick-Start)

---

<div align="center">

## 🎯 Still Need Help?

**Don't hesitate to reach out to our friendly community!**

[![Ask Question](https://img.shields.io/badge/Ask-Question-blue?style=for-the-badge&logo=github)](https://github.com/picovis/picovis-community/discussions/categories/q-a)
[![Report Bug](https://img.shields.io/badge/Report-Bug-red?style=for-the-badge&logo=bug)](https://github.com/picovis/picovis-community/issues/new/choose)

*We're here to help you succeed with Picovis CLI!*

</div>
