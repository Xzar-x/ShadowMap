#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
set -e # Exit immediately if a command exits with a non-zero status

sudo rm -f "$(which httpx)" 

# Funkcja do sprawdzania, czy narzędzie jest zainstalowane
check_tool() {
    if ! command -v "$1" &>/dev/null; then
        return 1
    fi
    return 0
}

# Lista wymaganych narzędzi do instalacji
# ZMIANA: Dodano wszystkie narzędzia używane w totalsubfinder
TOOLS=("ffuf" "gobuster" "subfinder" "amass" "jq" "httpx" "waybackurls" "katana" "hakrawler" "paramspider")
missing_tools=()

echo "Sprawdzam wymagane narzędzia..."

for tool in "${TOOLS[@]}"; do
    if ! check_tool "$tool"; then
        echo -e "${RED}Brakujące narzędzie: $tool${NC}"
        missing_tools+=("$tool")
    else
        echo "Znaleziono: ${GREEN}$tool${NC}"
    fi
done

# Jeśli brakuje narzędzi opartych na Go, sprawdź, czy Go jest zainstalowany
if [[ " ${missing_tools[@]} " =~ " subfinder " || " ${missing_tools[@]} " =~ " httpx " || " ${missing_tools[@]} " =~ " waybackurls " || " ${missing_tools[@]} " =~ " katana " || " ${missing_tools[@]} " =~ " hakrawler " ]]; then
    if ! check_tool "go"; then
        echo -e "${YELLOW}Uwaga: 'go' nie jest zainstalowane. Aby zainstalować narzędzia oparte na Go (np. subfinder, httpx, waybackurls, katana, hakrawler), proszę zainstalować Go z https://golang.org/dl/ lub za pomocą menedżera pakietów dystrybucji.${NC}"
    fi
fi

# Jeśli jakieś narzędzia są brakujące, zapytaj użytkownika, czy je zainstalować
if [ ${#missing_tools[@]} -ne 0 ]; then
    echo -e "\n${YELLOW}Następujące narzędzia są brakujące: ${missing_tools[*]}${NC}"
    read -p "Czy chcesz zainstalować brakujące narzędzia? [T/n]: " answer
    answer=${answer:-T} # Domyślnie tak

    if [[ "$answer" =~ ^[Tt]$ ]]; then
        echo "Aktualizuję listę pakietów..."
        if ! sudo apt update; then
            echo -e "${RED}Nie udało się zaktualizować listy pakietów. Proszę sprawdzić połączenie sieciowe lub źródła pakietów.${NC}"
            exit 1
        fi
        
        # Instalowanie brakujących narzędzi
        for tool in "${missing_tools[@]}"; do
            echo -e "${BLUE}Instaluję $tool...${NC}"
            case "$tool" in
                ffuf)
                    if ! sudo apt install ffuf -y; then
                        echo -e "${RED}Nie udało się zainstalować ffuf.${NC}"
                    fi
                    ;;
                gobuster)
                    if ! sudo apt install gobuster -y; then
                        echo -e "${RED}Nie udało się zainstalować gobuster.${NC}"
                    fi
                    ;;
                amass)
                    if ! sudo apt install amass -y; then
                        echo -e "${RED}Nie udało się zainstalować amass.${NC}"
                    fi
                    ;;
                jq)
                    if ! sudo apt install jq -y; then
                        echo -e "${RED}Nie udało się zainstalować jq.${NC}"
                    fi
                    ;;
                subfinder)
                    # ZMIANA: Instalacja subfindera przez go install, jeśli apt nie działa lub jest preferowane
                    if check_tool "go"; then
                        if ! go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest; then
                            echo -e "${RED}Nie udało się zainstalować subfindera za pomocą go install. Spróbuj sudo apt install subfinder -y.${NC}"
                            sudo apt install subfinder -y || echo -e "${RED}Nie udało się zainstalować subfindera za pomocą apt.${NC}"
                        fi
                    else
                        if ! sudo apt install subfinder -y; then
                            echo -e "${RED}Nie udało się zainstalować subfindera.${NC}"
                        fi
                    fi
                    ;;
                httpx)
                    # ZMIANA: Instalacja httpx
                    if check_tool "go"; then
                        if ! go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest; then
                            echo -e "${RED}Nie udało się zainstalować httpx za pomocą go install.${NC}"
                        fi
                    else
                        echo -e "${YELLOW}Aby zainstalować httpx, potrzebujesz Go. Proszę zainstalować Go ręcznie.${NC}"
                    fi
                    ;;
                waybackurls)
                    # ZMIANA: Instalacja waybackurls
                    if check_tool "go"; then
                        if ! go install -v github.com/tomnomnom/waybackurls@latest; then
                            echo -e "${RED}Nie udało się zainstalować waybackurls za pomocą go install.${NC}"
                        fi
                    else
                        echo -e "${YELLOW}Aby zainstalować waybackurls, potrzebujesz Go. Proszę zainstalować Go ręcznie.${NC}"
                    fi
                    ;;
                katana)
                    # ZMIANA: Instalacja katana
                    if check_tool "go"; then
                        if ! go install -v github.com/projectdiscovery/katana/cmd/katana@latest; then
                            echo -e "${RED}Nie udało się zainstalować katana za pomocą go install.${NC}"
                        fi
                    else
                        echo -e "${YELLOW}Aby zainstalować katana, potrzebujesz Go. Proszę zainstalować Go ręcznie.${NC}"
                    fi
                    ;;
                hakrawler)
                    # ZMIANA: Instalacja hakrawler
                    if check_tool "go"; then
                        if ! go install -v github.com/hakluke/hakrawler@latest; then
                            echo -e "${RED}Nie udało się zainstalować hakrawler za pomocą go install.${NC}"
                        fi
                    else
                        echo -e "${YELLOW}Aby zainstalować hakrawler, potrzebujesz Go. Proszę zainstalować Go ręcznie.${NC}"
                    fi
                    ;;
                paramspider)
                    # ZMIANA: Instalacja paramspider (narzędzie Python)
                    if ! command -v "pip3" &>/dev/null; then
                        echo -e "${YELLOW}Uwaga: 'pip3' nie jest zainstalowany. Instaluję pip3.${NC}"
                        sudo apt install python3-pip -y || echo -e "${RED}Nie udało się zainstalować pip3.${NC}"
                    fi
                    if command -v "pip3" &>/dev/null; then
                        if ! pip3 install paramspider; then
                            echo -e "${RED}Nie udało się zainstalować paramspider za pomocą pip3.${NC}"
                            echo -e "${YELLOW}Spróbuj zainstalować ręcznie: git clone https://github.com/0xasm0d3us/ParamSpider.git && cd ParamSpider && pip3 install -r requirements.txt && sudo ln -s $(pwd)/paramspider.py /usr/local/bin/paramspider${NC}"
                        fi
                    fi
                    ;;
                *)
                    echo -e "${RED}Nieznane narzędzie: $tool${NC}"
                    ;;
            esac
        done
    else
        echo -e "${YELLOW}Proszę zainstalować wymagane narzędzia ręcznie przed kontynuowaniem.${NC}"
        exit 1
    fi
