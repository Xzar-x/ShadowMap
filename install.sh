#!/bin/bash
set -e

# Function to check if a tool is installed
check_tool() {
    if ! command -v "$1" &>/dev/null; then
        return 1
    fi
    return 0
}

# List of required tools for installation
TOOLS=("ffuf" "gobuster" "subfinder" "amass" "jq")
missing_tools=()

echo "Checking required tools..."

for tool in "${TOOLS[@]}"; do
    if ! check_tool "$tool"; then
        echo "Missing tool: $tool"
        missing_tools+=("$tool")
    else
        echo "Found: $tool"
    fi
done

# Jeśli subfinder brakuje, sprawdź czy zainstalowane jest narzędzie go, aby ułatwić instalację przez użytkownika
if [[ " ${missing_tools[@]} " =~ " subfinder " ]]; then
    if ! check_tool "go"; then
        echo "Note: 'go' is not installed. To install subfinder via 'go install', please install Go from https://golang.org/dl/ or use your distribution's package manager."
    fi
fi

# Jeśli jakieś narzędzia są brakujące, zapytaj użytkownika czy je zainstalować
if [ ${#missing_tools[@]} -ne 0 ]; then
    echo -e "\nThe following tools are missing: ${missing_tools[*]}"
    read -p "Would you like to install the missing tools? [Y/n]: " answer
    answer=${answer:-Y}
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Updating package list..."
        if ! sudo apt update; then
            echo "Failed to update package list. Please check your network connection or package sources."
            exit 1
        fi
        for tool in "${missing_tools[@]}"; do
            case "$tool" in
                ffuf)
                    echo "Installing ffuf..."
                    if ! sudo apt install ffuf -y; then
                        echo "Failed to install ffuf."
                        exit 1
                    fi
                    ;;
                gobuster)
                    echo "Installing gobuster..."
                    if ! sudo apt install gobuster -y; then
                        echo "Failed to install gobuster."
                        exit 1
                    fi
                    ;;
                amass)
                    echo "Installing amass..."
                    if ! sudo apt install amass -y; then
                        echo "Failed to install amass."
                        exit 1
                    fi
                    ;;
                jq)
                    echo "Installing jq..."
                    if ! sudo apt install jq -y; then
                        echo "Failed to install jq."
                        exit 1
                    fi
                    ;;
                subfinder)
                    echo "Installing subfinder..."
                    if ! sudo apt install subfinder -y; then
                        echo "Failed to install subfinder."
                        exit 1
                    fi
                    ;;
                *)
                    echo "Unknown tool: $tool"
                    ;;
            esac
        done
    else
        echo "Please install the required tools manually before proceeding."
        exit 1
    fi
fi

# Installing subsearcher
if [ ! -f "subsearcher" ]; then
    echo "The 'subsearcher' file was not found in the current directory."
    exit 1
fi

install_dir="/usr/local/bin"
echo -e "\nInstalling 'subsearcher' to: $install_dir (sudo privileges required)"
if ! sudo mv subsearcher "$install_dir/"; then
    echo "Failed to copy subsearcher to $install_dir."
    exit 1
fi
if ! sudo chmod +x "$install_dir/subsearcher"; then
    echo "Failed to set executable permissions for $install_dir/subsearcher."
    exit 1
fi
echo "'subsearcher' has been installed successfully."

# Config file installation
user_home="$HOME"

# Amass config
amass_config_source="amass_config.yaml"
amass_config_dest="$user_home/.config/amass/config.yaml"
mkdir -p "$user_home/.config/amass"

if [ -f "$amass_config_dest" ]; then
    read -p "Amass config already exists in $amass_config_dest. Overwrite? [y/N]: " replace_amass
    if [[ "$replace_amass" =~ ^[Yy]$ ]]; then
        if ! cp "$amass_config_source" "$amass_config_dest"; then
            echo "Failed to copy Amass config."
            exit 1
        fi
        echo "Amass config has been overwritten."
    else
        echo "Skipping Amass config overwrite."
    fi
else
    if ! cp "$amass_config_source" "$amass_config_dest"; then
        echo "Failed to copy Amass config."
        exit 1
    fi
    echo "Amass config installed in $amass_config_dest."
fi

# Subfinder config
subfinder_config_source="subfinder_config.yaml"
subfinder_config_dest="$user_home/.config/subfinder/config.yaml"
mkdir -p "$user_home/.config/subfinder"

if [ -f "$subfinder_config_dest" ]; then
    read -p "Subfinder config already exists in $subfinder_config_dest. Overwrite? [y/N]: " replace_subfinder
    if [[ "$replace_subfinder" =~ ^[Yy]$ ]]; then
        if ! cp "$subfinder_config_source" "$subfinder_config_dest"; then
            echo "Failed to copy Subfinder config."
            exit 1
        fi
        echo "Subfinder config has been overwritten."
    else
        echo "Skipping Subfinder config overwrite."
    fi
else
    if ! cp "$subfinder_config_source" "$subfinder_config_dest"; then
        echo "Failed to copy Subfinder config."
        exit 1
    fi
    echo "Subfinder config installed in $subfinder_config_dest."
fi
sudo rm -r ../subsearcher
echo -e "\nSubsearcher has been successfully installed!"
echo "Remember to update your API keys in the config files of subfinder in $user_home/.config/subfinder/config.yaml and amass in $user_home/.config/amass/config.yaml."
