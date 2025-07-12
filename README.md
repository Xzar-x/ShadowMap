# **🚀 TotalSubFinder**

TotalSubFinder to narzędzie, które łączy kilka potężnych skryptów do enumeracji subdomen, uruchamiając je jednocześnie w tle, co znacznie przyspiesza proces rozpoznania subdomen.

## **📥 Instalacja**

Aby zainstalować TotalSubFinder, uruchom następujące polecenia:

git clone https://github.com/Xzar-x/TotalSubFinder.git \# Repozytorium może nadal nazywać się SubSearcher  
cd totalsubfinder \# Przejdź do katalogu repozytorium  
chmod \+x install.sh  
./install.sh

## **🔧 Użycie**

Po zainstalowaniu możesz użyć TotalSubFinder do skanowania subdomen:

### **Podstawowe użycie:**

TotalSubFinder \-u example.com

### **Wyświetl pomoc:**

TotalSubFinder \-h

## **📌 Funkcje**

✔️ Automatyczna instalacja zależności

✔️ Obsługuje wiele narzędzi rozpoznawczych (ffuf, gobuster, subfinder, amass, httpx, waybackurls, katana, hakrawler, paramspider)

✔️ Konfigurowalne ustawienia skanowania

✔️ Generowanie szczegółowego raportu z wynikami i błędami

## **🛠 Wymagania**

Ten skrypt wymaga następujących narzędzi:

* ffuf  
* gobuster  
* subfinder  
* amass  
* jq  
* httpx  
* waybackurls  
* katana  
* hakrawler  
* paramspider  
* go (wymagane do instalacji niektórych narzędzi, takich jak httpx, waybackurls, katana, hakrawler, jeśli nie są dostępne przez menedżer pakietów)  
* pip3 (wymagane do instalacji paramspider)

Skrypt instalacyjny (install.sh) sprawdzi te narzędzia i spróbuje je zainstalować, jeśli brakuje.

## **🖼️ Zrzuty ekranu**

Oto przykład wyjścia TotalSubFinder:  
\!(https://github.com/Xzar-x/images/raw/main/subsearcher.png)

## **📄 Licencja**

Ten projekt jest objęty licencją MIT.

✨ *Stworzone przez Xzar* ✨