fi

if [ ! -f "totalsubfinder" ]; then
    echo -e "${RED}Plik 'totalsubfinder' nie został znaleziony w bieżącym katalogu.${NC}"
    exit 1
fi

install_dir="/usr/local/bin"
echo -e "\n${BLUE}Instaluję 'totalsubfinder' do: $install_dir (wymagane uprawnienia sudo)${NC}"
if ! sudo mv totalsubfinder "$install_dir/totalsubfinder"; then
    echo -e "${RED}Nie udało się skopiować totalsubfinder do $install_dir.${NC}"
    exit 1
fi
if ! sudo chmod +x "$install_dir/totalsubfinder"; then
    echo -e "${RED}Nie udało się ustawić uprawnień wykonywalnych dla $install_dir/totalsubfinder.${NC}"
    exit 1
fi
echo -e "${GREEN}'totalsubfinder' został pomyślnie zainstalowany.${NC}"

# Instalacja plików konfiguracyjnych
user_home="$HOME"

# Konfiguracja Amass
amass_config_source="amass_config.yaml"
amass_config_dest="$user_home/.config/amass/config.yaml"
mkdir -p "$user_home/.config/amass"

if [ -f "$amass_config_dest" ]; then
    read -p "${YELLOW}Plik konfiguracyjny Amass już istnieje w $amass_config_dest. Nadpisać? [t/N]: ${NC}" replace_amass
    replace_amass=${replace_amass:-N} # Domyślnie nie
    if [[ "$replace_amass" =~ ^[Tt]$ ]]; then
        if ! cp "$amass_config_source" "$amass_config_dest"; then
            echo -e "${RED}Nie udało się skopiować konfiguracji Amass.${NC}"
            exit 1
        fi
        echo -e "${GREEN}Konfiguracja Amass została nadpisana.${NC}"
    else
        echo -e "${YELLOW}Pominięto nadpisywanie konfiguracji Amass.${NC}"
    fi
else
    if ! cp "$amass_config_source" "$amass_config_dest"; then
        echo -e "${RED}Nie udało się skopiować konfiguracji Amass.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Konfiguracja Amass zainstalowana w $amass_config_dest.${NC}"
fi

# Konfiguracja Subfinder
subfinder_config_source="subfinder_config.yaml"
subfinder_config_dest="$user_home/.config/subfinder/config.yaml"
mkdir -p "$user_home/.config/subfinder"

if [ -f "$subfinder_config_dest" ]; then
    read -p "${YELLOW}Plik konfiguracyjny Subfinder już istnieje w $subfinder_config_dest. Nadpisać? [t/N]: ${NC}" replace_subfinder
    replace_subfinder=${replace_subfinder:-N} # Domyślnie nie
    if [[ "$replace_subfinder" =~ ^[Tt]$ ]]; then
        if ! cp "$subfinder_config_source" "$subfinder_config_dest"; then
            echo -e "${RED}Nie udało się skopiować konfiguracji Subfinder.${NC}"
            exit 1
        fi
        echo -e "${GREEN}Konfiguracja Subfinder została nadpisana.${NC}"
    else
        echo -e "${YELLOW}Pominięto nadpisywanie konfiguracji Subfinder.${NC}"
    fi
else
    if ! cp "$subfinder_config_source" "$subfinder_config_dest"; then
        echo -e "${RED}Nie udało się skopiować konfiguracji Subfinder.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Konfiguracja Subfinder zainstalowana w $subfinder_config_dest.${NC}"
fi

echo -e "\n${GREEN}totalsubfinder został pomyślnie zainstalowany!${NC}"
echo -e "${RED}Pamiętaj, aby zaktualizować swoje klucze API w plikach konfiguracyjnych subfindera w $user_home/.config/subfinder/config.yaml oraz amass w $user_home/.config/amass/config.yaml.${NC}"
