<p align="center">
  <img src="https://raw.githubusercontent.com/Xzar-x/images/main/shadowmap.png" alt="ShadowMap Banner" width="100%">
</p>

<h1 align="center">ShadowMap 🕵️‍♂️</h1>

<p align="center">
  A fully automated, modular subdomain reconnaissance framework with <strong>stealth</strong> mode, error logging, JSON/Markdown reporting, and an interactive terminal UI.
</p>

---

## 🧠 What is ShadowMap?

**ShadowMap** is a modular Bash-based reconnaissance toolkit designed for bug bounty hunters and penetration testers.  
It consolidates multiple tools and techniques into one **interactive and stealthy CLI app** to automate subdomain enumeration and crawling.

---

## ⚙️ Features

- 🔍 Subdomain discovery via FFUF, Gobuster, Subfinder, Amass, CRT.sh
- 🕸️ Crawling and parameter discovery using Hakrawler, Katana, ParamSpider
- 🌐 Live host detection with `httpx`
- 📊 JSON and Markdown report generation
- 🎛️ Interactive terminal-based tool selector
- 🛡️ Stealth mode with built-in rate limit options (`--stealth`, `--rl=`)
- ✅ Error logging (separate `shadowmap_error.log`)
- 🚦 Smart tool control (run only selected modules)
- 📁 Output is organized into clearly structured files

---

## 🚀 Usage

```bash
chmod +x shadowmap
./shadowmap -u target.com
```

### Options

```bash
  -u <URL>       Target domain (e.g., example.com)
  -f <file>      File containing list of domains
  -w <wordlist>  Custom wordlist for bruteforcing
  -t <threads>   Threads (default: 40)
  -T <timeout>   Timeout in seconds (default: 30)
  -S             Silent mode (suppress tool output)
  -j             Generate JSON report
  -o <dir>       Output directory
  --rl=<val>     Global rate limit (LOW, MEDIUM, HIGH or custom number)
  --stealth      Enable stealthy scanning config
```

---

## 📦 Dependencies

Make sure you have the following tools installed:

- `ffuf`
- `gobuster`
- `subfinder`
- `amass`
- `httpx`
- `waybackurls`
- `katana`
- `hakrawler`
- `paramspider`
- `jq`
- `curl`

You can install them using tools like:

```bash
go install github.com/projectdiscovery/...
pip install paramspider
```

---

## 📁 Output Structure

All results are saved in the chosen output directory (default: current folder):

- `all_subdomains.txt` – All discovered subdomains
- `live_subdomains.txt` – Only reachable (HTTP/S) subdomains
- `vhost_status_200.txt` – Gobuster vhost results with status 200
- `found_urls.txt` – URLs from crawling and Wayback
- `urls_with_params.txt` – URLs containing parameters
- `report.md` – Markdown report
- `report.json` – JSON summary (if `-j` is set)
- `shadowmap_error.log` – All tool errors for debugging

---

## 🧪 Example

```bash
./shadowmap -f domains.txt --rl=LOW --stealth -j -o scans/
```

---

## 🔒 Stealth Mode

To avoid WAF detection or blockades, use:

```bash
--stealth
--rl=LOW
```

This will configure all tools to use conservative timeouts and thread counts.

---

## 🧙‍♂️ Why "ShadowMap"?

The name represents a "map" of subdomains and web surfaces discovered from the shadows – silently and effectively, just like a hacker should.  
Alias `sm` also makes it quick and intuitive to use.

---

## 🤖 Author

Created with 💻 and ☕ by [Xzar](https://github.com/Xzar-x)  
Feel free to contribute or suggest improvements!

---

## 📜 License

MIT License

---

## 🙌 Contributions Welcome

- Found a bug? Open an issue.
- Got an idea? Start a discussion.
- Want to improve the script? Send a pull request!

---

<p align="center">
  <strong>#HappyHunting 🐞</strong>
</p>
