#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ANSI Color Definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Function for colored output
# Usage: cecho <COLOR> "Text to display"
cecho() {
    local color="$1"; shift
    printf '%b\n' "${color}$*${NC}"
}

# Check if a program is installed
check_tool() {
    command -v "$1" &>/dev/null
}

# Remove old httpx version (if it exists)
cecho "${BLUE}" "Removing old httpx version (if it exists)..."
sudo rm -f "$(which httpx 2>/dev/null || true)" || true # Added || true to avoid error if httpx does not exist

# Updated list of required tools
TOOLS=(ffuf gobuster subfinder amass jq httpx waybackurls katana hakrawler paramspider curl nmap)
missing=()

cecho "${BLUE}" "Checking required tools..."

for t in "${TOOLS[@]}"; do
    if check_tool "$t"; then
        cecho "${GREEN}" "Found: $t"
    else
        cecho "${RED}" "Missing tool: $t"
        missing+=("$t")
    fi
done

# If Go-based tools are missing, inform about Go
if printf '%s\n' "${missing[@]}" | grep -Eq 'subfinder|httpx|waybackurls|katana|hakrawler'; then
    if ! check_tool go; then
        cecho "${YELLOW}" "Note: Go is not installed. It is needed for: subfinder, httpx, waybackurls, katana, hakrawler."
    fi
fi

# Install missing tools
if [ ${#missing[@]} -gt 0 ]; then
    cecho "${YELLOW}" "Missing tools: ${missing[*]}"
    read -rp "$(printf '%b' "${YELLOW}Install missing tools? [Y/n]: ${NC}")" ans
    ans=${ans:-Y}

    if [[ $ans =~ ^[Yy]$ ]]; then
        cecho "${BLUE}" "Updating apt package list..."
        sudo apt update || { cecho "${RED}" "Failed to update apt package list. Check internet connection or permissions."; exit 1; }
        
        for t in "${missing[@]}"; do
            cecho "${BLUE}" "Installing $t..."
            case "$t" in
                ffuf|gobuster|amass|jq|curl|nmap) # Added curl and nmap
                    sudo apt install -y "$t" || cecho "${RED}" "Error installing $t. Try installing manually."
                    ;;
                subfinder)
                    if check_tool go; then
                        go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest \
                          || cecho "${RED}" "go install subfinder failed. Try installing via apt or manually."
                    else
                        sudo apt install -y subfinder || cecho "${RED}" "Error installing subfinder. Install Go or try manually."
                    fi
                    ;;
                httpx)
                    if check_tool go; then
                        go install github.com/projectdiscovery/httpx/cmd/httpx@latest \
                          || cecho "${RED}" "go install httpx failed. Try installing via apt or manually."
                    else
                        cecho "${YELLOW}" "You need Go to install httpx. Try installing Go, then run the script again."
                    fi
                    ;;
                waybackurls|katana|hakrawler)
                    if check_tool go; then
                        go install "github.com/tomnomnom/$t@latest" \
                          || cecho "${RED}" "go install $t failed. Try installing manually."
                    else
                        cecho "${YELLOW}" "You need Go to install $t. Try installing Go, then run the script again."
                    fi
                    ;;
                paramspider)
                    if ! check_tool pip3; then
                        cecho "${BLUE}" "Installing python3-pip..."
                        sudo apt install -y python3-pip || cecho "${RED}" "Failed to install python3-pip."
                    fi
                    pip3 install paramspider || cecho "${RED}" "pip3 install paramspider failed. Try installing manually."
                    ;;
                *)
                    cecho "${RED}" "Unknown tool: $t. Please install manually."
                    ;;
            esac
        done
    else
        cecho "${YELLOW}" "Please install missing tools manually and run the script again."
        exit 1
    fi
fi

# Check for ShadowMap.sh file
if [ ! -f shadowmap ]; then # Changed file name to ShadowMap.sh
    cecho "${RED}" "Missing ShadowMap file in the working directory. Ensure the main script is in the same directory as the installer."
    exit 1
fi

# Install the binary
install_dir="/usr/local/bin"
cecho "${BLUE}" "Installing Shadowmap to $install_dir"
sudo cp shadowmap "$install_dir/" # Use cp instead of mv to preserve the original
sudo chmod +x "$install_dir/shadowmap"
sudo ln -s /usr/local/bin/shadowmap /usr/local/bin/smp

# Amass and Subfinder configurations
for tool in amass subfinder; do
    cfg_src="${tool}_config.yaml"
    cfg_dest="$HOME/.config/${tool}/config.yaml"
    
    # Check if the source config file exists
    if [ ! -f "$cfg_src" ]; then
        cecho "${YELLOW}" "Warning: Missing config file ${cfg_src}. Skipping ${tool} configuration."
        continue
    fi

    mkdir -p "$(dirname "$cfg_dest")"
    if [ -f "$cfg_dest" ]; then
        read -rp "$(printf '%b' "${YELLOW}Overwrite existing $tool config? [N/y]: ${NC}")" rep
        rep=${rep:-N}
        if [[ $rep =~ ^[Yy]$ ]]; then
            cp "$cfg_src" "$cfg_dest" && cecho "${GREEN}" "Configuration $tool overwritten." || cecho "${RED}" "Error overwriting $tool configuration."
        else
            cecho "${YELLOW}" "Skipped overwriting $tool configuration."
        fi
    else
        cp "$cfg_src" "$cfg_dest" && cecho "${GREEN}" "Configuration $tool installed." || cecho "${RED}" "Error installing $tool configuration."
    fi
done

cecho "${GREEN}" "Installation complete! Remember to fill in API keys in ~/.config/{amass,subfinder}/config.yaml (if using these tools)."
cecho "${GREEN}" "ShadowMap installed as 'shadowmap' and shortcut 'smp'"
