\<p align="center"\>  
\<img src="https://github.com/Xzar-x/images/blob/main/shadowmap.png" alt="ShadowMap Banner" width="100%"\>  
\</p\>  
\<h1 align="center"\>ShadowMap 🕵️‍♂️\</h1\>

\<p align="center"\>  
A fully automated, modular subdomain reconnaissance framework with \<strong\>stealth\</strong\> mode, error logging, JSON/Markdown reporting, and an interactive terminal UI.  
\</p\>

## **🧠 What is ShadowMap?**

**ShadowMap** is a modular Bash-based reconnaissance toolkit designed for bug bounty hunters and penetration testers.

It consolidates multiple tools and techniques into one **interactive and stealthy CLI app** to automate subdomain enumeration, crawling, and port scanning.

## **⚙️ Features**

* 🔍 **Comprehensive Subdomain Discovery:** Utilizes FFUF, Gobuster, Subfinder, Amass, and CRT.sh for extensive subdomain enumeration.  
* 🕸️ **Advanced Crawling & Parameter Discovery:** Leverages Hakrawler, Katana, and ParamSpider to find URLs and identify parameters.  
* 🌐 **Reliable Live Host Detection:** Employs httpx to efficiently identify reachable (HTTP/S) subdomains.  
* ⚡ **Automated Port Scanning:** Integrates Nmap with options for light or deep scans, automatically targeting live hosts.  
* 📊 **Flexible Reporting:** Generates detailed reports in both JSON and Markdown formats.  
* 🎛️ **Interactive Terminal UI:** Provides an intuitive menu for selecting and configuring tools.  
* ✅ **Robust Error Logging:** All tool errors are captured in a dedicated shadowmap\_error.log file for easy debugging.  
* 🚦 **Smart Tool Control:** Allows running only selected modules for focused reconnaissance.  
* 📁 **Organized Output:** All results are structured into clearly named files within a specified output directory.  
* 🔄 **Resume Functionality:** Automatically detects existing scan results for a domain and offers to skip or overwrite, enabling seamless resumption of interrupted scans.

## **🚀 Usage**

First, ensure the script is executable:

chmod \+x shadowmap

Then, run it with your target domain or a file containing a list of domains:

shadowmap \-u target.com

or

smp \-f domains.txt

### **Options**

  \-u \<URL\>       Target domain (e.g., example.com)  
  \-f \<file\>      File containing list of domains  
  \-w \<wordlist\>  Path to a custom wordlist file (default: /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt)  
  \-t \<threads\>   Number of threads (default: 40\)  
  \-T \<timeout\>   Timeout in seconds (default: 30\)  
  \-S             Enable silent mode (suppress tool output to console)  
  \-j             Generate JSON report  
  \-o \<dir\>       Specify output directory  
  \-h             Display this help message

After running the script, an interactive menu will appear, allowing you to select and configure specific tools, including Nmap scan types (light/deep) and Amass options (passive/brute/active).

### **Usage Example**

./shadowmap \-f domains.txt \-j \-o scans/

This command will scan domains from domains.txt, generate a JSON report, and save all output files in the scans/ directory.

## **📦 Installation**

To install ShadowMap and its dependencies, follow these steps:

1. Download the scripts:  
   Download shadowmap and install.sh to your local machine.  
2. **Make the installer executable:**  
   chmod \+x install.sh

3. **Run the installer:**  
   ./install.sh

   The installer will check for required tools (ffuf, gobuster, subfinder, amass, httpx, waybackurls, katana, hakrawler, paramspider, jq, curl, nmap). If any are missing, it will prompt you to install them using apt or go install/pip.  
   **Note:** For Go-based tools (subfinder, httpx, waybackurls, katana, hakrawler), ensure you have Go installed. The installer will inform you if Go is missing.  
4. Configuration (Optional but Recommended):  
   The installer will also attempt to copy amass\_config.yaml and subfinder\_config.yaml to their respective default configuration paths (\~/.config/amass/config.yaml and \~/.config/subfinder/config.yaml). You might be prompted to overwrite existing configurations.  
   **Important:** Remember to fill in your API keys in \~/.config/{amass,subfinder}/config.yaml for optimal results with tools like Amass and Subfinder that leverage external services.

After successful installation, shadowmap will be available in your system's PATH, and you can run it directly by typing shadowmap or smp

## **📁 Output Structure**

All results are saved in the chosen output directory (default: current folder):

* all\_subdomains.txt – All discovered unique subdomains from all enumeration tools.  
* live\_subdomains.txt – Only reachable (HTTP/S) subdomains identified by httpx.  
* vhost\_status\_200.txt – Gobuster vhost results specifically with HTTP status 200\.  
* found\_urls.txt – All URLs discovered from crawling tools (Waybackurls, Katana, Hakrawler).  
* urls\_with\_params.txt – URLs containing parameters, identified by Paramspider.  
* report.md – A comprehensive Markdown report summarizing the scan.  
* report.json – A JSON summary of the scan results (if \-j is set).  
* shadowmap\_error.log – A log file containing all errors encountered during tool execution for debugging.  
* \<domain\>\_nmap.nmap – Nmap scan results in normal format (if Nmap scan is enabled).  
* \<domain\>\_nmap.xml – Nmap scan results in XML format (if Nmap scan is enabled).  
* \<domain\>\_nmap.gnmap – Nmap scan results in Grepable format (if Nmap scan is enabled).

## **📸 Screenshot**

\<p align="center"\>  
\<img src="https://raw.githubusercontent.com/Xzar-x/images/main/screenshot.png" alt="ShadowMap Screenshot" width="100%"\>  
\</p\>

## **🔒 Stealth Mode**

ShadowMap's interactive menu allows you to configure tools for stealthy scanning. By adjusting options like threads and timeouts (e.g., choosing "Deep Scan" for Nmap), you can minimize the footprint and avoid WAF detection or blockades.

## **🧙‍♂️ Why "ShadowMap"?**

The name represents a "map" of subdomains and web surfaces discovered from the shadows – silently and effectively, just like a hacker should.

The alias smp (though the current script is shadowmap, the concept remains) also makes it quick and intuitive to use.

## **🤖 Author**

Created with 💻 and ☕ by [Xzar](https://github.com/Xzar-x)

Feel free to contribute or suggest improvements\!

## **📜 License**

MIT License

## **🙌 Contributions Welcome**

* Found a bug? Open an issue.  
* Got an idea? Start a discussion.  
* Want to improve the script? Send a pull request\!

\<p align="center"\>  
\<strong\>\#HappyHunting 🐞\</strong\>  
\</p\>
