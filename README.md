# 🚀 Subsearcher Installer

A powerful and automated script to install **Subsearcher** and its dependencies for subdomain enumeration.

## 📥 Installation
To install Subsearcher, run the following commands:
```bash
git clone https://github.com/Xzar-x/SubSearcher.git
cd SubSearcher
chmod +x install.sh
./install.sh
```

## 🔧 Usage
Once installed, you can use Subsearcher to scan for subdomains:

### Basic Usage:
```bash
subsearcher -u example.com
```

### Display Help:
```bash
subsearcher -h
```

## 📌 Features
✔️ Automated installation of dependencies  
✔️ Supports multiple reconnaissance tools (ffuf, gobuster, subfinder, amass)  
✔️ Configurable settings for scanning  

## 🛠 Requirements
This script requires the following tools:
- `ffuf`
- `gobuster`
- `subfinder`
- `amass`
- `jq`

The script will check for these tools and install them if missing.

## 🖼️ Screenshots
Here’s an example output of Subsearcher:
![Subsearcher Output](images/screenshot.png)

## 📄 License
This project is licensed under the MIT License.

---
✨ *Created with ❤️ by Xzar* ✨
