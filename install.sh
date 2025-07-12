#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Definicja kolorów ANSI
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Funkcja do kolorowego wypisywania
# Użycie: cecho <KOLOR> "Tekst do wyświetlenia"
cecho() {
    local color="$1"; shift
    printf '%b\n' "${color}$*${NC}"
}

# Sprawdź, czy program jest zainstalowany
check_tool() {
    command -v "$1" &>/dev/null
}

# Usuń starą wersję httpx (jeśli istnieje)
sudo rm -f "$(which httpx 2>/dev/null || true)"

TOOLS=(ffuf gobuster subfinder amass jq httpx waybackurls katana hakrawler paramspider)
missing=()

cecho "${BLUE}" "Sprawdzam wymagane narzędzia..."

for t in "${TOOLS[@]}"; do
    if check_tool "$t"; then
        cecho "${GREEN}" "Znaleziono: $t"
    else
        cecho "${RED}" "Brakujące narzędzie: $t"
        missing+=("$t")
    fi
done

# Jeśli brakuje narzędzi Go-based, poinformuj o Go
if printf '%s\n' "${missing[@]}" | grep -Eq 'subfinder|httpx|waybackurls|katana|hakrawler'; then
    if ! check_tool go; then
        cecho "${YELLOW}" "Uwaga: nie masz zainstalowanego Go. Potrzebne do: subfinder, httpx, waybackurls, katana, hakrawler."
    fi
fi

# Instalacja brakujących
if [ ${#missing[@]} -gt 0 ]; then
    cecho "${YELLOW}" "Brakujące: ${missing[*]}"
    read -rp "$(printf '%b' "${YELLOW}Zainstalować brakujące? [T/n]: ${NC}")" ans
    ans=${ans:-T}

    if [[ $ans =~ ^[Tt]$ ]]; then
        sudo apt update || { cecho "${RED}" "Nie udało się apt update."; exit 1; }
        for t in "${missing[@]}"; do
            cecho "${BLUE}" "Instaluję $t..."
            case "$t" in
                ffuf|gobuster|amass|jq)
                    sudo apt install -y "$t" || cecho "${RED}" "Błąd instalacji $t."
                    ;;
                subfinder)
                    if check_tool go; then
                        go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest \
                          || sudo apt install -y subfinder
                    else
                        sudo apt install -y subfinder
                    fi
                    ;;
                httpx)
                    if check_tool go; then
                        go install github.com/projectdiscovery/httpx/cmd/httpx@latest \
                          || cecho "${RED}" "go install httpx nie powiodło się."
                    else
                        cecho "${YELLOW}" "Potrzebujesz Go, aby zainstalować httpx."
                    fi
                    ;;
                waybackurls|katana|hakrawler)
                    if check_tool go; then
                        go install "github.com/${t#*/}/${t#*/}@latest" \
                          || cecho "${RED}" "go install $t nie powiodło się."
                    else
                        cecho "${YELLOW}" "Potrzebujesz Go, aby zainstalować $t."
                    fi
                    ;;
                paramspider)
                    if ! check_tool pip3; then
                        sudo apt install -y python3-pip
                    fi
                    pip3 install paramspider || cecho "${RED}" "pip3 install paramspider nie powiodło się."
                    ;;
                *)
                    cecho "${RED}" "Nieznane narzędzie: $t"
                    ;;
            esac
        done
    else
        cecho "${YELLOW}" "Proszę zainstalować ręcznie i uruchomić ponownie."
        exit 1
    fi
fi

# Sprawdzenie pliku totalsubfinder
if [ ! -f totalsubfinder ]; then
    cecho "${RED}" "Brak pliku totalsubfinder w katalogu roboczym."
    exit 1
fi

# Instalacja binarki
install_dir="/usr/local/bin"
cecho "${BLUE}" "Instaluję totalsubfinder do $install_dir"
sudo mv totalsubfinder "$install_dir/"
sudo chmod +x "$install_dir/totalsubfinder"
cecho "${GREEN}" "totalsubfinder zainstalowany."

# Konfiguracje Amass i Subfinder
for tool in amass subfinder; do
    cfg_src="${tool}_config.yaml"
    cfg_dest="$HOME/.config/${tool}/config.yaml"
    mkdir -p "$(dirname "$cfg_dest")"
    if [ -f "$cfg_dest" ]; then
        read -rp "$(printf '%b' "${YELLOW}Nadpisać istniejący $tool config? [N/t]: ${NC}")" rep
        rep=${rep:-N}
        if [[ $rep =~ ^[Tt]$ ]]; then
            cp "$cfg_src" "$cfg_dest" && cecho "${GREEN}" "Konfiguracja $tool nadpisana."
        else
            cecho "${YELLOW}" "Pominięto $tool."
        fi
    else
        cp "$cfg_src" "$cfg_dest" && cecho "${GREEN}" "Konfiguracja $tool zainstalowana."
    fi
done

cecho "${GREEN}" "Gotowe — pamiętaj uzupełnić API-keys w ~/.config/{amass,subfinder}/config.yaml!"
